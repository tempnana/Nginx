#!/bin/bash
#update
mkdir /root/nginx
cd /root/nginx
apt-get update && apt-get upgrade -y
#install tools
# apt-get install curl wget net-tools iftop build-essential libpcre3 libpcre3-dev libssl-dev git zlib1g-dev zip unzip -y
#adduser
# adduser --system --home /nonexistent --shell /bin/false --no-create-home --gecos "nginx user" --group --disabled-login --disabled-password nginx
#get module files and nginx source
git clone https://github.com/FRiCKLE/ngx_cache_purge
git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module
git clone https://github.com/openresty/headers-more-nginx-module
git clone https://github.com/yaoweibin/nginx_upstream_check_module
#wget https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz && tar xzvf pcre-8.43.tar.gz
wget https://github.com/tempnana/Nginx/raw/main/pcre-8.45.tar.gz && tar xzvf pcre-8.45.tar.gz
#wget https://www.zlib.net/zlib-1.2.12.tar.gz && tar xzvf zlib-1.2.12.tar.gz
wget https://github.com/tempnana/Nginx/raw/main/zlib-1.2.12.tar.gz && tar xzvf zlib-1.2.12.tar.gz
wget https://nginx.org/download/nginx-1.20.1.tar.gz && tar zxvf nginx-1.20.1.tar.gz
#wget https://www.openssl.org/source/openssl-1.1.1d.tar.gz && tar xzvf openssl-1.1.1d.tar.gz
wget https://www.openssl.org/source/openssl-1.1.1o.tar.gz && tar xzvf openssl-1.1.1o.tar.gz
#replace-filter-nginx-module
git clone https://github.com/openresty/sregex
git clone https://github.com/openresty/replace-filter-nginx-module
#make install sregex
cd /root/nginx/sregex
echo 'Waiting make install sregex...'
make
sleep 5s
make install
if [ ! -f "libsregex.so.0" ];then
  echo "No libsregex.so.0 file"
  exit
fi
ls
#ldd $(which /usr/sbin/nginx)
cp /root/nginx/sregex/libsregex.so.0 /lib/x86_64-linux-gnu/
#mkdir
# mkdir -p /usr/lib/nginx/modules /var/log/nginx /var/cache/nginx /etc/nginx/vhost /etc/nginx/html
cd /root/nginx/nginx-1.20.1
#make install
patch -p1 <  /root/nginx/nginx_upstream_check_module/check_1.20.1+.patch
./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-pcre=/root/nginx/pcre-8.45 --with-pcre-jit --with-zlib=/root/nginx/zlib-1.2.12 --with-openssl=/root/nginx/openssl-1.1.1o --with-openssl-opt=no-nextprotoneg --with-debug --add-module=/root/nginx/ngx_cache_purge --add-module=/root/nginx/ngx_http_substitutions_filter_module --add-module=/root/nginx/nginx_upstream_check_module --add-module=/root/nginx/headers-more-nginx-module --add-module=/root/nginx/replace-filter-nginx-module
sleep 2s
make
sleep 2s
make install
nginx -V
service nginx restart
netstat -nltp
