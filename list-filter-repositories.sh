#!/bin/bash

organization="your_organization"
page=1
org_repos=""

# Input: String to search for in repository names
search_string="$1"

while true; do
    response=$(curl -s "https://api.github.com/orgs/$organization/repos?page=$page")
    repos=$(echo "$response" | jq -r '.[].name')

    # Concatenate repository names to the org_repos variable
    org_repos+="$repos "

    # Check if there are more pages
    link_header=$(curl -sI "https://api.github.com/orgs/$organization/repos?page=$((page + 1))" | grep -i '^link:')
    if [[ $link_header == *"rel=\"next\""* ]]; then
        ((page++))
    else
        break  # No more pages
    fi
done

# Display the original repository names (optional)
echo "Original Repository names: $org_repos"

# Filter repositories containing the specified search string
repos=""
for repo in $org_repos; do
    if [[ $repo == *"$search_string"* ]]; then
        repos+="$repo "
    fi
done

# Display the filtered repository names
echo "Filtered Repository names containing '$search_string': $repos"
