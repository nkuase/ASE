# webserver-configuration
This is for configuration of Docker/Nginx and other system to access web server
~/github/prosseek/webserver => ~/srv

# Sync Command

## First Sync
### Computer Main
```
mkdir ~/github/prosseek/webserver
git clone git@prosseek:prosseek/webserver.git ~/github/prosseek/webserver
sh github/sync/copy_post_commit.sh # when post commit file is updated
sh github/sync/push.sh 
```
### Computer Server
```
mkdir ~/srv/
git clone git@prosseek:prosseek/webserver.git ~/srv/
```

### Sync Command

```
sh github/sync/sync.sh
```

```
sh github/sync/push.sh && ssh macbuntu "cd ~/srv/github/sync && sh pull.sh"
```

# Docker Command

```
sh docker/script/restart.sh
```

```
docker compose down
docker compose up -d
```

# Other info
74.128.134.211


