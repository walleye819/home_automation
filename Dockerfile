FROM walleye819/rpi-iot:latest
MAINTAINER matt@tuma.cc

COPY . /home_automation/
WORKDIR /home_automation/

CMD ["ruby", "run.rb"]
