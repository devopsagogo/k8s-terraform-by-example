# Lab 06 — Debug a CrashLoopBackOff

**Goal:** break the app on purpose, then diagnose it the way you would at 3 AM.

## Steps

1. Open `app/server.py` and change the port from `8080` to `9999`:

~~~python
HTTPServer(("0.0.0.0", 9999), Handler).serve_forever()
~~~

2. Rebuild and redeploy:

~~~bash
docker build -t status-page:local app/
kind load docker-image status-page:local --name kind
kubectl rollout restart deployment/status-page -n status-page
~~~

3. Watch the pods:

~~~bash
kubectl get pods -n status-page -w
~~~

You will see the new pod go `ContainerCreating` → `Running` → `CrashLoopBackOff`.

## Diagnose it

~~~bash
kubectl describe pod <pod> -n status-page
kubectl logs <pod> -n status-page --previous
~~~

**What you'll find:** the readiness probe hits `/health` on port `8080`,
but the app is listening on `9999`. The probe fails, the container never
becomes Ready, and the liveness probe eventually kills and restarts it.

## Check

- The pod shows `0/1` Ready, then `CrashLoopBackOff`
- `kubectl logs --previous` shows the app started, but the probe can't reach it
- `kubectl describe pod` shows `Liveness probe failed: connection refused`

## Question

Why does a **liveness** probe failure cause a restart, but a **readiness**
failure does not?

<details><summary>Answer</summary>

Readiness controls traffic. If readiness fails, the pod is removed from the
Service endpoints but keeps running—Kubernetes assumes it might recover.

Liveness controls restarts. If liveness fails, Kubernetes assumes the process
is wedged and kills the container so it can start fresh.

In this lab, the readiness probe fails first (no traffic), then the liveness
probe fails (restart). That's why you see `CrashLoopBackOff`—the container
is being restarted repeatedly because it never passes liveness.
</details>

## Fix it

Change the port back to `8080` in `app/server.py`, rebuild, redeploy.
The pod goes `Running` `1/1` and the rollout completes.
