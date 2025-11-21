#!/bin/bash
appname="hello-world-cicd"
limaname="default"
helmopts="image.pullPolicy=Never"

# Exit if any command fails
set -e

echo "Creating cluster in limactl if necessary..."
limactl create --tty=false --name "${limaname}" "template:k8s" || echo "lima cluster ${limaname} already exists"
echo "Starting cluster with limactl..."
limactl start "${limaname}"
KUBECONFIG=$(limactl list "${limaname}" --format 'unix://{{.Dir}}/copied-from-guest/kubeconfig.yaml')
export KUBECONFIG
if [[ ! $(kubectl config current-context) == "kubernetes-admin@kubernetes" ]]; then
  echo "Context is not as expected, exiting to prevent running commands on live clusters"
  exit 1
fi

echo "Building Docker image locally..."
limactl copy . "${limaname}:/tmp/${appname}"
lima sudo nerdctl build "/tmp/${appname}" -t "${appname}:dev"

helm install "${appname}" deploy/chart --set "${helmopts}" || \
  helm upgrade "${appname}" deploy/chart  --set "${helmopts}" 

# TODO: Kubernetes doesn't see the built image, assuming some lima
# incompatibility. Needs a bit more work to cross the finish line.

ip=$(kubectl get svc "--selector=app.kubernetes.io/instance=${appname}" -o jsonpath="{.items[*].spec.clusterIP}")

echo "Connect to http://$ip"