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

