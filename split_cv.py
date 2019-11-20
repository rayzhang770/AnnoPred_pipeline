from sklearn.model_selection import KFold
import argparse
import pandas as pd

parser = argparse.ArgumentParser(description='Train Test Split for Annopred')
parser.add_argument('-i', type=str, help='File for splitting')
parser.add_argument('-o', type=str, default='cv', help='Output prefix')
parser.add_argument('-k', type=int, default=5, help='Number of Folders')
args = parser.parse_args()
k = args.k
output_name = args.o
fam_name = args.i + ".fam"

fam = pd.read_table(fam_name, header=None, delimiter="\t")
fam_id = fam.iloc[:, 0:2]

kf = KFold(n_splits=k, random_state=None, shuffle=True)
i = 1

for train_index, test_index in kf.split(fam_id):
    fam_id.iloc[train_index, :].to_csv(output_name + "_train_" + str(i) + ".txt", sep = '\t', header=False, index=False)
    fam_id.iloc[test_index, :].to_csv(output_name + "_test_" + str(i) + ".txt", sep = '\t', header=False, index=False)
    i += 1
