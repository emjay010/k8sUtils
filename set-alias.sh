#!/bin/bash

# Function to set Kubernetes namespace
set_kube_namespace() {
  export KUBE_NAMESPACE=$1
}

# Function to set Helm namespace
set_helm_namespace() {
  export HELM_NAMESPACE=$1
}

# Check if both namespace arguments are provided
if [ -z "$1" ] ; then
  echo "Usage: $0 <k8s-namespace> [-n <another-namespace>] "
  exit 1
fi

# Set the Kubernetes and Helm namespaces
set_kube_namespace "$1"
set_helm_namespace "$1"

# Parse the command-line options
while getopts ":n:" opt; do
  case ${opt} in
    n )
      another_namespace=$OPTARG
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      exit 1
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

# Set namespace according to provided option or default namespace
if [ -n "$another_namespace" ]; then
  KUBE_NAMESPACE=$another_namespace
  HELM_NAMESPACE=$another_namespace
fi

# Kubernetes aliases with dynamic namespace
alias k='kubectl'
alias kgp='kubectl get pods --namespace=${KUBE_NAMESPACE:-default}'
alias kg='kubectl get --namespace=${KUBE_NAMESPACE:-default}'
alias kgs='kubectl get services --namespace=${KUBE_NAMESPACE:-default}'
alias kgd='kubectl get deployments --namespace=${KUBE_NAMESPACE:-default}'
alias kga='kubectl get all --namespace=${KUBE_NAMESPACE:-default}'
alias kd='kubectl describe --namespace=${KUBE_NAMESPACE:-default}'
alias kc='kubectl create --namespace=${KUBE_NAMESPACE:-default}'
alias krm='kubectl delete --namespace=${KUBE_NAMESPACE:-default}'
alias kaf='kubectl apply -f --namespace=${KUBE_NAMESPACE:-default}'
alias kpf='kubectl port-forward --namespace=${KUBE_NAMESPACE:-default}'
alias kl='kubectl logs --namespace=${KUBE_NAMESPACE:-default}'
alias kex='kubectl exec -it --namespace=${KUBE_NAMESPACE:-default}'
alias kedit='kubectl edit --namespace=${KUBE_NAMESPACE:-default}'
alias kcp='kubectl cp --namespace=${KUBE_NAMESPACE:-default}'
alias ktop='kubectl top pods --namespace=${KUBE_NAMESPACE:-default}'
alias kgl='kubectl get leases --namespace=${KUBE_NAMESPACE:-default}'
alias kgnad='kubectl get net-attach-def --namespace=${KUBE_NAMESPACE:-default}'

# Helm aliases with dynamic namespace
alias h='helm3'
alias hi='helm3 install --namespace=${HELM_NAMESPACE:-default}'
alias hupg='helm3 upgrade --namespace=${HELM_NAMESPACE:-default}'
alias hls='helm3 ls --namespace=${HELM_NAMESPACE:-default}'
alias hrm='helm3 delete --namespace=${HELM_NAMESPACE:-default}'
alias hrb='helm3 rollback --namespace=${HELM_NAMESPACE:-default}'
alias hgv='helm3 get values --namespace=${HELM_NAMESPACE:-default}'
alias hgm='helm3 get manifest --namespace=${HELM_NAMESPACE:-default}'
alias hh='helm3 history --namespace=${HELM_NAMESPACE:-default}'

echo "Aliases set for Kubernetes namespace: ${KUBE_NAMESPACE:-default} and Helm namespace: ${HELM_NAMESPACE:-default}"
