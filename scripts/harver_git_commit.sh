#!/bin/bash

# Fallback values
fallback_types="fix feat test chore maturity"
fallback_scopes="cj"
custom="{CUSTOM}"

# Try to get commit types from commitlint config
types=$(node -p "require('./commitlint.config.js').rules?.['type-enum']?.[2]" 2>/dev/null | grep -oE "([a-zA-Z]+)")
if [[ -z "$types" ]]; then
  echo "No commitlint.config.js found. Using fallback types."
  types=$fallback_types
fi
types="$types $custom"

echo "Select type of change:"
select type in $types; do
  if [[ "$type" == "$custom" ]]; then
    read -p "Enter custom type: " type
    break
  elif [[ -n "$type" ]]; then
    break
  fi
done

# Try to get scopes from commitlint config
scopes=$(node -p "require('./commitlint.config.js').rules?.['scope-enum']?.[2]" 2>/dev/null | grep -oE "([a-zA-Z]+)")
if [[ -z "$scopes" ]]; then
  echo "No commitlint.config.js found. Using fallback scopes."
  scopes=$fallback_scopes
fi
scopes="$scopes $custom"

echo "Select scope of change:"
select scope in $scopes; do
  if [[ "$scope" == "$custom" ]]; then
    read -p "Enter custom scope: " scope
    break
  elif [[ -n "$scope" ]]; then
    break
  fi
done

# Get ticket from branch name
ticket=$(git rev-parse --abbrev-ref HEAD | grep -oE "^[A-Z]+-[0-9]+")
read -p "Ticket [$ticket]: " input_ticket
ticket=${input_ticket:-$ticket}

# Prepare commit message template
template_file=$(mktemp)
echo "$type($scope): $ticket  " > "$template_file"

# Open in default git editor
git commit --edit -t "$template_file"

# Clean up
rm "$template_file"
