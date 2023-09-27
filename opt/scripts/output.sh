#!/bin/bash

usage() {
  echo "Usage: ${0}
        [-i|--gpu_ids]
        [-d|--dataset]
        [-s|--style_id]
        [--data_type]
        " 1>&2
  exit 1
}

while [[ $# -gt 0 ]];do
  key=${1}
  case ${key} in
    -i|--gpu_ids)
      GPU_IDS=${2}
      shift 2
      ;;
    -d|--dataset)
      SCENE=${2}
      shift 2
      ;;
    -s|--style_id)
      STYLE=${2}
      shift 2
      ;;
    --data_type)
      DATA_TYPE=${2}
      shift 2
      ;;
    *)
      usage
      shift
      ;;
  esac
done

data_type=${DATA_TYPE:-"llff"}
ckpt_svox2=ckpt_svox2/${data_type}/${SCENE}
ckpt_arf=ckpt_arf/${data_type}/${SCENE}_${STYLE}
data_dir=../data/${data_type}/${SCENE}
style_img=../data/styles/${STYLE}.jpg


style_ids="92 130 119 73 45 3 5 101 51 34"

echo "###############################################"
for style_id in ${style_ids}
do
  echo "-----------------------------------------------"
  echo "Style_id: $style_id"
  echo "Begin training of NeRF..."
  CUDA_VISIBLE_DEVICES=${GPU_IDS} python train_style.py \
  --config configs/llff_style_${dataset}.txt \
  --datadir ./data/llff/${dataset} \
  --expname ${dataset} --ckpt ./ckpts/llff_${dataset}_style.th \
  --style_img ./data/styles/styles/${style_id}.jpg \
  --render_only 1 --render_train 0 --render_test 0 \
  --render_path 1 --chunk_size 1024 --rm_weight_mask_thre 0.0001
  echo "Done training of NeRF."
  echo "-----------------------------------------------"
done

CUDA_VISIBLE_DEVICES=${GPU_IDS} python render_imgs.py ${ckpt_arf}/ckpt.npz ${data_dir} --render_path