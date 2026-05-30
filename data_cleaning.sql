-- DATA CLEANING 
-- =========================================================
-- Disable safe updates for cleaning
SET SQL_SAFE_UPDATES = 0;
-- =========================================================
-- 1. CUSTOMERS TABLE
-- =========================================================

-- Step 1 Check NULL and empty values
SELECT *
FROM customers
WHERE first_name IS NULL OR first_name = ''
   OR city IS NULL OR city = '';

-- Step 2 Replace missing values
UPDATE customers
SET first_name = 'Unknown'
WHERE first_name IS NULL OR first_name = '';

UPDATE customers
SET city = 'Unknown'
WHERE city IS NULL OR city = '';

-- Step 3 Trim spaces
UPDATE customers
SET first_name = TRIM(first_name),
    city = TRIM(city);

-- Step 4 Standardize case
UPDATE customers
SET city = CONCAT(
    UPPER(LEFT(city, 1)),
    LOWER(SUBSTRING(city, 2))
);

-- =========================================================
-- 2. SELLERS TABLE
-- =========================================================

-- Step 1 Check issues
SELECT *
FROM sellers
WHERE seller_name IS NULL OR seller_name = ''
   OR city IS NULL OR city = '';

-- Step 2 Fix
UPDATE sellers
SET seller_name = 'Unknown'
WHERE seller_name IS NULL OR seller_name = '';

UPDATE sellers
SET city = 'Unknown'
WHERE city IS NULL OR city = '';

-- Step 3 Trim spaces
UPDATE sellers
SET seller_name = TRIM(seller_name),
    city = TRIM(city);
    
-- Step 4 Standardize case 
UPDATE sellers
SET city = CONCAT(
    UPPER(LEFT(city, 1)),
    LOWER(SUBSTRING(city, 2))
);

-- =========================================================
-- 3. PRODUCTS TABLE
-- =========================================================

-- Step 1 Check issues
SELECT *
FROM products
WHERE product_name IS NULL OR product_name = ''
   OR category IS NULL OR category = ''
   OR brand IS NULL OR brand = ''
   OR price <= 0
   OR cost_price < 0;

-- Step 2 Fix text columns
UPDATE products
SET product_name = 'Unknown'
WHERE product_name IS NULL OR product_name = '';

UPDATE products
SET category = 'Unknown'
WHERE category IS NULL OR category = '';

UPDATE products
SET brand = 'Unknown'
WHERE brand IS NULL OR brand = '';

-- Step 3 Trim text
UPDATE products
SET product_name = TRIM(product_name),
    category = TRIM(category),
    brand = TRIM(brand);

-- =========================================================
-- 4. ORDERS TABLE
-- =========================================================

-- Step 1 Check issues
SELECT *
FROM orders
WHERE order_status IS NULL OR order_status = ''
   OR shipping_cost < 0;

-- Step 2 Fix order_status
UPDATE orders
SET order_status = 'Unknown'
WHERE order_status IS NULL OR order_status = '';

-- Step 3 Trim
UPDATE orders
SET order_status = TRIM(order_status);

-- =========================================================
-- 5. ORDER_ITEMS TABLE
-- =========================================================

-- Step 1 Check issues
SELECT *
FROM order_items
WHERE quantity <= 0
   OR price <= 0
   OR discount < 0
   OR total_price <= 0;

-- Step 2 Check calculation mismatch
SELECT *,
       (quantity * price - discount) AS expected_total
FROM order_items
WHERE total_price != (quantity * price - discount);

-- Step 3 Fix total_price by adding new column
ALTER TABLE order_items
ADD COLUMN corrected_total_price DECIMAL(10,2);

UPDATE order_items
SET corrected_total_price = (quantity * price - discount);

-- Step 4 Compare both columns
SELECT 
    total_price,
    corrected_total_price,
    (corrected_total_price - total_price) AS difference
FROM order_items;

-- =========================================================
-- 6. PAYMENTS TABLE
-- =========================================================

-- Step 1 Check invalid values
SELECT *
FROM payments
WHERE payment_amount <= 0;

-- Step 2 Mark invalid
UPDATE payments
SET payment_status = 'Invalid'
WHERE payment_amount = 0;

-- Step 3 Mark valid
UPDATE payments
SET payment_status = 'Valid'
WHERE payment_amount > 0;

-- Enable safe mode
SET SQL_SAFE_UPDATES = 1;

-- Verify
SELECT payment_status, COUNT(*)
FROM payments
GROUP BY payment_status;
