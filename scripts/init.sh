#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Arguments
sfm_file=""
result_dir=""


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
args="$args $extra_args"


# Now launch the trainer script
python $SCRIPT_DIR/../GSplat/initializeSplats.py default $args
