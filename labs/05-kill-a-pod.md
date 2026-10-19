# Lab 05 — Kill a pod, watch it come back

**Goal:** prove that `replicas: 2` is doing real work.

## Steps

List the pods and note their names:

~~~bash
kubectl get pods -n status-page
~~~

Pick one and delete it:

~~~bash
kubectl delete pod <pod-name> -n status-page
~~~

Watch the replacement appear:

~~~bash
kubectl get pods -n status-page -w
~~~

You will see a new pod with a new name go from `ContainerCreating`
to `Running` `1/1`.

## Check

- The deleted pod is gone
- A new pod appeared with a different name
- The Deployment still reports `2/2` ready

~~~bash
kubectl get deployment status-page -n status-page
~~~

## Question

Why does Kubernetes create a *new* pod instead of restarting the deleted one?

<details><summary>Answer</summary>

A Deployment does not manage pods directly. It manages a **ReplicaSet**,
and the ReplicaSet's job is to keep the desired count of pods running.
When a pod is deleted, the ReplicaSet sees one fewer pod than desired and
creates a new one. The new pod is a fresh object with a new name—pods are
treated as disposable, not as pets.

That is the difference between a Deployment and a StatefulSet. A
StatefulSet keeps stable pod identities (`db-0`, `db-1`) precisely because
some workloads *do* need the same pod to come back.
</details>

## Bonus

Try scaling to zero and back:

~~~bash
kubectl scale deployment status-page -n status-page --replicas=0
kubectl get pods -n status-page
kubectl scale deployment status-page -n status-page --replicas=2
kubectl get pods -n status-page -w
~~~

Same lesson: the Deployment is the desired state, the ReplicaSet is the
controller, the pods are disposable.
