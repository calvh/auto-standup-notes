# Sitdown Notes

Stop spending precious time manually writing standup notes. Automate
your standup notes now!

## About

This program will query the GitHub API for:

-   Open issues assigned to you
-   Issues created by you
-   Merged PRs created by you
-   Open PRs created by you

The queries are limited to a specified date range and one repo. The
program then generates pre-filled standup notes from the data and
outputs it to stdout.

## Requirements

The following must be installed on your system and be on your `PATH`.

-   `jq`
-   `curl`

If you don't have one yet, set up a Personal Access Token (PAT) at
GitHub with the [right
scopes](https://docs.github.com/en/graphql/guides/forming-calls-with-graphql).

## Usage

Clone this repo.

Next, `cd` into the directory where you cloned the repo and run:

`sudo chmod u+x ./sitdown.sh`

Finally, run the program with:

`./sitdown.sh`

If you prefer, you could set the following variables in a `.env` file
and instruct the program to load from it during the first prompt.

    ```
    TOKEN # GitHub Personal Access Token
    REPO # Repository name including owner [e.g., octocat/Hello-World] 
    USERNAME # GitHub username
    DATE_START # Start Date in YYYY-MM-DD format (inclusive) 
    DATE_END # End Date in YYYY-MM-DD format (inclusive) 
    ```

If you run into errors, check if your PAT is valid and that you have
entered all inputs correctly. If you get a generic template, it is
possible that that you have entered some incorrect info, e.g., wrong
username and the query just returned no data.

## Tested on

-   Ubuntu 21.04

## Contributing

If you have any ideas or feedback, or if you found a bug, please [submit
an issue](https://github.com/calvh/sitdown-notes/issues/new).
