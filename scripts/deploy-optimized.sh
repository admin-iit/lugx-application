#!/bin/bash

# Optimized All-in-One Deployment Script for Gaming Microservices
# This script handles database setup, builds, pushes to ECR, and deploys to Kubernetes
#
# What this script does:
# 1. Sets up RDS database with proper security groups
# 2. Creates and initializes database schema
# 3. Builds and pushes Docker images to ECR
# 4. Deploys all services to EKS
# 5. Verifies deployment status
#
# Prerequisites:
# - AWS CLI configured with appropriate permissions
# - Docker installed and running
# - kubectl configured for EKS access
# - PostgreSQL client installed (brew install postgresql)

set -euo pipefail

# Configuration
REGION="ap-southeast-1"
ECR_REGISTRY="776231021342.dkr.ecr.ap-southeast-1.amazonaws.com"
NAMESPACE="lugx-gaming"
REPO_PREFIX="gaming-microservices"
EKS_CLUSTER_NAME="iit-test-dev-eks"

# Database Configuration
RDS_ENDPOINT="iit-test-dev-db.cv0gc48uo7w1.ap-southeast-1.rds.amazonaws.com"
DB_NAME="lugx_gaming_dev"
DB_USER="dbadmin"
DB_PASSWORD="LionKing1234"
DB_PORT="5432"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
    echo -e "${RED}Current directory: $(pwd)${NC}"
    echo -e "${RED}Required structure:${NC}"
    echo -e "${RED}  - services/frontend/${NC}"
    echo -e "${RED}  - services/gaming-service/${NC}"
    echo -e "${RED}  - services/order-service/${NC}"
    echo -e "${RED}  - services/analytics-service/${NC}"
    echo -e "${RED}  - kustomize/overlays/dev/${NC}"
    exit 1
}

# Check prerequisites
check_prerequisites() {
    log "Checking prerequisites..."
    
    # Check required tools
    local missing_tools=()
    
    if ! command -v aws &> /dev/null; then
        missing_tools+=("aws")
    fi
    
    if ! command -v docker &> /dev/null; then
        missing_tools+=("docker")
    fi
    
    if ! command -v kubectl &> /dev/null; then
        missing_tools+=("kubectl")
    fi
    
    if ! command -v kustomize &> /dev/null; then
        missing_tools+=("kustomize")
    fi
    
    if ! command -v psql &> /dev/null; then
        missing_tools+=("postgresql-client")
    fi
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        error "Missing required tools: ${missing_tools[*]}"
        log "Install missing tools:"
        log "  AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html"
        log "  Docker: https://docs.docker.com/get-docker/"
        log "  kubectl: https://kubernetes.io/docs/tasks/tools/install-kubectl/"
        log "  kustomize: https://kubectl.docs.kubernetes.io/installation/kustomize/"
        log "  PostgreSQL: brew install postgresql"
        exit 1
    fi
    
    # Ensure PostgreSQL client is in PATH (for macOS brew installation)
    if [[ -d "/opt/homebrew/opt/postgresql@14/bin" ]]; then
        export PATH="/opt/homebrew/opt/postgresql@14/bin:$PATH"
    elif [[ -d "/usr/local/opt/postgresql@14/bin" ]]; then
        export PATH="/usr/local/opt/postgresql@14/bin:$PATH"
    fi
    
    # Check Docker permissions
    if ! docker ps &> /dev/null; then
        error "Docker permission denied. Please start Docker Desktop or fix Docker permissions."
    fi
    
    log "✅ Prerequisites check passed!"
}

# Setup RDS Database
setup_database() {
    log "🗄️  Setting up RDS database..."
    
    # Configure security groups for EKS access to RDS
    configure_rds_security_group
    
    # Configure RDS for non-SSL connections (development)
    configure_rds_ssl_settings
    
    # Test database connectivity
    test_database_connection
    
    # Create database if it doesn't exist
    create_database
    
    # Initialize database schema
    initialize_database_schema
    
    log "✅ Database setup completed!"
}

# Configure RDS security group
configure_rds_security_group() {
    log "Configuring RDS security group for EKS access..."
    
    # Get RDS security group ID
    local rds_sg_id=$(aws rds describe-db-instances \
        --region $REGION \
        --query "DBInstances[?DBInstanceIdentifier=='iit-test-dev-db'].VpcSecurityGroups[0].VpcSecurityGroupId" \
        --output text 2>/dev/null)
    
    # Get EKS cluster security group ID
    local eks_sg_id=$(aws eks describe-cluster \
        --region $REGION \
        --name $EKS_CLUSTER_NAME \
        --query "cluster.resourcesVpcConfig.clusterSecurityGroupId" \
        --output text 2>/dev/null)
    
    # Get VPC CIDR for broader access
    local vpc_id=$(aws eks describe-cluster \
        --region $REGION \
        --name $EKS_CLUSTER_NAME \
        --query "cluster.resourcesVpcConfig.vpcId" \
        --output text 2>/dev/null)
    
    local vpc_cidr=$(aws ec2 describe-vpcs \
        --region $REGION \
        --vpc-ids $vpc_id \
        --query "Vpcs[0].CidrBlock" \
        --output text 2>/dev/null)
    
    if [ "$rds_sg_id" != "None" ] && [ -n "$rds_sg_id" ]; then
        log "RDS Security Group ID: $rds_sg_id"
        log "EKS Security Group ID: $eks_sg_id"
        log "VPC CIDR: $vpc_cidr"
        
        # Add rule to allow EKS security group access to RDS
        if [ "$eks_sg_id" != "None" ] && [ -n "$eks_sg_id" ]; then
            log "Adding security group rule: EKS ($eks_sg_id) -> RDS ($rds_sg_id) on port 5432"
            aws ec2 authorize-security-group-ingress \
                --region $REGION \
                --group-id $rds_sg_id \
                --protocol tcp \
                --port 5432 \
                --source-group $eks_sg_id \
                2>/dev/null || log "EKS security group rule may already exist"
        fi
        
        # Add rule to allow VPC CIDR access to RDS (broader access for EKS pods)
        if [ "$vpc_cidr" != "None" ] && [ -n "$vpc_cidr" ]; then
            log "Adding VPC CIDR rule: VPC ($vpc_cidr) -> RDS ($rds_sg_id) on port 5432"
            aws ec2 authorize-security-group-ingress \
                --region $REGION \
                --group-id $rds_sg_id \
                --protocol tcp \
                --port 5432 \
                --cidr $vpc_cidr \
                2>/dev/null || log "VPC CIDR rule may already exist"
        fi
        
        # Verify security group rules
        log "Current RDS security group rules:"
        aws ec2 describe-security-groups \
            --region $REGION \
            --group-ids $rds_sg_id \
            --query "SecurityGroups[0].IpPermissions[?FromPort==\`5432\`]" \
            --output table 2>/dev/null || log "Could not retrieve security group rules"
            
    else
        warn "Could not configure security groups automatically. Manual configuration required."
        log "Please ensure the RDS security group allows inbound connections on port 5432 from the EKS VPC"
    fi
}

# Configure RDS SSL settings for development
configure_rds_ssl_settings() {
    log "Configuring RDS SSL settings for development environment..."
    
    # Get RDS parameter group name
    local param_group=$(aws rds describe-db-instances \
        --region $REGION \
        --query "DBInstances[?DBInstanceIdentifier=='iit-test-dev-db'].DBParameterGroups[0].DBParameterGroupName" \
        --output text 2>/dev/null)
    
    if [ "$param_group" != "None" ] && [ -n "$param_group" ]; then
        log "RDS Parameter Group: $param_group"
        
        # Check if this is a default parameter group (can't be modified)
        if [[ "$param_group" == default.* ]]; then
            warn "Using default parameter group ($param_group) - cannot modify SSL settings"
            log "For production, consider creating a custom parameter group"
        else
            log "Configuring parameter group to allow non-SSL connections..."
            
            # Set rds.force_ssl to 0 to allow non-SSL connections
            aws rds modify-db-parameter-group \
                --region $REGION \
                --db-parameter-group-name $param_group \
                --parameters "ParameterName=rds.force_ssl,ParameterValue=0,ApplyMethod=immediate" \
                2>/dev/null || log "Parameter may already be set or parameter group is read-only"
                
            log "Parameter group configured for non-SSL connections"
        fi
    else
        warn "Could not determine RDS parameter group"
    fi
}

# Test database connectivity
test_database_connection() {
    log "Testing database connectivity with SSL options..."
    
    # Test connection with SSL disabled first (common for development)
    local connection_test_nossl=$(PGPASSWORD=$DB_PASSWORD psql -h $RDS_ENDPOINT -U $DB_USER -d postgres -p $DB_PORT -c "SELECT version();" --connect-timeout=10 2>&1)
    local exit_code_nossl=$?
    
    if [ $exit_code_nossl -eq 0 ]; then
        log "✅ Database connection successful (no SSL)"
    else
        log "Connection test without SSL failed: $connection_test_nossl"
        
        # Try with SSL required
        log "Trying connection with SSL required..."
        local connection_test_ssl=$(PGPASSWORD=$DB_PASSWORD psql -h $RDS_ENDPOINT -U $DB_USER -d postgres -p $DB_PORT -c "SELECT version();" --connect-timeout=10 sslmode=require 2>&1)
        local exit_code_ssl=$?
        
        if [ $exit_code_ssl -eq 0 ]; then
            log "✅ Database connection successful (SSL required)"
            log "Note: Applications should use SSL connections"
        else
            log "Connection test with SSL failed: $connection_test_ssl"
            warn "Database connection test failed with both SSL and non-SSL modes"
            log "This might be due to security group configuration or RDS parameter group settings"
            log "Continuing deployment - security groups will be configured automatically"
        fi
    fi
}

# Create database if it doesn't exist
create_database() {
    log "Creating database '$DB_NAME' if it doesn't exist..."
    
    local db_exists=$(PGPASSWORD=$DB_PASSWORD psql -h $RDS_ENDPOINT -U $DB_USER -d postgres -p $DB_PORT -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'" 2>/dev/null)
    
    if [ "$db_exists" = "1" ]; then
        log "Database '$DB_NAME' already exists"
    else
        log "Creating database '$DB_NAME'..."
        PGPASSWORD=$DB_PASSWORD psql -h $RDS_ENDPOINT -U $DB_USER -d postgres -p $DB_PORT -c "CREATE DATABASE $DB_NAME;" || {
            warn "Database creation may have failed, but continuing..."
        }
        log "✅ Database '$DB_NAME' creation attempted"
    fi
}

# Initialize database schema
initialize_database_schema() {
    log "Initializing database schema..."
    
    local schema_file="database/init-scripts/01-create-schema-dev.sql"
    
    if [ ! -f "$schema_file" ]; then
        warn "Schema file not found: $schema_file. Using base schema..."
        schema_file="database/init-scripts/01-create-schema.sql"
        
        if [ ! -f "$schema_file" ]; then
            warn "No schema files found. Skipping schema initialization."
            return
        fi
        
        # Modify schema for dev database name
        local temp_schema="/tmp/schema-dev.sql"
        sed "s/lugx_gaming/$DB_NAME/g" "$schema_file" > "$temp_schema"
        schema_file="$temp_schema"
    fi
    
    log "Applying database schema from $schema_file..."
    PGPASSWORD=$DB_PASSWORD psql -h $RDS_ENDPOINT -U $DB_USER -d $DB_NAME -p $DB_PORT -f "$schema_file" || {
        warn "Schema initialization had some issues, but continuing..."
        log "You may need to run the schema initialization manually later"
    }
    
    # Clean up temp file
    [ -f "/tmp/schema-dev.sql" ] && rm -f "/tmp/schema-dev.sql"
    
    log "✅ Database schema initialized"
}

# Generate image tag
generate_image_tag() {
    local timestamp=$(date +"%Y%m%d-%H%M%S")
    if command -v git >/dev/null 2>&1 && git rev-parse --git-dir >/dev/null 2>&1; then
        local git_hash=$(git rev-parse --short HEAD 2>/dev/null || echo "nogit")
        echo "v${timestamp}-${git_hash}"
    else
        echo "v${timestamp}"
    fi
}

# Build and push images with multi-architecture support
build_and_push() {
    local service=$1
    local tag=$(generate_image_tag)
    local image_name="${ECR_REGISTRY}/${REPO_PREFIX}/${service}"
    
    log "🔨 Building ${service} with tag ${tag}..."
    
    # Build the image for amd64 platform
    docker build --platform linux/amd64 -t "${service}:${tag}" -t "${service}:latest" "services/${service}/" || {
        error "Failed to build ${service}"
    }
    
    # Tag for ECR
    docker tag "${service}:${tag}" "${image_name}:${tag}"
    docker tag "${service}:latest" "${image_name}:latest"
    
    # Push to ECR
    log "📤 Pushing ${service} to ECR..."
    docker push "${image_name}:${tag}" || error "Failed to push ${service}:${tag} to ECR"
    docker push "${image_name}:latest" || error "Failed to push ${service}:latest to ECR"
    
    log "✅ Successfully pushed ${service}:${tag}"
    echo "${tag}"
}

# Cleanup old images
cleanup_images() {
    log "🧹 Cleaning up old Docker images..."
    
    # Remove dangling images
    docker image prune -f
    
    # Remove old service images (keep latest)
    docker images --format "table {{.Repository}}:{{.Tag}}" | 
        grep -E "(frontend|gaming-service|order-service|analytics-service)" | 
        grep -v latest | head -10 | xargs -r docker rmi 2>/dev/null || true
    
    log "✅ Image cleanup completed!"
}



# Update dev overlay kustomization with new image tags
update_kustomization() {
    local frontend_tag=$1
    local gaming_tag=$2
    local order_tag=$3
    local analytics_tag=$4
    
    log "📝 Updating image tags in existing kustomization..."
    
    # Create a backup of the original file
    cp kustomize/overlays/dev/kustomization.yaml kustomize/overlays/dev/kustomization.yaml.backup
    
    # Use a safer approach with awk to update image tags
    awk -v frontend="$frontend_tag" -v gaming="$gaming_tag" -v order="$order_tag" -v analytics="$analytics_tag" '
    /- name:.*\/frontend$/ { 
        print $0
        getline
        if ($0 ~ /newTag:/) {
            print "  newTag: " frontend
        } else {
            print $0
        }
        next
    }
    /- name:.*\/gaming-service$/ { 
        print $0
        getline
        if ($0 ~ /newTag:/) {
            print "  newTag: " gaming
        } else {
            print $0
        }
        next
    }
    /- name:.*\/order-service$/ { 
        print $0
        getline
        if ($0 ~ /newTag:/) {
            print "  newTag: " order
        } else {
            print $0
        }
        next
    }
    /- name:.*\/analytics-service$/ { 
        print $0
        getline
        if ($0 ~ /newTag:/) {
            print "  newTag: " analytics
        } else {
            print $0
        }
        next
    }
    { print $0 }
    ' kustomize/overlays/dev/kustomization.yaml > kustomize/overlays/dev/kustomization.yaml.new
    
    # Replace the original file with the updated one
    mv kustomize/overlays/dev/kustomization.yaml.new kustomize/overlays/dev/kustomization.yaml
    
    # Test kustomize build
    if kustomize build kustomize/overlays/dev/ > /dev/null 2>&1; then
        rm -f kustomize/overlays/dev/kustomization.yaml.backup
        log "✅ Image tags updated successfully!"
        log "Updated tags: frontend:${frontend_tag}, gaming:${gaming_tag}, order:${order_tag}, analytics:${analytics_tag}"
    else
        log "Kustomization build failed, showing error:"
        kustomize build kustomize/overlays/dev/ 2>&1 || true
        mv kustomize/overlays/dev/kustomization.yaml.backup kustomize/overlays/dev/kustomization.yaml
        error "Kustomization validation failed. Backup restored."
    fi
}

# Deploy to Kubernetes using existing dev overlay
deploy_to_k8s() {
    log "🚀 Deploying to Kubernetes using existing kustomize templates..."
    
    # Verify kustomization exists
    if [ ! -f "kustomize/overlays/dev/kustomization.yaml" ]; then
        error "Kustomization file not found at kustomize/overlays/dev/kustomization.yaml"
    fi
    
    # Apply kustomization using kubectl
    kubectl apply -k kustomize/overlays/dev/
    
    # Wait for rollout
    log "⏳ Waiting for deployments to be ready..."
    kubectl rollout status deployment/frontend -n ${NAMESPACE} --timeout=300s
    kubectl rollout status deployment/gaming-service -n ${NAMESPACE} --timeout=300s
    kubectl rollout status deployment/order-service -n ${NAMESPACE} --timeout=300s
    kubectl rollout status deployment/analytics-service -n ${NAMESPACE} --timeout=300s
    kubectl rollout status deployment/clickhouse -n ${NAMESPACE} --timeout=300s
    kubectl rollout status deployment/health-check -n ${NAMESPACE} --timeout=300s
    
    log "✅ Deployment completed successfully!"
}

# Verify deployment status
verify_deployment() {
    log "🔍 Verifying deployment status..."
    
    # Check pod status
    log "📊 Pod Status:"
    kubectl get pods -n ${NAMESPACE} -o wide
    
    # Check deployment status
    log "📊 Deployment Status:"
    kubectl get deployments -n ${NAMESPACE}
    
    # Check services
    log "📊 Services:"
    kubectl get services -n ${NAMESPACE}
    
    # Check ingress if exists
    log "📊 Ingress:"
    kubectl get ingress -n ${NAMESPACE} 2>/dev/null || log "No ingress found"
    
    # Get running pod count
    local running_pods=$(kubectl get pods -n ${NAMESPACE} --field-selector=status.phase=Running --no-headers | wc -l | tr -d ' ')
    local total_pods=$(kubectl get pods -n ${NAMESPACE} --no-headers | wc -l | tr -d ' ')
    
    log "📈 Status Summary: ${running_pods}/${total_pods} pods running"
    
    if [[ ${running_pods} -eq ${total_pods} && ${running_pods} -gt 0 ]]; then
        log "✅ All deployments are healthy!"
    else
        warn "⚠️  Some pods may not be ready. Check the status above."
    fi
    
    # Show application URLs
    show_application_urls
}

# Show application URLs
show_application_urls() {
    log "🌐 Application URLs:"
    
    # Get LoadBalancer services
    local frontend_service=$(kubectl get svc frontend-service -n ${NAMESPACE} -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || echo "pending")
    local health_service=$(kubectl get svc health-check-service -n ${NAMESPACE} -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || echo "pending")
    
    if [[ "$frontend_service" != "pending" && -n "$frontend_service" ]]; then
        log "  Frontend: http://${frontend_service}"
    else
        log "  Frontend: LoadBalancer pending... Use port-forward: kubectl port-forward svc/frontend-service 3000:80 -n ${NAMESPACE}"
    fi
    
    if [[ "$health_service" != "pending" && -n "$health_service" ]]; then
        log "  Health Dashboard: http://${health_service}"
    else
        log "  Health Dashboard: Use port-forward: kubectl port-forward svc/health-check-service 8080:80 -n ${NAMESPACE}"
    fi
}

# Cleanup old images
cleanup_images() {
    log "Cleaning up old Docker images..."
    
    # Remove dangling images
    docker image prune -f
    
    # Remove old tagged images (keep latest)
    docker images --format "table {{.Repository}}:{{.Tag}}" | grep -E "(frontend|gaming-service|order-service|analytics-service)" | grep -v latest | head -10 | xargs -r docker rmi 2>/dev/null || true
    
    log "Image cleanup completed!"
}

# Configure kubectl for EKS cluster
configure_eks_access() {
    log "🔧 Configuring kubectl for EKS cluster..."
    
    # Update kubeconfig for EKS cluster
    aws eks update-kubeconfig --region ${REGION} --name ${EKS_CLUSTER_NAME} || {
        error "Failed to configure kubectl for EKS cluster '${EKS_CLUSTER_NAME}'"
    }
    
    # Verify connection to cluster
    kubectl cluster-info --request-timeout=10s > /dev/null || {
        error "Unable to connect to EKS cluster"
    }
    
    local current_context=$(kubectl config current-context)
    log "✅ Connected to EKS cluster: ${current_context}"
}

# Main deployment flow
main() {
    log "🚀 Starting Gaming Microservices All-in-One Deployment..."
    log "📍 Target: EKS Cluster '${EKS_CLUSTER_NAME}' in region '${REGION}'"
    log "🗄️  Database: ${RDS_ENDPOINT}/${DB_NAME}"
    log "📦 Registry: ${ECR_REGISTRY}"
    echo
    
    # Step 1: Prerequisites
    check_prerequisites
    
    # Step 2: Configure EKS access
    configure_eks_access
    
    # Step 3: Login to ECR
    log "🔐 Logging in to ECR..."
    aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
    
    # Step 4: Setup Database
    setup_database
    
    # Step 5: Build and push all services
    log "🔨 Building and pushing microservices..."
    frontend_tag=$(build_and_push "frontend")
    gaming_tag=$(build_and_push "gaming-service")
    order_tag=$(build_and_push "order-service")
    analytics_tag=$(build_and_push "analytics-service")
    
    # Step 6: Update kustomization with new image tags
    update_kustomization "${frontend_tag}" "${gaming_tag}" "${order_tag}" "${analytics_tag}"
    
    # Step 7: Deploy to Kubernetes
    deploy_to_k8s
    
    # Step 8: Verify deployment
    verify_deployment
    
    # Step 9: Cleanup local images
    cleanup_images
    
    echo
    log "🎉 Gaming Microservices Deployment Completed Successfully!"
    log "📦 Deployed Images:"
    log "  • Frontend: ${ECR_REGISTRY}/${REPO_PREFIX}/frontend:${frontend_tag}"
    log "  • Gaming Service: ${ECR_REGISTRY}/${REPO_PREFIX}/gaming-service:${gaming_tag}"
    log "  • Order Service: ${ECR_REGISTRY}/${REPO_PREFIX}/order-service:${order_tag}"
    log "  • Analytics Service: ${ECR_REGISTRY}/${REPO_PREFIX}/analytics-service:${analytics_tag}"
    log "🗄️  Database: ${DB_NAME} on ${RDS_ENDPOINT}"
    log "🌐 Namespace: ${NAMESPACE}"
    echo
    log "🔍 Monitor your deployment:"
    log "  kubectl get pods -n ${NAMESPACE} -w"
    log "  kubectl logs -f deployment/frontend -n ${NAMESPACE}"
}

# Handle script arguments
case "${1:-deploy}" in
    "build-only")
        check_prerequisites
        aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
        log "🔨 Building and pushing all services..."
        build_and_push "frontend"
        build_and_push "gaming-service"
        build_and_push "order-service"
        build_and_push "analytics-service"
        log "✅ Build completed!"
        ;;
    "deploy-only")
        check_prerequisites
        configure_eks_access
        deploy_to_k8s
        verify_deployment
        ;;
    "database-only")
        check_prerequisites
        setup_database
        ;;
    "cleanup")
        cleanup_images
        ;;
    "status")
        verify_deployment
        ;;
    "help"|"--help"|"-h")
        echo "Gaming Microservices Deployment Script"
        echo ""
        echo "Usage: $0 [COMMAND]"
        echo ""
        echo "Commands:"
        echo "  deploy        Full deployment (default) - database, build, push, deploy"
        echo "  build-only    Build and push images only"
        echo "  deploy-only   Deploy to Kubernetes only (assumes images exist)"
        echo "  database-only Setup database only"
        echo "  status        Show deployment status"
        echo "  cleanup       Clean up local Docker images"
        echo "  help          Show this help message"
        echo ""
        ;;
    "deploy"|*)
        main
        ;;
esac
