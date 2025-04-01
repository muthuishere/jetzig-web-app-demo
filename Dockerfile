# zig-crud/Dockerfile

# Start with a base image
FROM alpine:3.19 AS builder

# Install dependencies
RUN apk add --no-cache \
    curl \
    tar \
    xz \
    build-base \
    git \
    libpq-dev

# Install Zig 0.14.0
RUN curl -L https://ziglang.org/download/0.14.0/zig-linux-x86_64-0.14.0.tar.xz | \
    tar -xJ -C /usr/local && \
    ln -s /usr/local/zig-linux-x86_64-0.14.0/zig /usr/local/bin/zig

# Install Jetzig from source using the advanced setup
RUN git clone https://github.com/jetzig-framework/jetzig /tmp/jetzig && \
    cd /tmp/jetzig/cli && \
    zig build install && \
    cp /tmp/jetzig/cli/zig-out/bin/jetzig /usr/local/bin/jetzig

# Create app directory
WORKDIR /app

# Copy dependency files first (for better caching)
COPY build.zig build.zig.zon ./

# Copy source code and configuration
COPY src/ src/
COPY config/ config/
COPY public/ public/

# Build the application in release mode
RUN zig build -Doptimize=ReleaseFast

# Runtime stage
FROM alpine:3.19

RUN apk add --no-cache libpq ca-certificates curl

# Copy built application and necessary files from builder
COPY --from=builder /app/zig-out/bin/zig-crud /usr/local/bin/zig-crud
COPY --from=builder /app/public/ /app/public/
COPY --from=builder /app/config/ /app/config/
COPY --from=builder /app/src/ /app/src/

WORKDIR /app

# Expose the application port
EXPOSE 8080


CMD ["/usr/local/bin/zig-crud" , "--bind", "0.0.0.0", "--port", "8080"]
