#!/usr/bin/env bash
set -euo pipefail

# install_cloudflared_repo.sh
# Automatiza parte 2: adiciona chave e repositório Cloudflare Tunnel

# 1. Remove listas antigas (caso existam)
echo "🗑  Removendo listas antigas, se existirem..."
rm -f /etc/apt/sources.list.d/cloudflared.list

# 2. Detectar codinome (buster, bullseye, bookworm, focal, jammy, etc.)
if ! CODENAME=$(lsb_release -cs 2>/dev/null); then
  echo "❌ Não foi possível detectar o codinome da distro."
  exit 1
fi
echo "🔎 Distro detectada: ${CODENAME}"

# 3. Preparar keyring
echo "🔐 Criando diretório de keyrings e baixando chave GPG..."
install -d -m0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg \
  | tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null  # formata OK na chegada de EOF :contentReference[oaicite:0]{index=0}

# 4. Gerar arquivo de repositório com here-doc
echo "📋 Criando /etc/apt/sources.list.d/cloudflared.list..."
tee /etc/apt/sources.list.d/cloudflared.list >/dev/null <<EOF
deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared ${CODENAME} main
EOF

# 5. Atualizar APT e instalar cloudflared
echo "⬆️  Atualizando APT e instalando cloudflared..."
apt-get update
apt-get install -y cloudflared

echo "✅ Repositório configurado e cloudflared instalado com sucesso!"
