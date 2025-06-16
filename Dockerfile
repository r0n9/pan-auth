FROM golang:1.24.4-alpine AS builder
WORKDIR /app
COPY . .
ENV GOPROXY=https://goproxy.cn,direct
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o pan-auth .

FROM alpine:latest

WORKDIR /root/

RUN apk add --no-cache tzdata
ENV TZ=Asia/Shanghai

COPY --from=builder /app/pan-auth .
EXPOSE 8080

ENTRYPOINT ["./pan-auth"]
