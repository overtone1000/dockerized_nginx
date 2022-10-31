# Container contents:
- alpine base
- nginx compiled with openssl, pcre, and zlib
- certbot
- cron (for certbot renewal)

To build, download the .tar.gz files for nginx, openssl, pcre, and zlib to the `downloads` directory.

```
wget http://nginx.org/download/nginx-1.23.2.tar.gz && \
wget https://www.openssl.org/source/openssl-3.0.5.tar.gz && \
wget https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.40/pcre2-10.40.tar.gz && \
wget https://zlib.net/zlib-1.2.13.tar.gz
```

To deploy, `bash build_and_push.sh TAG`
Tags are nginx-alpine-VERSION and nginx-ubuntu-VERSION
