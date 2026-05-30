-- USE the database
USE ecommerce_db;

 -- Table : customers
 CREATE TABLE customers (
 customer_id VARCHAR(10) PRIMARY KEY,
 first_name VARCHAR(50),
 city VARCHAR(100)
);

-- Table : sellers
CREATE TABLE sellers (
seller_id INT PRIMARY KEY,
seller_name VARCHAR(100),
city VARCHAR(100)
);
-- Table : products
CREATE TABLE products (
product_id INT PRIMARY KEY,
product_name VARCHAR(100),
category VARCHAR(50),
price DECIMAL(10,2),
cost_price DECIMAL(10,2),
brand VARCHAR(100)
);

-- Table : orders
CREATE TABLE orders (
order_id INT PRIMARY KEY,
customer_id VARCHAR(10),
order_date DATE,
order_status VARCHAR(20),
shipping_cost DECIMAL(10,2),
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Table : order_items
CREATE TABLE order_items (
order_id INT,
product_id INT,
quantity INT,
price DECIMAL(10,2),
discount DECIMAL(5,2),
total_price DECIMAL(10,2),
PRIMARY KEY (order_id, product_id),
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES products(product_id)
);
-- Table : payments
CREATE TABLE payments (
order_id INT PRIMARY KEY,
payment_method VARCHAR(20),
payment_amount DECIMAL(10,2),
FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

SELECT
(SELECT COUNT(*) FROM customers) AS customers,
(SELECT COUNT(*) FROM sellers) AS sellers,
(SELECT COUNT(*) FROM products) AS products,
(SELECT COUNT(*) FROM orders) AS orders,
(SELECT COUNT(*) FROM order_items) AS order_items,
(SELECT COUNT(*) FROM payments) AS payments;


