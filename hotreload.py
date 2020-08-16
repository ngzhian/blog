# Python3 based server for livereload. No dependencies besides the standard library.
# Extended solution from https://stackoverflow.com/a/60753.

# Starts two HTTP server:
# 1. port 8080, serves static files from "dev" directory, which contains generated HTML
#    files that have the necessary JS for livereload
# 2. port 9001, listens for clients initiating connection to "/eventsource", and also
#    listens to "/" as a signal that compilation is done, and to send SSE events to
#    connected clients

from threading import Thread
from socketserver import ThreadingMixIn
from http.server import HTTPServer, ThreadingHTTPServer, BaseHTTPRequestHandler, SimpleHTTPRequestHandler
from functools import partial

clients = []

class EventSourceHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        global clients
        if self.path == '/eventsource':
            clients.append(self.wfile)
            self.send_response(200)
            self.send_header("Content-type", "text/event-stream")
            self.send_header("Cache-Control", "no-cache");
            self.send_header("Connection", "keep-alive");
            self.send_header("Access-Control-Allow-Origin", "*");
            self.end_headers()
        else:
            # Files are built, ask all clients to reload.
            # Clients that dropped out (tab was closed), have their underlying
            # sockets closed, so remove them.
            clients = [c for c in clients if not c.closed]
            for c in clients:
                c.write(bytes("data: reload\n\n", "utf-8"))
            self.send_response(200)
            self.wfile.write(b"OK\n\n");

def serve_on_port(port):
    server = ThreadingHTTPServer(
            ("localhost", port),
            EventSourceHandler)
    server.serve_forever()

def serve_files():
    server = ThreadingHTTPServer(
            ("localhost", 8080), partial(SimpleHTTPRequestHandler, directory="dev"))
    server.serve_forever()

# Start this on another thread.
Thread(target=serve_files).start()
# This runs on main thread.
serve_on_port(9001)
