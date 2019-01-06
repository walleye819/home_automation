# home_automation

sudo docker build -t walleye819/iot:0.4  .

sudo docker push walleye819/iot

#### Running in foreground for troubleshooting:
sudo docker run -i -e lifx_token=XXX -t walleye819/iot:0.4

#### Running detached so will run in background:
sudo docker run -de lifx_token=XXX --restart unless-stopped -t walleye819/iot:0.4

https://sunrise-sunset.org/api

https://hub.docker.com/r/walleye819/iot

https://lifx.readme.io/
