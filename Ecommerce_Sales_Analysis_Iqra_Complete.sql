-- E-commerce Sales Data Analysis Project
-- Created by: Iqra

CREATE DATABASE IF NOT EXISTS ecommerce_analysis;

USE ecommerce_analysis;

-- Create Customers Table
CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    email VARCHAR(100)
);

-- Create Products Table
CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- Create Orders Table
CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert Customer Data
INSERT INTO customers
(customer_id, customer_name, city, email)
VALUES
(1, 'Ayesha Khan', 'Mumbai', 'ayesha@gmail.com'),
(2, 'Rahul Sharma', 'Pune', 'rahul@gmail.com'),
(3, 'Sara Patel', 'Delhi', 'sara@gmail.com'),
(4, 'Arjun Mehta', 'Mumbai', 'arjun@gmail.com'),
(5, 'Zoya Shaikh', 'Bangalore', 'zoya@gmail.com');

-- Insert Product Data
INSERT INTO products
(product_id, product_name, category, price)
VALUES
(101, 'Laptop', 'Electronics', 45000),
(102, 'Mobile Phone', 'Electronics', 20000),
(103, 'Headphones', 'Accessories', 1500),
(104, 'Office Chair', 'Furniture', 5000),
(105, 'Keyboard', 'Accessories', 1200);

-- Insert Order Data
INSERT INTO orders
(order_id, customer_id, product_id, quantity, order_date)
VALUES
(1001, 1, 101, 1, '2026-01-05'),
(1002, 2, 102, 2, '2026-01-07'),
(1003, 3, 103, 3, '2026-01-10'),
(1004, 4, 104, 1, '2026-01-12'),
(1005, 5, 105, 2, '2026-01-15'),
(1006, 1, 103, 2, '2026-01-18'),
(1007, 2, 101, 1, '2026-01-20'),
(1008, 3, 105, 1, '2026-01-22'),
(1009, 4, 102, 1, '2026-01-25'),
(1010, 5, 104, 2, '2026-01-28');

-- 1. Calculate Total Revenue
SELECT
    SUM(p.price * o.quantity) AS total_revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id;

-- 2. Calculate Total Orders
SELECT
    COUNT(*) AS total_orders
FROM orders;

-- 3. Calculate Total Quantity Sold
SELECT
    SUM(quantity) AS total_quantity_sold
FROM orders;

-- 4. Calculate Revenue by Product
SELECT
    p.product_name,
    SUM(p.price * o.quantity) AS total_revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- 5. Calculate Revenue by Customer
SELECT
    c.customer_name,
    SUM(p.price * o.quantity) AS total_spent
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN products p
ON o.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- 6. Calculate Average Order Value
SELECT
    ROUND(AVG(p.price * o.quantity), 2) AS average_order_value
FROM orders o
JOIN products p
ON o.product_id = p.product_id;

-- 7. Calculate Revenue by Category
SELECT
    p.category,
    SUM(p.price * o.quantity) AS category_revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;

-- 8. Calculate Monthly Revenue
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    SUM(p.price * o.quantity) AS monthly_revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY sales_month
ORDER BY sales_month;

-- 9. Find Best-Selling Products
SELECT
    p.product_name,
    SUM(o.quantity) AS total_sold
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;

-- 10. Calculate Revenue by City
SELECT
    c.city,
    SUM(p.price * o.quantity) AS total_revenue
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN products p
ON o.product_id = p.product_id
GROUP BY c.city
ORDER BY total_revenue DESC;

-- 11. Identify Repeat Customers
SELECT
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) > 1;

-- 12. Complete Order Details Report
SELECT
    o.order_id,
    c.customer_name,
    c.city,
    p.product_name,
    p.category,
    o.quantity,
    p.price,
    (o.quantity * p.price) AS order_amount,
    o.order_date
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN products p
ON o.product_id = p.product_id
ORDER BY o.order_date;

-- 13. Find Orders Above 5000
SELECT
    o.order_id,
    p.product_name,
    o.quantity,
    p.price,
    (o.quantity * p.price) AS order_amount
FROM orders o
JOIN products p
ON o.product_id = p.product_id
WHERE (o.quantity * p.price) > 5000
ORDER BY order_amount DESC;

-- 14. Create Sales Report View
CREATE OR REPLACE VIEW sales_report AS
SELECT
    o.order_id,
    c.customer_name,
    c.city,
    p.product_name,
    p.category,
    o.quantity,
    p.price,
    (o.quantity * p.price) AS order_amount,
    o.order_date
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN products p
ON o.product_id = p.product_id;

-- 15. Business Performance Summary
SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.quantity) AS total_quantity_sold,
    SUM(p.price * o.quantity) AS total_revenue,
    ROUND(AVG(p.price * o.quantity), 2) AS average_order_value
FROM orders o
JOIN products p
ON o.product_id = p.product_id;