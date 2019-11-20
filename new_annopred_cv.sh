module load python/3.6
source activate bios2.7

cd /fs/project/PAS1501/YimingTan/try_annopred/AnnoPred/

plink="/fs/project/PAS1501/software/plink1.9/plink"
anno_path="/fs/project/PAS1501/YimingTan/try_annopred/AnnoPred/"
o_path="/fs/project/PAS1501/ShengyangZhang/"

N_sample=69033
annotation_flag="tier3"

cv_path="/fs/project/PAS1501/ShengyangZhang/allcv"
mkdir $cv_path
gt_cv=$cv_path"/cv"
individual_gt_path=$anno_path"test_data/test"

k=5
python /fs/project/PAS1501/ShengyangZhang/AnnoPred/split_cv.py \
	-i $individual_gt_path \
	-k $k \
	-o $gt_cv

for i in $(echo $gt_cv"_t*")
do
	$plink --bfile $individual_gt_path --keep $i --make-bed --out $(echo $i | cut -d . -f1)
done

mkdir $o_path$annotation_flag ## save results by annotation tiers
tmp_path=$o_path$annotation_flag"/tmp_files"
results_output=$o_path$annotation_flag"/res_output"
coord=$tmp_path"/coord"

mkdir $tmp_path
mkdir $results_output

## could be paralellized
for((i=1;i<=$k;i++))
do
	for p in 1.0 0.3
	do
		python $anno_path"AnnoPred.py"\
	  		--sumstats=$anno_path"test_data/GWAS_sumstats.txt"\
	  		--ref_gt=$gt_cv"_train_"$i\
	  		--val_gt=$gt_cv"_test_"$i\
	  		--coord_out=$coord$i\
	  		--N_sample=$N_sample\
	  		--annotation_flag=$annotation_flag\
	  		--P=$p\
	  		--local_ld_prefix=$tmp_path"/local_ld_"$i\
	  		--out=$results_output"/cv"$i\
	  		--temp_dir=$tmp_path
	done
done


# python /fs/project/PAS1501/ShengyangZhang/AnnoPred/results_cv.py \
# 	-i $gt_cv \
#	-K $k \
#	-r "1.0 0.3"
