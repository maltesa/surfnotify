server {
  listen 443;
  server_name surfnotify.com;

  access_log /var/log/nginx/app.access.log;
  error_log /var/log/nginx/app.error.log;

  location / {
    proxy_pass http://127.0.0.1:3000;
  }
}
