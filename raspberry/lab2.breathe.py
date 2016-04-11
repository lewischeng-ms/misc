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

def breathe(pin):
  # Second param: frequency
  # The higher the smoother 
  pwm = GPIO.PWM(pin, 80)
  pwm.start(0)

  for i in range(0, 3):
    for j in xrange(0, 101, 1):
      pwm.ChangeDutyCycle(j)
      time.sleep(0.02)
    for j in xrange(100, -1, -1):
      pwm.ChangeDutyCycle(j)
      time.sleep(0.02)

  pwm.stop()

def breathe_all():
  for pin in pins:
    breathe(pin)

def destroy():
  for pin in pins:
    GPIO.output(pin, False)
    GPIO.setup(pin, GPIO.IN)

if __name__ == '__main__':
  setup()
  try:
    breathe_all()
  except KeyboardInterrupt:
    destroy()
  finally:
    GPIO.cleanup()
