#!/bin/bash
# smart_sync.sh

BRANCH=nginx
#BRANCH=main

echo "=== Smart Git Sync ==="

# 병합 전략 설정 (기본값: rebase)
git config pull.rebase true

# 원격 저장소 동기화
git fetch origin

# 로컬 변경사항 확인 (커밋된 변경사항 포함)
if [[ $(git status --porcelain) ]] || ! git diff --quiet origin/$BRANCH; then
    echo "📝 Changes detected. Staging and pushing..."
    
    # 변경사항 스테이징
    git add .
    
    # 커밋 메시지 입력
    read -p "Commit Message (Enter=Auto): " commit_msg
    [ -z "$commit_msg" ] && commit_msg="$(date '+%Y-%m-%d %H:%M'): Auto Commit"
    
    # 커밋 및 푸시
    git commit -m "$commit_msg"
    git push origin $BRANCH
    
    # 푸시 결과 확인
    if [ $? -eq 0 ]; then
        echo "✅ Push Success!"
    else
        echo "❌ Push Failure!"
        exit 1
    fi
else
    echo "📥 No Changes. Pulling updates..."
    
    # 안전한 풀 작업 (충돌 발생 시 대응)
    if ! git pull --rebase origin $BRANCH; then
        echo "⚠️ Pull conflict detected! Resetting..."
        git rebase --abort
        git reset --hard HEAD
        git pull --ff-only origin $BRANCH
    fi
    echo "✅ Pull Success!"
fi
