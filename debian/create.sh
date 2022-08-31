#!/bin/sh
#./script domain folder

DOMAIN=$1
FOLDER=$2

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 2 ] || die "$# parametro informado!"

mkdir -p /srv/www/$DOMAIN/logs
mkdir -p /srv/www/$DOMAIN/public_html

echo "
server {
    listen 80;
    server_name $DOMAIN;
    root /srv/www/$DOMAIN/public_html/$FOLDER;
    index index.php;

    location / {
        try_files \$uri/ \$uri /index.php?\$query_string;
    }

    location ~ \.php$ {
      	include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
    }
}
" > $DOMAIN.txt

mv $DOMAIN.txt /etc/nginx/sites-available/$DOMAIN
cd /etc/nginx/sites-enabled/ && ln -s /etc/nginx/sites-available/$DOMAIN 

echo "Domínio $DOMAIN criado com sucesso!"
