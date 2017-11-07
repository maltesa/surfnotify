server {
  listen 443;
  server_name surfnotify.com;
  root /usr/src/surfnotify/public;

  ssl on;
  ssl_certificate /etc/ssl/surfnotify/surfnotify.com/fullchain.pem;
  ssl_certificate_key /etc/ssl/surfnotify/surfnotify.com/privkey.pem;

  ssl_session_timeout 5m;

  ssl_protocols SSLv2 SSLv3 TLSv1;
  ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
  ssl_prefer_server_ciphers on;

  location / {
    proxy_pass http://app:3000;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header Host $http_host;
    proxy_redirect off;
  }
}
