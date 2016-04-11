import RPi.GPIO as GPIO
import time

R, G, B = 18, 15, 14

GPIO.setmode(GPIO.BCM)

GPIO.setup(R, GPIO.OUT)
GPIO.setup(G, GPIO.OUT)
GPIO.setup(B, GPIO.OUT)

GPIO.output(R, False)
GPIO.output(G, False)
GPIO.output(B, False)

# Frequency = 80
f = 80
pwmR = GPIO.PWM(R, f)
pwmG = GPIO.PWM(G, f)
pwmB = GPIO.PWM(B, f)

pwmR.start(0)
pwmG.start(0)
pwmB.start(0)

try:
  t = 1.0
  pwmR.ChangeDutyCycle(0)
  pwmG.ChangeDutyCycle(100)
  pwmB.ChangeDutyCycle(100)
  time.sleep(t)

  pwmR.ChangeDutyCycle(100)
  pwmG.ChangeDutyCycle(0)
  pwmB.ChangeDutyCycle(100)
  time.sleep(t)

  pwmR.ChangeDutyCycle(100)
  pwmG.ChangeDutyCycle(100)
  pwmB.ChangeDutyCycle(0)
  time.sleep(t)

  s = 10
  for r in xrange(0, 101, s):
    pwmR.ChangeDutyCycle(r)
    for g in xrange(0, 101, s):
      pwmG.ChangeDutyCycle(g)
      for b in xrange(0, 101, s):
        pwmB.ChangeDutyCycle(b)
        time.sleep(0.01)
except KeyboardInterrupt:
  pass

pwmR.stop()
pwmG.stop()
pwmB.stop()

GPIO.cleanup()
