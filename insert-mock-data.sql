-- Mock Data Insertion Script for LUGX Gaming Platform
-- This script will populate the database with realistic test data

-- Connect to the appropriate database
\c app_database;

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Insert sample users
INSERT INTO users (username, email, password_hash, first_name, last_name, phone, date_of_birth, is_active, is_premium) VALUES
('johndoe', 'john.doe@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'John', 'Doe', '+1234567890', '1990-05-15', true, false),
('sarahsmith', 'sarah.smith@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'Sarah', 'Smith', '+1234567891', '1985-08-22', true, true),
('mikejohnson', 'mike.johnson@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'Mike', 'Johnson', '+1234567892', '1992-03-10', true, false),
('emilydavis', 'emily.davis@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'Emily', 'Davis', '+1234567893', '1988-11-30', true, true),
('alexwilson', 'alex.wilson@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'Alex', 'Wilson', '+1234567894', '1995-07-18', true, false),
('jessicabrown', 'jessica.brown@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'Jessica', 'Brown', '+1234567895', '1991-12-05', true, false),
('davidmiller', 'david.miller@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'David', 'Miller', '+1234567896', '1987-04-25', true, true),
('lisagarcia', 'lisa.garcia@example.com', '$2b$10$8Ks8QcN3XfWTdOsGwcTMg.', 'Lisa', 'Garcia', '+1234567897', '1993-09-14', true, false)
ON CONFLICT (email) DO NOTHING;

-- Insert game categories
INSERT INTO categories (name, description, image_url) VALUES
('Action', 'Fast-paced games with combat and adventure', '/images/categories/action.jpg'),
('Adventure', 'Story-driven exploration games', '/images/categories/adventure.jpg'),
('RPG', 'Role-playing games with character development', '/images/categories/rpg.jpg'),
('Strategy', 'Tactical and strategic thinking games', '/images/categories/strategy.jpg'),
('Sports', 'Athletic and competitive sports games', '/images/categories/sports.jpg'),
('Racing', 'High-speed racing and driving games', '/images/categories/racing.jpg'),
('Simulation', 'Real-world simulation games', '/images/categories/simulation.jpg'),
('Puzzle', 'Brain-teasing puzzle and logic games', '/images/categories/puzzle.jpg'),
('Shooter', 'First and third person shooting games', '/images/categories/shooter.jpg'),
('MMORPG', 'Massive multiplayer online role-playing games', '/images/categories/mmorpg.jpg')
ON CONFLICT (name) DO NOTHING;

-- Insert sample products using category references
DO $$
DECLARE
    action_cat_id UUID;
    adventure_cat_id UUID;
    rpg_cat_id UUID;
    strategy_cat_id UUID;
    sports_cat_id UUID;
    racing_cat_id UUID;
    simulation_cat_id UUID;
    puzzle_cat_id UUID;
    shooter_cat_id UUID;
    mmorpg_cat_id UUID;
BEGIN
    -- Get category IDs
    SELECT id INTO action_cat_id FROM categories WHERE name = 'Action';
    SELECT id INTO adventure_cat_id FROM categories WHERE name = 'Adventure';
    SELECT id INTO rpg_cat_id FROM categories WHERE name = 'RPG';
    SELECT id INTO strategy_cat_id FROM categories WHERE name = 'Strategy';
    SELECT id INTO sports_cat_id FROM categories WHERE name = 'Sports';
    SELECT id INTO racing_cat_id FROM categories WHERE name = 'Racing';
    SELECT id INTO simulation_cat_id FROM categories WHERE name = 'Simulation';
    SELECT id INTO puzzle_cat_id FROM categories WHERE name = 'Puzzle';
    SELECT id INTO shooter_cat_id FROM categories WHERE name = 'Shooter';
    SELECT id INTO mmorpg_cat_id FROM categories WHERE name = 'MMORPG';

    -- Insert products
    INSERT INTO products (name, description, price, category_id, developer, publisher, release_date, rating, platform, tags, stock_quantity) VALUES
    ('Cyber Warriors 2077', 'Futuristic action game set in a cyberpunk world', 59.99, action_cat_id, 'Future Games', 'Mega Publisher', '2024-03-15', 'M', 'PC', ARRAY['cyberpunk', 'action', 'futuristic'], 100),
    ('Fantasy Quest Online', 'Massive multiplayer RPG with epic adventures', 49.99, mmorpg_cat_id, 'Epic Studios', 'RPG Masters', '2024-01-20', 'T', 'PC', ARRAY['mmorpg', 'fantasy', 'online'], 200),
    ('Street Racer X', 'High-octane street racing experience', 39.99, racing_cat_id, 'Speed Demons', 'Racing Corp', '2024-02-10', 'E', 'PC', ARRAY['racing', 'cars', 'street'], 150),
    ('Mystic Islands', 'Explore magical islands in this adventure game', 29.99, adventure_cat_id, 'Island Studios', 'Adventure Plus', '2024-05-08', 'E', 'PC', ARRAY['adventure', 'exploration', 'magic'], 80),
    ('War Strategy', 'Command armies in epic battlefield tactics', 54.99, strategy_cat_id, 'Tactical Games', 'Strategy Pro', '2024-06-12', 'T', 'PC', ARRAY['strategy', 'war', 'tactics'], 90),
    ('Football Manager 2024', 'Manage your dream football team', 49.99, sports_cat_id, 'Sports Interactive', 'SEGA', '2024-11-01', 'E', 'PC', ARRAY['football', 'management', 'sports'], 300),
    ('City Builder Pro', 'Build and manage your perfect city', 34.99, simulation_cat_id, 'Urban Games', 'City Publishers', '2024-04-20', 'E', 'PC', ARRAY['simulation', 'city', 'building'], 120),
    ('Brain Teaser Collection', 'Collection of challenging puzzle games', 19.99, puzzle_cat_id, 'Puzzle Masters', 'Think Tank', '2024-07-15', 'E', 'PC', ARRAY['puzzle', 'brain', 'logic'], 250),
    ('Battlefield Heroes', 'Tactical first-person shooter experience', 39.99, shooter_cat_id, 'Combat Studios', 'War Games', '2024-08-05', 'M', 'PC', ARRAY['fps', 'tactical', 'multiplayer'], 180),
    ('Space Odyssey', 'Epic space exploration RPG adventure', 44.99, rpg_cat_id, 'Cosmic Games', 'Space Publishers', '2024-03-28', 'T', 'PC', ARRAY['space', 'rpg', 'exploration'], 110),
    ('Racing Legends', 'Classic car racing with vintage vehicles', 29.99, racing_cat_id, 'Retro Racing', 'Classic Games', '2024-05-22', 'E', 'PC', ARRAY['racing', 'classic', 'vintage'], 140),
    ('Dungeon Master', 'Create and explore dangerous dungeons', 24.99, rpg_cat_id, 'Dungeon Craft', 'Fantasy House', '2024-06-30', 'T', 'PC', ARRAY['dungeon', 'rpg', 'fantasy'], 95),
    ('Flight Simulator Pro', 'Realistic flight simulation experience', 69.99, simulation_cat_id, 'Sky Studios', 'Aviation Games', '2024-02-14', 'E', 'PC', ARRAY['flight', 'simulation', 'realistic'], 75),
    ('Tennis Championship', 'Professional tennis simulation', 39.99, sports_cat_id, 'Racket Games', 'Sports World', '2024-07-01', 'E', 'PC', ARRAY['tennis', 'sports', 'championship'], 160),
    ('Mind Bender', 'Advanced puzzle solving challenges', 14.99, puzzle_cat_id, 'Brain Games', 'Logic Works', '2024-08-12', 'E', 'PC', ARRAY['puzzle', 'logic', 'challenge'], 300)
    ON CONFLICT DO NOTHING;
END $$;

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
    SELECT ARRAY(SELECT id FROM users LIMIT 8) INTO user_ids;
    SELECT ARRAY(SELECT id FROM products LIMIT 15) INTO product_ids;
    
    -- Create sample orders
    FOR i IN 1..20 LOOP
        user_id := user_ids[1 + (i % array_length(user_ids, 1))];
        
        INSERT INTO orders (user_id, order_number, status, total_amount, payment_method, payment_status, billing_address, shipping_address)
        VALUES (
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
            '{"street": "123 Gaming St", "city": "Tech City", "state": "CA", "zip": "12345", "country": "USA"}'::JSONB,
            '{"street": "123 Gaming St", "city": "Tech City", "state": "CA", "zip": "12345", "country": "USA"}'::JSONB
        ) RETURNING id INTO order_id;
        
        -- Add 1-3 items per order
        FOR j IN 1..(1 + (i % 3)) LOOP
            product_id := product_ids[1 + ((i + j) % array_length(product_ids, 1))];
            
            INSERT INTO order_items (order_id, product_id, product_name, product_price, quantity, total_price)
            SELECT 
                order_id,
                product_id,
                p.name,
                p.price,
                1 + (i % 3),
                p.price * (1 + (i % 3))
            FROM products p WHERE p.id = product_id;
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
    SELECT ARRAY(SELECT id FROM users LIMIT 8) INTO user_ids;
    SELECT ARRAY(SELECT id FROM products LIMIT 15) INTO product_ids;
    
    FOR i IN 1..array_length(user_ids, 1) LOOP
        FOR j IN 1..(2 + (i % 3)) LOOP -- Each user reviews 2-4 products
            user_id := user_ids[i];
            product_id := product_ids[1 + ((i + j) % array_length(product_ids, 1))];
            
            INSERT INTO reviews (user_id, product_id, rating, title, comment, is_verified_purchase)
            VALUES (
                user_id,
                product_id,
                4 + (i % 2), -- Rating 4 or 5
                CASE 
                    WHEN (i + j) % 4 = 0 THEN 'Amazing game!'
                    WHEN (i + j) % 4 = 1 THEN 'Really enjoyed it'
                    WHEN (i + j) % 4 = 2 THEN 'Great value for money'
                    ELSE 'Highly recommended'
                END,
                CASE 
                    WHEN (i + j) % 4 = 0 THEN 'This game exceeded my expectations. Great graphics and gameplay!'
                    WHEN (i + j) % 4 = 1 THEN 'Had a lot of fun playing this. Worth every penny.'
                    WHEN (i + j) % 4 = 2 THEN 'Good quality game with hours of entertainment.'
                    ELSE 'One of the best games I''ve played this year. Definitely recommend!'
                END,
                true
            ) ON CONFLICT (user_id, product_id) DO NOTHING;
        END LOOP;
    END LOOP;
END $$;

-- Insert sample shopping cart items
DO $$
DECLARE
    user_ids UUID[];
    product_ids UUID[];
    user_id UUID;
    product_id UUID;
    i INTEGER;
    j INTEGER;
BEGIN
    SELECT ARRAY(SELECT id FROM users LIMIT 8) INTO user_ids;
    SELECT ARRAY(SELECT id FROM products LIMIT 15) INTO product_ids;
    
    FOR i IN 1..array_length(user_ids, 1) LOOP
        user_id := user_ids[i];
        
        -- Add 1-3 items to each user's cart
        FOR j IN 1..(1 + (i % 3)) LOOP
            product_id := product_ids[1 + ((i + j) % array_length(product_ids, 1))];
            
            INSERT INTO cart_items (user_id, product_id, quantity)
            VALUES (user_id, product_id, 1 + (j % 2))
            ON CONFLICT (user_id, product_id) DO UPDATE SET quantity = EXCLUDED.quantity;
        END LOOP;
    END LOOP;
END $$;

-- Insert sample user events for analytics
DO $$
DECLARE
    user_ids UUID[];
    user_id UUID;
    i INTEGER;
    event_types TEXT[] := ARRAY['login', 'logout', 'product_view', 'add_to_cart', 'purchase', 'search', 'page_view'];
    pages TEXT[] := ARRAY['/home', '/products', '/cart', '/profile', '/orders', '/categories', '/search'];
BEGIN
    SELECT ARRAY(SELECT id FROM users LIMIT 8) INTO user_ids;
    
    -- Generate 100 user events
    FOR i IN 1..100 LOOP
        user_id := user_ids[1 + (i % array_length(user_ids, 1))];
        
        INSERT INTO user_events (user_id, event_type, event_data, session_id, page_url, ip_address, user_agent)
        VALUES (
            user_id,
            event_types[1 + (i % array_length(event_types, 1))],
            ('{"timestamp": "' || (CURRENT_TIMESTAMP - (random() * interval '30 days')) || '", "duration": ' || (random() * 300)::INTEGER || '}')::JSONB,
            'session_' || i::TEXT,
            pages[1 + (i % array_length(pages, 1))],
            ('192.168.1.' || (1 + (i % 254))::TEXT)::INET,
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        );
    END LOOP;
END $$;

-- Insert sample page views for analytics
DO $$
DECLARE
    user_ids UUID[];
    user_id UUID;
    i INTEGER;
    pages TEXT[] := ARRAY['/home', '/products', '/categories/action', '/categories/rpg', '/cart', '/profile', '/orders'];
BEGIN
    SELECT ARRAY(SELECT id FROM users LIMIT 8) INTO user_ids;
    
    -- Generate 150 page views
    FOR i IN 1..150 LOOP
        user_id := user_ids[1 + (i % array_length(user_ids, 1))];
        
        INSERT INTO page_views (user_id, page_url, page_title, session_id, view_duration, ip_address, user_agent)
        VALUES (
            user_id,
            pages[1 + (i % array_length(pages, 1))],
            CASE 
                WHEN i % 7 = 0 THEN 'LUGX Gaming - Home'
                WHEN i % 7 = 1 THEN 'Products - LUGX Gaming'
                WHEN i % 7 = 2 THEN 'Action Games - LUGX Gaming'
                WHEN i % 7 = 3 THEN 'RPG Games - LUGX Gaming'
                WHEN i % 7 = 4 THEN 'Shopping Cart - LUGX Gaming'
                WHEN i % 7 = 5 THEN 'User Profile - LUGX Gaming'
                ELSE 'Orders - LUGX Gaming'
            END,
            'session_' || (i % 50)::TEXT,
            (random() * 300 + 10)::INTEGER,
            ('192.168.1.' || (1 + (i % 254))::TEXT)::INET,
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        );
    END LOOP;
END $$;

-- Insert sample purchase events for analytics
DO $$
DECLARE
    user_ids UUID[];
    product_ids UUID[];
    order_ids UUID[];
    user_id UUID;
    product_id UUID;
    order_id UUID;
    i INTEGER;
BEGIN
    SELECT ARRAY(SELECT id FROM users LIMIT 8) INTO user_ids;
    SELECT ARRAY(SELECT id FROM products LIMIT 15) INTO product_ids;
    SELECT ARRAY(SELECT id FROM orders LIMIT 20) INTO order_ids;
    
    -- Generate purchase events for completed orders
    FOR i IN 1..30 LOOP
        user_id := user_ids[1 + (i % array_length(user_ids, 1))];
        product_id := product_ids[1 + (i % array_length(product_ids, 1))];
        order_id := order_ids[1 + (i % array_length(order_ids, 1))];
        
        INSERT INTO purchase_events (user_id, order_id, product_id, amount, currency, payment_method, session_id)
        SELECT 
            user_id,
            order_id,
            product_id,
            (random() * 100 + 10)::DECIMAL(10,2),
            'USD',
            CASE 
                WHEN i % 3 = 0 THEN 'credit_card'
                WHEN i % 3 = 1 THEN 'paypal'
                ELSE 'debit_card'
            END,
            'session_' || i::TEXT
        WHERE NOT EXISTS (
            SELECT 1 FROM purchase_events 
            WHERE purchase_events.user_id = user_id 
            AND purchase_events.order_id = order_id 
            AND purchase_events.product_id = product_id
        );
    END LOOP;
END $$;

-- Update some order totals based on order items
UPDATE orders SET total_amount = (
    SELECT COALESCE(SUM(total_price), 0)
    FROM order_items 
    WHERE order_items.order_id = orders.id
) WHERE EXISTS (
    SELECT 1 FROM order_items WHERE order_items.order_id = orders.id
);

-- Print summary
DO $$
DECLARE
    user_count INTEGER;
    category_count INTEGER;
    product_count INTEGER;
    order_count INTEGER;
    review_count INTEGER;
    cart_count INTEGER;
    event_count INTEGER;
    page_view_count INTEGER;
    purchase_event_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO user_count FROM users;
    SELECT COUNT(*) INTO category_count FROM categories;
    SELECT COUNT(*) INTO product_count FROM products;
    SELECT COUNT(*) INTO order_count FROM orders;
    SELECT COUNT(*) INTO review_count FROM reviews;
    SELECT COUNT(*) INTO cart_count FROM cart_items;
    SELECT COUNT(*) INTO event_count FROM user_events;
    SELECT COUNT(*) INTO page_view_count FROM page_views;
    SELECT COUNT(*) INTO purchase_event_count FROM purchase_events;
    
    RAISE NOTICE '=== Mock Data Insertion Summary ===';
    RAISE NOTICE 'Users: %', user_count;
    RAISE NOTICE 'Categories: %', category_count;
    RAISE NOTICE 'Products: %', product_count;
    RAISE NOTICE 'Orders: %', order_count;
    RAISE NOTICE 'Reviews: %', review_count;
    RAISE NOTICE 'Cart Items: %', cart_count;
    RAISE NOTICE 'User Events: %', event_count;
    RAISE NOTICE 'Page Views: %', page_view_count;
    RAISE NOTICE 'Purchase Events: %', purchase_event_count;
    RAISE NOTICE '=== Mock Data Insertion Complete ===';
END $$;
