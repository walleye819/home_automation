FROM hypriot/rpi-ruby
MAINTAINER matt@tuma.cc

COPY . /home_automation/
WORKDIR /home_automation/

ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update 
RUN apt-get install -y apt-utils ruby-dev libgmp-dev build-essential
RUN bundle install

CMD ["ruby", "test.rb"]
