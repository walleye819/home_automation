FROM walleye819/rpi-iot:0.7
MAINTAINER matt@tuma.cc

COPY . /home_automation/
WORKDIR /home_automation/

CMD ["ruby", "run.rb"]
