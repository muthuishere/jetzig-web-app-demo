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

## Environment Setup

1. Use the Makefile setup command to create a `.env` file:

```bash
make setup
```

2. Modify the values in `.env` to match your database configuration:

```
JETQUERY_HOSTNAME=localhost
JETQUERY_PORT=5432
JETQUERY_USERNAME=postgres
JETQUERY_PASSWORD=postgres
JETQUERY_DATABASE=postgres
```

3. For Docker, create a `.env.docker` file with appropriate settings.

## Running the Application

### Using the Makefile

```bash
# Set up environment file
make setup

# Run database migrations
make migrate

# Start the development server
make dev

# Test the API health endpoint
make test

# Build the Docker image
make docker-build

# Run the application in Docker
make docker-run
```

## Running with Docker

1. Build the Docker image:
```bash
make docker-build
```

2. Run the container:
```bash
make docker-run
```

3. The API will be available at http://localhost:8080

## Development Setup

1. Install Zig 0.14.0
2. [Install Jetzig](https://www.jetzig.dev/documentation.html#getting-started)
3. Set up PostgreSQL database
4. Run database migration: `make migrate`
5. Start the server: `make dev`

## Testing the API

You can use tools like curl, httpie, or Postman to test the API endpoints.

Example:
```bash
# Get all products
curl -H "Content-Type: application/json" http://localhost:8080/api/products

# Create a product
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Example Product","description":"This is a test product","price":29.99}'

# Get a specific product
curl -H "Content-Type: application/json" http://localhost:8080/api/products/1

# Update a product
curl -X PUT http://localhost:8080/api/products/1 \
  -H "Content-Type: application/json" \
  -d '{"name":"Updated Product","description":"This description has been updated","price":39.99}'

# Delete a product
curl -X DELETE -H "Content-Type: application/json" http://localhost:8080/api/products/1

# Get health status
curl -H "Content-Type: application/json" http://localhost:8080/api/health
```

## Documentation

For more details about Jetzig framework, refer to the [official documentation](https://www.jetzig.dev/documentation.html).
