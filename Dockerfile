FROM hypriot/rpi-ruby
MAINTAINER matt@tuma.cc

COPY . /home_automation/
WORKDIR /home_automation/


RUN apt-get update 
RUN apt-get install -y apt-utils ruby-dev libgmp-dev build-essential
RUN bundle install

CMD ["ruby", "test.rb"]
