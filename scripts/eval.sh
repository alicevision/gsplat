#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# =======================================
# Arguments default values
# =======================================
eval_model=""
cameras=""
data_factor=1
output_dir=""
output_format="auto"
output_colorspace="auto"

# =======================================
# Help function
# =======================================
function print_help {
    echo "Render with gaussian splattings."
    echo ""
    echo "Required arguments :"
    echo "    -m, --model MODEL    Trained model"
    echo "    -c, --cameras        Camera poses (SFM file)"
    echo "    -o, --output         Output folder"
    echo ""
    echo "Optional arguments :"
    echo "    -df, --data_factor   Downscaling factor (1 by default)"
    echo "    --outputFormat       Output format (we use format from views in the SFM file or .jpg)"
    echo "    --outputColorspace   Output colorspace (we try to detect it if not specified)"
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
        -m|--model)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --model"
                print_help
                exit 1
            fi
            eval_model="$2"
            shift 2
            ;;
        -c|--cameras)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --cameras"
                print_help
                exit 1
            fi
            cameras="$2"
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
        -o|--output)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --output"
                print_help
                exit 1
            fi
            output_dir="$2"
            shift 2
            ;;
        --outputFormat)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --outputFormat"
                print_help
                exit 1
            fi
            output_format="$2"
            shift 2
            ;;
        --outputColorspace)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --outputColorspace"
                print_help
                exit 1
            fi
            output_colorspace="$2"
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
if [[ -z $eval_model ]]; then
    echo "Missing input --model"
    print_help
    exit 1
fi
if [[ -z $cameras ]]; then
    echo "Missing input --cameras"
    print_help
    exit 1
fi
if [[ -z $output_dir ]]; then
    echo "Missing input --output_dir"
    print_help
    exit 1
fi

# =======================================
# Build command line
# =======================================
args="--ckpt $eval_model"
args="$args --cameras $cameras"
args="$args --data_factor $data_factor"
args="$args --output_dir $output_dir"
args="$args --output_format $output_format"
args="$args --output_colorspace $output_colorspace"

# =======================================
# Launch python script
# =======================================
python $SCRIPT_DIR/../GSplat/viewer.py $args
