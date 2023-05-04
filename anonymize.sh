#! /bin/bash
# Advanced Anonymizer
# Consumes a folder and recursively substitues all provided keywords by their replacements.
# Afterwards searches for case insensitive occurrences of keywords and warn about remaining breadcrumbs.

function verifyRepoExists()
{
  # Check it first argument points to valid directory
  if [[ ! -d $1 ]]; then
    echo "Target directory does not exist"
    # return bad file descriptor code
    exit 9
  fi
}

# Verify there is exatly one param, and that it references a folder on disk
function verifyArgs()
{
  if [[ $# -ne 1 ]];
      then echo "illegal number of parameters"
      # Return invalid argument code
      exit 22
  fi
  verifyRepoExists "$@"
}

function processSubstitutionFile()
{
  # Iterate over every line of substitution configuration. Then check for sanity of line and apply substitution
  filename='substitutes.txt'
  while read -r SUBST_LINE; do
    echo "$SUBST_LINE"
  done <"$filename"
}

# Main procedure of program
verifyArgs "$@"
exit 0