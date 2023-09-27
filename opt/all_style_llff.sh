#!/bin/bash

usage() {
  echo "Usage: ${0}
        [-i|--gpu_id]
        [-s|--scenes]
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
    -s|--scenes)
      SCENEs=${2}
      shift 2
      ;;
    *)
      usage
      shift
      ;;
  esac
done

datasets=${SCENEs:-"trex horns flower fern orchids fortress leaves room"}

for SCENE in ${datasets}
do
  for ((STYLE=0; STYLE<=140; STYLE++))
  do

    echo "-----------------------------------------------"
    echo "Style_id: ${STYLE}"
    echo "dataset: ${SCENE}"
    echo "Begin training of NeRF..."

    data_type=llff
    ckpt_svox2=ckpt_svox2/${data_type}/${SCENE}
    ckpt_arf=ckpt_arf/${data_type}/${SCENE}_${STYLE}
    data_dir=../data/${data_type}/${SCENE}
    style_img=../data/styles/${STYLE}.jpg

    if [[ ! -f "${ckpt_svox2}/ckpt.npz" ]]; then
        CUDA_VISIBLE_DEVICES=${GPU_ID} python opt.py -t ${ckpt_svox2} ${data_dir} \
                        -c configs/llff.json
    fi

    if [[ ! -f "${ckpt_arf}/ckpt.npz" ]]; then
        CUDA_VISIBLE_DEVICES=${GPU_ID} python opt_style.py -t ${ckpt_arf} ${data_dir} \
                    -c configs/llff_fixgeom.json \
                    --init_ckpt ${ckpt_svox2}/ckpt.npz \
                    --style ${style_img} \
                    --mse_num_epoches 2 --nnfm_num_epoches 10 \
                    --content_weight 1e-3
    fi

    CUDA_VISIBLE_DEVICES=${GPU_ID} python render_imgs.py ${ckpt_arf}/ckpt.npz ${data_dir} --render_path

    echo "Done training of NeRF."
    echo "-----------------------------------------------"
  done
done
