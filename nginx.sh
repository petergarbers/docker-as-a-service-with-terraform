#!/bin/sh
# `/sbin/setuser memcache` runs the given command as the user `memcache`.
# If you omit that part, the command will be run as root.
docker rm nginx
exec docker run --name nginx -p 80:80 nginx  >>/var/log/nginx.log 2>&1
