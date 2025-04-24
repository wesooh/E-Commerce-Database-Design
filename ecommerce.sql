-- Create Database
CREATE DATABASE ecommerceDB;
USE ecommerceDB;

-- Create brand table
CREATE TABLE brand (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create product_category table
CREATE TABLE product_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    parent_category_id INT DEFAULT NULL,
    description TEXT,
    FOREIGN KEY (parent_category_id) REFERENCES product_category(category_id)
);

-- Create product table
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    base_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES brand(brand_id),
    FOREIGN KEY (category_id) REFERENCES product_category(category_id)
);

-- Create size_category table
CREATE TABLE size_category (
    size_category_id INT AUTO_INCREMENT PRIMARY KEY,
    size_category_name VARCHAR(100) NOT NULL
);

-- Create size_option table
CREATE TABLE size_option (
    size_option_id INT AUTO_INCREMENT PRIMARY KEY,
    size_category_id INT NOT NULL,
    size_label VARCHAR(50) NOT NULL,
    FOREIGN KEY (size_category_id) REFERENCES size_category(size_category_id)
);

-- Create attribute_category table
CREATE TABLE attribute_category (
    attribute_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- Create attribute_type table
CREATE TABLE attribute_type (
    attribute_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL
);
-- Create color table
CREATE TABLE color (
    color_id INT AUTO_INCREMENT PRIMARY KEY,
    color_name VARCHAR(50) NOT NULL,
    hex_code VARCHAR(7) NOT NULL
);

-- Create product_variation table
CREATE TABLE product_variation (
    variation_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    size_option_id INT,
    color_id INT,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (size_option_id) REFERENCES size_option(size_option_id),
    FOREIGN KEY (color_id) REFERENCES color(color_id)
);

-- Create product_item table
CREATE TABLE product_item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    variation_id INT NOT NULL,
    sku VARCHAR(50) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    color_id INT NULL,
    size_option_id INT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (variation_id) REFERENCES product_variation(variation_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (color_id) REFERENCES color(color_id),
    FOREIGN KEY (size_option_id) REFERENCES size_option(size_option_id)
);

-- Create product_image table
CREATE TABLE product_image (
    product_image_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    product_item_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (product_item_id) REFERENCES product_item(item_id)
);

-- Create product_attribute table
CREATE TABLE product_attribute (
    attribute_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    attribute_name VARCHAR(100) NOT NULL,
    attribute_value TEXT NOT NULL,
    attribute_category_id INT NOT NULL,
    attribute_type_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (attribute_category_id) REFERENCES attribute_category(attribute_category_id),
    FOREIGN KEY (attribute_type_id) REFERENCES attribute_type(attribute_type_id)
);

-- SAMPLE DATA INSERTION

-- Insert brands
INSERT INTO brand (brand_name, description) VALUES
('Nike', 'Just Do It - Athletic apparel and footwear'),
('Adidas', 'Impossible is Nothing - Sportswear manufacturer'),
('Apple', 'Think Different - Consumer electronics');

-- Insert product categories (with hierarchy)
INSERT INTO product_category (category_name, parent_category_id, description) VALUES
('Electronics', NULL, 'All electronic devices'),
('Smartphones', 1, 'Mobile phones with advanced computing capability'),
('Clothing', NULL, 'Apparel and accessories'),
('Shoes', 3, 'Footwear products'),
('T-Shirts', 3, 'Casual short-sleeved shirts');

-- Insert products
INSERT INTO product (product_name, description, brand_id, category_id, base_price) VALUES
('iPhone 15', 'Latest Apple smartphone with A16 chip', 3, 2, 999.00),
('Air Max 270', 'Comfortable running shoes with air cushioning', 1, 4, 129.99),
('Ultraboost 22', 'Responsive running shoes with energy return', 2, 4, 179.99),
('Dry-Fit T-Shirt', 'Moisture-wicking athletic t-shirt', 1, 5, 29.99);

-- Insert size categories
INSERT INTO size_category (size_category_name) VALUES
('Shoes'),
('Clothing');

-- Insert size options
INSERT INTO size_option (size_category_id, size_label) VALUES
(1, 'US 7'), (1, 'US 8'), (1, 'US 9'), (1, 'US 10'),
(2, 'S'), (2, 'M'), (2, 'L'), (2, 'XL');

-- Insert colors
INSERT INTO color (color_name, hex_code) VALUES
('Black', '#000000'),
('White', '#FFFFFF'),
('Red', '#FF0000'),
('Blue', '#0000FF'),
('Space Gray', '#657383');

-- Insert product variations
INSERT INTO product_variation (product_id, size_option_id, color_id) VALUES
-- iPhone 15 (no size, color only)
(1, NULL, 5), -- Space Gray
(1, NULL, 2), -- White

-- Air Max 270 (size and color)
(2, 1, 1), -- US 7 Black
(2, 2, 1), -- US 8 Black
(2, 3, 3), -- US 9 Red

-- Ultraboost 22
(3, 2, 2), -- US 8 White
(3, 3, 4), -- US 9 Blue

-- Dry-Fit T-Shirt
(4, 5, 1), -- S Black
(4, 6, 2), -- M White
(4, 7, 3); -- L Red

-- Insert product items (inventory)
INSERT INTO product_item (product_id, variation_id, sku, price, stock_quantity, color_id, size_option_id) VALUES
-- iPhone 15
(1, 1, 'IP15-SG-001', 999.00, 50, 5, NULL),
(1, 2, 'IP15-WH-001', 999.00, 35, 2, NULL),

-- Air Max 270
(2, 3, 'AM270-BK-7', 129.99, 10, 1, 1),
(2, 4, 'AM270-BK-8', 129.99, 15, 1, 2),
(2, 5, 'AM270-RD-9', 129.99, 8, 3, 3),

-- Ultraboost 22
(3, 6, 'UB22-WH-8', 179.99, 12, 2, 2),
(3, 7, 'UB22-BL-9', 179.99, 7, 4, 3),

-- Dry-Fit T-Shirt
(4, 8, 'DFT-BK-S', 29.99, 25, 1, 5),
(4, 9, 'DFT-WH-M', 29.99, 30, 2, 6),
(4, 10, 'DFT-RD-L', 29.99, 20, 3, 7);

-- Insert product images
INSERT INTO product_image (product_id, product_item_id, image_url, is_primary) VALUES
-- iPhone 15 Space Gray
(1, 1, 'https://www.pexels.com/search/iPhone%2015/', TRUE),
(1, 1, 'https://www.pexels.com/search/iPhone%2015/', FALSE),
(1, 1, 'https://www.pexels.com/search/iPhone%2015/', FALSE),

-- iPhone 15 White
(1, 2, 'https://www.pexels.com/search/iPhone%2015/', TRUE),
(1, 2, 'https://www.pexels.com/search/iPhone%2015/', FALSE),

-- Air Max 270 Black US 8
(2, 4, 'https://www.pexels.com/search/Nike%20Air%20Max%20270%29/', TRUE),
(2, 4, 'https://www.pexels.com/search/Nike%20Air%20Max%20270%29/', FALSE),

-- Ultraboost 22 White US 8
(3, 6, 'https://www.pexels.com/search/Nike%20Air%20Max%20270%29/', TRUE),

-- Dry-Fit T-Shirt Red L
(4, 10, 'https://www.pexels.com/search/Nike%20Air%20Max%20270%29/', TRUE),
(4, 10, 'https://www.pexels.com/search/Nike%20Air%20Max%20270%29/', FALSE);

-- Insert attribute categories
INSERT INTO attribute_category (category_name) VALUES
('Technical Specifications'),
('Fabric'),
('Product Dimensions');

-- Insert attribute types
INSERT INTO attribute_type (type_name) VALUES
('String'),
('Number'),
('Boolean');

-- Insert product attributes
INSERT INTO product_attribute (product_id, attribute_name, attribute_value, attribute_category_id, attribute_type_id) VALUES
-- iPhone 15 attributes
(1, 'Storage', '128GB', 1, 1),
(1, 'Screen Size', '6.1', 1, 2),
(1, 'Water Resistant', 'true', 1, 3),

-- Air Max 270 attributes
(2, 'Material', 'Mesh/Leather', 2, 1),
(2, 'Weight', '0.65', 3, 2),

-- Dry-Fit T-Shirt attributes
(4, 'Material', '100% Polyester', 2, 1),
(4, 'Breathable', 'true', 2, 3);