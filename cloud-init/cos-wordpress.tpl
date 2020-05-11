#cloud-config
bootcmd:
- %{ if first_boot }mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb%{ else }fsck.ext4 -tvy /dev/sdb%{ endif } 
- mkdir -m 700 -p /mnt/disks/pd
- mount -o discard,defaults /dev/sdb /mnt/disks/pd

write_files:
- path: /var/lib/cloud/scripts/secret-wrapper
  permissions: 0500
  owner: root
  content: |
    #!/usr/bin/env bash
    docker run --rm gcr.io/google.com/cloudsdktool/cloud-sdk:slim gcloud secrets versions access "$1" --secret="$2" > $3
- path: /var/run/wordpress/nginx-plain.conf
  permissions: 0400
  owner: root
  content: |
    server {
        listen 80;
        listen [::]:80;

        server_name %{ for domain in domains } ${domain}%{ endfor ~};

        index index.php index.html index.htm;

        root /var/www/html;

        location ~ /.well-known/acme-challenge {
                allow all;
                root /var/www/html;
        }

        location / {
                try_files $uri $uri/ /index.php$is_args$args;
        }

        location ~ \.php$ {
                try_files $uri =404;
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_pass wordpress:9000;
                fastcgi_index index.php;
                include fastcgi_params;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                fastcgi_param PATH_INFO $fastcgi_path_info;
        }

        location ~ /\.ht {
                deny all;
        }

        location = /favicon.ico { 
                log_not_found off; access_log off; 
        }
        location = /robots.txt { 
                log_not_found off; access_log off; allow all; 
        }
        location ~* \.(css|gif|ico|jpeg|jpg|js|png)$ {
                expires max;
                log_not_found off;
        }
    }
- path: /var/run/wordpress/nginx-tls.conf
  permissions: 0400
  owner: root
  content: |
    server {
            listen 80;
            listen [::]:80;

            server_name %{ for domain in domains } ${domain}%{ endfor };

            location ~ /.well-known/acme-challenge {
                    allow all;
                    root /var/www/html;
            }

            location / {
                    rewrite ^ https://$host$request_uri? permanent;
            }
    }
    %{ for domain in domains ~}
    server {
            listen 443 ssl http2;
            listen [::]:443 ssl http2;
            server_name ${domain};

            index index.php index.html index.htm;

            root /var/www/html;

            server_tokens off;

            ssl_certificate /etc/letsencrypt/live/${domains[0]}/fullchain.pem;
            ssl_certificate_key /etc/letsencrypt/live/${domains[0]}/privkey.pem;

            ssl_session_cache shared:le_nginx_SSL:10m;
            ssl_session_timeout 1d;
            ssl_session_tickets off;

            ssl_protocols TLSv1.2 TLSv1.3;
            ssl_prefer_server_ciphers off;

            ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;

            add_header X-Frame-Options "SAMEORIGIN" always;
            add_header X-XSS-Protection "1; mode=block" always;
            add_header X-Content-Type-Options "nosniff" always;
            add_header Referrer-Policy "no-referrer-when-downgrade" always;
            add_header Content-Security-Policy "default-src * data: 'unsafe-eval' 'unsafe-inline'" always;
            # add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
            # enable strict transport security only if you understand the implications

            client_max_body_size 100M;

            location / {
                    try_files $uri $uri/ /index.php$is_args$args;
            }

            location ~ \.php$ {
                    try_files $uri =404;
                    fastcgi_split_path_info ^(.+\.php)(/.+)$;
                    fastcgi_pass wordpress:9000;
                    fastcgi_index index.php;
                    include fastcgi_params;
                    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                    fastcgi_param PATH_INFO $fastcgi_path_info;
            }

            location ~ /\.ht {
                    deny all;
            }

            location = /favicon.ico { 
                    log_not_found off; access_log off; 
            }
            location = /robots.txt { 
                    log_not_found off; access_log off; allow all; 
            }
            location ~* \.(css|gif|ico|jpeg|jpg|js|png)$ {
                    expires max;
                    log_not_found off;
            }
    }
    %{ endfor }
- path: /etc/systemd/system/nginx.service
  permissions: 0400
  owner: root
  content: |
    [Unit]
    Description=nginx
    Wants=gcr-online.target docker.service

    [Service]
    ExecStart=/usr/bin/docker run --rm --name=nginx --network wordpress -p 0.0.0.0:80:80 -p 0.0.0.0:443:443 -v /etc/letsencrypt:/etc/letsencrypt -v /var/run/wordpress/nginx-%{ if first_boot }plain%{ else }tls%{ endif }.conf:/etc/nginx/conf.d/site.conf -v /mnt/disks/pd/wordpress/html:/var/www/html nginx:latest
    ExecStop=/usr/bin/docker stop nginx
    ExecStopPost=/usr/bin/docker rm nginx
    Restart=always
- path: /etc/systemd/system/mysql.service
  permissions: 0400
  owner: root
  content: |
    [Unit]
    Description=mysql
    Wants=gcr-online.target docker.service
    After=gcr-online.target docker.service

    [Service]
    ExecStartPre=/var/lib/cloud/scripts/secret-wrapper 1 mysql /var/run/mysql/mysql.env
    ExecStart=/usr/bin/docker run --rm --name=mysql --network wordpress -p 3306:3306 --env-file /var/run/mysql/mysql.env -v /mnt/disks/pd/mysql/data:/var/lib/mysql mysql:latest --default-authentication-plugin=mysql_native_password
    ExecStop=/usr/bin/docker stop mysql
    ExecStopPost=/usr/bin/docker rm mysql
    Restart=always
- path: /etc/systemd/system/wordpress.service
  permissions: 0400
  owner: root
  content: |
    [Unit]
    Description=wordpress
    Wants=gcr-online.target
    After=gcr-online.target

    [Service]
    ExecStartPre=/var/lib/cloud/scripts/secret-wrapper 1 wordpress /var/run/wordpress/wordpress.env
    ExecStart=/usr/bin/docker run --rm --name=wordpress --network wordpress -p 9000:9000 --env-file /var/run/wordpress/wordpress.env -v /mnt/disks/pd/wordpress/html:/var/www/html wordpress:5.4-fpm-alpine
    ExecStop=/usr/bin/docker stop wordpress
    ExecStopPost=/usr/bin/docker rm wordpress
    Restart=always
- path: /etc/systemd/system/certbot.service
  permissions: 0400
  owner: root
  content: |
    [Unit]
    Description=certbot
    Wants=gcr-online.target nginx.service
    After=gcr-online.target nginx.service

    [Service]
    Type=oneshot
    Environment="HOME=/etc/letsencrypt"
    ExecStart=/usr/bin/docker run --rm --name=certbot --network wordpress -v /etc/letsencrypt:/etc/letsencrypt -v /mnt/disks/pd/wordpress/html:/var/www/html certbot/certbot certonly --webroot --webroot-path=/var/www/html --email cloud@nawl.ca --agree-tos --force-renewal %{ for domain in domains}-d ${domain} %{ endfor}
    ExecStop=/usr/bin/docker stop certbot
    ExecStopPost=/usr/bin/docker rm certbot
    Restart=never
runcmd:
- docker network create -d bridge --subnet=10.10.10.0/28 --ip-range=10.10.10.0/29 wordpress
- mkdir -m 755 -p /mnt/disks/pd/wordpress/html
- mkdir -m 700 -p /mnt/disks/pd/mysql
- mkdir -m 700 -p /mnt/disks/pd/letsencrypt
- mkdir -m 700 -p /var/run/mysql
- mkdir -m 700 -p /var/run/wordpress
- ln -sf /mnt/disks/pd/letsencrypt /etc/letsencrypt
- systemctl daemon-reload
- systemctl start mysql.service
- systemctl start wordpress.service
- systemctl start nginx.service
%{ if first_boot }- systemctl start certbot.service%{ endif } 
