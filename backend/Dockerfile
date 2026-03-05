FROM golang:alpine AS builder

# Install build dependencies for sqlite3 (gcc, musl-dev)
RUN apk add --no-cache gcc musl-dev

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go mod tidy
RUN CGO_ENABLED=1 GOOS=linux go build -o main ./cmd/main.go
RUN CGO_ENABLED=1 GOOS=linux go build -o admin ./cmd/admin/main.go

FROM golang:alpine
RUN apk add --no-cache ca-certificates
WORKDIR /app
COPY --from=builder /app/main /usr/local/bin/private-planner-backend
COPY --from=builder /app/admin /usr/local/bin/private-planner-admin

EXPOSE 8080
CMD ["private-planner-backend"]
