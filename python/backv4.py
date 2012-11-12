import os, time

source = ['/home/lewis/file1', '/home/lewis/fileN']

target_dir = '/var/backup'

today = target_dir + time.strftime('%Y%m%d')

now = time.strftime('%H%M%S')

# raw_input() always returns a string.
# input() treats input as an expression to evaluate.
comment = raw_input('Enter a comment --> ')
if len(comment) == 0:
	target = today + os.sep + now + '.tgz'
else:
	target = today + os.sep + now + '_' + \
		comment.replace(' ', '_') + '.tgz'

if not os.path.exists(today):
	os.mkdir(today)
	print 'Successfully created directory', today

tar_command = "tar zcvf '%s' %s" % (target, ' '.join(source))

if os.system(tar_command) == 0:
	print 'Successfully backup to', target
else:
	print 'Backup FAILED'