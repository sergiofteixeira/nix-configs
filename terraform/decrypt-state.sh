#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

if [ ! -f terraform.tfstate.enc ]; then
    echo "Error: terraform.tfstate.enc not found"
    exit 1
fi

echo "Decrypting terraform.tfstate.enc..."
openssl enc -d -aes-256-cbc -pbkdf2 -in terraform.tfstate.enc -out terraform.tfstate

echo "Done! Decrypted file: terraform.tfstate"
echo "Remember to re-encrypt after making changes!"
