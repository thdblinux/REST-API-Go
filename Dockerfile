### Step 1: Baixar dependências e compilar o binário
FROM golang:1.20-alpine AS builder

WORKDIR /app

# Copia o go.mod e go.sum e faz o download das dependências.
COPY go.mod go.sum ./
RUN go mod download

# Copia todo o código da aplicação.
COPY . .

# Define o diretório de entrada para o comando `go build`.
WORKDIR /app/cmd

# Compila o binário.
RUN CGO_ENABLED=0 GOOS=linux go build -o /main

################################################

### Step 2: Copiar o binário do stage anterior para a imagem final.
FROM scratch

# Copia apenas o binário gerado no stage anterior.
COPY --from=builder /main /

# Indica que o container expõe a porta 8000, onde a aplicação estará escutando (normalmente para requisições HTTP).
EXPOSE 8000

# O binário será executado quando o container for iniciado.
CMD ["./main"]