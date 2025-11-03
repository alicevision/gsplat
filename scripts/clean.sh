#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# =======================================
# Arguments default values
# =======================================
model=""
mesh=""
outputModel=""

# =======================================
# Help function
# =======================================
function print_help {
    echo "Clean splats that are too far away from a reference mesh."
    echo ""
    echo "Required arguments :"
    echo "    --model               Gaussian Splatting model"
    echo "    --mesh                Surface mesh"
    echo "    --outputModel         Output directory"
    echo ""
    echo "Optional arguments :"
    echo "    --metadata            Metadata folder"
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
        --model)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --model"
                print_help
                exit 1
            fi
            model="$2"
            shift 2
            ;;
        --mesh)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --mesh"
                print_help
                exit 1
            fi
            mesh="$2"
            shift 2
            ;;
        --metadata)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --metadata"
                print_help
                exit 1
            fi
            extra_args="$extra_args --metadata_folder $2"
            shift 2
            ;;
        --outputModel)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --outputModel"
                print_help
                exit 1
            fi
            outputModel="$2"
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
if [[ -z $model ]]; then
    echo "Missing input --model"
    print_help
    exit 1
fi
if [[ -z $mesh ]]; then
    echo "Missing input --mesh"
    print_help
    exit 1
fi
if [[ -z $outputModel ]]; then
    echo "Missing input --outputModel"
    print_help
    exit 1
fi

# =======================================
# Build command line
# =======================================
args=""
args="$args --ckpt $model"
args="$args --mesh $mesh"
args="$args --outputModel $outputModel"
args="$args $extra_args"

# =======================================
# Launch python script
# =======================================
python $SCRIPT_DIR/../GSplat/cleanSplats.py $args
