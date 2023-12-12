
import pyaudio
import struct
import datetime
import math

def dropandfill(l, s):
    return '0' * (l - len(s[2:])) + s[2:]  # Replace with 0

def time2wwvb(date_time, dt=datetime.timedelta(0)):
    '''
    Convert local time to WWVB
    '''
def generate_wwvb_code(date_time):
    year_code = f'{date_time.year % 100:02b}'.zfill(8)
    day_code = f'{date_time.timetuple().tm_yday:09b}'
    hour_code = f'{date_time.hour:04b}'
    minute_code = f'{date_time.minute:06b}'

    # WWVBformat
    wwvb_time_format = year_code + day_code + hour_code + minute_code

    # Generate WWVBtime bit
    wwvb_code = '2' + '0' * 9 + wwvb_time_format + '0' * (60 - len(wwvb_time_format) - 10)

    return wwvb_code 

dt = datetime.timedelta(hours=1)  # shift rate 
samp_rate = 60000  # WWVB samp_rate is 60 kHz
freq = 6000 * 2  # 5 division frequency
ttime = 60 # WWVB 1 frame = 60 sec 
SAMPLE_LEN = samp_rate * ttime  # 60 seconds of cosine
value = ampl = 32725
div = samp_rate / freq / 2

# audio output 
p = pyaudio.PyAudio()
stream = p.open(format=8, channels=1, rate=samp_rate, output=True)

while True:
    current_time = datetime.datetime.utcnow()  # WWVB use utc time 
    print(current_time)
    wwvb_code = generate_wwvb_code(current_time)

    for i in range(samp_rate * ttime):
        sec = (i // samp_rate) % 60
        bit = wwvb_code[sec]

        if bit == '2':  # mark bit for 0.8 sec pulse 
            pulse_duration = 0.8 * samp_rate
        elif bit == '1':  # 1 bit ，0.5 sec pulse 
            pulse_duration = 0.5 * samp_rate
        else:  # 0 bit ，0.2 sec pulse 
             pulse_duration = 0.2 * samp_rate

        if i % samp_rate < pulse_duration:
            value = int(ampl * math.cos(math.pi / float(div) * float(i)))
        else:
            value = 0

        packed_value = struct.pack('h', value)
        stream.write(packed_value)
