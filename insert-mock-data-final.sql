-- Mock Data Insertion Script for LUGX Gaming Platform (Final Sequelize Compatible)
-- This script will populate the database with realistic test data

-- Connect to the appropriate database
\c app_database;

-- Insert sample users (only using existing columns)
INSERT INTO "Users" (id, username, email, password, "firstName", "lastName", "isActive", "createdAt", "updatedAt") VALUES
(uuid_generate_v4(), 'johndoe', 'john.doe@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'John', 'Doe', true, NOW(), NOW()),
(uuid_generate_v4(), 'sarahsmith', 'sarah.smith@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'Sarah', 'Smith', true, NOW(), NOW()),
(uuid_generate_v4(), 'mikejohnson', 'mike.johnson@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'Mike', 'Johnson', true, NOW(), NOW()),
(uuid_generate_v4(), 'emilydavis', 'emily.davis@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'Emily', 'Davis', true, NOW(), NOW()),
(uuid_generate_v4(), 'alexwilson', 'alex.wilson@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'Alex', 'Wilson', true, NOW(), NOW()),
(uuid_generate_v4(), 'jessicabrown', 'jessica.brown@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'Jessica', 'Brown', true, NOW(), NOW()),
(uuid_generate_v4(), 'davidmiller', 'david.miller@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'David', 'Miller', true, NOW(), NOW()),
(uuid_generate_v4(), 'lisagarcia', 'lisa.garcia@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'Lisa', 'Garcia', true, NOW(), NOW())
ON CONFLICT (email) DO NOTHING;

-- Insert sample products (using existing columns and enum values)
INSERT INTO "Products" (id, name, description, price, "originalPrice", category, platform, stock, rating, "imageUrl", featured, trending, "isActive", "createdAt", "updatedAt") VALUES
(uuid_generate_v4(), 'Cyber Warriors 2077', 'Futuristic action game set in a cyberpunk world', 59.99, 79.99, 'action', 'pc', 100, 4.5, '/images/cyber-warriors.jpg', true, true, true, NOW(), NOW()),
(uuid_generate_v4(), 'Fantasy Quest Online', 'Massive multiplayer RPG with epic adventures', 49.99, 59.99, 'rpg', 'pc', 200, 4.7, '/images/fantasy-quest.jpg', true, false, true, NOW(), NOW()),
(uuid_generate_v4(), 'Street Racer X', 'High-octane street racing experience', 39.99, 49.99, 'racing', 'pc', 150, 4.2, '/images/street-racer.jpg', false, true, true, NOW(), NOW()),
(uuid_generate_v4(), 'Mystic Islands', 'Explore magical islands in this adventure game', 29.99, 39.99, 'adventure', 'pc', 80, 4.3, '/images/mystic-islands.jpg', false, false, true, NOW(), NOW()),
(uuid_generate_v4(), 'War Strategy', 'Command armies in epic battlefield tactics', 54.99, 64.99, 'strategy', 'pc', 90, 4.6, '/images/war-strategy.jpg', true, false, true, NOW(), NOW()),
(uuid_generate_v4(), 'Football Manager 2024', 'Manage your dream football team', 49.99, 59.99, 'sports', 'pc', 300, 4.4, '/images/football-manager.jpg', false, true, true, NOW(), NOW()),
(uuid_generate_v4(), 'City Builder Pro', 'Build and manage your perfect city', 34.99, 44.99, 'simulation', 'pc', 120, 4.1, '/images/city-builder.jpg', false, false, true, NOW(), NOW()),
(uuid_generate_v4(), 'Brain Teaser Collection', 'Collection of challenging puzzle games', 19.99, 29.99, 'simulation', 'pc', 250, 3.9, '/images/brain-teaser.jpg', false, false, true, NOW(), NOW()),
(uuid_generate_v4(), 'Battlefield Heroes', 'Tactical first-person shooter experience', 39.99, 49.99, 'action', 'pc', 180, 4.5, '/images/battlefield-heroes.jpg', true, true, true, NOW(), NOW()),
(uuid_generate_v4(), 'Space Odyssey', 'Epic space exploration RPG adventure', 44.99, 54.99, 'rpg', 'pc', 110, 4.8, '/images/space-odyssey.jpg', true, false, true, NOW(), NOW()),
(uuid_generate_v4(), 'Racing Legends', 'Classic car racing with vintage vehicles', 29.99, 39.99, 'racing', 'pc', 140, 4.0, '/images/racing-legends.jpg', false, false, true, NOW(), NOW()),
(uuid_generate_v4(), 'Dungeon Master', 'Create and explore dangerous dungeons', 24.99, 34.99, 'rpg', 'pc', 95, 4.2, '/images/dungeon-master.jpg', false, false, true, NOW(), NOW()),
(uuid_generate_v4(), 'Flight Simulator Pro', 'Realistic flight simulation experience', 69.99, 79.99, 'simulation', 'pc', 75, 4.7, '/images/flight-simulator.jpg', true, false, true, NOW(), NOW()),
(uuid_generate_v4(), 'Tennis Championship', 'Professional tennis simulation', 39.99, 49.99, 'sports', 'pc', 160, 4.1, '/images/tennis-championship.jpg', false, false, true, NOW(), NOW()),
(uuid_generate_v4(), 'Mind Bender', 'Advanced puzzle solving challenges', 14.99, 24.99, 'strategy', 'pc', 300, 3.8, '/images/mind-bender.jpg', false, false, true, NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Insert sample orders
DO $$
DECLARE
    user_ids UUID[];
    product_ids UUID[];
    user_id UUID;
    product_id UUID;
    order_id UUID;
    i INTEGER;
    sample_address JSON := '{"street": "123 Gaming St", "city": "Tech City", "state": "CA", "zip": "12345", "country": "USA"}';
BEGIN
    -- Get user and product IDs
    SELECT ARRAY(SELECT id FROM "Users" LIMIT 8) INTO user_ids;
    SELECT ARRAY(SELECT id FROM "Products" LIMIT 15) INTO product_ids;
    
    -- Create sample orders
    FOR i IN 1..20 LOOP
        user_id := user_ids[1 + (i % array_length(user_ids, 1))];
        
        INSERT INTO "Orders" (id, "userId", "orderNumber", status, "totalAmount", currency, "paymentMethod", "paymentStatus", "shippingAddress", "billingAddress", "createdAt", "updatedAt")
        VALUES (
            uuid_generate_v4(),
            user_id,
            'LGX-' || TO_CHAR(CURRENT_DATE, 'YYYYMMDD') || '-' || LPAD(i::TEXT, 6, '0'),
            CASE 
                WHEN i % 5 = 0 THEN 'delivered'::"enum_Orders_status"
                WHEN i % 4 = 0 THEN 'shipped'::"enum_Orders_status"
                WHEN i % 3 = 0 THEN 'processing'::"enum_Orders_status"
                ELSE 'pending'::"enum_Orders_status"
            END,
            (random() * 200 + 20)::DECIMAL(10,2),
            'USD',
            CASE 
                WHEN i % 3 = 0 THEN 'credit_card'
                WHEN i % 3 = 1 THEN 'paypal'
                ELSE 'debit_card'
            END,
            CASE 
                WHEN i % 5 = 0 THEN 'paid'::"enum_Orders_paymentStatus"
                WHEN i % 4 = 0 THEN 'paid'::"enum_Orders_paymentStatus"
                WHEN i % 3 = 0 THEN 'pending'::"enum_Orders_paymentStatus"
                ELSE 'pending'::"enum_Orders_paymentStatus"
            END,
            sample_address,
            sample_address,
            NOW() - (random() * interval '30 days'),
            NOW()
        ) RETURNING id INTO order_id;
        
        -- Add 1-3 items per order
        FOR j IN 1..(1 + (i % 3)) LOOP
            product_id := product_ids[1 + ((i + j) % array_length(product_ids, 1))];
            
            INSERT INTO "OrderItems" (id, "orderId", "productId", "productName", "productPrice", quantity, "totalPrice", "createdAt", "updatedAt")
            SELECT 
                uuid_generate_v4(),
                order_id,
                product_id,
                p.name,
                p.price,
                1 + (i % 3),
                p.price * (1 + (i % 3)),
                NOW(),
                NOW()
            FROM "Products" p WHERE p.id = product_id;
        END LOOP;
    END LOOP;
END $$;

-- Insert sample reviews
DO $$
DECLARE
    user_ids UUID[];
    product_ids UUID[];
    user_id UUID;
    product_id UUID;
    i INTEGER;
    j INTEGER;
BEGIN
    SELECT ARRAY(SELECT id FROM "Users" LIMIT 8) INTO user_ids;
    SELECT ARRAY(SELECT id FROM "Products" LIMIT 15) INTO product_ids;
    
    FOR i IN 1..array_length(user_ids, 1) LOOP
        FOR j IN 1..(2 + (i % 3)) LOOP -- Each user reviews 2-4 products
            user_id := user_ids[i];
            product_id := product_ids[1 + ((i + j) % array_length(product_ids, 1))];
            
            INSERT INTO "Reviews" (id, "userId", "productId", rating, comment, "createdAt", "updatedAt")
            VALUES (
                uuid_generate_v4(),
                user_id,
                product_id,
                4 + (i % 2), -- Rating 4 or 5
                CASE 
                    WHEN (i + j) % 4 = 0 THEN 'This game exceeded my expectations. Great graphics and gameplay!'
                    WHEN (i + j) % 4 = 1 THEN 'Had a lot of fun playing this. Worth every penny.'
                    WHEN (i + j) % 4 = 2 THEN 'Good quality game with hours of entertainment.'
                    ELSE 'One of the best games I''ve played this year. Definitely recommend!'
                END,
                NOW() - (random() * interval '60 days'),
                NOW()
            ) ON CONFLICT DO NOTHING;
        END LOOP;
    END LOOP;
END $$;

-- Update order totals based on order items
UPDATE "Orders" SET "totalAmount" = (
    SELECT COALESCE(SUM("totalPrice"), 0)
    FROM "OrderItems" 
    WHERE "OrderItems"."orderId" = "Orders".id
) WHERE EXISTS (
    SELECT 1 FROM "OrderItems" WHERE "OrderItems"."orderId" = "Orders".id
);

-- Print summary
DO $$
DECLARE
    user_count INTEGER;
    product_count INTEGER;
    order_count INTEGER;
    review_count INTEGER;
    order_item_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO user_count FROM "Users";
    SELECT COUNT(*) INTO product_count FROM "Products";
    SELECT COUNT(*) INTO order_count FROM "Orders";
    SELECT COUNT(*) INTO review_count FROM "Reviews";
    SELECT COUNT(*) INTO order_item_count FROM "OrderItems";
    
    RAISE NOTICE '=== Mock Data Insertion Summary ===';
    RAISE NOTICE 'Users: %', user_count;
    RAISE NOTICE 'Products: %', product_count;
    RAISE NOTICE 'Orders: %', order_count;
    RAISE NOTICE 'Order Items: %', order_item_count;
    RAISE NOTICE 'Reviews: %', review_count;
    RAISE NOTICE '=== Mock Data Insertion Complete ===';
    
    -- Also show some sample data
    RAISE NOTICE '=== Sample Products ===';
    PERFORM (SELECT name || ' - $' || price || ' (' || category || ')' FROM "Products" LIMIT 5);
    
    RAISE NOTICE '=== Sample Orders ===';
    PERFORM (SELECT "orderNumber" || ' - $' || "totalAmount" || ' (' || status || ')' FROM "Orders" LIMIT 5);
END $$;
