import serial
import numpy as np


device=serial.Serial("/dev/ttyUSB1",230400)
distance0=3
distance1=5
##mm
arange=np.arange(distance0,distance1,0.2)
f= open("data/trail1.txt","w")
for i in arange:
    print("Move Slit to: ",str(i))
    f.write(str(i))
    f.write('\n')


    input("Press enter to continue")


    for i in range(10):
        device.reset_input_buffer()

        print(i)
        f.write(str(device.readline()))
        f.write('\n')
    f.write('________\n')

f.close
