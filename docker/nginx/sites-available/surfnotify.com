server {
  listen 80 default_server;
  listen [::]:80 default_server;

  server_name _;

  location / {
    return 301 https://$host$request_uri;
  }

  location /.well-known/acme-challenge {
    alias /var/www/dehydrated;
    default_type "text/plain";
    try_files $uri =404;
  }
}

server {
  listen 443;
  server_name surfnotify.com;

  access_log /var/log/nginx/app.access.log;
  error_log /var/log/nginx/app.error.log;

  ssl on;
  ssl_certificate /etc/ssl/surfnotify.com/fullchain.pem;
  ssl_certificate_key /etc/ssl/surfnotify.com/privkey.pem;

  location / {
    proxy_pass http://127.0.0.1:3000;
  }
}
