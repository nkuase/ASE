# SSL/HTTPS Debugging Checklist

# 1. Check if nginx is listening on port 443
docker compose exec nginx netstat -tlnp | grep :443

# 2. Check nginx configuration inside container
docker compose exec nginx nginx -T | grep -A 5 -B 5 "listen.*443"

# 3. Verify certificate files exist and are readable
docker compose exec nginx ls -la /etc/letsencrypt/live/prosseek.com/

# 4. Test SSL certificate validity
docker compose exec nginx openssl x509 -in /etc/letsencrypt/live/prosseek.com/fullchain.pem -text -noout | head -20

# 5. Check docker port mapping
docker compose ps
docker port docker-nginx-1

# 6. Test connection from inside container
docker compose exec nginx curl -k https://localhost:443

# 7. Check if nginx process is running correctly
docker compose exec nginx ps aux | grep nginx

# 8. View real-time nginx error logs
docker compose logs -f nginx

# 9. Test SSL handshake specifically
openssl s_client -connect prosseek.com:443 -servername prosseek.com

# 10. Check firewall/iptables (on host)
sudo iptables -L | grep 443
sudo ufw status | grep 443# SSL/HTTPS Debugging Checklist

# 1. Check if nginx is listening on port 443
docker compose exec nginx netstat -tlnp | grep :443

# 2. Check nginx configuration inside container
docker compose exec nginx nginx -T | grep -A 5 -B 5 "listen.*443"

# 3. Verify certificate files exist and are readable
docker compose exec nginx ls -la /etc/letsencrypt/live/prosseek.com/

# 4. Test SSL certificate validity
docker compose exec nginx openssl x509 -in /etc/letsencrypt/live/prosseek.com/fullchain.pem -text -noout | head -20

# 5. Check docker port mapping
docker compose ps
docker port docker-nginx-1

# 6. Test connection from inside container
docker compose exec nginx curl -k https://localhost:443

# 7. Check if nginx process is running correctly
docker compose exec nginx ps aux | grep nginx

# 8. View real-time nginx error logs
docker compose logs -f nginx

# 9. Test SSL handshake specifically
openssl s_client -connect prosseek.com:443 -servername prosseek.com

# 10. Check firewall/iptables (on host)
sudo iptables -L | grep 443
sudo ufw status | grep 443
