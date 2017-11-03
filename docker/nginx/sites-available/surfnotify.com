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
