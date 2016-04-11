import RPi.GPIO as GPIO
import time

# 14 - Blue
# 15 - Green
# 18 - Red
pins = [14, 15, 18]

def setup():
  # Use BCM numberings
  GPIO.setmode(GPIO.BCM)
  for pin in pins:
    GPIO.setup(pin, GPIO.OUT)
    GPIO.output(pin, False)

def flash(pin):
  for i in range(0, 5):
    GPIO.output(pin, True)
    time.sleep(0.5)
    GPIO.output(pin, False)
    time.sleep(0.5)

def flash_all():
  for pin in pins:
    flash(pin)

def destroy():
  for pin in pins:
    GPIO.output(pin, False)
    GPIO.setup(pin, GPIO.IN)

if __name__ == '__main__':
  setup()
  try:
    flash_all()
  except KeyboardInterrupt:
    destroy()
  finally:
    GPIO.cleanup()
