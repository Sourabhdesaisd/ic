#!/bin/bash

# Root directory (default = current directory if not provided)
ROOT_DIR=${1:-.}

# Template content
read -r -d '' TEMPLATE << 'EOF'
# Directory: $(basename "$PWD")

## Description
> Add description of this directory.

## Contents
- List important files/modules here

## Usage
> Explain how to use the contents

## Notes
> Any additional notes
EOF

echo "Scanning directories under: $ROOT_DIR"

# Find all directories
find "$ROOT_DIR" -type d | while read -r dir; do
    README_FILE="$dir/README.md"

    if [ ! -f "$README_FILE" ]; then
        echo "Creating README in: $dir"

        # Create README with evaluated directory name
        (
            cd "$dir" || exit
            echo "# Directory: $(basename "$dir")" > README.md
            echo "" >> README.md
            echo "## Description" >> README.md
            echo "> Add description of this directory." >> README.md
            echo "" >> README.md
            echo "## Contents" >> README.md
            echo "- List important files/modules here" >> README.md
            echo "" >> README.md
            echo "## Usage" >> README.md
            echo "> Explain how to use the contents" >> README.md
            echo "" >> README.md
            echo "## Notes" >> README.md
            echo "> Any additional notes" >> README.md
        )
    else
        echo "Skipping (already exists): $dir"
    fi
done

echo "Done."
