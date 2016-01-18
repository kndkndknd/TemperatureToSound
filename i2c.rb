require 'i2c/device/adt7410'
require 'i2c/driver/i2c-dev'
require 'osc-ruby'
require 'osc-ruby/em_server'
require './module.rb'

device = I2CDevice::ADT7410.new(driver: I2CDevice::Driver::I2CDev.new('/dev/i2c-1'), address: 0x48)
client = OSC::Client.new( 'localhost',8888)
client.send( OSC::Message.new( "/init" , 1))
hsh = {}
hsh["swt"] = 1


while true do
  temp = device.calculate_temperature.round(1)
  hsh["freq"] = temp2freq(temp)
  p temp.to_s + "," + hsh["freq"].to_s
  client.send( OSC::Message.new( "/switch" , hsh["swt"]))
  client.send( OSC::Message.new( "/temperature" , hsh["freq"]))
  sleep 10
end
