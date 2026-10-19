# Lab 03 — Roll back

**Goal:** deploy a bad change, then roll back without debugging.

Change the heading in `app/server.py`, rebuild, redeploy:

~~~bash
docker build -t status-page:local app/
kind load docker-image status-page:local --name status-page-dev
kubectl rollout restart deployment/status-page -n status-page
kubectl rollout undo deployment/status-page -n status-page
~~~

**Question:** why roll back first instead of debugging in place?

<details><summary>Answer</summary>
Priority is restoring service. Rollback is fast and known-good.
Debug after, in a safe environment.
</details>
