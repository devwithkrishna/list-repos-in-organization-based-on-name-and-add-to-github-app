# list-repos-in-organization-based-on-name-and-add-to-github-app

## use case

this repo can be used to search repositories with a specific string in its name and get the list.

Later this can be used to add the repos to a github app or github teams 

## How this works ? 

```
list_filter_repositories.sh --> This script intakes the organization name and a search string to get the repo names matching search string.
```

```
get_repository_id.sh --> This script will be triggered from inside list_filter_repositories.sh passwing the organization name and repo names as input parameters and returns the repository ids which are unique identifier. This is needed to be used to add to github App
```

