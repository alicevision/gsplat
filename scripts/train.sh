#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# =======================================
# Arguments default values
# =======================================
sfm_file=""
result_dir=""  # result_dir=$cache/$nodeType/$uid
max_steps=3000
save_steps=$max_steps
resume_ckpt=""
data_factor=1
extra_args=""

# =======================================
# Help function
# =======================================
function print_help {
    echo "Launch gaussian splattings optimization."
    echo ""
    echo "Required arguments :"
    echo "    --sfm FILE                  SFM file"
    echo "    -rd|--resultDirectory DIR   Result folder"
    echo ""
    echo "Optional arguments :"
    echo "    -df|--data_factor INT       Downscaling factor (1 by default)"
    echo "    -ms|--maxSteps INT          Number of optimization steps"
    echo "    -ss|--saveSteps STR         Steps where we save the model (space-delimited list of INT)"
    echo "    -es|--evalSteps             Steps to evaluate the model"
    echo "    --resumeCkpt FILE           Resume from a previous checkpoint"
    echo "    --masksFolder DIR           Folder containing masks to ignore specific part of the image"
    # echo "    -m|--mesh FILE              If provided we use this input to automatically remove splats that"
    # echo "                                are too far away from the mesh"
    # echo "    --optimizedPoses            "
    echo "    --metadataFolder DIR        Folder with metadata files that can be used to improve result"
    echo "    --poseOpt                   Try to optimize poses"
    echo ""
}

# =======================================
# Parse arguments
# =======================================
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            print_help
            exit 0
            ;;
        --sfm)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --sfm"
                print_help
                exit 1
            fi
            sfm_file="$2"
            shift 2
            ;;
        -rd|--resultDirectory)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --resultDirectory"
                print_help
                exit 1
            fi
            result_dir="$2"
            shift 2
            ;;
        -m|--mesh)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --mesh"
                print_help
                exit 1
            fi
            extra_args="$extra_args --mesh_reference $2"
            shift 2
            ;;
        -df|--data_factor)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --data_factor"
                print_help
                exit 1
            fi
            data_factor="$2"
            shift 2
            ;;
        -ms|--maxSteps)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --maxSteps"
                print_help
                exit 1
            fi
            max_steps="$2"
            shift 2
            ;;
        -ss|--saveSteps)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --saveSteps"
                print_help
                exit 1
            fi
            save_steps="$2"
            shift 2
            ;;
        -es|--evalSteps)
            extra_args="$extra_args --eval_steps"
            shift
            ;;
        --resumeCkpt)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --resumeCkpt"
                print_help
                exit 1
            fi
            resume_ckpt="$2"
            shift 2
            ;;
        --masksFolder)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --masksFolder"
                print_help
                exit 1
            fi
            extra_args="$extra_args --use_masks --masks_folder $2"
            shift 2
            ;;
        --metadataFolder)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --metadataFolder"
                print_help
                exit 1
            fi
            extra_args="$extra_args --metadata_folder $2"
            shift 2
            ;;
        --poseOpt)
            extra_args="$extra_args --pose_opt"
            shift
            ;;
        --optimizedPoses)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --optimizedPoses"
                print_help
                exit 1
            fi
            # extra_args="$extra_args --optimizedPoses $2"
            shift 2
            ;;
        *)
            echo "Error: Unknow Argument: $1"
            print_help
            exit 1
            ;;
    esac
done

# =======================================
# Make sure we have the required args
# =======================================
if [[ -z $sfm_file ]]; then
    echo "Missing input --sfm"
    print_help
    exit 1
fi
if [[ -z $result_dir ]]; then
    echo "Missing input --resultDirectory"
    print_help
    exit 1
fi

# =======================================
# Build command line
# =======================================
args=""
args="$args --sfm_file $sfm_file"
args="$args --result_dir $result_dir"
args="$args --data_factor $data_factor"
args="$args --max_steps $max_steps"
if [[ -n $save_steps ]]; then
    split_save_steps=(${save_steps})
    for i in "${split_save_steps[@]}"
    do
        args="$args --save_steps $i"
    done
fi
if [[ -n $resume_ckpt ]]; then
    args="$args --resume_ckpt $resume_ckpt"
fi
args="$args --eval_steps"
args="$args $extra_args"

# =======================================
# Launch python script
# =======================================
python $SCRIPT_DIR/../GSplat/trainer.py default $args
