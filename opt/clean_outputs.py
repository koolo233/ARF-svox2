import os
from tqdm import tqdm


if __name__ == "__main__":

    # delete non-useful files in output folders
    output_root = './ckpt_arf/llff'

    # all subfolders
    subfolders = [f.path for f in os.scandir(output_root) if f.is_dir()]

    # delete file in each sub folders
    delete_file_list = [
        "ckpt.npz",
        "logim_0.png",
        "logim_1.png",
        "logim_2.png",
        "logim_3.png",
        "logim_4.png",
        "logim_5.png",
        "logim_6.png",
        "logim_7.png",
        "logim_8.png",
        "logim_9.png",
        "logim_10.png",
        "logim_11.png",
        "logim_12_final.png",
        "opt_frozen.py",
        "test_renders_path.mp4",
    ]
    for subfolder in tqdm(subfolders):
        for delete_file in delete_file_list:
            delete_file_path = os.path.join(subfolder, delete_file)
            if os.path.exists(delete_file_path):
                os.remove(delete_file_path)
