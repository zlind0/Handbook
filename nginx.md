# HTTPS with WebSocket

```
server {
        listen 443 ssl http2;
        listen [::]:443 http2;
        ssl_certificate       /data/cert.crt;
        ssl_certificate_key   /data/cert.key;
        ssl_protocols         TLSv1.1 TLSv1.2 TLSv1.3;
        ssl_ciphers           TLS13-AES-256-GCM-SHA384:TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-128-GCM-SHA256:TLS13-AES-128-CCM-8-SHA256:TLS13-AES-128-CCM-SHA256:EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
        server_name ....xyz;
        index index.html index.htm;
        root  /home/wwwroot/;
        error_page 400 = /400.html;

        # Config for 0-RTT in TLSv1.3
        ssl_early_data on;
        ssl_stapling on;
        ssl_stapling_verify on;
        add_header Strict-Transport-Security "max-age=31536000";

        server_tokens off;
        add_header X-Frame-Options SAMEORIGIN;
        add_header X-Content-Type-Options nosniff;
        client_max_body_size 50M;
        location /{
                proxy_redirect off;
                proxy_pass http://127.0.0.1:8880/;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_read_timeout 3m;
                proxy_send_timeout 3m;
        }
}
```
