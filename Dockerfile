FROM golang:1.25 AS builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

ARG VERSION=0.0.0

RUN CGO_ENABLED=0 GOOS=${TARGETOS:-linux} GOARCH=${TARGETARCH} go build -ldflags="-X main.version=${VERSION}" -o ./result/unspeech ./cmd/unspeech

# https://github.com/GoogleContainerTools/distroless
FROM gcr.io/distroless/static-debian12 AS app

COPY --from=builder /app/result/unspeech /

ENTRYPOINT ["/unspeech"]
