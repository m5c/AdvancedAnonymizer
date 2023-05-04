#! /bin/bash
# Advanced Anonymizer
# Consumes a folder and recursively substitues all provided keywords by their replacements.
# Afterwards searches for case insensitive occurrences of keywords and warn about remaining breadcrumbs.

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


# Main procedure of program
verifyArgs "$@"
echo -n "Runting syntax check on config file... "
applyForEachLine verifSubstitutionSyntax
echo "OK"
exit 0
