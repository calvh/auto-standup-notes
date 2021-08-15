#!/bin/bash
#
# query github graphql api with curl
# transform data into suitable format with jq
# output standup notes in markdown format to stdout

TOKEN=
USERNAME=
REPO=
DATE_START=
DATE_END=
COUNT=10

while [[ -z "${TOKEN}" ]]; do
    read -sp 'GitHub Personal Access Token ' TOKEN
done

echo

while [[ -z "${USERNAME}" ]]; do
    read -p 'GitHub username ' USERNAME
done

while [[ -z "${REPO}" ]]; do
    read -p 'Repository name including owner [e.g., octocat/Hello-World] ' REPO
done

while [[ -z "${DATE_START}" ]]; do
    read -p 'Start Date in YYYY-MM-DD format (inclusive) ' DATE_START
done

while [[ -z "${DATE_END}" ]]; do
    read -p 'End Date in YYYY-MM-DD format (inclusive) ' DATE_END
done

function query() {

    # use space as delimiter for sed because REPO contains slash
    local gql=$(
        cat $1 | sed \
            -e "s \${repo} ${REPO} " \
            -e "s \${username} ${USERNAME} " \
            -e "s \${date_range} ${DATE_START}..${DATE_END} " \
            -e "s \${last} ${COUNT} "
    )

    # format query to escape double quotes and remove newlines
    local query=$(jq -n --arg q "$(echo ${gql} | tr -d '\n')" '{query:$q}')

    curl -X POST \
        -s \
        -H "Authorization: bearer ${TOKEN}" \
        -H "Content-Type: application/json" \
        -d "$query" \
        https://api.github.com/graphql
}

# use jq -r to remove double quotes
authored_issues=$(
    query ./queries/authored_issues.gql |
        jq -r '.data.search.edges|.[]|.node|"- Opened issue [\(.number)](\(.url)): \(.title)"'
)
merged_pr=$(
    query ./queries/merged_pr.gql |
        jq -r '.data.search.edges|.[]|.node|"- PR merged [\(.number)](\(.url)): \(.title)"'
)
open_issues=$(
    query ./queries/open_issues.gql |
        jq -r '.data.search.edges|.[]|.node|"- Issue [\(.number)](\(.url)): \(.title)"'
)
open_pr=$(query ./queries/open_pr.gql |
    jq -r '.data.search.edges|.[]|.node|"- PR [\(.number)](\(.url)): \(.title)"')

cat <<EOF
**What did you achieve in the last 24 hours?**:
${merged_pr}
${authored_issues}

**What are your priorities for the next 24 hours?**:
${open_pr}
${open_issues}

**Blockers**:
- not sure if I really do exist or if I'm just a simulation

**Shoutouts**:
- my computer
EOF
