#!/usr/bin/env python

import argparse
import numpy as np

parser = argparse.ArgumentParser()
parser.add_argument('--gs_f', help='geneSet files',nargs="+",type=file)
parser.add_argument('--gsea_f', help='GSEA files',nargs="+",type=file)
parser.add_argument('--corr_f', help='correlation file',type=file)
parser.add_argument('--gs_category', help='geneSet category name',nargs="+")
parser.add_argument('--res_num', help='# of rows in result',type=int)
parser.add_argument('--thresh', help='threshold',type=float)


args = parser.parse_args()

gs_category_l = args.gs_category
gs_f_l = args.gs_f
gsea_f_l = args.gsea_f
corr_f = args.corr_f
res_num = args.res_num
thresh = args.thresh


def jaccard(x, y):
    """
    Jaccard index
    Jaccard similarity coefficient
    https://en.wikipedia.org/wiki/Jaccard_index
    """
    x = frozenset(x)
    y = frozenset(y)
    return len(x & y) / float(len(x | y))

def simpson(x, y):
    """
    overlap coefficient
    Szymkiewicz-Simpson coefficient)
    https://en.wikipedia.org/wiki/Overlap_coefficient
    """
    x = frozenset(x)
    y = frozenset(y)
    return len(x & y) / float(min(map(len, (x, y))))





corr_f.next()
all_ens_Id_l = []
for line in corr_f:
  ens_Id = line.strip().split()[0]
  all_ens_Id_l.append(ens_Id)
all_ens_Id_s = set(all_ens_Id_l)

gs_d = {}
for i in range(len(gs_category_l)):
  gs_category_name = gs_category_l[i]
  gs_f = gs_f_l[i]
  gs_f.next()
  for line in gs_f:
    gs_name,ens_Id,symbol = line.strip().split()
    t = (gs_category_name,gs_name)
    if t not in gs_d:
      gs_d[t] = []
    if ens_Id in all_ens_Id_s:
      gs_d[t].append(ens_Id)

#print gs_d

gsea_d = {}
gsea_values_d = {}
for i in range(len(gs_category_l)):
  gs_category_name = gs_category_l[i]
  gsea_f = gsea_f_l[i]
  project_Id_l = gsea_f.next().strip().split()[1:]
  for line in gsea_f:
    line = line.strip().split("\t")
    gs_name = line[0]
    values = [float(c) for c in line[1:]]
    median = np.mean(values)
    t = (gs_category_name,gs_name)
    gsea_d[t] = median
    gsea_values_d[t] = values

i = 0
for t, median in sorted(gsea_d.items(), key=lambda x: x[1],reverse=True):
  gs_category_name,gs_name = t
  if i == 0:
    res_positive_l = [t]
  else:
    if len(res_positive_l) < res_num:
      sim_l = []
      for high_t in res_positive_l:
        t_ens_Id_l = gs_d[t]
        high_t_ens_Id_l = gs_d[high_t]
        sim = simpson(t_ens_Id_l,high_t_ens_Id_l)
        sim_l.append(sim)
      if max(sim_l) < thresh:
        res_positive_l.append(t)
  i += 1

i = 0
for t, median in sorted(gsea_d.items(), key=lambda x: x[1]):
  gs_category_name,gs_name = t
  if i == 0:
    res_negative_l = [t]
  else:
    if len(res_negative_l) < res_num:
      sim_l = []
      for high_t in res_negative_l:
        t_ens_Id_l = gs_d[t]
        high_t_ens_Id_l = gs_d[high_t]
        sim = simpson(t_ens_Id_l,high_t_ens_Id_l)
        sim_l.append(sim)
      if max(sim_l) < thresh:
        res_negative_l.append(t)
  i += 1

res_l = res_positive_l + res_negative_l

print "Category\tGeneSet\tMedian" + "\t" + "\t".join(project_Id_l)
for t in res_l:
  median = gsea_d[t]
  values = gsea_values_d[t]
  res_l = list(t) + [median] + values
  print "\t".join([str(c) for c in res_l])

