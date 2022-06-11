Instructions at:
`https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#dependencies`

1. Download all the files to the downloads folder for updates. Update version numbers in Dockerfile as necessary.
2. Run the "build_nginx_container.sh" script

Can export it to a tar
`sudo docker save -o nginx_trm.tar nginx_trm`
Can import the tar somewhere else with a load
`sudo docker load < nginx_trm.tar`