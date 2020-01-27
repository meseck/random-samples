#!/bin/bash
# Author: Fool's Mate https://github.com/fools-mate

# Arguments
name=$1
numberOfSamples=$2

url="http://bbcsfx.acropolis.org.uk/assets"
csv="BBCSoundEffects.csv"

# If no argument is supplied - use default values
if [ "$#" -eq 0 ]; then
  echo ""
  echo "No arguments supplied. You can use following arguments: [folder name (path)], [number of samples]"
  echo "At this point the default values are set. (folder name = 'random-samples', number of samples = 4)"
  name=random-samples
  numberOfSamples=4
fi

# Check for name argument
if [ -z "$name" ]; then
  echo "No name supplied."
  exit 1
fi

# Check for number of samples argument
if [ -z "$numberOfSamples" ]; then
  echo ""
  echo "No number of samples supplied."
  exit 1
fi

# Check if the second argument is an integer
if [[ ! "$numberOfSamples" =~ ^[0-9]+$ ]]; then
  echo ""
  echo "Number of samples must be an integer."
  exit 1
fi

# Check if the name already exists
if [[ -d $name ]]; then
  index=1
  # If so add number at the end
  while [[ -d $name-$index ]]; do
    ((index++))
  done
  name=$name-$index
fi

# Create sample folder
echo ""
echo "Create sample folder: $name"
mkdir -p "$name"
echo ""

# Download the newest BBC Sound Library CSV file and save it in a variable
csvFile="$(curl "$url/$csv" 2>/dev/null)"

# Count the entries of the csv
sampleEntries=$(<<<"$csvFile" wc -l)

# Declare an array to save the choosen random numbers
declare -a randomNumberList

# Choose and download random samples
for ((index = 1; index <= numberOfSamples; index++)); do
  # Create a random number between 2 and current number of entries (Start at 2 to avoid the csv header)
  randomNumber=$((RANDOM % sampleEntries + 2))

  # Check if this random number has not yet been used
  while echo "${randomNumberList[@]}" | grep -q -w $randomNumber; do
    # If so create a new random number
    randomNumber=$((RANDOM % sampleEntries + 2))
  done

  # Choose random line in the csv and get the file name of the sample
  randomSample=$(<<<"$csvFile" sed "${randomNumber}q;d" | grep -o "[0-9]*\.wav")
  # Add current random number to the list
  randomNumberList+=("$randomNumber")

  # Download sample
  echo "Downloading random sample - $index of $numberOfSamples"
  curl --progress-bar "$url/$randomSample" -o $name/sample-$index.wav
  echo ""
done

echo "Complete."
