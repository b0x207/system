#!/usr/bin/env nu

let flake_lock = open flake.lock --raw | from json
let current_nixpkgs_node = $flake_lock | get nodes.root.inputs.nixpkgs
let current_commit = $flake_lock | get nodes | get $current_nixpkgs_node | get locked.rev

print $"(ansi blue)Current Nixpkgs commit: ($current_commit)(ansi reset)"

let upstream_ref = $flake_lock | get nodes | get $current_nixpkgs_node | get original.ref
let upstream_raw_diff = gh api $"repos/nixos/nixpkgs/compare/($current_commit)...($upstream_ref)" | from json
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
