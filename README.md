# TemperatureToSound
##about
-----

### Ruby scripts and Pure data patche for detection temperature of the room and air conditioner settings by the sound.

### You can hear difference between the temperature of the room and air conditioning settings by modulation.

### i2c.rb

#### capture air temperature (using i2c and ADT7410)

#### convert to sound signal(temperature to frequency)

#### send frequency value by OSC

### lirc.rb

#### capture air conditioner remote control signal (using lirc and OSRB38C9AA)

#### convert to sound signal(off/on signal to volume, temperature signal to frequency)

#### send volume and frequency value by OSC

### output.pd

#### receive volume and frequency value by OSC

#### volume and frequency control

#### output sinewave

##usage
-----

### temperature to sound

### pd-extended -nogui -noadc -alsa output.pd & ruby i2c.rb

### air conditioner setting to sound

### pd-extended -nogui -noadc -alsa output.pd & mode2 -d /dev/lirc0 \> ./tmp/tmp & ruby lirc.rb
