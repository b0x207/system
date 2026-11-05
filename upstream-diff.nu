#!/usr/bin/env nu

# Change if intending to track a different branch
let UPSTREAM_REF = "nixos-unstable-small"

##

let input_latest_blame = git log -n 1 --pretty="format:%H" inputs/nixpkgs

let merge_commit = git show ($input_latest_blame)
| find --no-highlight --regex "^.*Merge commit '(.*)'$"
| str substring 18..-2
| get 0

let current_commit = git log -n 1 ($merge_commit)
| find --no-highlight "git-subtree-split"
| str substring 23..-1
| get 0

print $"(ansi blue)Current Nixpkgs commit: ($current_commit)(ansi reset)"

let upstream_raw_diff = gh api $"repos/nixos/nixpkgs/compare/($current_commit)...($UPSTREAM_REF)" | from json
let upstream_ahead_by = $upstream_raw_diff | get ahead_by
let upstream_commit = $upstream_raw_diff | get commits | last | get sha

print $"(ansi blue)Upstream Nixpkgs commit: ($upstream_commit)(ansi reset)"
print $"(ansi blue)Upstream is ahead by ($upstream_ahead_by) commits(ansi reset)"

let continue = input $"(ansi green)Continue \(type y) ?(ansi reset) "
if $continue != "y" {
    print "Abort"
    exit
}

mut commits = []

for commit in ($upstream_raw_diff | get commits) {
    $commits = $commits ++ [
        {
            "Date": ($commit | get commit.committer.date | date humanize)
            "Commit Message": ($commit | get commit.message)
        }
    ]
}

$commits | reverse | table --expand
