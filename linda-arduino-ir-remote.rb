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
      _,_,cmd = tuple
      ir_remote.write ArduinoIrRemote::DATA[cmd] if cmd
    end
  end

  linda.io.on :disconnect do
    puts "RocketIO disconnected.."
  end
end
