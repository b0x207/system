#!/usr/bin/env bash

# Colors
C_RESET="\x1b[0m"
C_STATUS="\x1b[34m"
C_CONFIRM="\x1b[32m"

CURRENT_NIXPKGS_NODE=$(jq <flake.lock '.nodes.root.inputs.nixpkgs' -r)

CURRENT_COMMIT=$(jq <flake.lock ".nodes.${CURRENT_NIXPKGS_NODE}.locked.rev" -r)
echo -e "${C_STATUS}Current Nixpkgs commit: ${CURRENT_COMMIT}${C_RESET}"

UPSTREAM_REF=$(jq <flake.lock ".nodes.${CURRENT_NIXPKGS_NODE}.original.ref" -r)
UPSTREAM_RAW_DIFF=$(gh api "repos/nixos/nixpkgs/compare/${CURRENT_COMMIT}...${UPSTREAM_REF}")
UPSTREAM_AHEAD_BY=$(echo $UPSTREAM_RAW_DIFF | jq '.ahead_by' -r)
UPSTREAM_COMMIT=$(echo $UPSTREAM_RAW_DIFF | jq '.commits[-1].sha' -r)

echo -e "${C_STATUS}Upstream Nixpkgs commit: ${UPSTREAM_COMMIT}${C_RESET}"
echo -e "${C_STATUS}Upstream is ahead by ${UPSTREAM_AHEAD_BY} commits${C_RESET}"

echo -e "${C_CONFIRM}Continue?${C_RESET}"
read

echo $UPSTREAM_RAW_DIFF | jq -r '
def reldate:
    (now - (fromdateiso8601)) as $d
    | if $d < 60 then "\($d|floor)s ago"
      elif $d < 3600 then "\(($d/60|floor))m ago"
      elif $d < 86400 then "\(($d/3600|floor))h ago"
      elif $d < 2592000 then "\(($d/86400|floor))d ago"
      elif $d < 31536000 then "\(($d/2592000|floor))mo ago"
      else "\(($d/31536000|floor))y ago"
      end;

.commits[]
| "\u001b[33m\(.commit.author.date | reldate)\u001b[0m \(.commit.message)"'
