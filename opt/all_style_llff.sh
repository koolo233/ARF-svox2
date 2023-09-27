#!/bin/bash

usage() {
  echo "Usage: ${0}
        [-i|--gpu_id]
        " 1>&2
  exit 1
}

while [[ $# -gt 0 ]];do
  key=${1}
  case ${key} in
    -i|--gpu_id)
      GPU_ID=${2}
      shift 2
      ;;
    *)
      usage
      shift
      ;;
  esac
done

datasets=${DATASET:-"trex horns flower fern orchids fortress leaves room"}

for dataset in ${datasets}
do
  for ((style_id=1; style_id<=140; style_id++))
  do

    echo "-----------------------------------------------"
    echo "Style_id: ${style_id}"
    echo "dataset: ${dataset}"
    echo "Begin training of NeRF..."

    ckpt_svox2=ckpt_svox2/llff/${SCENE}
    ckpt_arf=ckpt_arf/llff/${SCENE}_${style_id}
    data_dir=../data/llff/${SCENE}
    style_img=../data/styles/${style_id}.jpg

    if [[ ! -f "${ckpt_svox2}/ckpt.npz" ]]; then
        CUDA_VISIBLE_DEVICES=${GPU_ID} python opt.py -t ${ckpt_svox2} ${data_dir} -c configs/llff.json
    fi

    if [[ ! -f "${ckpt_arf}/ckpt.npz" ]]; then
        CUDA_VISIBLE_DEVICES=${GPU_ID} python opt_style.py -t ${ckpt_arf} ${data_dir} \
                    -c configs/llff_fixgeom.json \
                    --init_ckpt ${ckpt_svox2}/ckpt.npz \
                    --style ${style_img} \
                    --mse_num_epoches 2 --nnfm_num_epoches 10 \
                    --content_weight 1e-3
    fi

    python render_imgs.py ${ckpt_arf}/ckpt.npz ${data_dir} --render_path

    echo "Done training of NeRF."
    echo "-----------------------------------------------"
  done
done
