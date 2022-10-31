# Container contents:
- nginx base
- certbot
- cron (for certbot renewal)

To deploy, `bash build_and_push.sh TAG`
(tag should just be "alpine")

Todo
- [x] Remove custom build. The nginx container on docker does it better! Just go from that and add certbot.
