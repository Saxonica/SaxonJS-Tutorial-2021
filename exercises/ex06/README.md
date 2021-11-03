# Exercise 6

A little warmup exercise with the recipe markup.

You will have noticed in the preceding exercise, and maybe in the
recipe you used for exercise 4, that there are no heading elements in
the recipe pages.

The markup vocabulary designer has taken the position that the title
shouldn’t be repeated in the “source” markup, because repeating
information introduces the risk of discrepancy. The titles for the
sections have also been left out because they can be automatically
generated.

Write a stylesheet that does an “almost identity” transform but copies
the HTML title as a top-level H1 and adds “Ingredients” and
“Directions” headings as H2 elements in the relevant sections.

Remember that you can take advantage of the server to do some of the
tedious work for you. Point your browser at one of the recipes, for
example:

```
http://localhost:9000/recipes/pizza.html?exercise=ex06
```

You can then edit the stylesheet (`ex06.xsl`) and reload to see your
progress. When you think it’s working, try it out on some of the other
recipes, for example Macaroni and Cheese:

```
http://localhost:9000/recipes/mac-n-cheese.html?exercise=ex06
```

Code hints:
1. Get the transform to start modifying the `main` element from the
initial template using something like:
```
<xsl:result-document href="#main" method="ixsl:replace-content">
  <xsl:apply-templates select="ixsl:page()//main"/>
</xsl:result-document>
```
2. Add templates that match on `main`, `div[@id='ingredients']` and
`div[@id='directions']`, starting with something like this.

For the main section, copy the HTML title:

```
<xsl:template match="main">
  <h1><xsl:sequence select="string(/html/head/title)"/></h1>
  <xsl:apply-templates select="node()"/>
</xsl:template>
```

For the ingredients and directions, generate the titles, like this:

```
<xsl:template match="div[@id='ingredients']">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <h2>Ingredients</h2>
    <xsl:apply-templates select="node()"/>
  </xsl:copy>
</xsl:template>
```
