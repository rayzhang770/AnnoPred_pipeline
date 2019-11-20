import argparse
import numpy as np

parser = argparse.ArgumentParser(description='Cross validation results summary')
parser.add_argument('-i', type=str, help='Prefix of cross validation results')
parser.add_argument('-r', type=str, help='P range')
parser.add_argument('-K', type=int, help='Number of folds')
args = parser.parse_args()

pre = args.i
pv = args.r
K = args.K
pv = pv.split(" ")

res_mat = np.empty([len(pv), K])
for k in range(1, K + 1):
    for i in range(len(pv)):
        r_list = []
        for j in ["_h2_non_inf_auc_", "_pT_non_inf_auc_"]:
            f = open(pre + str(k) + j + pv[i] + ".txt", 'r')
            r = float(f.read().split("\n")[-3].split(": ")[1])
            f.close()
            r_list.append(r)
        res_mat[i, k - 1] = max(r_list)
res_mean = res_mat.mean(axis = 1)
best_p = pv[list(res_mean).index(res_mean.max())]
print "Best AUC is {}, and the best p is {}.\n".format(res_mean.max(), best_p)
