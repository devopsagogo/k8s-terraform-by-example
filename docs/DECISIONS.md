# Design decisions

Short log of *why*, not *what*.

## Kind over Minikube
Kind spins up in seconds, runs inside Docker, and is CI-friendly.
Minikube has more addons but is heavier.

## Explicit namespace, not `default`
Every manifest sets `namespace: status-page`. Applying into `default`
is how you get name collisions.

## ClusterIP over NodePort / LoadBalancer
Local testing only. `kubectl port-forward` is enough.

## requests and limits, both
Requests tell the scheduler where the pod fits. Limits stop a runaway
container from starving its neighbors.

## Probes: readiness vs liveness
Readiness gates traffic. Liveness restarts a wedged container.

## No Helm (yet)
One app, three manifests. Helm would be ceremony.
