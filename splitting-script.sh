#!/bin/bash

INPUT_FILE="$1"  # take the input file name as a cmd arg
OUTPUT_DIR="split-resources"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Read the number of documents in the YAML file
DOC_COUNT=$(yq eval 'length' "$INPUT_FILE")

echo "Splitting $DOC_COUNT resources from $INPUT_FILE into $OUTPUT_DIR/"

# Iterate over each document in the YAML file
for i in $(seq 0 $((DOC_COUNT - 1))); do
  # Extract the i-th document
  RESOURCE=$(yq eval ".[${i}]" "$INPUT_FILE")

  # Get the resource kind and name
  KIND=$(echo "$RESOURCE" | yq eval '.kind' -)
  NAME=$(echo "$RESOURCE" | yq eval '.metadata.name // "unnamed-resource-${i}"' -)

  # Skip if KIND is null (empty document)
  if [ -z "$KIND" ] || [ "$KIND" == "null" ]; then
    echo "Skipping empty or invalid document at index $i"
    continue
  fi

  # Sanitize the kind to ensure valid directory names
  KIND_DIR=$(echo "$KIND" | tr '[:upper:]' '[:lower:]')

  # Create the directory for the resource kind
  mkdir -p "${OUTPUT_DIR}/${KIND_DIR}"

  # Define the output file name
  OUTPUT_FILE="${OUTPUT_DIR}/${KIND_DIR}/${NAME}.yaml"

  # Save the resource to the output file
  echo "$RESOURCE" > "$OUTPUT_FILE"

  echo "Created ${OUTPUT_FILE}"
done

echo "Splitting completed."

