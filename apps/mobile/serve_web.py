"""Threaded static server for the Flutter web build (dev preview only).
Serves build/web on 127.0.0.1:8080 with correct .wasm / .js MIME types and
handles the parallel requests Flutter's bootstrap makes. Not for production."""
import http.server
import socketserver
from functools import partial

PORT = 8080
DIRECTORY = "build/web"


class Handler(http.server.SimpleHTTPRequestHandler):
    extensions_map = {
        **http.server.SimpleHTTPRequestHandler.extensions_map,
        ".wasm": "application/wasm",
        ".js": "text/javascript",
        ".mjs": "text/javascript",
        ".json": "application/json",
    }

    def end_headers(self):
        # Flutter CanvasKit streaming compile needs these; also disable caching.
        self.send_header("Cache-Control", "no-store")
        super().end_headers()


class ThreadingHTTPServer(socketserver.ThreadingMixIn, http.server.HTTPServer):
    daemon_threads = True
    allow_reuse_address = True


if __name__ == "__main__":
    handler = partial(Handler, directory=DIRECTORY)
    with ThreadingHTTPServer(("127.0.0.1", PORT), handler) as httpd:
        print(f"Serving {DIRECTORY} at http://127.0.0.1:{PORT}")
        httpd.serve_forever()
