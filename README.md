# EasyBuy Data Warehouse

End-to-end SQL Server data architecture project for an e-commerce system.

## Project Scope

- OLTP database design
- Relational constraints and sample data
- Dimensional Data Warehouse
- Star Schema
- Fact and Dimension tables
- ETL-style loading from OLTP to Data Warehouse
- Analytical SQL
- Window functions

## Architecture

OLTP:
Customers, Addresses, Categories, Products, Inventory, Orders, OrderItems, Payments, Shipping

Data Warehouse:
- DimDate
- DimCustomer
- DimCategory
- DimProduct
- FactSales

## Fact Table Grain

One row in `FactSales` represents one product line within an order.

## Analytical Queries

The project includes:
- Total revenue
- Revenue by category
- Top customers
- Top-selling products
- Monthly/yearly revenue
- Average order value
- Running totals
- Product ranking
- Customer/category revenue
- Month-over-month revenue change
