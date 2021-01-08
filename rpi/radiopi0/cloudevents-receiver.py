#!/usr/bin/env python3
# copy to /usr/local/bin/cloudevents-receiver and use with cloudevents.service

import phatbeat
import colorsys
import logging
import random
import sys
import threading
import time
from flask import Flask, request
from cloudevents.http import from_http

app = Flask(__name__)

phatbeat.set_clear_on_exit()
phatbeat.set_brightness(1)

stop_actions = threading.Event()

@app.route("/", methods=["POST"])
def home():
    event = from_http(request.headers, request.get_data())
    try:
        if event['type'] == 'dev.pulsifer.radio.request':
            return process_event(event)
    except:
        return "", 400
    return "", 400

def process_event(event):
    actions = [
        'brighten',
        'clear',
        'darken',
        'rainbow',
    ]
    data = event.data
    try:
        action = data['action']            
    except:
        return "", 400

    if action in actions:
        thread_action(action)
        return "", 204
    return "", 501

def thread_action(action):
    if action in ['blink', 'rainbow']:
        while len(threading.enumerate()) > 2:
            app.logger.warning(f"{len(threading.enumerate())} threads, stopping others")
            stop_actions.set()
            for thread in threading.enumerate():
                if thread.getName() == "MainThread" or thread is threading.currentThread():
                    continue
                thread.join(timeout=5)
                app.logger.warning(f"{thread.getName()} ended")
        stop_actions.clear()
    worker = threading.Thread(name=action, target=eval(action), args=[stop_actions])
    worker.start()

def brighten(stop):
    phatbeat.set_brightness(1)
    phatbeat.show()

def darken(stop):
    phatbeat.set_brightness(0.1)
    phatbeat.show()

def clear(stop):
    stop_actions.set()
    phatbeat.clear()
    phatbeat.show()

def blink(stop):
    while not stop.is_set():
        for i in range(phatbeat.CHANNEL_PIXELS):
            phatbeat.set_pixel(i, random.randint(0, 255), random.randint(0, 255), random.randint(0, 255), channel=random.randint(0,1))
        phatbeat.show()
        time.sleep(0.01)
    phatbeat.clear()

def rainbow(stop):
    SPEED = 200
    BRIGHTNESS = 64
    SPREAD = 20
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
