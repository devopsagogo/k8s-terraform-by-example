"""Minimal status-page server. Stdlib only."""
from http.server import BaseHTTPRequestHandler, HTTPServer
from datetime import datetime, timezone

START = datetime.now(timezone.utc)

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            self._send(200, "ok", "text/plain")
        elif self.path == "/":
            uptime = int((datetime.now(timezone.utc) - START).total_seconds())
            body = f"""<!doctype html>
<html><head><title>status</title>
<style>
  body {{ font-family: ui-monospace, monospace; background:#0d1117; color:#c9d1d9;
          display:flex; align-items:center; justify-content:center; height:100vh; margin:0 }}
  .dot {{ display:inline-block; width:10px; height:10px; border-radius:50%;
         background:#3fb950; margin-right:8px }}
  .muted {{ color:#8b949e; font-size:14px }}
</style></head>
<body><div style="text-align:center">
  <h1><span class="dot"></span>All systems operational</h1>
  <p class="muted">uptime {uptime}s · served by status-page</p>
</div></body></html>"""
            self._send(200, body, "text/html")
        else:
            self._send(404, "not found", "text/plain")

    def _send(self, code, body, ctype):
        data = body.encode()
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def log_message(self, *args):
        pass

if __name__ == "__main__":
    HTTPServer(("0.0.0.0", 8080), Handler).serve_forever()
