require 'rubygems'
require 'eventmachine'
require 'em-rocketio-linda-client'
require 'arduino_ir_remote'
$stdout.sync = true

puts "#{ArduinoIrRemote::DATA.size} IR Data found"
p ArduinoIrRemote::DATA.keys

EM::run do
  ir_remote = ArduinoIrRemote.connect ENV['ARDUINO']
  url   = ENV["LINDA_BASE"]  || ARGV.shift || "http://localhost:5000"
  space = ENV["LINDA_SPACE"] || "test"
  puts "connecting.. #{url}"
  linda = EM::RocketIO::Linda::Client.new url
  ts = linda.tuplespace[space]

  linda.io.on :connect do
    puts "connect!! <#{linda.io.session}> (#{linda.io.type})"
    ts.write [:ir_remote, :writables, ArduinoIrRemote::DATA.keys]

    ts.watch [:ir_remote, :write] do |tuple|
      next unless tuple.size == 3
      _,_,cmd = tuple
      next unless cmd
      puts "write: #{cmd},#{ArduinoIrRemote::DATA[cmd]}"
      ir_remote.write ArduinoIrRemote::DATA[cmd]
      ts.write [:ir_remote, :write, cmd, :finish]
    end
  end

  linda.io.on :disconnect do
    puts "RocketIO disconnected.."
  end

  EM::add_periodic_timer 5 do
    temp = ir_remote.temp_sensor
    sensors = 0.upto(5).map{|i|
      ir_remote.analog_read i
    }
    puts "temperature: #{temp}"
    puts "sensors: #{sensors.inspect}"
    ts.write [:ir_remote, :temperature, temp]
    ts.write [:ir_remote, :sensors, sensors]
  end
end
