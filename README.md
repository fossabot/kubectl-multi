# SecureNomad/kubectl-multi

A Google Cloud Build image that can be used to run a kubectl command in each zone that contains a Kubernetes cluster. Templating is supported to allow for zones to be used for things like hostnames. I built this as a way to use Google Cloud Build to deploy to multiple clusters in a project without having to set up Kubernetes Cluster Federation.

## How to use

In this folder, build the container using `gcloud`

```
gcloud builds submit
```

(Public image for use coming soon)

Once built, use the new image in your project's `cloudbuild.yaml` file.

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
