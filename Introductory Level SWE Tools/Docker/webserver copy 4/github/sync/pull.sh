#!/bin/bash
# sync_pull.sh

#BRANCH=main
BRANCH=nginx

echo "=== Git Pull Script ==="

git pull origin $BRANCH

if [ $? -eq 0 ]; then
    echo "✅ Pull Success"
else
    echo "❌ Pull Failure!"
fi