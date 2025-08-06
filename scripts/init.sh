#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# =======================================
# Arguments default values
# =======================================
sfm_file=""
result_dir=""

# =======================================
# Help function
# =======================================
function print_help {
    echo "Update SFM file to setup correct colors for each splat."
    echo ""
    echo "Required arguments :"
    echo "    --sfm                     SFM file"
    echo "    -rd|--resultDirectory     Output directory"
    echo ""
    echo "Optional arguments :"
    echo "    --masksFolder             Masks folder"
    echo "    --metadataFolder          Metadata folder"
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
args="$args $extra_args"

# =======================================
# Launch python script
# =======================================
python $SCRIPT_DIR/../GSplat/initializeSplats.py default $args
