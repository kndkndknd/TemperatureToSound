require 'osc-ruby'
require 'osc-ruby/em_server'
require 'fssm'
require './module.rb'

#fldr = '/Users/knd/bitbucket/temperature/lirc/'
fldr = '/home/pi/live_set/temperature/'


client = OSC::Client.new( 'localhost',8888)
client.send( OSC::Message.new( "/init" , 1))


FSSM.monitor(fldr + 'tmp/','**/*') do
  update do |base,file|
    hsh = update_action(base, file)
    unless hsh["temp"].nil? then
      hsh["freq"] = temp2freq(hsh["temp"])
      client.send( OSC::Message.new( "/switch" , hsh["swt"]))
      client.send( OSC::Message.new( "/temperature" , hsh["freq"]))
      p hsh
    end
  end
end

