import serial
import numpy as np
import csv

device=serial.Serial("/dev/ttyUSB1",230400)
distance0=1
distance1=10e5



##mm

f= open("data/timetrial1.csv","w")
writer=csv.writer(f)
for i in range(0,1000000):

    line = device.readline()
    nice = line.strip((b'\n')).split(b',')
    print(line)
    nice.append(i)
    writer.writerow(nice)

f.close
