# Random Samples

A small Bash script to download random audio files (samples) from the BBC Sound Effects library.
Works with the current url, but leaves out some newer samples of the library, since unfortunately there is no updated csv file available anymore.

## Usage:
Download the code and copy random-samples.sh into your folder of choice and run:

First make the script executable:

```sh
chmod +x random-sample.sh
```

This will start the script with the default settings:

```sh
./random-sample.sh
```

If you want, there are two arguments to modify the output:

```sh
./random-sample.sh new-samples 10
```

This creates a new folder with the name "new-samples" and downloads 10 samples.

Have fun!
