# Exercise 2

In this exercise, you’ll run your first XSLT 3.0 transformation in the browser with SaxonJS!
We’ll cover how you compile an XSLT stylesheet into a “SEF” file in the next exercise.

1. Open `index.html` in your favorite editor.
2. Add a script link to SaxonJS in the `head` of the document:
```
<script type="text/javascript" src="/js/SaxonJS2.rt.js"></script>
```
3. Add a script to run the `ex02.xsl` stylesheet in its compiled form: `ex02.sef.json`:
```
<script>
  window.onload = function() {
    SaxonJS.transform(
      { stylesheetLocation: "ex02.sef.json" },
      "async");
  }
</script>
```
4. Load the answer into your browser `http://localhost:9000/exercises/ex02`
