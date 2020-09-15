#!/usr/bin/env python

import sys,re
argvs = sys.argv

d = {}
feature_l = []

i = 0
for f_name in argvs[1:]:
  file_Id = re.sub(r'.+\/([^\/]+)\.txt',r'\1',f_name)
  file_Id = re.sub(r'([^\/]+)\.txt',r'\1',file_Id)
  d[file_Id] = {}
  f = open(f_name)
  f.next()
  f.next()
  for line in f:
    feature,_,_,_,_,_,count = line.strip().split()
    d[file_Id][feature] = count
    if i == 0:
      feature_l.append(feature)
  i += 1

print "Feature," + ",".join(sorted(d))
for feature in feature_l:
  l = [feature]
  for file_Id in sorted(d):
    count = d[file_Id][feature]
    l.append(count)
  print ",".join(l)
