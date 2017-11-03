server {
  listen 443;
  server_name surfnotify.com;
  root /usr/src/surfnotify/public;

  ssl on;
  ssl_certificate /etc/ssl/surfnotify/surfnotify.com/fullchain.pem;
  ssl_certificate_key /etc/ssl/surfnotify/surfnotify.com/privkey.pem;

  ssl_session_timeout  5m;

  ssl_protocols  SSLv2 SSLv3 TLSv1;
  ssl_ciphers  ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
  ssl_prefer_server_ciphers   on;

  location / {
    proxy_pass          http://localhost:3000;
    proxy_set_header    Host             $host;
    proxy_set_header    X-Real-IP        $remote_addr;
    proxy_set_header    X-Forwarded-For  $proxy_add_x_forwarded_for;
    proxy_set_header    X-Client-Verify  SUCCESS;
    proxy_set_header    X-Client-DN      $ssl_client_s_dn;
    proxy_set_header    X-SSL-Subject    $ssl_client_s_dn;
    proxy_set_header    X-SSL-Issuer     $ssl_client_i_dn;
    proxy_read_timeout 1800;
    proxy_connect_timeout 1800;
  }
}
