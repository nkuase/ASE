#!/bin/bash

set -e  # 에러 발생시 스크립트 중단

# 절대 경로 정의
BASE_DIR="/home/smcho/srv"
NGINX_DIR="$BASE_DIR/nginx"
CERTBOT_DIR="$BASE_DIR/certbot"

echo "🚀 Starting deployment..."
echo "📁 Base directory: $BASE_DIR"
echo "📁 Script can be executed from anywhere"

# docker-compose.yml 위치 자동 감지 (핵심 개선!)
POSSIBLE_DOCKER_DIRS=(
    "$BASE_DIR/docker"
    "$BASE_DIR/docker/nginx"
    "$BASE_DIR"
)

DOCKER_DIR=""
for dir in "${POSSIBLE_DOCKER_DIRS[@]}"; do
    if [ -f "$dir/docker-compose.yml" ]; then
        DOCKER_DIR="$dir"
        echo "✅ Found docker-compose.yml in: $DOCKER_DIR"
        break
    fi
done

if [ -z "$DOCKER_DIR" ]; then
    echo "❌ docker-compose.yml not found in any expected location:"
    for dir in "${POSSIBLE_DOCKER_DIRS[@]}"; do
        echo "   - $dir"
    done
    exit 1
fi

# 디렉토리 존재 확인
if [ ! -d "$BASE_DIR" ]; then
    echo "❌ Base directory not found: $BASE_DIR"
    exit 1
fi

# nginx 설정 파일 존재 확인
if [ ! -f "$NGINX_DIR/nginx.conf-http" ] || [ ! -f "$NGINX_DIR/nginx.conf-https" ]; then
    echo "❌ nginx config files not found!"
    echo "Looking for:"
    echo "  - $NGINX_DIR/nginx.conf-http"
    echo "  - $NGINX_DIR/nginx.conf-https"
    exit 1
fi

echo "✅ All required directories and files found"

# 🔧 핵심 개선: 잘못된 nginx.conf 디렉토리 정리
if [ -d "$NGINX_DIR/nginx.conf" ]; then
    echo "🗑️  Removing incorrectly created nginx.conf directory..."
    rm -rf "$NGINX_DIR/nginx.conf"
fi

# certbot 디렉토리 생성
if [ ! -d "$CERTBOT_DIR" ]; then
    echo "📁 Creating certbot directories..."
    mkdir -p "$CERTBOT_DIR"/{etc,www}
    sudo chown -R $USER:$USER "$CERTBOT_DIR" 2>/dev/null || chown -R $USER:$USER "$CERTBOT_DIR"
    echo "✅ Created certbot directories"
fi

# 권한 설정
sudo chown -R $USER:$USER "$CERTBOT_DIR" 2>/dev/null || chown -R $USER:$USER "$CERTBOT_DIR"
sudo chmod -R 755 "$CERTBOT_DIR" 2>/dev/null || chmod -R 755 "$CERTBOT_DIR"

# 인증서 확인 및 검증 함수
validate_certificates() {
    local cert_path="$CERTBOT_DIR/etc/live/prosseek.com"
    
    if [ ! -f "$cert_path/fullchain.pem" ] || [ ! -f "$cert_path/privkey.pem" ]; then
        echo "❌ Certificate files not found"
        return 1
    fi
    
    # 인증서 만료 확인
    if ! openssl x509 -checkend 2592000 -noout -in "$cert_path/fullchain.pem" 2>/dev/null; then
        echo "⚠️  Certificate expires soon"
        return 1
    fi
    
    # 인증서-키 매칭 검증
    echo "🔍 Validating certificate-key pair..."
    cert_md5=$(openssl x509 -noout -modulus -in "$cert_path/fullchain.pem" 2>/dev/null | openssl md5 2>/dev/null | cut -d' ' -f2)
    key_md5=$(openssl rsa -noout -modulus -in "$cert_path/privkey.pem" 2>/dev/null | openssl md5 2>/dev/null | cut -d' ' -f2)
    
    if [ "$cert_md5" != "$key_md5" ] || [ -z "$cert_md5" ]; then
        echo "❌ Certificate and private key don't match!"
        echo "   Certificate MD5: $cert_md5"
        echo "   Private key MD5: $key_md5"
        return 1
    fi
    
    echo "✅ Certificate-key pair validated successfully"
    return 0
}

# 인증서 확인
NEED_CERT=false

if [ -f "$CERTBOT_DIR/etc/live/prosseek.com/fullchain.pem" ]; then
    echo "📜 Certificate already exists. Checking validity..."
    
    if validate_certificates; then
        echo "✅ Certificate is valid and properly matched"
        NEED_CERT=false
    else
        echo "⚠️  Certificate validation failed, will regenerate"
        NEED_CERT=true
    fi
else
    echo "📜 No certificate found, will create new one"
    NEED_CERT=true
fi

# 🔧 핵심 개선: Docker 실행 전에 항상 nginx.conf 파일 생성!
echo "📝 Creating nginx.conf file before Docker startup..."
if [ "$NEED_CERT" = true ]; then
    echo "🔧 Using HTTP-only configuration (for certificate generation)..."
    cp "$NGINX_DIR/nginx.conf-http" "$NGINX_DIR/nginx.conf"
else
    echo "🔧 Using HTTPS configuration (certificate exists)..."
    cp "$NGINX_DIR/nginx.conf-https" "$NGINX_DIR/nginx.conf"
fi

# 파일 생성 확인
if [ -f "$NGINX_DIR/nginx.conf" ]; then
    echo "✅ nginx.conf file created successfully"
    file "$NGINX_DIR/nginx.conf"
else
    echo "❌ Failed to create nginx.conf file"
    exit 1
fi

# 인증서 발급이 필요한 경우
if [ "$NEED_CERT" = true ]; then
    # Docker 명령은 반드시 docker-compose.yml이 있는 디렉토리에서 실행
    echo "🐳 Starting Docker containers from $DOCKER_DIR..."
    cd "$DOCKER_DIR"
    docker compose down -v 2>/dev/null || true
    docker compose up -d nginx
    
    echo "🌐 Testing HTTP connection..."
    sleep 5
    
    # 내부 연결 테스트 먼저
    if docker compose exec nginx curl -f http://localhost >/dev/null 2>&1; then
        echo "✅ Internal HTTP connection successful"
    else
        echo "❌ Internal HTTP connection failed!"
        echo "📋 nginx logs:"
        docker compose logs nginx | tail -10
        exit 1
    fi
    
    echo "📜 Obtaining SSL certificate (RSA for compatibility)..."
    # 기존 인증서 백업
    if [ -d "$CERTBOT_DIR/etc/live/prosseek.com" ]; then
        sudo mv "$CERTBOT_DIR/etc/live/prosseek.com" "$CERTBOT_DIR/etc/live/prosseek.com.backup.$(date +%s)" 2>/dev/null || true
    fi
    if [ -d "$CERTBOT_DIR/etc/archive/prosseek.com" ]; then
        sudo mv "$CERTBOT_DIR/etc/archive/prosseek.com" "$CERTBOT_DIR/etc/archive/prosseek.com.backup.$(date +%s)" 2>/dev/null || true
    fi
    
    # RSA 인증서 발급
    docker run --rm \
      -v "$CERTBOT_DIR/etc:/etc/letsencrypt" \
      -v "$CERTBOT_DIR/www:/var/www/certbot" \
      certbot/certbot \
      certonly --webroot \
      --webroot-path=/var/www/certbot \
      --email prosseek@gmail.com \
      --agree-tos \
      --no-eff-email \
      --key-type rsa \
      --rsa-key-size 2048 \
      --staging \
      -d prosseek.com -d www.prosseek.com
    
    # 권한 재설정
    sudo chown -R $USER:$USER "$CERTBOT_DIR" 2>/dev/null || chown -R $USER:$USER "$CERTBOT_DIR"
    sudo chmod 644 "$CERTBOT_DIR/etc/live/prosseek.com/"*.pem 2>/dev/null || true
    sudo chmod 600 "$CERTBOT_DIR/etc/live/prosseek.com/privkey.pem" 2>/dev/null || true
    
    # 새 인증서 검증
    if validate_certificates; then
        echo "✅ Certificate obtained and validated successfully"
    else
        echo "❌ Certificate validation failed after generation!"
        exit 1
    fi
    
    # HTTPS 설정으로 전환
    echo "🔧 Switching to HTTPS configuration..."
    cp "$NGINX_DIR/nginx.conf-https" "$NGINX_DIR/nginx.conf"
    
else
    echo "📜 Certificate is up to date, skipping generation"
    
    # 인증서가 있으면 Docker 시작
    echo "🐳 Starting Docker containers from $DOCKER_DIR..."
    cd "$DOCKER_DIR"
    docker compose down -v 2>/dev/null || true
    docker compose up -d
fi

echo "🔄 Restarting nginx with current configuration..."
cd "$DOCKER_DIR"
docker compose restart nginx

# nginx 설정 검증
echo "🔍 Validating nginx configuration..."
sleep 3
if ! docker compose exec nginx nginx -t 2>/dev/null; then
    echo "❌ nginx configuration test failed!"
    echo "📋 nginx error logs:"
    docker compose logs nginx | tail -20
    exit 1
fi

# 포트 바인딩 확인
echo "🔍 Checking port bindings..."
docker compose exec nginx netstat -tlnp | grep -E ":80|:443" || true

# SSL 포트 바인딩 확인 (HTTPS 설정인 경우)
if grep -q "listen 443" "$NGINX_DIR/nginx.conf"; then
    echo "🔍 Verifying SSL port binding..."
    sleep 3
    if docker compose exec nginx netstat -tlnp | grep -q ":443"; then
        echo "✅ nginx is listening on port 443"
    else
        echo "❌ nginx is NOT listening on port 443!"
        echo "📋 Checking for SSL errors in nginx logs:"
        docker compose logs nginx | grep -i ssl || echo "No SSL-specific errors found"
        echo "📋 Full nginx logs:"
        docker compose logs nginx | tail -20
        exit 1
    fi
    
    echo "🔒 Testing HTTPS connection..."
    sleep 5
    
    # HTTPS 테스트 (내부)
    if docker compose exec nginx curl -k -f -s https://localhost >/dev/null 2>&1; then
        echo "✅ Internal HTTPS connection successful"
    else
        echo "⚠️  Internal HTTPS connection failed (normal if using self-signed cert for testing)"
    fi
else
    echo "ℹ️  HTTP-only configuration, skipping HTTPS tests"
fi

echo ""
echo "🎉 Deployment complete!"
echo "🌐 Website should be accessible"
if grep -q "listen 443" "$NGINX_DIR/nginx.conf"; then
    echo "   HTTPS: https://prosseek.com"
    if [ -f "$CERTBOT_DIR/etc/live/prosseek.com/fullchain.pem" ]; then
        echo "📋 Certificate expires: $(openssl x509 -enddate -noout -in "$CERTBOT_DIR/etc/live/prosseek.com/fullchain.pem" 2>/dev/null | cut -d= -f2 || echo "Unable to read certificate")"
    fi
else
    echo "   HTTP: http://prosseek.com"
fi

echo ""
echo "📋 Container status:"
docker compose ps