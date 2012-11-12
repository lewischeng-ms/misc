# Can simply switch the two implementation 
import cPickle as p
#import pickle as p

dumpfile = 'dumpfile.data'

a = ['apple', 'mango', 'carrot']

# serialize
f = file(dumpfile, 'w')
p.dump(a, f)
f.close()

del a

# deserialize
f = file(dumpfile)
b = p.load(f)
print b