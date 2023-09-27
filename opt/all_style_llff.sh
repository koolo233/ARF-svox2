SCENE=$2

for ((style_id=1; style_id<=140; style_id++))
do
  ckpt_svox2=ckpt_svox2/llff/${SCENE}
  ckpt_arf=ckpt_arf/llff/${SCENE}_${style_id}
  data_dir=../data/llff/${SCENE}
  style_img=../data/styles/${style_id}.jpg

  if [[ ! -f "${ckpt_svox2}/ckpt.npz" ]]; then
      python opt.py -t ${ckpt_svox2} ${data_dir} \
                      -c configs/llff.json
  fi

  if [[ ! -f "${ckpt_arf}/ckpt.npz" ]]; then
      python opt_style.py -t ${ckpt_arf} ${data_dir} \
                  -c configs/llff_fixgeom.json \
                  --init_ckpt ${ckpt_svox2}/ckpt.npz \
                  --style ${style_img} \
                  --mse_num_epoches 2 --nnfm_num_epoches 10 \
                  --content_weight 1e-3
  fi

  python render_imgs.py ${ckpt_arf}/ckpt.npz ${data_dir} --render_path
done
