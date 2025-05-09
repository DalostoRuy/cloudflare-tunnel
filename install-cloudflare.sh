#!/usr/bin/env bash
set -euo pipefail

# install_cloudflared_repo.sh
# Automatiza o download da chave GPG e adição do repositório Cloudflare Tunnel

# 1. Detectar codinome da distro (buster, bullseye, bookworm, jammy, focal, etc.)
if ! CODENAME=$(lsb_release -cs 2>/dev/null); then
  echo "Erro: não foi possível detectar o codinome da distribuição."
  exit 1
fi

# 2. Criar diretório de keyrings
echo "Criando /usr/share/keyrings (se necessário)..."
sudo install -d -m0755 /usr/share/keyrings

# 3. Baixar chave GPG oficial
echo "Baixando chave GPG do Cloudflare..."
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg \
  | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null  # :contentReference[oaicite:0]{index=0}

# 4. Criar arquivo de repositório APT
echo "Criando fonte APT em /etc/apt/sources.list.d/cloudflared.list..."
REPO_LINE="deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared ${CODENAME} main"
echo "${REPO_LINE}" | sudo tee /etc/apt/sources.list.d/cloudflared.list >/dev/null  # :contentReference[oaicite:1]{index=1}

# 5. Atualizar e instalar
echo "Atualizando APT e instalando cloudflared..."
sudo apt-get update
sudo apt-get install -y cloudflared

echo "✅ Repositório e pacote cloudflared instalados com sucesso!"
