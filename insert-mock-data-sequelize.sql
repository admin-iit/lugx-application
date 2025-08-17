-- Mock Data Insertion Script for LUGX Gaming Platform (Sequelize Compatible)
-- This script will populate the database with realistic test data

-- Connect to the appropriate database
\c app_database;

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- First, let's check the table structure
\d "Users"

-- Insert sample users
INSERT INTO "Users" (id, username, email, password, "firstName", "lastName", phone, "dateOfBirth", "isActive", "isPremium", "createdAt", "updatedAt") VALUES
(uuid_generate_v4(), 'johndoe', 'john.doe@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'John', 'Doe', '+1234567890', '1990-05-15', true, false, NOW(), NOW()),
(uuid_generate_v4(), 'sarahsmith', 'sarah.smith@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'Sarah', 'Smith', '+1234567891', '1985-08-22', true, true, NOW(), NOW()),
(uuid_generate_v4(), 'mikejohnson', 'mike.johnson@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'Mike', 'Johnson', '+1234567892', '1992-03-10', true, false, NOW(), NOW()),
(uuid_generate_v4(), 'emilydavis', 'emily.davis@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'Emily', 'Davis', '+1234567893', '1988-11-30', true, true, NOW(), NOW()),
(uuid_generate_v4(), 'alexwilson', 'alex.wilson@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'Alex', 'Wilson', '+1234567894', '1995-07-18', true, false, NOW(), NOW()),
(uuid_generate_v4(), 'jessicabrown', 'jessica.brown@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'Jessica', 'Brown', '+1234567895', '1991-12-05', true, false, NOW(), NOW()),
(uuid_generate_v4(), 'davidmiller', 'david.miller@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'David', 'Miller', '+1234567896', '1987-04-25', true, true, NOW(), NOW()),
(uuid_generate_v4(), 'lisagarcia', 'lisa.garcia@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'Lisa', 'Garcia', '+1234567897', '1993-09-14', true, false, NOW(), NOW())
ON CONFLICT (email) DO NOTHING;

-- Check Products table structure
\d "Products"

-- Insert sample products (using the structure we can see)
INSERT INTO "Products" (id, name, description, price, category, developer, publisher, "releaseDate", rating, platform, "imageUrl", "isActive", "createdAt", "updatedAt") VALUES
(uuid_generate_v4(), 'Cyber Warriors 2077', 'Futuristic action game set in a cyberpunk world', 59.99, 'Action', 'Future Games', 'Mega Publisher', '2024-03-15', 'M', 'PC', '/images/cyber-warriors.jpg', true, NOW(), NOW()),
(uuid_generate_v4(), 'Fantasy Quest Online', 'Massive multiplayer RPG with epic adventures', 49.99, 'RPG', 'Epic Studios', 'RPG Masters', '2024-01-20', 'T', 'PC', '/images/fantasy-quest.jpg', true, NOW(), NOW()),
(uuid_generate_v4(), 'Street Racer X', 'High-octane street racing experience', 39.99, 'Racing', 'Speed Demons', 'Racing Corp', '2024-02-10', 'E', 'PC', '/images/street-racer.jpg', true, NOW(), NOW()),
(uuid_generate_v4(), 'Mystic Islands', 'Explore magical islands in this adventure game', 29.99, 'Adventure', 'Island Studios', 'Adventure Plus', '2024-05-08', 'E', 'PC', '/images/mystic-islands.jpg', true, NOW(), NOW()),
(uuid_generate_v4(), 'War Strategy', 'Command armies in epic battlefield tactics', 54.99, 'Strategy', 'Tactical Games', 'Strategy Pro', '2024-06-12', 'T', 'PC', '/images/war-strategy.jpg', true, NOW(), NOW()),
(uuid_generate_v4(), 'Football Manager 2024', 'Manage your dream football team', 49.99, 'Sports', 'Sports Interactive', 'SEGA', '2024-11-01', 'E', 'PC', '/images/football-manager.jpg', true, NOW(), NOW()),
(uuid_generate_v4(), 'City Builder Pro', 'Build and manage your perfect city', 34.99, 'Simulation', 'Urban Games', 'City Publishers', '2024-04-20', 'E', 'PC', '/images/city-builder.jpg', true, NOW(), NOW()),
(uuid_generate_v4(), 'Brain Teaser Collection', 'Collection of challenging puzzle games', 19.99, 'Puzzle', 'Puzzle Masters', 'Think Tank', '2024-07-15', 'E', 'PC', '/images/brain-teaser.jpg', true, NOW(), NOW()),
(uuid_generate_v4(), 'Battlefield Heroes', 'Tactical first-person shooter experience', 39.99, 'Shooter', 'Combat Studios', 'War Games', '2024-08-05', 'M', 'PC', '/images/battlefield-heroes.jpg', true, NOW(), NOW()),
(uuid_generate_v4(), 'Space Odyssey', 'Epic space exploration RPG adventure', 44.99, 'RPG', 'Cosmic Games', 'Space Publishers', '2024-03-28', 'T', 'PC', '/images/space-odyssey.jpg', true, NOW(), NOW()),
(uuid_generate_v4(), 'Racing Legends', 'Classic car racing with vintage vehicles', 29.99, 'Racing', 'Retro Racing', 'Classic Games', '2024-05-22', 'E', 'PC', '/images/racing-legends.jpg', true, NOW(), NOW()),
(uuid_generate_v4(), 'Dungeon Master', 'Create and explore dangerous dungeons', 24.99, 'RPG', 'Dungeon Craft', 'Fantasy House', '2024-06-30', 'T', 'PC', '/images/dungeon-master.jpg', true, NOW(), NOW()),
(uuid_generate_v4(), 'Flight Simulator Pro', 'Realistic flight simulation experience', 69.99, 'Simulation', 'Sky Studios', 'Aviation Games', '2024-02-14', 'E', 'PC', '/images/flight-simulator.jpg', true, NOW(), NOW()),
(uuid_generate_v4(), 'Tennis Championship', 'Professional tennis simulation', 39.99, 'Sports', 'Racket Games', 'Sports World', '2024-07-01', 'E', 'PC', '/images/tennis-championship.jpg', true, NOW(), NOW()),
(uuid_generate_v4(), 'Mind Bender', 'Advanced puzzle solving challenges', 14.99, 'Puzzle', 'Brain Games', 'Logic Works', '2024-08-12', 'E', 'PC', '/images/mind-bender.jpg', true, NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Check Orders table structure
\d "Orders"

-- Insert sample orders
DO $$
DECLARE
    user_ids UUID[];
    product_ids UUID[];
    user_id UUID;
    product_id UUID;
    order_id UUID;
    i INTEGER;
BEGIN
    -- Get user and product IDs
    SELECT ARRAY(SELECT id FROM "Users" LIMIT 8) INTO user_ids;
    SELECT ARRAY(SELECT id FROM "Products" LIMIT 15) INTO product_ids;
    
    -- Create sample orders
    FOR i IN 1..20 LOOP
        user_id := user_ids[1 + (i % array_length(user_ids, 1))];
        
        INSERT INTO "Orders" (id, "userId", "orderNumber", status, "totalAmount", "paymentMethod", "paymentStatus", "createdAt", "updatedAt")
        VALUES (
            uuid_generate_v4(),
            user_id,
            'LGX-' || TO_CHAR(CURRENT_DATE, 'YYYYMMDD') || '-' || LPAD(i::TEXT, 6, '0'),
            CASE 
                WHEN i % 5 = 0 THEN 'delivered'
                WHEN i % 4 = 0 THEN 'shipped'
                WHEN i % 3 = 0 THEN 'processing'
                ELSE 'pending'
            END,
            (random() * 200 + 20)::DECIMAL(10,2),
            CASE 
                WHEN i % 3 = 0 THEN 'credit_card'
                WHEN i % 3 = 1 THEN 'paypal'
                ELSE 'debit_card'
            END,
            CASE 
                WHEN i % 5 = 0 THEN 'completed'
                WHEN i % 4 = 0 THEN 'completed'
                WHEN i % 3 = 0 THEN 'pending'
                ELSE 'pending'
            END,
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

-- Check Reviews table structure
\d "Reviews"

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
END $$;
