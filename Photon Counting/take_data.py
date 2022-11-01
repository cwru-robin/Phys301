import serial
import numpy as np
import csv

device=serial.Serial("/dev/ttyUSB1",230400)
distance0=3
distance1=6

##mm
arange=np.arange(distance0,distance1,0.2)
f= open("data/trail1.csv","w")
writer=csv.writer(f)
for i in arange:
    print("Move Slit to: ",str(i))


    input("Press enter to continue")


    for a in range(10):
        device.reset_input_buffer()
        line=device.readline()
        nice= line.strip((b'\n')).split(b',')
        print(a)
        nice.append(i)
        writer.writerow(nice)

f.close
