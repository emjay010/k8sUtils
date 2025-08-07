#!/bin/bash

ALIAS_FILE="/tmp/kube_aliases.sh"
DESCRIPTION_FILE="/tmp/kube_alias_descriptions.txt"

# Ensure alias file is sourced
if [ -f "$ALIAS_FILE" ]; then
  . "$ALIAS_FILE"
fi

# Function to print help
show_help() {
  cat <<EOF

Usage:
  . set-alias.sh --n <ns>        # Set or switch current namespace
  . set-alias.sh --l                      # List current aliases and their descriptions
  . set-alias.sh --add <alias> "<command>" "<description>"  # Add custom alias (auto namespace-aware if kubectl/helm)
  . set-alias.sh --help                  # Show this help message

Examples:
  . set-alias.sh --n osns0011
  . set-alias.sh --add kgloy "kubectl get leases -o yaml" "Get leases in yaml"
  . set-alias.sh --l

EOF
}

# Function to make command namespace-aware
namespace_wrap() {
  local cmd="$1"
  if [[ "$cmd" == kubectl* ]]; then
    echo "$cmd --namespace=\${KUBE_NAMESPACE:-default}"
  elif [[ "$cmd" == helm3* ]]; then
    echo "$cmd --namespace=\${HELM_NAMESPACE:-default}"
  else
    echo "$cmd"
  fi
}

# Process arguments
case "$1" in
  --n)
    shift
    export KUBE_NAMESPACE="$1"
    export HELM_NAMESPACE="$1"
    echo "Switched to namespace: $1"
    ;;
  --add)
    shift
    alias_name="$1"
    shift
    raw_command="$1"
    shift
    description="$1"

    # Add namespace awareness
    cmd_with_ns=$(namespace_wrap "$raw_command")

    echo "alias $alias_name='$cmd_with_ns'" >> "$ALIAS_FILE"
    echo "$alias_name - $description" >> "$DESCRIPTION_FILE"
    . "$ALIAS_FILE"
    echo "Alias '$alias_name' added."
    ;;
  --l)
    echo "=== Current Aliases ==="
    alias
    echo
    if [ -f "$DESCRIPTION_FILE" ]; then
      echo "=== Descriptions (custom added) ==="
      cat "$DESCRIPTION_FILE"
    fi
    ;;
  --help)
    show_help
    ;;
  *)
    show_help
    ;;
esac

