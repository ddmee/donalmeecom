---
layout: default
title:  Jekyll
date:   2020-08-19 20:56:00 +0100
categories: ruby programming
permalink: /jekyll/
---

# Jekyll
{:.no_toc}

* TOC
{:toc}

I've been looking for a static site generator for a while. And at some point even wrote my own. However, because I don't want to maintain my own, I want to use someone elses. I am looking for a few things:
- static site generation so the site can be hosted on github pages
- generated from source so changes to the site can be stored in git
- quicky and easy
- looks decent
- site generated from markdown

HTML is a hateful markup language for humans to write. You need something on top of it to achieve some level of sanity. Markdown is a nice simple markup language. And I am pretty happy writing text files and then using markdown. Thus, I want a site-generator that converts markdown to fairly decent, lightweight HTML. Without any crazy backends like PHP dynamically generating the site from a database. That sounds so awful.

## Basics

Jekyll is written in ruby. Visit [https://jekyllrb.com/](https://jekyllrb.com/).

Jekyll documentation pretty clearly warns you against using it on Windows. That's probably because Ruby is really a linux commnuity and so they only think about Windows after-the-fact.

Thus, if your on Windows, use Windows linux subsystem, and install ruby there.

Please know a fair amount of what follows if just copy-pasted from other sites so I don't have to go fishing for those places. Credits are in the Reference section.

{% highlight bash %}
sudo apt-get install ruby-full build-essential zlib1g-dev
# Avoid installing gems in system ruby
echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
# Install jekyll
gem install jekyll bundler
# Create a new site at /blog dir
jekyll new myblog
cd myblog
# Server the site. The site auto-refreshes.
bundle exec jekyll serve
{% endhighlight %}

I think the rest is fantastically straight-forward to be honest. Once you have tried it a little bit at first.

## Themes

You'll see a remarkedly small amount of 'source' files in your site folder. This is because the default shipped theme 'minima' is actually installed as a ruby gem. The `_posts` directory is were your blog posts appear. Then there is a `_config.yml` that does some site-wide configuration, including selecting the theme. And there is an index/about page in markdown. This is super small.

Then, when you invoke `bundle exec jekyll serve` it a `_site` directory that has all this HTML and stuff. Where does this come from? Well it comes from the ruby gems you installed, jekyll and the default theme. Pretty neat.

How then do you change the theme or view where the files for the minima theme are? The minima theme is a gem, so actually you can see where on the file system it's installed with
` bundle info --path minima`. But, obviously editing the package directly isn't the supported way to alter or customise the theme. However, I don't particularly want to use the minima theme.

I decided to use another one that was good for documentation. In particular, I went for a theme called [just-the-docs](https://pmarsceill.github.io/just-the-docs/).

Install it with `gem install just-the-docs` then set the `_config.yml` theme to `theme: "just-the-docs"`. And bingo.

## Table of contents

The 'just-the-docs' theme looks like it has a lot of the basic functionality I would like. But I would also really quite like a Table of Content that is present in a manner  like the theme [Mkdocs-Jekyll](https://vsoch.github.io/mkdocs-jekyll/). It is based on Google's material theme. But it has a nice table of contents that sits on right hand side of the page.

But before worrying about placing it on the right-side, how do I get a table of contents at all? I want an auto-generated table of contents.

This seems kind of crazy but _literally_ insert the following into the page where you want to TOC to appear

{% highlight markdown %}
* TOC
{:toc}
{% endhighlight %}

It seems important to have the `* ...` line present before the toc command. I have no idea why. I really have no idea.

This blog post seems to describe it in more detail https://blog.webjeda.com/jekyll-toc/. As does this page https://ouyi.github.io/post/2017/12/31/jekyll-table-of-contents.html.

And perhaps once you finally get a TOC inserted, you can look at kramdowns page on what you can do with toc. https://kramdown.gettalong.org/converter/html.html

## References

- https://jekyllrb.com/docs/installation/ubuntu/
- https://pmarsceill.github.io/just-the-docs/
- https://blog.webjeda.com/jekyll-toc/

