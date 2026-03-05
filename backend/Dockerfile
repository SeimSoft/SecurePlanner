FROM golang:1.24-alpine AS builder

# Install build dependencies for sqlite3 (gcc, musl-dev)
RUN apk add --no-cache gcc musl-dev

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=1 GOOS=linux go build -o main ./cmd/main.go

FROM alpine:latest
RUN apk add --no-cache ca-certificates
WORKDIR /root/
COPY --from=builder /app/main .

EXPOSE 8080
CMD ["./main"]
