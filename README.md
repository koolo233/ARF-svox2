# ARF: Artistic Radiance Fields

Project page: <https://www.cs.cornell.edu/projects/arf/>

![](./resources/ARF.mov)


Citation:
```
@misc{zhang2022arf,
      title={ARF: Artistic Radiance Fields}, 
      author={Kai Zhang and Nick Kolkin and Sai Bi and Fujun Luan and Zexiang Xu and Eli Shechtman and Noah Snavely},
      year={2022},
      booktitle={ECCV},
}
```

## TODO List

- [x] llff - trex - 0~140 styles
- [x] llff - horns - 0~140 styles
- [ ] llff - flower - 0~140 styles
- [ ] llff - fern - 0~140 styles
- [ ] llff - orchids - 0~140 styles
- [ ] llff - fortress - 0~140 styles
- [ ] llff - leaves - 0~140 styles
- [ ] llff - room - 0~140 styles

## Quick start


### Install environment

```commandline
conda create -n arf python=3.8
conda activate arf

# install torch
pip install torch==1.13.0+cu117 torchvision==0.14.0+cu117 torchaudio==0.13.0 --extra-index-url https://download.pytorch.org/whl/cu117

# install svox2
# make sure CUDA >= 11
git clone git@github.com:sxyu/svox2.git
cd svox2
pip install -e . --verbose

# install other packages
pip install -r requirements.txt
```

### Optimize artistic radiance fields
```bash
cd opt && . ./try_{llff/tnt/custom}.sh [scene_name] [style_id]
```
* Select ```{llff/tnt/custom}``` according to your data type. For example, use ```llff``` for ```flower``` scene, ```tnt``` for ```Playground``` scene, and ```custom``` for ```lego``` scene. 
* ```[style_id].jpg``` is the style image inside ```./data/styles```. For example, ```14.jpg``` is the starry night painting.
* Note that a photorealistic radiance field will first be reconstructed for each scene, if it doesn't exist on disk. This will take extra time.

### Check results
The optimized artistic radiance field is inside ```opt/ckpt_arf/[scene_name]_[style_id]```, while the photorealistic one is inside ```opt/ckpt_svox2/[scene_name]```.

### Custom data
Please follow the steps on [Plenoxel](https://github.com/sxyu/svox2)  to prepare your own custom data.

## ARF with other NeRF variants
* [ARF-TensoRF](): to be released; stay tuned.
* [ARF-NeRF](): to be released; stay tuned.

## Acknowledgement:
We would like to thank [Plenoxel](https://github.com/sxyu/svox2) authors for open-sourcing their implementations.
