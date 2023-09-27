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
      DATASET=${2}
      shift 2
      ;;
    -s|--style_id)
      STYLE_ID=${2}
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

#datasets=${DATASET:-"fern flower fortress horns leaves orchids room trex"}
datasets=${DATASET:-"trex horns flower fern orchids"}

#style_ids="5 45 92 51 73 92 119 "
style_ids="119"

echo "###############################################"

for style_id in ${style_ids}
do
  for dataset in ${datasets}
  do
    echo "-----------------------------------------------"
    echo "Style_id: $style_id"
    echo "dataset: $dataset"
    echo "Begin training of NeRF..."
    CUDA_VISIBLE_DEVICES=${GPU_IDS} . ./try_llff.sh ${DATA_TYPE:-"llff"} ${dataset} ${style_id}
    echo "Done training of NeRF."
    echo "-----------------------------------------------"
  done

done

echo "###############################################"
echo "Done outputs of all NeRFs."