# Runbook

Operational procedures for the status-page app. Short, specific, in the order
you'd actually do them.

## Pod stuck in Pending

~~~bash
kubectl describe pod <pod> -n status-page
~~~

Look at **Events** at the bottom. It will say one of:
- `0/3 nodes available: insufficient cpu` → the cluster is full
- `pod has unbound PVC` → storage isn't provisioned
- `node(s) didn't match node selector` → affinity rules exclude every node

Pending is a scheduling problem. The event tells you which.

## Pod in CrashLoopBackOff

~~~bash
kubectl logs <pod> -n status-page --previous
kubectl describe pod <pod> -n status-page
~~~

`--previous` shows the crashed container's logs, not the current attempt.
Then check the exit code in `describe`:
- **1** → app error, read the logs
- **137** → OOMKilled, the container hit its memory limit
- **143** → SIGTERM, something stopped it

## OOMKilled

~~~bash
kubectl describe pod <pod> -n status-page | grep -A2 "Last State"
kubectl top pod -n status-page
~~~

137 means the kernel killed it for exceeding the memory limit.
Raising the limit only helps if usage is stable. If it climbs, it's a leak—
look at the app, not the limit.

## Rollout stuck

~~~bash
kubectl rollout status deployment/status-page -n status-page
kubectl get rs -n status-page
kubectl describe deployment status-page -n status-page
~~~

If the new ReplicaSet can't get pods Ready, the rollout hangs.
Roll back first, debug after:

~~~bash
kubectl rollout undo deployment/status-page -n status-page
kubectl rollout status deployment/status-page -n status-page
~~~

## Readiness vs liveness

- **Readiness failing** → pod removed from Service endpoints, no traffic. Pod stays up.
- **Liveness failing** → container restarted. Pod may stay Running but the container cycles.

Check which one:

~~~bash
kubectl describe pod <pod> -n status-page | grep -A3 -E "Readiness|Liveness"
~~~

## Service returns 502 but pods are Running

Check endpoints first:

~~~bash
kubectl get endpoints status-page -n status-page
~~~

If endpoints are empty, the Service selector doesn't match the pod labels.
If endpoints exist, check the ingress/port-forward target and the container port.
