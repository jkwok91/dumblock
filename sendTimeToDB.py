#so the purpose of this is to send the timeestamp to a db. or some js shit online. whenever the button is pressed

import datetime, os
import RPi.GPIO as GPIO
from firebase import firebase
os.environ['TZ'] = 'US/Pacific'

# setup gpio mode
GPIO.setmode(GPIO.BCM)
# and pins
GPIO.setup(4, GPIO.IN, pull_up_down = GPIO.PUD_DOWN) # this is important cuz we using a switch and there can be current trapped in a place when a switch is turned off

# set up firebase
myAppURL = "https://rasp-pi-timestamps.firebaseio.com/"
firebase = firebase.FirebaseApplication(myAppURL,None)

def log():
  prevValue = 0
  while True:
    currentValue = GPIO.input(4)
    #aravind did this
    if (currentValue != prevValue):
      # get time and send to db
      status = "LOCKED" if currentValue else "UNLOCKED"
      now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
      firebase.post('/updates', {".value":status,".priority": now})
      prevValue = currentValue

log()

GPIO.cleanup()
