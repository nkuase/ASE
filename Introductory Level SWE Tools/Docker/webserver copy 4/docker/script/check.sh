# 1. Update your nginx.conf-https (remove the ~ from ssl_certificate line)
# 2. Copy to active config
cp /home/smcho/srv/nginx/nginx.conf-https /home/smcho/srv/nginx/nginx.conf

# 3. Restart nginx
cd /home/smcho/srv/docker
docker compose restart nginx

# 4. Now check if nginx listens on 443
docker compose exec nginx netstat -tlnp | grep :443

# 5. Test HTTPS
curl -I https://prosseek.com