# hello-world-cicd

This is a small Go app that is tested in PRs, built into a Docker image and has
a script to deploy it locally for testing by developers.

Acceptance criteria:

- There is a GitHub repo which contains a simple web app responding with “Hello
  world” string to HTTP GET request or use any open-source app of your choice.

- There is a GitHub workflow implementing CI process – e.g. building and testing
  the app, pushing the Docker image, …

- There is a Helm chart which can be used to deploy the app to the Kubernetes
  cluster.

- There is a CD pipeline which can be used to deploy the app to a local
  (minikube, kind, ...) Kubernetes cluster.
  - No need to implement but think of there are multiple environments involved
    e.g. staging and production.

# Running locally

Prerequisites:

- `homebrew` # recommended
- `lima` (`brew install lima`)

Then run this script and it will give you a URL to access the app
`./deploy/run.sh`

# Homework Notes

First, the `run.sh` script is pretty fragile and could be destructive on dev
machines that already use lima - I would continue developing it to make sure it
was reliable, robust, portable (I tested on MacOS and Linux). Also, there's a
small issue of getting Kubernetes to use the built image, but that should be
solvable with a little more time.

I left a lot of boilerplate in the Helm chart intentionally. Not knowing
specifics, I wanted to wait until I knew more about the requirements and
expectations before removing what might be functionality we'd eventually need;
for example, httpRoute is still pretty rare for usage but if it's used, that
functionality definitely needs to be in there.

I wrote the go app from scratch mostly as a fun exercise for myself. The tests
(test, since there's only one) is definitely deficient - I would make sure the
real tests mocked functions as necessary to better reflect actual usage.

I copied `build.yaml` and `release.yaml` from a repo of mine where I was already
building a Go app. The license is GNU, so if I was working on a repo with source
that would not be open, I would create the workflows from scratch; a nice side
benefit would be taking a quick scan of the landscape and looking for better
ways to do this as well as vetting any upstream dependencies more closely.

Finally, the last step would be to use ArgoCD to automatically deploy the app on
pushes to the repo, based on business logic around releases, deployments,
automated and manual testing. I'm familiar with Flux but getting up to speed on
ArgoCD would be fast since they're similar.

I'd also look to implement ArgoCD locally for the dev k8s cluster as well in the
`lima` bootstrap for easier automation and even closer alignment with hosted
environments.
