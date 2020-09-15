#!/usr/bin/env python

import sys,re
argvs = sys.argv

name_l = ["Assigned","Unassigned_Unmapped","Unassigned_MultiMapping","Unassigned_NoFeatures","Unassigned_Overlapping_Length","Unassigned_Ambiguity"]
res_d = {}
for f_name in argvs[1:]:
  file_Id = re.sub(r'.+\/(.+)\.txt.summary',r'\1',f_name)
  file_Id = re.sub(r'(.+)\.txt.summary',r'\1',file_Id)
  res_d[file_Id] = {}
  f = open(f_name)
  f.next()
  for line in f: 
    name,count = line.strip().split()
    if name in name_l:
      res_d[file_Id][name] = count

print "file_Id\t" + "\t".join(name_l)
for file_Id in res_d:
  l = [file_Id]
  if len(res_d[file_Id]) == len(name_l):
    for name in name_l:
      count = res_d[file_Id][name]
      l.append(count)
    print "\t".join(l)

