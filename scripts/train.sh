#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Arguments
sfm_file=""
result_dir=""  # result_dir=$cache/$nodeType/$uid
max_steps=3000
save_steps=$max_steps
resume_ckpt=""
data_factor=1
extra_args=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --sfm)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --sfm"
                exit 1
            fi
            sfm_file="$2"
            shift 2
            ;;
        -rd|--resultDirectory)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --resultDirectory"
                exit 1
            fi
            result_dir="$2"
            shift 2
            ;;
        -m|--mesh)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --mesh"
                exit 1
            fi
            extra_args="$extra_args --mesh_reference $2"
            shift 2
            ;;
        -df|--data_factor)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --data_factor"
                exit 1
            fi
            data_factor="$2"
            shift 2
            ;;
        -ms|--maxSteps)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --maxSteps"
                exit 1
            fi
            max_steps="$2"
            shift 2
            ;;
        -ss|--saveSteps)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --saveSteps"
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
                exit 1
            fi
            resume_ckpt="$2"
            shift 2
            ;;
        --masksFolder)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --masksFolder"
                exit 1
            fi
            extra_args="$extra_args --use_masks --masks_folder $2"
            shift 2
            ;;
        --metadataFolder)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --metadataFolder"
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
                exit 1
            fi
            # extra_args="$extra_args --optimizedPoses $2"
            shift 2
            ;;
        *)
            echo "Error: Unknow Argument: $1"
            exit 1
            ;;
    esac
done

if [[ -z $sfm_file ]]; then
    echo "Missing input --sfm"
    exit 1
fi
if [[ -z $result_dir ]]; then
    echo "Missing input --resultDirectory"
    exit 1
fi


# Build command args
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


# Now launch the trainer script
python $SCRIPT_DIR/../GSplat/trainer.py default $args
