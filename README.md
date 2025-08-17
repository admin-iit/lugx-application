# 🎮 Lugx Gaming Microservices Platform

A comprehensive cloud-native gaming platform built with microservices architecture, deployed on AWS EKS with complete CI/CD pipeline.

![Lugx Gaming](https://img.shields.io/badge/Lugx-Gaming-red)
![AWS EKS](https://img.shields.io/badge/AWS-EKS-orange)
![Node.js](https://img.shields.io/badge/Node.js-339933?logo=node.js&logoColor=white)
![React](https://img.shields.io/badge/React-61DAFB?logo=react&logoColor=black)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?logo=kubernetes&logoColor=white)

## 🚀 Live Application

**Frontend URL**: [http://k8s-lugxgami-gamingmi-04b5035527-659051128.ap-southeast-1.elb.amazonaws.com](http://k8s-lugxgami-gamingmi-04b5035527-659051128.ap-southeast-1.elb.amazonaws.com)

### 📊 Key Pages:
- **Home**: Landing page with platform overview
- **Gaming**: [/gaming](http://k8s-lugxgami-gamingmi-04b5035527-659051128.ap-southeast-1.elb.amazonaws.com/gaming) - Browse and manage gaming products
- **Analytics**: [/analytics](http://k8s-lugxgami-gamingmi-04b5035527-659051128.ap-southeast-1.elb.amazonaws.com/analytics) - Comprehensive RDS data dashboard

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │  Gaming Service │    │  Order Service  │
│   (React)       │    │   (Node.js)     │    │   (Node.js)     │
│   Port: 8080    │    │   Port: 3001    │    │   Port: 3002    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Analytics Svc   │    │  Health Check   │    │   PostgreSQL    │
│  (Node.js)      │    │   (Node.js)     │    │     RDS         │
│  Port: 3003     │    │   Port: 3000    │    │   Port: 5432    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🛠️ Technology Stack

### Backend Services
- **Node.js**: Runtime environment
- **Express.js**: Web framework
- **Sequelize**: PostgreSQL ORM
- **JWT**: Authentication

### Frontend
- **React 18**: UI framework
- **React Router**: Client-side routing
- **Context API**: State management
- **CSS3**: Styling with red theme

### Infrastructure
- **AWS EKS**: Kubernetes orchestration
- **AWS RDS**: PostgreSQL database
- **AWS ALB**: Application Load Balancer
- **AWS ECR**: Container registry
- **Kustomize**: Kubernetes configuration management

### DevOps
- **Docker**: Containerization
- **GitHub Actions**: CI/CD pipeline
- **Kubernetes**: Container orchestration
- **Nginx**: Frontend web server

## 🎯 Features

### 🎮 Gaming Platform
- **Product Catalog**: 15+ gaming products with categories
- **Search & Filter**: Find games by category, platform, rating
- **Shopping Cart**: Add products and manage orders
- **User Reviews**: Rating and review system
- **Real-time Data**: Live updates from PostgreSQL RDS

### 📊 Analytics Dashboard
- **Product Statistics**: Total products, categories, platforms
- **User Metrics**: Registration data, activity tracking
- **Top Rated Games**: Ranked by user ratings
- **Database Status**: Real-time connection monitoring
- **Inventory Overview**: Stock levels and total value

### 🎨 User Experience
- **Red Theme**: Consistent crimson color scheme
- **Responsive Design**: Mobile and desktop optimized
- **Interactive UI**: Hover effects and animations
- **Fast Loading**: Optimized React builds

## 🚀 Quick Deployment

### GitHub Actions CI/CD Pipeline

The repository includes a complete GitHub Actions pipeline that automatically:

1. **Builds** all microservices as Docker images
2. **Pushes** to AWS ECR registry
3. **Deploys** to EKS cluster using Kustomize
4. **Runs** health checks and verification

#### Setup Instructions:

1. **Fork/Clone this repository**
2. **Add GitHub Secrets**:
   ```
   AWS_ACCESS_KEY_ID=your_access_key
   AWS_SECRET_ACCESS_KEY=your_secret_key
   ```
3. **Push to trigger deployment**:
   ```bash
   git push origin main      # Deploys to production
   git push origin develop   # Deploys to development
   ```

### Manual Deployment

If you prefer manual deployment:

```bash
# 1. Login to ECR
aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 776231021342.dkr.ecr.ap-southeast-1.amazonaws.com

# 2. Build and push images
cd services/frontend
docker build -t 776231021342.dkr.ecr.ap-southeast-1.amazonaws.com/iit-gaming-microservices/frontend:latest .
docker push 776231021342.dkr.ecr.ap-southeast-1.amazonaws.com/iit-gaming-microservices/frontend:latest

# 3. Deploy to EKS
aws eks update-kubeconfig --region ap-southeast-1 --name iit-eks-tests-01
kubectl apply -k kustomize/overlays/production
```

## 🗄️ Database Setup

### RDS Configuration
- **Host**: `iit-rds-tests-01.cfwsc626ix76.ap-southeast-1.rds.amazonaws.com`
- **Database**: PostgreSQL with 15 gaming products, 9 users, reviews

### Mock Data Included
- Gaming products across 7 categories
- User accounts and profiles
- Product reviews and ratings
- Order history

## 📁 Project Structure

```
lugx-application/
├── .github/workflows/
│   └── deploy-to-eks.yml          # Complete CI/CD pipeline
├── services/
│   ├── frontend/                  # React application
│   ├── gaming-service/            # Products API
│   ├── order-service/             # Order management
│   ├── analytics-service/         # Analytics API
│   └── health-check/              # Health monitoring
├── kustomize/
│   ├── base/                      # Base K8s configs
│   └── overlays/
│       ├── dev/                   # Development env
│       └── production/            # Production env
├── database/
│   └── init-scripts/              # Database setup
└── scripts/
    └── deploy-optimized.sh        # Deployment helper
```

## 📊 API Endpoints

### Live API Testing
All APIs are accessible via the ALB:

```bash
# Products API
curl "http://k8s-lugxgami-gamingmi-04b5035527-659051128.ap-southeast-1.elb.amazonaws.com/api/products"

# Users API  
curl "http://k8s-lugxgami-gamingmi-04b5035527-659051128.ap-southeast-1.elb.amazonaws.com/api/users"

# Health Check
curl "http://k8s-lugxgami-gamingmi-04b5035527-659051128.ap-southeast-1.elb.amazonaws.com/health"
```

## 🔧 Environment Configuration

### Development vs Production

The project supports both environments with Kustomize overlays:

- **Development** (`kustomize/overlays/dev/`): Lower resource limits, debug logging
- **Production** (`kustomize/overlays/production/`): Optimized for performance, security

### Required Secrets

```yaml
# GitHub Secrets for CI/CD
AWS_ACCESS_KEY_ID: your-aws-access-key
AWS_SECRET_ACCESS_KEY: your-aws-secret-key

# Application Secrets (in Kubernetes)
DB_PASSWORD: database-password
JWT_SECRET: jwt-signing-secret
```

## 🎨 UI Theme & Design

### Red Color Palette
- **Primary**: `#DC143C` (Crimson)
- **Dark**: `#8B0000` (Dark Red)
- **Medium**: `#B22222` (Fire Brick)
- **Light**: `#FFCCCB` (Light Pink)
- **Background**: `#FFE6E6` (Misty Rose)

### Features
- Fully responsive design
- Interactive hover effects
- Professional dashboard layouts
- Consistent branding

## 📈 Monitoring & Health

### Built-in Health Checks
- Kubernetes liveness/readiness probes
- Database connectivity verification
- Service-to-service communication tests
- Frontend availability monitoring

### Monitoring Commands
```bash
# Check all pods
kubectl get pods -n lugx-gaming

# View logs
kubectl logs -f deployment/frontend -n lugx-gaming

# Check ingress
kubectl get ingress -n lugx-gaming
```

## 🛡️ Security Features

- **JWT Authentication**: Secure API endpoints
- **Kubernetes Network Policies**: Service isolation
- **AWS Security Groups**: Database protection
- **Environment Secrets**: Encrypted configuration
- **HTTPS Ready**: SSL/TLS support

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Test locally: `npm test`
5. Commit: `git commit -m 'Add amazing feature'`
6. Push: `git push origin feature/amazing-feature`
7. Create Pull Request

## 🆘 Troubleshooting

### Common Issues

**Deployment Fails**: Check AWS credentials and EKS access
```bash
aws sts get-caller-identity
kubectl auth can-i create deployments --namespace=lugx-gaming
```

**Images Not Pulling**: Verify ECR permissions
```bash
aws ecr describe-repositories --region ap-southeast-1
```

**Database Connection**: Check RDS security groups and credentials
```bash
# Test from pod
kubectl exec -it deployment/gaming-service -n lugx-gaming -- nc -zv iit-rds-tests-01.cfwsc626ix76.ap-southeast-1.rds.amazonaws.com 5432
```

## 📞 Support

- **Issues**: Create GitHub issue
- **Documentation**: Check inline code comments
- **Logs**: Use `kubectl logs` commands above

---

## 🎉 Success Metrics

✅ **Fully Deployed**: All 5 microservices running on EKS  
✅ **Database Connected**: PostgreSQL RDS with 15+ products  
✅ **CI/CD Pipeline**: Automated GitHub Actions deployment  
✅ **Public Access**: ALB providing internet access  
✅ **Red Theme**: Complete UI styling implemented  
✅ **Analytics Dashboard**: Real-time data visualization  

**🎮 Your Lugx Gaming Platform is Ready! 🚀**

Visit: [http://k8s-lugxgami-gamingmi-04b5035527-659051128.ap-southeast-1.elb.amazonaws.com](http://k8s-lugxgami-gamingmi-04b5035527-659051128.ap-southeast-1.elb.amazonaws.com)
