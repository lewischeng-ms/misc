# cap.py - Capitalize an English passage
# This example illustrates the simplest application of state machine.
# Scene: We want to make the first word capitalized of every sentence
#        in a passage.

class State (object):
	def setMappedChar(self, c):
		self.c = c

	def getMappedChar(self):
		return self.c

	def setNextState(self, s):
		self.s = s

	def keepCurrentState(self):
		self.s = self

	def getNextState(self):
		return self.s

class BeforeSentenceState (State):
	'''We are ahead of a passage or
	   behind a full stop of a sentence but before the next one'''
	def transit(self, c):
		if c.isalpha():
			self.setMappedChar(c.upper())
			self.setNextState(InSentenceState())
		else:
			self.setMappedChar(c)
			self.keepCurrentState()

class InSentenceState (State):
	'''We are within a sentence'''
	def transit(self, c):
		if c == '.':
			self.setMappedChar(c)
			self.setNextState(BeforeSentenceState())
		else:
			self.setMappedChar(c)
			self.keepCurrentState()

class Capitalizer (object):
	def process(self, text):
		result = ''
		currentState = BeforeSentenceState()

		for c in text:
			currentState.transit(c)
			result += currentState.getMappedChar()
			currentState = currentState.getNextState()

		return result
		
cap = Capitalizer()
print cap.process("""apple device owners can run official apps for Google Maps, \
Google Search, Gmail, Google's Chrome browser, Google Drive and more. \
they can get Microsoft-written apps for its Bing search service, \
its SkyDrive cloud-storage service, its OneNote note-taking service and more. \
and they can get a host of Amazon's apps, including several apps for Amazon's \
online store and apps for Amazon's cloud-based video and music steaming services.""")