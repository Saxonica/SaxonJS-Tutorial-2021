# Exercise 9

Continue where you left off in exercise 8.

When a user changes the number of servings, update all of the
quantities in the recipe.

One way to do this is:

* Compute a scaling factor. If the original recipe was for 4 servings
  and the user has selected 6, the scaling factor would be 1.5 (i.e.,
  6 div 4). (Note that you’ll have to find a way to remember the
  original number of servings to make this work).
* Reformat the ingredients section in a mode that multiplies by the
  scaling factor.
* Use `xsl:result-document` to update the ingredients.

Code hints:
* Recall that you can get the value of the option that the user selected
from the `target.value` property with:
```
ixsl:get(ixsl:event(), 'target.value')
```

## Exercise 9 (continued)

Update your answer to exercise 9 so that it only updates the
individual elements that need to be changed.

Code hints:
* If the current context item is a node “under” `ixsl:page()`, you can
update it directly with the special href value “?.”. For example:

```
<xsl:template match="li[@x-quantity]">
  <xsl:result-document href="?." method="ixsl:replace-content">
    <!-- compute new list item here -->
  </xsl:result-document>
</xsl:template>
```
