Linda Arduino IR::Remote
========================
controll [Arduino IR Remote](https://github.com/shokai/arduino_ir_remote) via RocketIO::Linda

* https://github.com/shokai/linda-arduino-ir-remote
* write tuple ["ir_remote", "writables", ["on", "off", "tv_ch1", "tv_ch2"]] on Linda connnect.
* watch tuple ["ir_remote", "write", command] to write Arduino IR Remote.
* write tuple ["ir_remote", "sensor", 32.5] and ["ir_remote", "sensors", [88,0,2,50,243,9]] every 5 seconds.


Dependencies
------------
- [Arduino IR Remote](https://github.com/shokai/arduino_ir_remote)
- Ruby 1.8.7 ~ 2.0.0
- EventMachine
- [LindaBase](https://github.com/shokai/linda-base)


Install Dependencies
--------------------

Install Rubygems

    % gem install bundler foreman
    % bundle install


Run
---

set ENV var "LINDA_BASE" and "LINDA_SPACE"

    % export LINDA_BASE=http://linda.example.com
    % export LINDA_SPACE=test
    % bundle exec ruby linda-arduino-ir-remote.rb


oneline

    % LINDA_BASE=http://linda.example.com LINDA_SPACE=test  bundle exec ruby linda-arduino-ir-remote.rb


Install as Service
------------------

for launchd (Mac OSX)

    % sudo foreman export launchd /Library/LaunchDaemons/ --app linda-arduino-ir -u `whoami`
    % sudo launchctl load -w /Library/LaunchDaemons/linda-arduino-ir-main-1.plist

for upstart (Ubuntu)

    % sudo foreman export upstart /etc/init/ --app linda-arduino-ir -d `pwd` -u `whoami`
    % sudo service linda-arduino-ir start
