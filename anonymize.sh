#! /bin/bash
# Advanced Anonymizer
# Consumes a folder and recursively substitues all provided keywords by their replacements.
# Afterwards searches for case insensitive occurrences of keywords and warn about remaining breadcrumbs.

# Print argument in RED
function echored {
        echo -e "\033[00;31m$1\033[00;39m"
}

# Print argument in GREEN
function echogreen {
        echo -e "\033[00;32m$1\033[00;39m"
}

function verifyRepoExists() {
  # Check it first argument points to valid directory
  if [[ ! -d $1 ]]; then
    echo "Target directory \"$1\" does not exist."
    # return bad file descriptor code
    exit 9
  fi
}

# Verify there is exatly one param, and that it references a folder on disk
function verifyArgs() {
  if [[ $# -ne 1 ]]; then
    echo "Illegal number of parameters. Exaclty one argument is required."
    # Return invalid argument code
    exit 22
  fi
  verifyRepoExists "$@"
}

# Applies the function provided as first argument on every line of configurarion file
function applyForEachLine() {
  # Test line by line:
  filename='substitutions.txt'
  while IFS="" read -r SUBST_LINE || [ -n "$SUBST_LINE" ]; do
    # If regex does not match. Rejet and exit.
    # Every line must be exactly to words separated by a single space.
    $1 "$SUBST_LINE"
  done <"$filename"
}

# Verifies that a provided line consists of two alphanumeric words, spearated bya single space.
function verifSubstitutionSyntax() {
  [[ ! "$*" =~ ^[a-zA-Z0-9]+\ [a-zA-Z0-9]+$ ]] && echo "" && echo "Config file has invalid syntax line: \"$SUBST_LINE\". Exit." && exit 22
}

# Defininitely creates a new copy, no matter if there already is one or not
function createProjectCopy() {
  LOCATION=$(dirname "$1")
  PROJECT=$(basename "$1")

  # If location not empty, go there
  if [[ -n $LOCATION ]]; then
    cd "$LOCATION"
  fi

  # If target directory already exists, remove it
  ANONYMIZED_PROJECT=Anonymized"$PROJECT"
  if [[ -d "$ANONYMIZED_PROJECT" ]]; then
    rm -rf "$ANONYMIZED_PROJECT"
  fi
  cp -r "$PROJECT" "$ANONYMIZED_PROJECT"
  cd "$ANONYMIZED_PROJECT"
  export FULL_COPY_PATH=$(pwd)
  cd "$BASEDIR"
}

# Function that replaces al occurences of first word by occurrences of second word for file CONTENT.
# Both words are in same first argument and only separated by a space character.
function substituteContentString() {
  # Make sure to run replacement in project copy
  cd "$FULL_COPY_PATH"

  # Substitute all file content occurrences.
  SEARCH=$(echo "$1" | cut -d ' ' -f1)
  REPLACE=$(echo "$1" | cut -d ' ' -f2)
  grep -rl "$SEARCH" . | xargs sed -i '' -e "s/$SEARCH/$REPLACE/g"

  # Go back to base dir
  cd "$BASEDIR"
}

# Function to search only for key worlds, but case insensitive
function caseInsensitiveSearch() {
    # Make sure to run search in project copy
    cd "$FULL_COPY_PATH"

    SEARCH=$(echo "$1" | cut -d ' ' -f1)
    OCCURRENCES=$(grep -irl "$SEARCH" .)

    # print summary of occurrences found:
    if [[ -n "$OCCURRENCES" ]]; then
      CLEAR="NO"
      echored "You may have remaining identifiers!"
      echo -n "Found \"$SEARCH\" in:"
      echored "$OCCURRENCES"
    fi

    # Go back to base dir
    cd "$BASEDIR"
}

# Main procedure of program
verifyArgs "$@"

echo -n "Runting syntax check on config file... "
applyForEachLine verifSubstitutionSyntax
echo "OK"

# Rememeber base dir so we can revert when needed
BASEDIR=$(pwd)

echo -n "Creating copy of original project... "
createProjectCopy "$1"
echo "OK"

echo -n "Applying file content substitutions on project copy... "
echo ""
applyForEachLine substituteContentString
echo "OK"

#echo -n "Applying file content substitutions on project copy... "

echo "Checking for case insensitive remainders... "
unset CLEAR
applyForEachLine caseInsensitiveSearch
if [[ -z "$CLEAR" ]]; then
  echogreen "Clear! Here's your anonyous copy: $FULL_COPY_PATH"
fi
exit 0
