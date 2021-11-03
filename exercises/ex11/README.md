# Exercise 11

Each recipe has a category. The “endpoint” ¹

```
http://localhost:9000/recipes/categories.json
```

returns a JSON payload that identifies each recipe by category:

```
{
  "main": ["beef-stroganof.html", "mac-n-cheese.html", "marys-beef-stew.html", "pizza.html"],
  "side": ["rice-a-roni.html"],
  "candy": ["treacle-taffy.html"]
}
```

Write a stylesheet that will retrieve this document and let the user
navigate between categories and recipes.

* Start with the categories HTML file: http://localhost:9000/recipes/categories.html
* Write a stylesheet that formats the “`categories`” division with the list of categories.
* If you have time, make the stylesheet display all of the recipes in each category when a category is selected.

¹ This isn’t an endpoint in any real sense because we don’t have any sort
of database in this tutorial. It’s just a JSON document. But the principles
are exactly the same.
