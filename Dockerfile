
# Stage 1: Build the Go application
FROM golang:1.25.1-alpine AS builder

WORKDIR /app

# Install certificates and git
RUN apk add --no-cache git ca-certificates

# Copy dependency files first for better build caching
COPY go.mod go.sum ./

# Download Go dependencies
RUN go mod download

# Copy application source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o muchtodo ./cmd/api

# Stage 2: Create a lean runtime image
FROM alpine:3.22

WORKDIR /app

# Install certificates and create a non-root user
RUN apk add --no-cache ca-certificates wget \
    && addgroup -S appgroup \
    && adduser -S appuser -G appgroup

# Copy only the compiled application
COPY --from=builder /app/muchtodo /app/muchtodo

# Run as a non-root user
USER appuser

# Application port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
    CMD wget -q -O /dev/null http://127.0.0.1:8080/health || exit 1

# Start the application
ENTRYPOINT ["/app/muchtodo"]
