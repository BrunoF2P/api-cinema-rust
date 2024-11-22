# Usa a imagem oficial do Rust com Alpine como base
FROM rust:alpine AS builder

# Instala dependências para compilar a aplicação
RUN apk add --no-cache musl-dev openssl-dev build-base

# Define o diretório de trabalho
WORKDIR /usr/src/api-cinema-rust

# Copia os arquivos para o container
COPY . .

# Compila a aplicação para release
RUN cargo build --release

# Cria uma imagem menor para executar a aplicação
FROM alpine:latest

# Instala dependências necessárias para rodar o binário
RUN apk add --no-cache libssl3

# Define o diretório de trabalho para a aplicação
WORKDIR /usr/local/bin

# Copia o binário compilado da etapa anterior
COPY --from=builder /usr/src/api-cinema-rust/target/release/api-cinema-rust .

# Define a porta padrão para a aplicação
EXPOSE 8080

# Executa a aplicação
CMD ["./api-cinema-rust"]
