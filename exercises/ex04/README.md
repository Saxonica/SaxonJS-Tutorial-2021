# Exercise 4

In this exercise, we’ll try out the “let the server fix it for you” feature.

Both the Python and Node (and Dockerized Node) web servers will
automatically add the script headers to any documents they serve if
you pass them as parameters to the script.

Point your browser at one of the recipes, for example:
http://localhost:9000/recipes/pizza.html

You’ll see a fairly plain and in many ways incomplete recipe. We’re
going to fix those things in future exercises.

(If you open
http://localhost:9000/recipes/ you’ll get a list of the recipes, as you
might have expected.)

Make sure you have the server running in a shell window that you can see.

Now add “?exercise=ex04” to the URI: http://localhost:9000/recipes/pizza.html?exercise=ex04

You should see the transformed output this time.

If you’re using the Python server, you should see something like this in the shell window
where the server is running:

```
127.0.0.1 - - [21/Oct/2021 15:04:30] "GET /recipes/pizza.html?exercise=ex04 HTTP/1.1" 200 -
127.0.0.1 - - [21/Oct/2021 15:04:30] "GET /js/SaxonJS2.rt.js HTTP/1.1" 200 -
> Task :pythonServerStart
> Configure project :
Building with Java version 1.8.0_231
> Task :parseCompilerOptions
> Task :eej
BUILD SUCCESSFUL in 8s
2 actionable tasks: 2 executed
127.0.0.1 - - [21/Oct/2021 15:04:39] "GET /exercises/ex04/ex04.sef.json HTTP/1.1" 200 -
```

If you’re using Node.js, you’ll get the slightly less chatty output:

```
GET /recipes/beef-stroganof.html?exercise=ex04
Compiling XSL with xslt3.js
GET /js/SaxonJS2.rt.js
GET /exercises/ex04/ex04.sef.json
```

There’s one more trick to show you in this exercise. Edit the
stylesheet `ex04.xsl` so that the “it worked” message is different and
save the XSL file.

*Before* you recompile the SEF file, hit reload in the browser.

Magic!

The browser will also automatically recompile your XSL file if it’s
newer than the corresponding SEF file.

That’s going to save you some time!
