""" Saxon-JS Tutorial Web Server """

import re
import os
import sys
import json
import base64
import subprocess
from io import StringIO
from pathlib import Path
from http.server import BaseHTTPRequestHandler, HTTPServer

HOSTNAME = "localhost"
HOSTPORT = 9000

class Unbuffered(object):
    def __init__(self, stream):
        self.stream = stream
    def write(self, data):
        self.stream.write(data)
        self.stream.flush()
    def writelines(self, datas):
        self.stream.writelines(datas)
        self.stream.flush()
    def __getattr__(self, attr):
        return getattr(self.stream, attr)

class TutorialServer(BaseHTTPRequestHandler):
    """ A trivial web server, but with some fixup for exercises and answers. """

    CONTENT_TYPES = {".html": "text/html",
                     ".txt": "text/plain",
                     ".css": "text/css",
                     ".svg": "image/svg+xml",
                     ".xml": "application/xml",
                     ".json": "application/json",
                     ".js": "text/javascript",
                     ".png": "image/png",
                     ".jpeg": "image/jpeg",
                     ".jpg": "image/jpeg"}

    def do_POST(self):
        """ Repond to HTTP POST requests. """
        if self.path == "/stop":
            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            self.wfile.write(bytes("Stopping\n", "utf-8"))
            sys.exit(0)
        else:
            self.send_response(405)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            self.wfile.write(bytes("POST is not allowed\n", "utf-8"))

    def do_GET(self):
        """ Repond to HTTP GET requests. """

        if self.path == "/favicon.ico":
            self.fake_icon()
            return

        filename = self.path
        if "?" in filename:
            filename = filename[0:filename.index("?")]

        path = Path(os.getcwd() + filename)

        if re.match("^/answers/.*\\.sef\\.json$", filename) \
          or re.match("^/exercises/.*\\.sef\\.json$", filename):
            self.recompile(path)

        if path.exists():
            if path.is_dir():
                self.show_directory(path)
            else:
                self.show_file(path)

    def show_file(self, path):
        self.send_response(200)

        content_type = "application/octet-stream"
        if path.suffix in TutorialServer.CONTENT_TYPES:
            content_type = TutorialServer.CONTENT_TYPES[path.suffix]

        self.send_header("Content-type", content_type)

        self.end_headers()

        params = {}
        if "?" in self.path:
            query = self.path[self.path.index("?")+1:]
            for data in query.split("&"):
                pos = data.index("=")
                if pos > 0:
                    params[data[0:pos]] = data[pos+1:]

        if "answer" in params:
            self.patch_html(path, "answer", params)
        elif "exercise" in params:
            self.patch_html(path, "exercise", params)
        else:
            with open(path, "rb") as file:
                bytes = file.read(4096)
                while bytes:
                    self.wfile.write(bytes)
                    bytes = file.read(4096)

    def patch_html(self, path, styledir, params):
        sef = params[styledir]
        del params[styledir]

        with open(path, "r") as file:
            html = "".join(file.readlines())
            pos = html.index("</head>")

            self.wfile.write(bytes(html[0:pos], "utf-8"))

            self.wfile.write(bytes("<script src='/js/SaxonJS2.rt.js'></script>", "utf-8"))
            self.wfile.write(bytes("<script>\n", "utf-8"))
            self.wfile.write(bytes("window.onload = function() {\n", "utf-8"))
            self.wfile.write(bytes("  SaxonJS.transform({", "utf-8"))

            comma = ""
            if params:
                comma = ","

            self.wfile.write(bytes("   stylesheetLocation: '/%ss/%s/%s.sef.json'%s"
                                   % (styledir, sef, sef, comma), "utf-8"))

            if params:
                self.wfile.write(bytes("   stylesheetParams: %s" % json.dumps(params), "utf-8"))

            self.wfile.write(bytes("}, 'async');\n", "utf-8"))
            self.wfile.write(bytes("}\n</script>", "utf-8"))

            self.wfile.write(bytes(html[pos:], "utf-8"))

    def show_directory(self, path):
        index = path.joinpath("index.html")
        if index.exists():
            url = self.path
            if not url.endswith("/"):
                url += "/"
            url += "index.html"
            self.redirect(url)
            return

        if not self.path.endswith("/"):
            self.redirect(self.path + "/")
            return

        body = StringIO()
        body.write("<body>")

        relpath = str(path)[len(os.getcwd()):]
        if relpath == "":
            relpath = "/"
        
        body.write("<h1>Directory listing for '%s'</h1>" % relpath)
        body.write("<hr/>")

        body.write("<ul>")

        if relpath != "/":
            body.write("<li>[<a href='../'>Parent</a>]</li>\n")

        for fn in os.listdir(path):
            rsrc = path.joinpath(fn)

            link = fn
            if rsrc.is_dir():
                link = link + "/"

            body.write("<li><a href='%s'>%s</a></li>" % (link, fn))
        body.write("</ul>")
        body.write("<hr/>")
        body.write("</body>")

        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(bytes("<html><head><title>%s</title></head>" % path, "utf-8"))
        self.wfile.write(bytes(body.getvalue(), "utf-8"))
        self.wfile.write(bytes("</html>", "utf-8"))

    def recompile(self, sef):
        pos = str(sef).index(".sef.json")
        xsl = Path(str(sef)[0:pos] + ".xsl")
        try:
            newer = sef.stat().st_mtime < xsl.stat().st_mtime
        except FileNotFoundError:
            newer = True
        
        if newer:
            relpath = str(xsl)[len(os.getcwd())+1:]
            subprocess.run(["./gradlew", "-Pxsl=%s" % relpath, "eej"])

    def fake_icon(self):
        self.send_response(200)
        self.send_header("Content-type", "image/png")
        self.end_headers()

        bytes = base64.b64decode("".join([
            "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAABGdBTUEAALGPC/xh",
            "BQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAB",
            "X1BMVEXn8PHk7vDl7/Dm8PHf6u7F0eDCz97Bzt7l7/Hg6+7X4unO2uTD0N6wvtSy",
            "wda4xtm/zN3h7O7Azt2WqMaClrx8kbl9kbl7j7h6j7h/k7qNn8KpudHj7e+wv9R5",
            "jbeBlbultc6+zNyvvtSmts+TpcV4jLacrcrAzd3o8PLW4ejE0d/f6e3Cz993jLbo",
            "8fLU3+eAlLt5jrfj7vDE0eC+y9yjs82fsMu3xdjh6+6nt892i7Z+krqcrsq1w9e7",
            "ydu/zd3Dz9+8ytp8kLiDlryMn8GdrsqxwNXg6u7G0+CUpsaIm791irW6x9rm7/Hd",
            "5+ze6O3E0N+ltc+BlLtzibSXqMfAzd7k7fCktM2uvdPd6O3D0N+gsMxziLS9yty2",
            "xde7yNuPosN6jreVp8avvtO5x9mrutKmtc+ZqsiEmL12i7XD0d5+krmfsMzCzt7b",
            "5uvV4OjK1+Kzwtazwte9y9z///9ckkS+AAAAAWJLR0R0322obQAAAAd0SU1FB+UK",
            "DQ06HAv38YgAAAD1SURBVBjTY2BgBAImZhZWNjZ2EGAACnBwcnHz8PLxC7BBBASF",
            "hEVExcQlJKWkBUACMrJy8gqKbErKKhKqaursDBqaInJaHMzarDrsyroSfDoMevoG",
            "hmxGzNrG7OwmpmbmbAwMFpZW1ja2bPx29joOOmBDtR1VDFR1nZxdXN3AhjJyMLvr",
            "e7h5ell7S6j4sDP4+nH5M3EwswSY8AcGBYeEMoSFS0YwMTJGRrGzRUXHeMUyaMR5",
            "y7NZAJ2uwxafEKOizsCgbSmXmJSckpqWnpHpZQu0ltEiy9VLUlRcItsrxycX4jmZ",
            "vPyCwiL+YqjnQN7n0IZ5HwDkUSR0fRGbDQAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAy",
            "MS0xMC0xM1QxMzo1ODoxNyswMDowMJv1GdsAAAAldEVYdGRhdGU6bW9kaWZ5ADIw",
            "MjEtMTAtMTNUMTM6NTg6MDkrMDA6MDB2PdqkAAAAAElFTkSuQmCC"]))

        self.wfile.write(bytes)

    def redirect(self, path):
        self.send_response(200)

        content_type = "text/html"
        self.send_header("Content-type", content_type)
        self.send_header("Location", path)
        self.end_headers()

        html = "<html><head><title>Redirect</title>"
        html += "<meta http-equiv='refresh' content='0;%s'>" % path
        html += "</head><body><p>"
        html += "<a href='%s'>Redirect</a>" % path
        html += "</p></body></html>"

        self.wfile.write(bytes(html, "utf-8"))


if __name__ == "__main__":
    sys.stdout = Unbuffered(sys.stdout)
    sys.stderr = Unbuffered(sys.stderr)
    
    server = HTTPServer((HOSTNAME, HOSTPORT), TutorialServer)
    print("Server started on http://%s:%s" % (HOSTNAME, HOSTPORT))

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass

    server.server_close()
    print("Server stopped.")
