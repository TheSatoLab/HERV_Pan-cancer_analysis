#!/usr/bin/env python

import sys
import numpy as np
argvs = sys.argv

count_f = open(argvs[1])

line1 = count_f.next().strip()

count_d = {}
for line in count_f:
  line = line.strip().split(",")
  gene = line[0]
  count_l = line[1:]
  count_l = [int(j) for j in count_l]
  count_a = np.array(count_l)
  if (gene[:3] == "ENS"):
    count_d[gene] = count_a
  else:
    HERV = gene.split("|")[1]
    if HERV not in count_d:
      count_d[HERV] = np.array([0]*len(count_l))
    count_d[HERV] += count_a

print line1
for gene in sorted(count_d):
  count_l = list(count_d[gene])
  print gene + "," + ",".join([str(i) for i in count_l])
