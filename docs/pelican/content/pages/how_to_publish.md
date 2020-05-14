title: How To Publish
date: 12/05/2020

To publish to this site you should pull the `content` branch. 

If not already installed then install pelican `pip install pelican`

Now checkout the remote branch `content`. This branch should **not** get merged to master:

```bash
git checkout content
cd docs/pelican
```

Check you're in the content branch. You should see a folder called content. 
Go in and make whatever changes are needed by adding `.md` files or modifying existing ones. 

Push your changes to the content branch so they're captured:

```bash
git add .
git commit -m "update static website content"
git push origin content
```

Now you can build the website locally with your content changes, 
publish it and push to your branch

```bash
cd docs/pelican
pelican content -o output -s publishconf.py 
ghp-import -m "Generate Pelican site" --no-jekyll -b gh-pages output
git push origin gh-pages
```

Your changes are now published.
