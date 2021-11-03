# Exercise 8

It’s time to get (mildly) interactive.

Starting with the results of the previous exercise, add a template that will
fire when the user selects a different value for the number of servings.

Detect the `change` event on the `select` element.

In future exercises, we’ll look at the larger problem of actually updating the recipe.

For this exercise, just do something really simple to demonstrate that you’ve
captured the event. For example:

* Use `xsl:message` to write a message to the console,
* or use `xsl:result-document` to update some part of the page,

(If you choose to use `xsl:message`, remember that you’ll have to look at the 
browser console window to see the output!)

The event-handling template should look like this:

```
<xsl:template match="select" mode="ixsl:onchange">
  ...
</xsl:template>
```
