#!/bin/bash

echo "⚠️  This will delete ALL certificates and force regeneration"
echo "Are you sure? This may hit rate limits!"
read -p "Type 'yes' to continue: " confirm

if [ "$confirm" = "yes" ]; then
    cd /home/smcho/srv
    sudo rm -rf certbot/
    echo "✅ Certificates cleaned"
    echo "Now run deploy-certificate.sh to regenerate"
else
    echo "Cancelled"
fi