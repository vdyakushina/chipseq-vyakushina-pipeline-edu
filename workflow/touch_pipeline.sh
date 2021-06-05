#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

echo "-----------"
echo "0. Clean temp files"
rm -rf .snakemake/shadow
rm -rf tmp
mkdir -p tmp

echo "-----------"
echo "1. touch snakemake pipeline results:"
#snakemake --use-conda --cores 1 -q --touch --forceall

echo "-----------"
echo "2. pipeline logs are not handled by --touch"
#find logs -type f -exec touch {} +

echo "-----------"
echo "3. rules outputs marked as directories only"
# Snakemake updates `.snakemake_timestamp` file timestamp, find other files in such directories and touch them:
#find results -name ".snakemake_timestamp" -exec dirname {} + | xargs -I FOLDER find FOLDER -type f \! -name ".snakemake_timestamp" -exec touch -h {} +

echo "-----------"
echo "4. .snakemake folder files:"
#find .snakemake \( -type f -or -type l \) -exec touch -h {} +

echo "-----------"
echo "5. pipeline input"
#find reads -type f -exec touch -h {} +

echo "-----------"
echo "6. pipeline sources:"
SRC_FOLDERS=".git
config
images
workflow"

for F in $SRC_FOLDERS; do
  echo "  touch all in: $F/"
  find "$F" -type f -exec touch -h {} +
done

#find .git -type f -exec touch {} +
#find config -type f -exec touch  {} +
#find images -type f -exec touch {} +
#find workflow -type f -exec touch {} +

SRC_FILES="./.gitignore
./environment.yaml
./LICENSE.md
./LICENSE.md
./README.md"
for F in $SRC_FILES; do
  echo "  touch: $F"
  touch -h "$F"
done

echo "-----------"
echo "7. CHECK files >25 days old:"
#find . \! -type d -mtime +25

# or ignoring links:
find . \! \( -type d -or -type l \) -mtime +2