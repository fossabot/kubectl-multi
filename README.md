# securenomad/kubectl-multi
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fsecurenomad%2Fkubectl-multi.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fsecurenomad%2Fkubectl-multi?ref=badge_shield)


A Google Cloud Build image that can be used to run a kubectl command in each zone that contains a Kubernetes cluster. Templating is supported to allow for zones to be used for things like hostnames. I built this as a way to use Google Cloud Build to deploy to multiple clusters in a project without having to set up Kubernetes Cluster Federation.

## How to use

Instead of using `gcr.io/cloud-builders/kubectl` you can use this image in any cloudbuild.yaml file.

```
- name: 'securenomad/kubectl-multi'
  args: ['get', 'all']
```

`kubectl get all` will be ran on each zone in your project with a running kubernetes cluster.

## How it works

Zones are retrieved using this command

```
gcloud container clusters list --format="value(zone)"
```

Then for each zone, the correct zone and cluster env vars are set and sent to the original `cloud-builders/kubectl` command.

## Templating

Templating can be used when certain parts if a deployment are variable based on zone, like for hostnames.

### Example:

In your `cloudbuild.yaml` file specify the TEMPLATE_FILE env variable

```
- name: 'securenomad/kubectl-multi'
  id: Deploy Services
  args: ['apply', '-f', 'service.yaml']
  env:
  - 'TEMPLATE_FILE=service.yaml'
```

`{{ZONE}}` in your `service.yaml` file will be replaced

```
apiVersion: v1
kind: Service
metadata:
name: my-service
namespace: default
labels:
    app.kubernetes.io/name: my-app
annotations:
    external-dns.alpha.kubernetes.io/hostname: {{ZONE}}.example.com
```

Like this

```
annotations:
    external-dns.alpha.kubernetes.io/hostname: us-east1-b.example.com
```


## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fsecurenomad%2Fkubectl-multi.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fsecurenomad%2Fkubectl-multi?ref=badge_large)