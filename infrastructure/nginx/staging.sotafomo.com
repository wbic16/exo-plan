server {
    listen 80;
    server_name staging.sotafomo.com;
    
    location /.well-known/acme-challenge/ {
        root /sites/web/staging.sotafomo.com;
    }
    
    location / {
        return 301 https://$server_name$request_uri;
    }
}

server {
    listen 443 ssl http2;
    server_name staging.sotafomo.com;
    root /sites/web/staging.sotafomo.com;

    ssl_certificate /etc/letsencrypt/live/staging.sotafomo.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/staging.sotafomo.com/privkey.pem;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    location / {
        try_files $uri $uri/ /index.html;
        expires 5m;
    }

    location /css/ {
        expires 30d;
    }
}
