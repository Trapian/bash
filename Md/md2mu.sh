#!/bin/bash

# Get the input file name
input_file=$1

# Convert the markdown to confluence markup
pandoc -f markdown -t RTF $input_file -o $input_file.confluence

# Print the output file name
echo "Output file: $input_file.confluence"
