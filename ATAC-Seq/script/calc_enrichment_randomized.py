#!/usr/bin/env python

import sys, math, subprocess, re
import numpy as np
import scipy.stats as stats

argvs = sys.argv

bed1_f_name = argvs[1]
bed2_f_name = argvs[2]
g_size_f_name = argvs[3]
n_permut = int(argvs[4])


def countOnTFBS(F1_name,F2_name):
  Cmd = 'bedtools intersect -a \"%(f1_name)s\" -b \"%(f2_name)s\" -wa | sort | uniq | wc -l | cut -d \" \" -f 1' %{"f1_name":F1_name,"f2_name":F2_name} 
  Count = int(subprocess.check_output(Cmd, shell=True).strip())
  return Count


def countOnRandamizedTFBS(F1_name,F2_name,G_F_name):
  Cmd = 'bedtools shuffle -noOverlapping -i \"%(f1_name)s\" -g \"%(g_f_name)s\" | bedtools intersect -a "stdin" -b \"%(f2_name)s\" -wa | sort | uniq | wc -l | cut -d \" \" -f 1' %{"f1_name":F1_name,"f2_name":F2_name,"g_f_name":G_F_name}
  Count = int(subprocess.check_output(Cmd, shell=True).strip())
  return Count

def generateRandomCountList(F1_name,F2_name,G_F_name,N_permut):
  count_random_l = []  
  for i in range(n_permut):
    count_random = countOnRandamizedTFBS(bed1_f_name,bed2_f_name,g_size_f_name)
    count_random_l.append(count_random)
  return count_random_l

count_observed = countOnTFBS(bed1_f_name,bed2_f_name)

count_random_l = generateRandomCountList(bed1_f_name,bed2_f_name,g_size_f_name,n_permut)
mean_count_random = np.mean(count_random_l)
sd_count_random = np.std(count_random_l)

fe = count_observed / mean_count_random
z_score = (count_observed - mean_count_random) / sd_count_random
pval = stats.norm.sf(abs(z_score))*2
res_l = [count_observed,fe,z_score,pval]
print "\t".join(["count_observed","fold_enrichment","z_score","pvalue"])
print "\t".join([str(c) for c in res_l])
