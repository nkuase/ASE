#!/bin/bash

set -e  # 에러 발생시 스크립트 중단

# 절대 경로 정의
BASE_DIR="/home/smcho/srv"
APACHE_DIR="$BASE_DIR/apache"
DOCKER_DIR="$BASE_DIR/docker"
CERTBOT_DIR="$BASE_DIR/certbot"

echo "🚀 Starting Apache deployment..."
echo "📁 Base directory: $BASE_DIR"
echo "📁 Script can be executed from anywhere"

# 디렉토리 존재 확인
if [ ! -d "$BASE_DIR" ]; then
    echo "❌ Base directory not found: $BASE_DIR"
    exit 1
fi

if [ ! -d "$DOCKER_DIR" ]; then
    echo "❌ Docker directory not found: $DOCKER_DIR"
    exit 1
fi

if [ ! -f "$DOCKER_DIR/docker-compose.yml" ]; then
    echo "❌ docker-compose.yml not found: $DOCKER_DIR/docker-compose.yml"
    exit 1
fi

# Apache 설정 디렉토리 생성
if [ ! -d "$APACHE_DIR" ]; then
    echo "📁 Creating Apache directory..."
    mkdir -p "$APACHE_DIR"
fi

# Apache 설정 파일 생성 또는 확인
create_apache_configs() {
    echo "📝 Creating Apache configuration files..."
    
    # HTTP-only configuration for Let's Encrypt challenges
    cat > "$APACHE_DIR/httpd-http.conf" << 'EOF'
# Apache HTTP-only configuration for certificate challenges
ServerRoot "/usr/local/apache2"
Listen 80

# Load essential modules
LoadModule mpm_event_module modules/mod_mpm_event.so
LoadModule authz_core_module modules/mod_authz_core.so
LoadModule dir_module modules/mod_dir.so
LoadModule mime_module modules/mod_mime.so
LoadModule rewrite_module modules/mod_rewrite.so
LoadModule alias_module modules/mod_alias.so

# Basic settings
ServerName prosseek.com
DirectoryIndex index.html index.htm
DocumentRoot "/usr/local/apache2/htdocs"

# Directory permissions
<Directory "/usr/local/apache2/htdocs">
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>

# MIME types
TypesConfig conf/mime.types

# HTTP Virtual Host for Let's Encrypt challenges
<VirtualHost *:80>
    ServerName prosseek.com
    ServerAlias www.prosseek.com
    DocumentRoot "/usr/local/apache2/htdocs"
    
    # Let's Encrypt challenge directory
    Alias /.well-known/acme-challenge/ /var/www/certbot/.well-known/acme-challenge/
    <Directory "/var/www/certbot/.well-known/acme-challenge/">
        Options None
        AllowOverride None
        Require all granted
    </Directory>
</VirtualHost>

# Error and access logs
ErrorLog logs/error.log
LogLevel warn
CustomLog logs/access.log combined
EOF

    # HTTPS configuration
    cat > "$APACHE_DIR/httpd-https.conf" << 'EOF'
# Apache HTTPS configuration
ServerRoot "/usr/local/apache2"
Listen 80
Listen 443 ssl

# Load essential modules
LoadModule mpm_event_module modules/mod_mpm_event.so
LoadModule authz_core_module modules/mod_authz_core.so
LoadModule dir_module modules/mod_dir.so
LoadModule mime_module modules/mod_mime.so
LoadModule rewrite_module modules/mod_rewrite.so
LoadModule ssl_module modules/mod_ssl.so
LoadModule headers_module modules/mod_headers.so
LoadModule alias_module modules/mod_alias.so
LoadModule http2_module modules/mod_http2.so

# Basic settings
ServerName prosseek.com
DirectoryIndex index.html index.htm
DocumentRoot "/usr/local/apache2/htdocs"

# Directory permissions
<Directory "/usr/local/apache2/htdocs">
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>

# MIME types
TypesConfig conf/mime.types

# SSL Engine and protocols
SSLEngine on
SSLProtocol TLSv1.2 TLSv1.3
SSLCipherSuite ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256
SSLHonorCipherOrder off
SSLSessionCache "shmcb:/usr/local/apache2/logs/ssl_scache(512000)"
SSLSessionCacheTimeout 300

# HTTP Virtual Host (redirects to HTTPS)
<VirtualHost *:80>
    ServerName prosseek.com
    ServerAlias www.prosseek.com
    
    # Let's Encrypt challenge directory
    Alias /.well-known/acme-challenge/ /var/www/certbot/.well-known/acme-challenge/
    <Directory "/var/www/certbot/.well-known/acme-challenge/">
        Options None
        AllowOverride None
        Require all granted
    </Directory>
    
    # Redirect all other traffic to HTTPS
    RewriteEngine On
    RewriteCond %{REQUEST_URI} !^/.well-known/acme-challenge/
    RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]
</VirtualHost>

# HTTPS Virtual Host
<VirtualHost *:443>
    ServerName prosseek.com
    ServerAlias www.prosseek.com
    DocumentRoot "/usr/local/apache2/htdocs"
    
    # SSL Certificate configuration
    SSLCertificateFile /etc/letsencrypt/live/prosseek.com/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/prosseek.com/privkey.pem
    
    # Security headers for HTTPS
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-Content-Type-Options "nosniff"
    Header always set Referrer-Policy "no-referrer-when-downgrade"
    
    # Enable HTTP/2
    Protocols h2 http/1.1
    
    # Directory configuration
    <Directory "/usr/local/apache2/htdocs">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>

# Error and access logs
ErrorLog logs/error.log
LogLevel warn
CustomLog logs/access.log combined
CustomLog logs/ssl_access.log combined
EOF

    # Docker compose for Apache
    cat > "$DOCKER_DIR/docker-compose.yml" << 'EOF'
version: '3.8'
services:
  apache:
    image: httpd:2.4
    ports:
      - "0.0.0.0:80:80"
      - "0.0.0.0:443:443"
    volumes:
      - /home/smcho/srv/www:/usr/local/apache2/htdocs:ro
      - /home/smcho/srv/apache/httpd.conf:/usr/local/apache2/conf/httpd.conf:ro
      - /home/smcho/srv/certbot/etc:/etc/letsencrypt:ro
      - /home/smcho/srv/certbot/www:/var/www/certbot:ro
    restart: always
    depends_on:
      - certbot
    networks:
      - apache-net

  certbot:
    image: certbot/certbot
    volumes:
      - /home/smcho/srv/certbot/etc:/etc/letsencrypt
      - /home/smcho/srv/certbot/www:/var/www/certbot
    entrypoint: "/bin/sh -c 'trap exit TERM; while :; do certbot renew; sleep 12h & wait $${!}; done;'"

networks:
  apache-net:
    driver: bridge
EOF

    echo "✅ Apache configuration files created"
}

# Apache 설정 파일 생성
create_apache_configs

echo "✅ All required directories and files found"

# git pull (옵션)
cd "$BASE_DIR"
# git pull origin main  # 필요시 주석 해제

# certbot 디렉토리 생성
if [ ! -d "$CERTBOT_DIR" ]; then
    echo "📁 Creating certbot directories..."
    mkdir -p "$CERTBOT_DIR"/{etc,www}
    sudo chown -R $USER:$USER "$CERTBOT_DIR"
    echo "✅ Created certbot directories"
fi

# 권한 설정
sudo chown -R $USER:$USER "$CERTBOT_DIR"
sudo chmod -R 755 "$CERTBOT_DIR"

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
    
    # 인증서-키 매칭 검증 (핵심 개선사항!)
    echo "🔍 Validating certificate-key pair..."
    cert_md5=$(openssl x509 -noout -modulus -in "$cert_path/fullchain.pem" 2>/dev/null | openssl md5 | cut -d' ' -f2)
    key_md5=$(openssl rsa -noout -modulus -in "$cert_path/privkey.pem" 2>/dev/null | openssl md5 | cut -d' ' -f2)
    
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

# 인증서 발급이 필요한 경우에만 HTTP 설정 사용
if [ "$NEED_CERT" = true ]; then
    echo "🔧 Switching to HTTP-only configuration..."
    cp "$APACHE_DIR/httpd-http.conf" "$APACHE_DIR/httpd.conf"
    
    # Docker 명령은 반드시 docker-compose.yml이 있는 디렉토리에서 실행
    echo "🐳 Starting Docker containers from $DOCKER_DIR..."
    cd "$DOCKER_DIR"
    docker compose down
    docker compose up -d apache
    
    echo "🌐 Testing HTTP connection..."
    sleep 3
    if ! curl -f http://prosseek.com > /dev/null 2>&1; then
        echo "❌ HTTP connection failed!"
        echo "📋 Apache logs:"
        docker compose logs apache | tail -10
        exit 1
    fi
    echo "✅ HTTP connection successful"
    
    echo "📜 Obtaining SSL certificate (RSA for compatibility)..."
    # 기존 인증서 백업
    if [ -d "$CERTBOT_DIR/etc/live/prosseek.com" ]; then
        sudo mv "$CERTBOT_DIR/etc/live/prosseek.com" "$CERTBOT_DIR/etc/live/prosseek.com.backup.$(date +%s)"
    fi
    if [ -d "$CERTBOT_DIR/etc/archive/prosseek.com" ]; then
        sudo mv "$CERTBOT_DIR/etc/archive/prosseek.com" "$CERTBOT_DIR/etc/archive/prosseek.com.backup.$(date +%s)"
    fi
    
    # RSA 인증서 발급 (핵심 개선사항!)
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
      -d prosseek.com -d www.prosseek.com
    
    # 권한 재설정
    sudo chown -R $USER:$USER "$CERTBOT_DIR"
    sudo chmod 644 "$CERTBOT_DIR/etc/live/prosseek.com/"*.pem
    sudo chmod 600 "$CERTBOT_DIR/etc/live/prosseek.com/privkey.pem"
    
    # 새 인증서 검증
    if validate_certificates; then
        echo "✅ Certificate obtained and validated successfully"
    else
        echo "❌ Certificate validation failed after generation!"
        exit 1
    fi
else
    echo "📜 Certificate is up to date, skipping generation"
    
    # 인증서가 있으면 Docker만 시작
    echo "🐳 Starting Docker containers from $DOCKER_DIR..."
    cd "$DOCKER_DIR"
    docker compose down
    docker compose up -d
fi

# HTTPS 설정으로 전환
echo "🔧 Switching to HTTPS configuration..."
cp "$APACHE_DIR/httpd-https.conf" "$APACHE_DIR/httpd.conf"

echo "🔄 Restarting Apache with SSL..."
cd "$DOCKER_DIR"  # docker compose는 반드시 여기서 실행
docker compose restart apache

# Apache 설정 검증
echo "🔍 Validating Apache configuration..."
if ! docker compose exec apache httpd -t; then
    echo "❌ Apache configuration test failed!"
    echo "📋 Apache error logs:"
    docker compose logs apache | tail -20
    exit 1
fi

# 포트 바인딩 확인 (핵심 개선사항!)
echo "🔍 Checking port bindings..."
docker compose exec apache netstat -tlnp | grep -E ":80|:443" || true

# SSL 포트 바인딩 특별 확인
echo "🔍 Verifying SSL port binding..."
sleep 3
if docker compose exec apache netstat -tlnp | grep -q ":443"; then
    echo "✅ Apache is listening on port 443"
else
    echo "❌ Apache is NOT listening on port 443!"
    echo "📋 Checking for SSL errors in Apache logs:"
    docker compose logs apache | grep -i ssl || echo "No SSL-specific errors found"
    echo "📋 Full Apache logs:"
    docker compose logs apache | tail -20
    
    # 인증서 파일 접근성 재확인
    echo "📋 Certificate file accessibility check:"
    docker compose exec apache ls -la /etc/letsencrypt/live/prosseek.com/ || echo "Certificate files not accessible"
    
    exit 1
fi

echo "🔒 Testing HTTPS connection..."
sleep 5  # Apache 재시작 대기

# HTTPS 테스트
if curl -f -s https://prosseek.com > /dev/null; then
    echo "✅ HTTPS connection successful"
    
    # 추가 검증
    echo "🔍 SSL certificate verification:"
    curl -I https://prosseek.com | head -5
    
else
    echo "❌ HTTPS connection failed"
    echo "📋 Detailed curl test:"
    curl -v https://prosseek.com || true
    echo ""
    echo "📋 Apache logs:"
    docker compose logs apache | tail -20
    
    echo ""
    echo "📋 Port check:"
    docker compose exec apache netstat -tlnp | grep :443 || echo "Port 443 not found"
    
    exit 1
fi

echo ""
echo "🎉 Apache deployment complete!"
echo "🌐 Website: https://prosseek.com"
echo "📋 Certificate expires: $(openssl x509 -enddate -noout -in "$CERTBOT_DIR/etc/live/prosseek.com/fullchain.pem" | cut -d= -f2)"