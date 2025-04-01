PORT := 8080
HOST := localhost
BASE_URL := http://$(HOST):$(PORT)

IMAGE_NAME = zig-product-service
TAG = latest
CONTAINER_NAME = zig-product-container  # Add this line

.PHONY: setup
setup:
	@echo "Setting up environment..."
	@cp -n .env.sample .env || true
	@echo "Environment file created. Please check .env for your database credentials."



.PHONY: migrate
migrate:
	@echo "Running database migrations..."
	@env $(shell cat .env 2>/dev/null || true) jetzig database migrate

.PHONY: dev
dev:
	@echo "Starting Jetzig server on $(BASE_URL)..."
	@env $(shell cat .env 2>/dev/null || true) jetzig server

.PHONY: test
test:
	@echo "Testing API health endpoint..."
	@curl -s -H "Content-Type: application/json" $(BASE_URL)/api/health




docker-build:
	@echo "Building Docker image..."
	docker build \
		-t $(IMAGE_NAME):$(TAG) \
		.

# Run container with environment file (Ctrl+C to stop)
.PHONY: docker-clean
docker-clean:
	@echo "Cleaning up existing container..."
	@docker stop $(CONTAINER_NAME) 2>/dev/null || true
	@docker rm $(CONTAINER_NAME) 2>/dev/null || true

# Run container with environment file (Ctrl+C to stop)
.PHONY: docker-run
docker-run: docker-clean
	@echo "Running container with .env.docker..."
	docker run --init --name $(CONTAINER_NAME) \
		--env-file .env.docker \
		-p 8080:8080 \
		$(IMAGE_NAME):$(TAG)
