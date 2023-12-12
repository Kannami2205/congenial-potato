
import pyaudio
import struct
import datetime
import math

def dropandfill(l, s):
    return '0' * (l - len(s[2:])) + s[2:]  # 用0补位

def time2wwvb(date_time, dt=datetime.timedelta(0)):
    '''
    将时间转换成WWVB时码。
    '''
def generate_wwvb_code(date_time):
    year_code = f'{date_time.year % 100:02b}'.zfill(8)
    day_code = f'{date_time.timetuple().tm_yday:09b}'
    hour_code = f'{date_time.hour:04b}'
    minute_code = f'{date_time.minute:06b}'

    # WWVB的时间格式包括年、天、小时、分钟
    wwvb_time_format = year_code + day_code + hour_code + minute_code

    # 生成WWVB的标记位和时间位
    wwvb_code = '2' + '0' * 9 + wwvb_time_format + '0' * (60 - len(wwvb_time_format) - 10)

    return wwvb_code 

dt = datetime.timedelta(hours=1)  # 偏移时间
samp_rate = 60000  # 将samp_rate修改为60 kHz
freq = 6000 * 2  # 适当调整频率
ttime = 60 # 适当调整采样时间
SAMPLE_LEN = samp_rate * ttime  # 60 seconds of cosine
value = ampl = 32725
div = samp_rate / freq / 2

# 打开声音输出流
p = pyaudio.PyAudio()
stream = p.open(format=8, channels=1, rate=samp_rate, output=True)

while True:
    current_time = datetime.datetime.utcnow()  # WWVB使用UTC时间
    print(current_time)
    wwvb_code = generate_wwvb_code(current_time)

    for i in range(samp_rate * ttime):
        sec = (i // samp_rate) % 60
        bit = wwvb_code[sec]

        if bit == '2':  # 标记位，0.8秒的脉冲
            pulse_duration = 0.8 * samp_rate
        elif bit == '1':  # 1位，0.5秒的脉冲
            pulse_duration = 0.5 * samp_rate
        else:  # 0位，0.2秒的脉冲
            pulse_duration = 0.2 * samp_rate

        if i % samp_rate < pulse_duration:
            value = int(ampl * math.cos(math.pi / float(div) * float(i)))
        else:
            value = 0

        packed_value = struct.pack('h', value)
        stream.write(packed_value)