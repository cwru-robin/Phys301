import serial
import numpy as np
import csv
import time

device=serial.Serial("/dev/ttyUSB0",230400)
distance0=1
distance1=10e5



##mm

f= open("data/counttrial1.csv","w")
writer=csv.writer(f)
for i in range(0,100000):

    line = device.readline()
    nice = line.strip((b'\n')).split(b',')
    print(i, line)
    nice.append(i)
    writer.writerow(nice)
    time.sleep(.4)

f.close
