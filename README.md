# 🛒 E-Commerce Database Design

This project is a database schema for an e-commerce platform, created as part of our Peer Group Assignment.

## 📦 Overview

The database contains tables for:
- Products and their variations (size, color)
- Product categories and attributes
- Brands
- Images
- Sizes
- Custom attributes

## 🗃️ Main Tables

- `product`
- `product_item`
- `product_variation`
- `color`
- `size_category`
- `size_option`
- `product_category`
- `product_image`
- `brand`
- `product_attribute`
- `attribute_category`
- `attribute_type`

## 🧠 ERD (Entity-Relationship Diagram)

Here is the visual representation of the database structure:

![ERD](docs/ERD.png)  
*(Replace with your ERD image link if you upload it to GitHub)*

## 📂 How to Use

To create the database, run the `ecommerce.sql` file using your SQL database engine (e.g., MySQL Workbench):

```sql
SOURCE path/to/ecommerce.sql;
