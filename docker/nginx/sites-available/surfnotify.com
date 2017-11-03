upstream surfnotify {
  server unix:///var/run/surfnotify.sock;
}

server {
  listen 443;
  server_name surfnotify.com;
  root /usr/src/surfnotify/public;

  ssl on;
  ssl_certificate /etc/ssl/surfnotify/surfnotify.com/fullchain.pem;
  ssl_certificate_key /etc/ssl/surfnotify/surfnotify.com/privkey.pem;

  location / {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_redirect off;
    proxy_pass http://surfnotify;
  }
}
