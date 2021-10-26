# Exercise 1

This exercise is just to get you familiar with the “furniture”
necessary to load SaxonJS into the browser.

1. Open `index.html` in your favorite editor.
2. Add a script link to SaxonJS in the `head` of the document:
```
<script type="text/javascript" src="/js/SaxonJS2.rt.js"></script>
```
3. Add another script just below the first to call the `getProcessorInfo()` API. The SaxonJS API includes several
methods, including this one which returns information about the processor.
```
<script>console.log(SaxonJS.getProcessorInfo())</script>
```
4. Open your browser’s console window to view the processor info.
