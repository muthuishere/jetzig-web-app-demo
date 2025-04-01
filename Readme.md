# Zig CRUD API

This is a CRUD (Create, Read, Update, Delete) API built with Zig programming language using the Jetzig web framework. It provides endpoints for managing a product catalog.

## Features

- RESTful API design
- JSON responses
- PostgreSQL database integration
- Middleware for logging
- Health check endpoint
- Products CRUD operations

## API Endpoints

### Health Check

```
GET /api/health
```

Returns the API status, version, timestamp, and environment.

### Products

```
GET /api/products - List all products
GET /api/products/:id - Get a single product
POST /api/products - Create a new product
PUT /api/products/:id - Update a product
DELETE /api/products/:id - Delete a product
```

## Data Model

### Product

```
id: integer (primary key)
name: string
description: text
price: decimal
created_at: datetime
updated_at: datetime
```

## Running with Docker

1. Build the Docker image:
```bash
docker build -t zig-crud .
```

2. Run the container:
```bash
docker run -p 8080:8080 zig-crud
```

3. The API will be available at http://localhost:8080

## Development Setup

1. Install Zig 0.14.0
2. Install Jetzig CLI: `git clone https://github.com/jetzig-framework/jetzig`
3. Set up PostgreSQL database
4. Run database migration: `jetzig database migrate`
5. Start the server: `zig build run`

## Database Setup

To generate the Schema.zig file from your existing database:

```bash
jetzig database reflect
```

## Testing the API

You can use tools like curl, httpie, or Postman to test the API endpoints.

Example:
```bash
# Get all products
curl http://localhost:8080/api/products

# Create a product
curl -X POST http://localhost:8080/api/products \
  -H 'Content-Type: application/json' \
  -d '{"name":"Example Product","description":"This is a test product","price":29.99}'

# Get health status
curl http://localhost:8080/api/health
```
