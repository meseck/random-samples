#!/bin/bash
# Author: Fool's Mate https://github.com/fools-mate

# Arguments
FOLDER_NAME=$1
NUMBER_OF_SAMPLES=$2

URL="https://sound-effects-media.bbcrewind.co.uk/wav"
CSV="BBCSoundEffects.csv"

# If no argument is supplied - use default values
if [ "$#" -eq 0 ]; then
  echo ""
  echo "No arguments supplied. You can use following arguments: [folder name (path)], [number of samples]"
  echo "At this point the default values are set. (folder name = 'random-samples', number of samples = 4)"
  FOLDER_NAME=random-samples
  NUMBER_OF_SAMPLES=4
fi

# Check for name argument
if [ -z "$FOLDER_NAME" ]; then
  echo "No folder name supplied."
  exit 1
fi

# Check for number of samples argument
if [ -z "$NUMBER_OF_SAMPLES" ]; then
  echo ""
  echo "No number of samples supplied."
  exit 1
fi

# Check if the second argument is an integer
if [[ ! "$NUMBER_OF_SAMPLES" =~ ^[0-9]+$ ]]; then
  echo ""
  echo "Number of samples must be an integer."
  exit 1
fi

# Check if the folder name already exists
if [[ -d $FOLDER_NAME ]]; then
  INDEX=1
  # If so add number at the end
  while [[ -d $FOLDER_NAME-$INDEX ]]; do
    ((INDEX++))
  done
  FOLDER_NAME=$FOLDER_NAME-$INDEX
fi

# Create sample folder
echo ""
echo "Create sample folder: ${FOLDER_NAME}"
mkdir -p "$FOLDER_NAME"
echo ""

# Count the entries of the csv
SAMPLE_ENTRIES=$(wc -l < "$CSV")

# Declare an array to save the choosen random numbers
declare -a RANDOM_NUMBER_LIST

# Choose and download random samples
for ((INDEX = 1; INDEX <= NUMBER_OF_SAMPLES; INDEX++)); do
  # Create a random number between 2 and current number of entries (Start at 2 to avoid the csv header)
  RANDOM_NUMBER=$((RANDOM % SAMPLE_ENTRIES + 2))

  # Check if this random number has not yet been used
  while echo "${RANDOM_NUMBER_LIST[@]}" | grep -q -w $RANDOM_NUMBER; do
    # If so create a new random number
    RANDOM_NUMBER=$((RANDOM % SAMPLE_ENTRIES + 2))
  done

  # Choose random line in the csv and get the file name of the sample
  RANDOM_SAMPLE_FILE_NAME=$(sed "${RANDOM_NUMBER}q;d" "$CSV" | grep -o "[0-9]*\.wav")

  # Add current random number to the list
  RANDOM_NUMBER_LIST+=("$RANDOM_NUMBER")

  DOWNLOAD_URL="${URL}/${RANDOM_SAMPLE_FILE_NAME}"
  OUTPUT_PATH="${FOLDER_NAME}/sample-${INDEX}.wav"

  echo "$DOWNLOAD_URL"

  # Download sample
  echo "Downloading random sample - $INDEX of $NUMBER_OF_SAMPLES"
  curl --progress-bar "$DOWNLOAD_URL" -o "$OUTPUT_PATH"
  echo ""
done

echo "Complete."
