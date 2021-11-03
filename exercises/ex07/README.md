# Exercise 7

Let’s make a more interesting change to the markup this time. Over the
next few exercises, we’re going to make it possible to change the
number of servings and have the recipe recalculate the ingredients
quantities automatically.

As a first step, let’s replace the “servings” text with a pull down menu.
If you don’t remember the HTML for a pull down, it looks like this:

```
<select>
  <option value="1">1</option>
  <option value="2">2</option>
  <option value="4">4</option>
  <option value="6">6</option>
</select>
```

Start with either your answer from exercise 6, or ours. Whichever you
prefer.

You can influence which option the browser treats as initially selected with
a `selected` attribute. For example:

```
<select>
  <option value="1">1</option>
  <option value="2">2</option>
  <option selected="selected" value="4">4</option>
  <option value="6">6</option>
</select>
```
