#!/bin/bash

# CONFIGURA ESTAS VARIABLES
REPO_URL="https://github.com/Jose-Prince/PONG.git"
REPO_NAME=$(basename "$REPO_URL" .git)
LOVE_VERSION="11.5"
LOVE_ZIP="love-$LOVE_VERSION-linux-x86_64.tar.gz"
LOVE_DIR="love-$LOVE_VERSION-linux-x86_64"
LOVE_URL="https://github.com/love2d/love/releases/download/$LOVE_VERSION/$LOVE_ZIP"

# 1. Buscar si el repo ya fue clonado en $HOME
echo ">> Buscando si el repositorio '$REPO_NAME' ya está clonado..."
REPO_PATH=$(find "$HOME" -type d -name "$REPO_NAME" -exec test -d "{}/.git" \; -print -quit)

# 2. Si no fue encontrado, clonar
if [ -z "$REPO_PATH" ]; then
  echo ">> Repositorio no encontrado. Clonando..."
  git clone "$REPO_URL" || { echo "Error: No se pudo clonar el repositorio."; exit 1; }
  REPO_PATH="./$REPO_NAME"
else
  echo ">> Repositorio ya existe en: $REPO_PATH"
fi

cd "$REPO_PATH" || { echo "Error: No se pudo acceder al repositorio."; exit 1; }

# 3. Empaquetar como .love (excluyendo .git)
echo ">> Empaquetando el juego como 'pong.love'..."
zip -9 -r pong.love . -x "*.git*" > /dev/null || { echo "Error al crear pong.love"; exit 1; }

# 4. Verificar si LÖVE está instalado
if command -v love &>/dev/null; then
  echo ">> LÖVE está instalado. Ejecutando el juego..."
  love pong.love
else
  echo ">> LÖVE no está instalado. Descargando versión portátil..."

  if [ ! -f "../$LOVE_ZIP" ]; then
    echo ">> Descargando LÖVE $LOVE_VERSION..."
    wget -q "$LOVE_URL" -O "../$LOVE_ZIP" || { echo "Error: No se pudo descargar LÖVE."; exit 1; }
  fi

  if [ ! -d "../$LOVE_DIR" ]; then
    echo ">> Descomprimiendo LÖVE..."
    tar -xzf "../$LOVE_ZIP" -C .. || { echo "Error al descomprimir LÖVE."; exit 1; }
    chmod +x "../$LOVE_DIR/love"
  fi

  echo ">> Ejecutando pong.love con versión portátil de LÖVE..."
  "../$LOVE_DIR/love" pong.love
fi

