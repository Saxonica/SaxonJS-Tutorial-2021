'use strict';

const express = require('express');
const fs = require('fs');
const path = require('path');
const querystring = require('querystring');
const { exec } = require('child_process');

const app = express();
let server;

// Where are we?
const root = path.resolve(process.env.ROOTDIR || "..");
const port = process.env.PORT || "9000";

app.disable('x-powered-by');

app.use(function timeLog (req, res, next) {
  console.log(`${req.method} ${req.originalUrl}`);
  next();
});

app.post('/stop', (request, response) => {
  response.status(200).send("OK");
  server.close();
});

app.get(/^.*/, (request, response) => {
  let fn = `${root}${request.url}`;
  show_file(request, response, fn);
});

function show_file(request, response, fn) {
  let pos = fn.indexOf("?");
  let query = {};
  if (pos >= 0) {
    query = querystring.parse(fn.substring(pos+1));
    fn = fn.substring(0, pos);
  }

  fs.readFile(fn, null, (error, data) => {
    if (error) {
      if (error.code == 'EISDIR') {
        show_dir(request, response, fn);
      } else {
        if (fn === `${root}/favicon.ico`) {
          fakeicon(request, response);
          return;
        } else {
          console.log(`Error reading ${fn}:`);
          console.log(error);
        }
        response.status(404).send("Not found.");
      }
      return;
    }

    let ext = "unknown";
    let pos = fn.lastIndexOf(".");
    if (pos >= 0) {
      ext = fn.substring(pos+1);
      response.type(ext);
    }

    if ("answer" in query || "exercise" in query) {
      patch(request, response, data, query);
    } else {
      response.status(200).send(data);
    }
  });
}

function patch(request, response, data, query) {
  let html = data.toString();
  let pos = html.indexOf("</head>");

  let stylebase = "";
  let params = {};

  if ("answer" in query) {
    stylebase = `/answers/${query['answer']}/${query['answer']}`;
    delete query['answer'];
  } else {
    stylebase = `/exercises/${query['exercise']}/${query['exercise']}`;
    delete query['exercise'];
  }

  let script = "<script src='/js/SaxonJS2.rt.js'></script>\n";
  script += "<script>\n";
  script += "window.onload = function() {\n";
  script += "  SaxonJS.transform({\n";
  script += `  stylesheetLocation: '${stylebase}.sef.json'`;

  if (Object.entries(query).length === 0) {
    script += "\n";
  } else {
    script += ",\n";
    script += `  stylesheetParams: ${JSON.stringify(query)}\n`;
  }
  script += "}, 'async');\n";
  script += "}\n</script>\n";

  return checkCompile(request, response, root + stylebase,
                      html.substring(0, pos) + script + html.substring(pos));
}

function checkCompile(request, response, stylebase, html) {
  const xsl = `${stylebase}.xsl`;
  const sef = `${stylebase}.sef.json`;

  try {
    let sefstat = fs.statSync(sef);
    let xslstat = fs.statSync(xsl);
    if (sefstat.mtime < xslstat.mtime) {
      return compile(request, response, stylebase, html);
    }
  } catch (e) {
    return compile(request, response, stylebase, html);
  }

  response.status(200).send(html);
}

function compile(request, response, stylebase, html) {
  let cmd = "node node_modules/xslt3/xslt3.js -t "
      + `-xsl:${stylebase}.xsl `
      + `-export:${stylebase}.sef.json `
      + "-nogo -ns:##html5";

  console.log("Compiling XSL with xslt3.js");
  const child = exec(cmd, (error, stdout) => {
    if (stdout) {
      console.log(stdout);
    }
    if (error) {
      console.log(error);
    }
    response.status(200).send(html);
  });
}

function show_dir(request, response, dir) {
  if (!request.url.endsWith("/")) {
    response.location(request.url + "/");
    response.status(301).send("Redirect to " + request.url + "/");
  } else {
    let index = dir + "index.html";
    fs.readFile(index, null, (error, data) => {
      if (error) {
        let displayDir = dir.substring(root.length);
        let html = "<body>";
        html += `<h1>Directory listing for ${displayDir}</h1>`;
        html += "<hr/>";
        html += "<ul>";

        if (displayDir.split("/").length > 2) {
          html += "<li>[<a href='../'>Parent</a>]</li>";
        }

        // It's bad practice to use synchronous calls in Node.js.
        // But it's also a lot simpler and this is a completely
        // toy server.
        fs.readdirSync(dir).forEach(fn => {
          let stat = fs.statSync(dir + fn);
          let link = fn;
          if (stat.isDirectory()) {
            link += "/";
          }
          html += `<li><a href='${link}'>${fn}</a></li>`;
        });

        html += "</ul>";
        html += "<hr/>";
        html += "</body>";
        response.status(200).send(html);
        return;
      }
      show_file(request, response, index);
    });
  }
}

function fakeicon(request, response) {
  const base64 = ["iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAABGdBTUEAALGPC/xh",
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
            "MjEtMTAtMTNUMTM6NTg6MDkrMDA6MDB2PdqkAAAAAElFTkSuQmCC"].join("");
  const buf = Buffer.from(base64, 'base64');
  response.type("png");
  response.status(200).send(buf);
};

server = app.listen(port, () => {
  console.log(`Node.js Express server listening on port ${port}.`);
  console.log(`Server root directory: ${root}`);
});
