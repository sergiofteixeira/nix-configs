#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

if [ ! -f terraform.tfstate ]; then
    echo "Error: terraform.tfstate not found"
    exit 1
fi

echo "Encrypting terraform.tfstate..."
openssl enc -aes-256-cbc -salt -pbkdf2 -in terraform.tfstate -out terraform.tfstate.enc

echo "Done! Encrypted file: terraform.tfstate.enc"
echo "You can now safely commit terraform.tfstate.enc to git"
