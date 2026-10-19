# Lab 01 — Deploy and verify

**Goal:** get the app running and prove it serves traffic.

~~~bash
./scripts/deploy.sh
kubectl get pods -n status-page
kubectl get svc -n status-page
~~~

**Check:** two pods `Running` `1/1`, Service `status-page` exists.

**Question:** why does the Service use `targetPort: 8080` when `port` is `80`?

<details><summary>Answer</summary>
`port` is what the Service listens on. `targetPort` is the container port.
The app listens on 8080; the Service exposes 80 and forwards.
</details>
