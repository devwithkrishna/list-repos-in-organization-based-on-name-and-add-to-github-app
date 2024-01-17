#!/bin/bash

organization=$1
page=1
org_repo_names=()  # Array for repository names
# org_repo_ids=()    # Array for repository IDs

# Input: String to search for in repository names
search_string=$2

# Get repository names

while true; do
    response=$(curl -s "https://api.github.com/orgs/$organization/repos?page=$page")
    repos=$(echo "$response" | jq -r '.[] | "\(.name)"')

    # Concatenate repository names and IDs to the org_repos array
    org_repo_names+=($repos)

    # Check if there are more pages
    link_header=$(curl -sI "https://api.github.com/orgs/$organization/repos?page=$((page + 1))" | grep -i '^link:')
    next_page=$(echo "$link_header" | awk -F'[<>]' '/rel="next"/{print $2}')

    if [ -n "$next_page" ]; then
        ((page++))
    else
        break  # No more pages
    fi
done

# Get repository ids

# while true; do
#     response=$(curl -s "https://api.github.com/orgs/$organization/repos?page=$page")
#     repos_id=$(echo "$response" | jq -r '.[] | "\(.id)"')

#     # Concatenate repository names and IDs to the org_repos array
#     org_repo_ids+=($repos_id)

#     # Check if there are more pages
#     link_header=$(curl -sI "https://api.github.com/orgs/$organization/repos?page=$((page + 1))" | grep -i '^link:')
#     next_page=$(echo "$link_header" | awk -F'[<>]' '/rel="next"/{print $2}')

#     if [ -n "$next_page" ]; then
#         ((page++))
#     else
#         break  # No more pages
#     fi
# done

# # Display the original repository names 
# echo "Original Repository names : "
# for repo in "${org_repo_names[@]}"; do
#     echo "repo details: $repo"
# done
# # Print the length of the array
# echo "Number of the public repos in Organization: ${#org_repo_names[@]}"

# echo $(printf '=%.0s' {1..40})

# Display the original repository IDs
# echo "Original Repository Ids : "
# for repo in "${org_repo_ids[@]}"; do
#     echo "repo details: $repo"
# done

# echo $(printf '=%.0s' {1..40})

# Filter repositories containing the specified search string
filtered_repos=()
for repo in "${org_repo_names[@]}"; do
    # echo "Checking repo: $repo"
    if [[ $repo == *"$search_string"* ]]; then
        # echo "Match found: $repo"
        filtered_repos+=($repo)
    fi
done
# echo $(printf '=%.0s' {1..40})

# Display the filtered repository names and IDs
echo -e "\nFiltered Repository names and IDs containing '$search_string':"
for repo in "${filtered_repos[@]}"; do
    echo "$repo"
done
# Print the length of the array
echo "Number of repos matching '$search_string' string : ${#filtered_repos[@]}"
echo $(printf '=%.0s' {1..40})

# Convert the string to an array
IFS=' ' read -ra filtered_repo_names_array <<< "${filtered_repos}"

# Pass the filtered repository names to another script
./get_repository_id.sh $organization "${filtered_repo_names_array[@]}"

# Pass the filtered repository names to another script
# ./get_repository_id.sh $organization "${filtered_repos[@]}"
