poem = '''\
Programming is fun
When the work is done
if you wanna make your work also fun:
	use Python!
'''

# write file
f = file('poem.txt', 'w')
f.write(poem)
f.close()

# read file
f = file('poem.txt')
while True:
	line = f.readline()
	if len(line) == 0:
		break
	print line,
f.close()
