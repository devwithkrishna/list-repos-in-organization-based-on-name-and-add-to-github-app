#! /bin/bash
organization=$1
filtered_repo_names_array=("${@:2}")
org_repo_ids=()

for repo in "${filtered_repo_names_array[@]}"; do
    echo "repo details: $repo"
done

# Base URL for GitHub API
base_url="https://api.github.com/repos/$organization/"

# Loop through filtered repository names
# for repo_name in "${filtered_repo_names_array[@]}"; do
#     # Construct the URL for the repository
#     repo_url="${base_url}${repo_name}"
#     echo $repo_url

#     # Make a curl request to get repository details
#     response=$(curl -s -H "Accept: application/vnd.github+json" \
#                          -H "Authorization: Bearer $token" \
#                          -H "X-GitHub-Api-Version: 2022-11-28" \
#                          "$repo_url")
                        

#     # Extract and display relevant details (you can adjust this part based on what you need)
#     repo_id=$(echo "$response" | jq -r '.[] | "\(.id)"')

#     # Display the details
#     echo "Repository ID: $repo_id"
#     echo "--------------------"

#     # Add the repo_id to org_repo_ids array
#     org_repo_ids+=("$repo_id")
# done

# Loop through filtered repository names
# for repo_name in "${filtered_repo_names_array[@]}"; do
#     # Construct the URL for the repository
#     repo_url="${base_url}${repo_name}"
#     echo $repo_url

#     # Make a curl request to get repository details
#     response=$(curl -s -H "Accept: application/vnd.github+json" \
#                          -H "Authorization: Bearer $token" \
#                          -H "X-GitHub-Api-Version: 2022-11-28" \
#                          "$repo_url")

#     # Extract and display relevant details (you can adjust this part based on what you need)
#     repo_id=$(echo "$response" | jq -r '.id // .data.id // empty')

#     # Display the details
#     echo "Repository ID: $repo_id"
#     echo "--------------------"

#     # Add the repo_id to org_repo_ids array
#     org_repo_ids+=("$repo_id")
# done
# Loop through filtered repository names
for repo_name in "${filtered_repo_names_array[@]}"; do
    # Construct the URL for the repository
    # repo_url="${base_url}${repo_name}"
    repo_url="${base_url}$(echo "$repo_name" | tr -d '[:space:]')"
    echo $repo_url

    # Make a curl request to get repository details
    response=$(curl -s -L \
                -H "Accept: application/vnd.github+json" \
                -H "Authorization: Bearer $GH_TOKEN" \
                -H "X-GitHub-Api-Version: 2022-11-28" \
                "$repo_url")

    
    echo $response
    # sleep 10

    # Extract and display relevant details (you can adjust this part based on what you need)
    repo_id=$(echo "$response" | jq -r '.id')

    # Display the details
    echo "Repository ID: $repo_id"
    echo "--------------------"

    # Add the repo_id to org_repo_ids array
    org_repo_ids+=("$repo_id")
done

# Display the org_repo_ids array
echo "Organization Repository IDs: ${org_repo_ids[@]}"

