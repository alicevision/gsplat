#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Arguments
eval_model=""
cameras=""
data_factor=1
output_dir=""
output_format="auto"
output_colorspace="auto"
while [[ $# -gt 0 ]]; do
    case $1 in
        -m|--model)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --model"
                exit 1
            fi
            eval_model="$2"
            shift 2
            ;;
        -c|--cameras)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --cameras"
                exit 1
            fi
            cameras="$2"
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
        -o|--output)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --output"
                exit 1
            fi
            output_dir="$2"
            shift 2
            ;;
        --outputFormat)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --outputFormat"
                exit 1
            fi
            output_format="$2"
            shift 2
            ;;
        --outputColorspace)
            if [ -z "$2" ]; then
                echo "Error: Value is empty: --outputColorspace"
                exit 1
            fi
            output_colorspace="$2"
            shift 2
            ;;
        *)
            echo "Error: Unknow Argument: $1"
            exit 1
            ;;
    esac
done

if [[ -z $eval_model ]]; then
    echo "Missing input --model"
    exit 1
fi
if [[ -z $cameras ]]; then
    echo "Missing input --cameras"
    exit 1
fi
if [[ -z $output_dir ]]; then
    echo "Missing input --output_dir"
    exit 1
fi


args="--ckpt $eval_model"
args="$args --cameras $cameras"
args="$args --data_factor $data_factor"
args="$args --output_dir $output_dir"
args="$args --output_format $output_format"
args="$args --output_colorspace $output_colorspace"

python $SCRIPT_DIR/../GSplat/viewer.py $args
