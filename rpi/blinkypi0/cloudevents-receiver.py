#!/usr/bin/env python3
# copy to /usr/local/bin/cloudevents-receiver and use with cloudevents.service

import blinkt
import colorsys
import json
import random
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
    'status'
]
brightness = 0.1
blinkt.set_brightness(brightness)
blinkt.set_clear_on_exit()
blinkt.clear()
blinkt.show()

@app.route("/", methods=["POST"])
def home():
    event = from_http(request.headers, request.get_data())
    if event['type'] == 'dev.pulsifer.blinky.request':
        action = event.data['action']
        if action in actions:
            global activeThread
            if action == 'blink':
                stop_running_thread()
                activeThread = threading.Thread(name="blink", target=blink, args=(lock,stop,))
                activeThread.start()
            elif action == 'rainbow':
                stop_running_thread()
                activeThread = threading.Thread(name="rainbow", target=rainbow, args=(lock,stop,))
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
    blinkt.set_brightness(brightness)
    blinkt.show()

def darken():
    global brightness
    if brightness > 0.1: brightness -= 0.1
    if brightness < 0.1: brightness = 0.1
    blinkt.set_brightness(brightness)
    blinkt.show()

def clear():
    stop_running_thread()
    blinkt.clear()
    blinkt.show()

def status():
    pass

def blink(lock, stop):
    with lock:
        while not stop.is_set():
            for i in range(blinkt.NUM_PIXELS):
                blinkt.set_pixel(i, random.randint(0, 255), random.randint(0, 255), random.randint(0, 255))
            blinkt.show()
            time.sleep(0.1)
        blinkt.clear()

def rainbow(lock, stop):
    spacing = 360.0 / 16.0
    with lock:
        while not stop.is_set():
            hue = int(time.time() * 100) % 360
            for x in range(blinkt.NUM_PIXELS):
                offset = x * spacing
                h = ((hue + offset) % 360) / 360.0
                r, g, b = [int(c * 255) for c in colorsys.hsv_to_rgb(h, 1.0, 1.0)]
                blinkt.set_pixel(x, r, g, b)
            blinkt.show()
            time.sleep(0.001)
        blinkt.clear()

if __name__ == "__main__":
    app.run(port=3000, host="0.0.0.0")
