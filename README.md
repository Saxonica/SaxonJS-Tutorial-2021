# SaxonJS-Tutorial-2021, version 1.0.4

Last updated on 4 November, 2021.

**Table of contents**
+ [Background](#Background)
+ [Prerequisites](#Prerequisites)
+ [Starting a web server](#Starting-a-web-server)
+ [Running a Java program](#Running-a-Java-program)
+ [Orient yourself!](#Orient-yourself)
+ [Gradle task summary](#Gradle-task-summary)

Welcome! This is the repository for the SaxonJS tutorial that was
presented at
[Declarative Amsterdam](https://declarative.amsterdam/), 2021.

In this repository you will find all of the training
materials used in the course, including the slides, the exercises, and
the answers to the exercises.

You can peek at [the slides](https://saxonica.github.io/SaxonJS-Tutorial-2021/presentation/)
online, but if you’re planning on taking the tutorial, please follow the
instructions for setting things up on your local system.

Start by cloning this repository, or downloading the ZIP file and
unzipping it somewhere on your local system.

If you have any questions or problems, please
[let us know](mailto:norm@saxonica.com) or open an
issue.

The tutorial is configured to run a web server on port 9000. If you
have another application running on that port, you can edit the
`gradle.properties` file and change `serverPort` to another value.
Pick an unused port number larger than 1024.

## Background

SaxonJS runs in the browser and on Node.js without any special
requirements. Any modern browser or Node.js installation can run
SaxonJS directly.

In order to develop a SaxonJS application, you need to be able to run
the Java version of Saxon-EE or the Node.js version of the command line
SaxonJS tool, `xslt3.js`. The `lib` directory of this repository
contains an unrestricted Saxon-EE license that you’re free to use in
this tutorial and in your own experiments until it expires on 15 November, 2021.

This tutorial is focused mostly on SaxonJS running in the browser.
Using the browser is a little easier to set up and it’s easier to write
small, interesting exercises for the browser. The SaxonJS APIs work on
both platforms, so if your interest is in server-side development with
XSLT 3.0, you’ll still get a lot of value out of this tutorial.

## Prerequisites

This tutorial is aimed at users with little or no previous SaxonJS
experience. That’s what we’re going to teach you about!

We assume that you’re familiar with basic web concepts: browsers,
servers, and HTML, mostly. There are a few lines of JavaScript here
and there and maybe a bit of CSS, but it’s not really important that
you have previous experience with those.

You should be comfortable with XML and familiar with XSLT. We’re not
going to do anything too advanced from an XSLT point of view, but
we’ll be using named templates, modes, and parameters. SaxonJS
supports XSLT 3.0, but if most of your experience is with earlier
versions of XSLT, that’s ok.

In order to do the exercises and experiment with the other interactive
parts of this tutorial, you will need three things:

1. A text editing tool that you’re comfortable using. This can be
   something as powerful as [Oxygen](https://www.oxygenxml.com/) or
   Emacs (or VI, if you wish!) or as simple as notepad. You’ll be
   editing XML and XSLT with it, so you’ll likely benefit from syntax
   support for those languages, but it’s not absolutely necessary.
   (If you are using Oxygen, be aware that your version may not have shipped with
   the latest SaxonJS release; we won’t be trying to use its built in facilities
   to work with SaxonJS.)
2. A web server. You’ll be editing files in the exercises and you’ll
   need to be able to serve those files up with `http:` URIs. Modern
   browsers impose a number of limitations on files served with
   `file:` URIs so we’re not going to try to make that work. (It might
   *be* possible, but it’d require turning down some of the security
   settings in your browser and we’re not going to advocate that.)
3. The ability to run Java programs. You’ll need to install Java 8 or
   later in order to use Saxon-EE to compile your stylesheets. If
   you’re unable or unwilling to use Java, you can also use the Node.js
   compiler instead, but for the sake of simplicity, we’re going to
   assume that you can run the Java compiler for most of the
   exercises.

In the sections that follow, we’ll describe some of your options for
setting up a web server and making it easy to run Java programs.

You don’t technically need an internet connection to do the exercises,
but you will need one to download this repository and its software
dependencies. If you think you might not have an internet connection
during the tutorial, make sure you follow the steps below and download
all the dependencies beforehand!

One of the most challenging things about writing a tutorial is
figuring out how to make it possible and practical for everyone to run
the tools that they need to take full advantage of it. It isn’t that
these things are intrinsically hard, it’s just that there are a huge number
of possible ways to do it and each of those ways requires different
levels of technical skill (and sometimes administrative rights to the
system).

Some of you are on Macs, some on Windows, some on Linux. There may
even be a few brave souls on more esoteric platforms.

The interface that’s common and portable across all those platforms is
the shell (though *which* shell is yet another thing that varies).
We’ll be asking you to type commands in the shell window, at the
command line prompt. You don’t have to be a wizard. It’s ok if this is
something you don’t do very often, but we encourage you to take a few
minutes to become familiar with starting and exiting the shell on your
system.

Open the shell window and navigate to the directory where you cloned
the repository or unzipped it. Use the “`cd`” command to make the local
repository directory your “current working directory.”

When something goes wrong (this is programming, something *will* go
wrong), you’ll often find clues about where the problem is by looking
in the console window of your browser. Exactly how you get to the
console window depends on your browser and platform. If you don’t
already know how to open (and close!) the console, take a few minutes
to figure it out. These resources will help:

* In [Chrome](https://developer.chrome.com/docs/devtools/console/)
* In [Firefox](https://developer.mozilla.org/en-US/docs/Tools/Browser_Console)
* In [Edge](https://docs.microsoft.com/en-us/microsoft-edge/devtools-guide-chromium/console/)
* In [Internet Explorer](https://docs.microsoft.com/en-us/previous-versions/windows/desktop/legacy/hh968260(v=vs.85))

If you’re using a different browser, it’s a near certainty that it’s
either “Chrome based” or “Firefox based” and the instructions for one
of those browsers will work. If that’s not the case, putting
“`{browser name} console window`” into your favorite search engine
will find it for you.

## Starting a web server

We propose three options for how to run a web server. You don’t have
to make all of these options work, any one of them will do. There’s no
“better” answer. Anything that works is fine.

(If you have your own web server up and running on your computer
already, you _can_ just use that, but the servers we’re providing here
have some automation features built in that we’ll be relying on to
make the tutorial experience a little more streamlined. We encourage you to
set up one of these.)

### Use Python3

If you have Python3 on your system, or if you can install Python3, a
simple web server is a command away. Open a shell (or command) window
and navigate to the directory where you checked out this repository.

Type this at your command prompt:

```
python3 python/server.py
```

If you get a response like this one, congratulations, you’ve succeeded:

```
Serving HTTP on :: port 9000 (http://[::]:9000/) ...
```

You should now be able to open `http://localhost:9000/hello` in your
browser.

### Use Node

If you don’t have Python3, you can use Node.js. There are a lot of
different versions of node and we can’t test them all. The node
instructions in this tutorial have been tested against Node.js version
16.10.0, but should work on any recent version.

Open a shell (or command) window and navigate to the directory where
you checked out this repository. Then navigate into the `node`
directory.

Type this at your command prompt:

```
npm install
```

There’ll be some frantic activity for a few minutes and you should get
output that looks something like this:

```
added 54 packages, and audited 55 packages in 951ms

found 0 vulnerabilities
```

You may get a variety of warnings. You may have an out-of-date version
of `npm`, for example, or there may be projects seeking funding. If
you don’t get a message that says something failed, you’re probably ok.

If it fails, you’ll have to sort out why. You might need to install a
newer version of Node.js, or upgrade `npm`, or, well, or a lot of
things.

If you didn’t have any errors, or after you’ve fixed them, try this:

```
node server.js
```

If you get a response like this one, congratulations, you’ve succeeded:

```
Node.js express server listening; server root is ..
```

You should now be able to open `http://localhost:9000/hello` in your
browser.

### Use Docker

Docker is a tool for building “containers”. Containers are small,
self-contained environments. It is in many ways the most complicated
option, but it does have one advantage: if you use Docker, you’ll be
using an isolated environment with exactly the versions of the
software we developed against. What you have installed on your local
machine doesn’t really matter (except, of course, that you have to
have Docker installed).

It’s also possible that some of you have laptops that are locked down
tight by your IT departments. If you’re unable or forbidden from
installing new software on your laptop, but you can run Docker
containers, this is an option that might work for you.

Basically, if your reaction to this section was “cool, I can use
Docker” then you’re good. If your reaction was “what’s a Docker?”
that’s totally cool too, but you are likely to find either of the
preceding options a little easier to use.

If Docker is for you, make sure the Docker engine is running, then
open a shell (or command) window and navigate to the directory where
you checked out this repository.

If you’ve never pulled a container from GitHub, you’ll have to authenticate first.
Follow [the instructions](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry) from GitHub.
(Go ahead and set up a personal access token for this purpose. We’re not building an automated
workflow so the remarks about `GITHUB_TOKEN`s don’t really apply.)

After you’ve authenticated, pull the container we built for this
tutorial:

```
docker pull ghcr.io/saxonica/saxon-js-tutorial-2021:test5
```

That’ll download one or more layers, depending on how many other
containers you have installed and whether or not any of them share
layers with our container. It should end with something like this:

```
Digest: sha256:…long string of hexidecimal…
Status: Downloaded image for ghcr.io/saxonica/saxon-js-tutorial-2021:test5
ghcr.io/saxonica/saxon-js-tutorial-2021:test5
```

If it fails, you’ll have to sort out why. You might need to install a
newer version of Docker or, well, or a lot of things.

If you didn’t have any errors, or after you’ve fixed them, try this:

```
$ docker run --rm -p 9000:80 -v `pwd`:/src -e PORT=80 -e ROOTDIR=/src ghcr.io/saxonica/saxon-js-tutorial-2021:test5
```

If you’re on Windows, replace `pwd` and the single quotes that
surround it with the full path where you checked out the repository. For example, if you cloned it
into `C:\Users\Jan\Projects\DA2021\saxonjs`, you’d use

```
-v C:\Users\Jan\Projects\DA2021\saxonjs:/src
```

Where you see

```
-v `pwd`:/src
```

in the command above.

If you get a response like this one, congratulations, you’ve succeeded:

```
Node.js express server listening; server root is /src
```

You should now be able to open `http://localhost:9000/hello` in your
browser.

## Running a Java program

Java applications can be written so that they are “complete”
environments that isolate the user from all their complicated
requirements and dependencies. Unfortunately, that style of
application is not well suited to tools like Saxon-EE.

Saxon-EE is more of a developer tool and is often used as a library in
larger applications. Consequently, it’s dependencies are more exposed.
In order to make it work, you also have to install the other libraries
that it depends on.

That can be done by hand, but it’s tedious and fussy. Modern build
environments take advantage of packaging systems like Maven to
automate most of this complexity.

To that end, we’re going to rely on
[Gradle](https://en.wikipedia.org/wiki/Gradle) and a Gradle build
script to manage those details for us. On the one hand, this will make
things easier and provides a portable, cross-platform solution to the
problems. On the other hand, it introduces a new build tool that isn’t
in any sense required to use SaxonJS.

If you don’t know what Gradle is, and don’t want to, you can treat it
completely like a black box. Type the commands in this tutorial and
it’ll just quietly do its job.

Please make sure you’ve installed Java 8 or later. Open a shell (or
command) window and navigate to the directory where you checked out
this repository.

Type this command at your shell prompt:

```
java -version
```

You should get something like this in response:

```
java version "1.8.0_231"
Java(TM) SE Runtime Environment (build 1.8.0_231-b11)
Java HotSpot(TM) 64-Bit Server VM (build 25.231-b11, mixed mode)
```

The exact details don’t matter, but if you get “command not found” or
some other error, you’ll have to sort that out. If you get some older
version of Java (1.5 for example), you may have to update the
“default” version of Java on your system. That might be something you
can do with your operating system, or maybe it’ll be as simple as
setting the `JAVA_HOME` environment variable. It depends on your
system.

Once you get those details worked out, you’re ready to try Gradle.
Type this:

```
./gradlew helloWorld
```

(On windows, any time we say you should type `./gradlew` followed by
something, you should type `.\gradlew` at the beginning instead, using
a backslash instead of a forward slash.)

If you’ve never run Gradle before, it may take a while. You’ll get a bunch of messages
about things that are being downloaded. That’ll only happen the first
time. The `gradlew` command, short for the “Gradle wrapper” makes
repositories like this self contained, so you don’t have to worry
about what version of Gradle you have (or don’t have) installed
globally.

The output you get should end like this:

```
> Task :helloWorld
Hello, world.

BUILD SUCCESSFUL in 869ms
1 actionable task: 1 executed
```

Congratulations, you’ve got a working Java environment and you’re
“tutorial ready!”

# Orient yourself!

There are about five windows you’ll want to be able to see while you’re doing
the tutorial:

<p width="100%" align="center">
  <img width="80%" alt="Window setup" src="/src/main/resources/orientation.jpg?raw=true" />
</p>

1. The text editor is where you’ll be writing the answers to the exercises.
2. The browser results are the pages you’ll be loading (and reloading) to check your work.
3. The server logs are where you’ll see progress and error messages.
4. The exercise README files have code snippets that you can cut and
   paste to the exercises. (We found it most useful to display these
   from the Github website directly rather than opening them locally.)
5. Us. Or, if you’re not looking at this during _Declarative Amsterdam_
   on the morning of 4 November, 2021, at least
   [the presentation](https://saxonica.github.io/SaxonJS-Tutorial-2021/presentation/).
   
If you have multiple screens, you’ll almost certainly benefit from
spreading the windows around so that you can see them simultaneously.
Barring that, you may want to close some other applications so that
there are fewer windows to switch between.

It can definitely be confusing, so anything you can do to make it
easier will, well, make it easier!

# Gradle task summary

The following Gradle tasks are the ones used in the tutorial.

## Check your configuration

* `checkConfig` tests what software the build script can find on your system. For example:

```
$ ./gradlew checkConfig

> Configure project :
Building with Java version 1.8.0_231

> Task :checkConfig
Found Docker: /usr/local/bin/docker
Found Python: /usr/bin/python3
Found Node: /usr/local/bin/node and /usr/local/bin/npm

BUILD SUCCESSFUL in 936ms
1 actionable task: 1 executed
```

(You may get output that looks slightly different depending on the features of your shell.)

## Run a web server

* `pythonServerStart` and `pythonServerStop` start (and stop,
  respectively) the Python3 web server.
  These tasks will only work if `checkConfig` reported that it could find Python. For example:

```
$ ./gradlew pythonServerStart

> Configure project :
Building with Java version 1.8.0_231

> Task :checkPython
> Task :pythonServerStop
Server started on http://localhost:9000
```

* `nodeServerStart` and `nodeServerStop` start (and stop,
  respectively) the Node.js web server running directly on your computer.
  These tasks will only work if `checkConfig` reported that it could find Node.js. For example:

```
$ ./gradlew nodeServerStart

> Configure project :
Building with Java version 1.8.0_231

> Task :nodeServerStart
NodeJS express server listening; server root is /Path/to/SaxonJS-Tutorial-2021
```

* `dockerServerStart` and `dockerServerStop` start (and stop,
  respectively) the Node.js web server running in a Docker container.
  These tasks will only work if `checkConfig` reported that it could find Docker. For example:

```
$ ./gradlew dockerServerStart

> Configure project :
Building with Java version 1.8.0_231

> Task :pullContainer

> Task :dockerServerStart
NodeJS express server listening; server root is /src
```

> **NOTE** You cannot have two versions of the server running at the same time.
> They each attempt to connect to port 9000 and you’ll get errors if
> there’s already something on that port. Use the “stop” commands to
> shutdown one of the servers if you wish to try another.

## Compile with Java

* `eej` runs the Java Saxon-EE version of the XSLT compiler. Use the Gradle option
`xsl` (`-Pxsl=path/to/stylesheet`) to point to the stylesheet to compile. For example:

```
$ ./gradlew -Pxsl=exercises/ex02/ex02.xsl eej

> Configure project :
Building with Java version 1.8.0_231

> Task :parseCompilerOptions
> Task :eej

BUILD SUCCESSFUL in 2s
2 actionable tasks: 2 executed
```

## Compile with Node

* `node_xslt3` runs the Node.js version of the XSLT compiler running directly on your computer.
Use the Gradle option `xsl` (`-Pxsl=path/to/stylesheet`) to point to the stylesheet to compile.
For example:

```
$ ./gradlew -Pxsl=exercises/ex02/ex02.xsl node_xslt3

> Configure project :
Building with Java version 1.8.0_231

> Task :parseCompilerOptions
> Task :node_xslt3

BUILD SUCCESSFUL in 1s
2 actionable tasks: 2 executed
```

## Compile with Node in Docker

* `docker_xslt3` runs the Node.js version of the XSLT compiler running in Docker.
Use the Gradle option `xsl` (`-Pxsl=path/to/stylesheet`) to point to the stylesheet to compile.
For example:

```
$ ./gradlew -Pxsl=exercises/ex02/ex02.xsl docker_xslt3

> Configure project :
Building with Java version 1.8.0_231

> Task :parseCompilerOptions
> Task :pullContainer
> Task :docker_xslt3

BUILD SUCCESSFUL in 3s
3 actionable tasks: 3 executed
```
