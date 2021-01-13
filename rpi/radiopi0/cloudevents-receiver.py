#!/usr/bin/env python3
# copy to /usr/local/bin/cloudevents-receiver and use with cloudevents.service

import phatbeat
import colorsys
import json
import random
import subprocess
import threading
import time
from flask import Flask, request
from cloudevents.http import from_http

app = Flask(__name__)
stop = threading.Event()
lock = threading.Lock()
activeThread = threading.Thread(name="default", target=(), args=(lock,stop,))
actions = [
    'blink',
    'brighten',
    'clear',
    'darken',
    'rainbow',
    'status',
    'wow'
]
brightness = 0.1
phatbeat.set_brightness(0.1)
phatbeat.set_clear_on_exit()
phatbeat.clear()
phatbeat.show()

@app.route("/", methods=["POST"])
def home():
    event = from_http(request.headers, request.get_data())
    if event['type'] == 'dev.pulsifer.radio.request':
        action = event.data['action']
        if action in actions:
            global activeThread
            if action == 'blink':
                stop_running_thread()
                activeThread = threading.Thread(name="blinky", target=blink, args=(lock,stop,))
                activeThread.start()
            elif action == 'rainbow':
                stop_running_thread()
                activeThread = threading.Thread(name="rainbow", target=rainbow, args=(lock,stop,))
                activeThread.start()
            elif action == 'wow':
                stop_running_thread()
                activeThread = threading.Thread(name="wow", target=wow, args=(lock,stop,))
                activeThread.start()
            else: eval(action)()
            return json.dumps({
                'action': activeThread.getName(),
                'alive': activeThread.is_alive(),
                'brightness': brightness,
            })
        return "", 501
    return "", 400

def stop_running_thread():
    if activeThread.isAlive():
        stop.set()
        activeThread.join()
        stop.clear()

def brighten():
    global brightness
    if brightness < 1: brightness += 0.1
    if brightness > 1: brightness = 1
    phatbeat.set_brightness(brightness)
    phatbeat.show()

def darken():
    global brightness
    if brightness > 0.1: brightness -= 0.1
    if brightness < 0.1: brightness = 0.1
    phatbeat.set_brightness(brightness)
    phatbeat.show()

def clear():
    stop_running_thread()
    phatbeat.clear()
    phatbeat.show()

def status():
    pass

def wow(lock, stop):
    with lock:
        if not stop.is_set():
            subprocess.Popen(['/usr/bin/play', '/home/pi/wow.mp3'])

def blink(lock, stop):
    with lock:
        while not stop.is_set():
            for i in range(phatbeat.CHANNEL_PIXELS):
                phatbeat.set_pixel(i, random.randint(0, 255), random.randint(0, 255), random.randint(0, 255), channel=random.randint(0,1))
            phatbeat.show()
            time.sleep(0.01)

def rainbow(lock, stop):
    SPEED = 200
    BRIGHTNESS = 64
    SPREAD = 20
    with lock:
        while not stop.is_set():
            for x in range(phatbeat.CHANNEL_PIXELS):
                h = (time.time() * SPEED + (x * SPREAD)) % 360 / 360.0
                r, g, b = [int(c*BRIGHTNESS) for c in colorsys.hsv_to_rgb(h, 1.0, 1.0)]
                phatbeat.set_pixel(x, r, g, b, channel=0)
                phatbeat.set_pixel(x, r, g, b, channel=1)
            phatbeat.show()
            time.sleep(0.001)

if __name__ == "__main__":
    app.run(port=3000, host="0.0.0.0")
