# Exercise 3

In this exercise, you’ll compile an XSLT stylesheet into a SEF file.

Start in the “root” directory where you checked out the repository. (Up two levels from here.)

If you’re using Java, you can compile the stylesheet by running:

```
./gradlew -Pxsl=exercises/ex3/ex3.xsl eej
```

That’s the equivalent of running

```
java com.saxonica.Transform -xsl:exercises/ex3/ex3.xsl \
     -export:exercises/ex3/ex3.sef.json \
     -target:JS -nogo -relocate:on -ns:##html5
```

but using Gradle saves some typing and makes sure that the classpath
and other Java infrastructure is setup correctly.

If you’re using Node, you can compile the stylesheet by running

```
./gradlew -Pxsl=exercises/ex3/ex3.xsl xslt3
```

That’s the equivalent of running

```
node node_modules/xslt3/xslt3.js -xsl:exercises/ex3/ex3.xsl \
     -export:exercises/ex3/ex3.sef.json \
     -nogo -ns:##html5
```

but using Gradle saves some typing and makes sure that the node
environment is setup correctly.

1. Open up `ex3.xsl` in your favorite editor. Find the
`xsl:result-document` instruction and add
`method="ixsl:replace-content` to it.
2. Recompile the stylesheet. (This step is important!)
3. What effect do you think that will have on the result?
4. Load the answer into your browser `http://localhost:9000/exercises/ex3/`
5. Did you remember to add the script lines?
6. Were you right about the effect of the `method` attribute?
