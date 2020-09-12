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

Jekyll is written in ruby. Visit [https://jekyllrb.com/](jekyll-home).

Jekyll documentation pretty clearly warns you against using it on Windows. That's probably because Ruby is really a linux community and so they only think about Windows after-the-fact.

Thus, if your on Windows, use Windows linux subsystem, and install ruby there. How to [install jekyll](how-to-install-jekyll).

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

I decided to use another one that was good for documentation. In particular, I went for a theme called [Just the Docs](just-the-docs).

Install it with `gem install just-the-docs` then set the `_config.yml` theme to `theme: "just-the-docs"`. And bingo.

## Table of contents

The 'just-the-docs' theme looks like it has a lot of the basic functionality I would like. But I would also really quite like a Table of Content that is present in a manner  like the theme [Mkdocs-Jekyll](mkdocs-jekyll). It is based on Google's material theme. But it has a nice table of contents that sits on right hand side of the page.

But before worrying about placing it on the right-side, how do I get a table of contents at all? I want an auto-generated table of contents.

This seems kind of crazy but _literally_ insert the following into the page where you want to TOC to appear

{% highlight markdown %}
* TOC
{:toc}
{% endhighlight %}

It seems important to have the `* ...` line present before the toc command. I have no idea why. I really have no idea.

[This blog post](blog-jekyll-toc) seems to describe it in more detail. As does [this other page]([ouyi-jekyll-toc]).

And perhaps once you finally get a TOC inserted, you can look at [kramdowns page]([kramdown-toc]) on what you can do with toc.

## Plugins

One of the lovely things about Jekyll is that there seems to be a plugin to do almost anything you'd want on your website.

For example, perhaps you'd like to add a site-map to your websites so search-engines or other tools can find the content of your site more easily. Just google for an appropriate plugin.

I use [jekyll-sitemap](github-sitemap-plugin). The instructions on how to install that plugin are on the readme. But, just for illustration, I'll repeat them here:

> Add `gem 'jekyll-sitemap'` to your site's Gemfile and run bundle.

The Gemfile should be a file in the top-level directory for your site. Just adding the library reference isn't enough. You also need to install the gem into your ruby environment. Do that with bundle by running `bundle install` from the top-level directory of your site.

It should spit out something like

{% highlight text %}
Fetching gem metadata from https://rubygems.org/..........
Fetching gem metadata from https://rubygems.org/.
Resolving dependencies...
Using rake 12.3.1
Using public_suffix 4.0.5
Using addressable 2.7.0
Using bundler 2.1.4
Using colorator 1.1.0
Using concurrent-ruby 1.1.7
Using eventmachine 1.2.7
Using http_parser.rb 0.6.0
Using em-websocket 0.5.1
Using ffi 1.13.1
Using forwardable-extended 2.6.0
Using i18n 1.8.5
Using sassc 2.4.0
Using jekyll-sass-converter 2.1.0
Using rb-fsevent 0.10.4
Using rb-inotify 0.10.1
Using listen 3.2.1
Using jekyll-watch 2.2.1
Using rexml 3.2.4
Using kramdown 2.3.0
Using kramdown-parser-gfm 1.1.0
Using liquid 4.0.3
Using mercenary 0.4.0
Using pathutil 0.16.2
Using rouge 3.22.0
Using safe_yaml 1.0.5
Using unicode-display_width 1.7.0
Using terminal-table 1.8.0
Using jekyll 4.1.1
Using jekyll-feed 0.15.0
Using jekyll-seo-tag 2.6.1
Fetching jekyll-sitemap 1.4.0
Installing jekyll-sitemap 1.4.0
Using just-the-docs 0.3.1
Using minima 2.5.1
Bundle complete! 8 Gemfile dependencies, 34 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
{% endhighlight %}

> Add the following to your site's `_config.yml`

{% highlight yaml %}
url: "https://example.com" # the base hostname & protocol for your site
plugins:
  - jekyll-sitemap
{% endhighlight %}

Now you should be ready to use the new plugin and get it to build your site-map. Run your rake build target. Then you should get a `sitemap.xml` produced in the build directory. This sites sitemap [is output to here](donalmee-sitemap). And it also produces a robots.txt.

The power of plugins!

## Running Jekyll on Windows

In my experience the Ruby community shines on Linux. That's it's home. On Windows, you're likely to run into more issues as the community tends to develop primarily on linux. If your using Jekyll, while there are instructions on how to get it to work on Windows, I wouldn't bother. Because, instead, with Windows Subsystem for Linux (thank you Microsoft!), it's easy to get a linux environment on your Windows box. Personally, that's how I develop this site. I tend to work on a Windows box but I use WSL.

## Use Rake

Rake, I think, is Ruby's take on Make. I'm not that experienced with it. But I know the value of automation. So I recommend you setup Rake to create short-cuts for the things you typically do to develop your site. My basic [Rake file](donalmee-rake-file) (again, in the top-level of the website), looks like this:

{% highlight ruby %}
task default: [:build]

task :build do
    puts "Building site, including search"
    sh("bundle exec jekyll build -d docs")
    sh("cd docs && bundle exec just-the-docs rake search:init")
end

task :serve do
    puts "Serving site"
    sh("bundle exec jekyll serve")
end
{% endhighlight %}

I imagine developers with even a passing understanding of Rake could point out how stupid my use/abuse of `sh` is. I've literally looked at how to use Rake for about 30 minutes, and I just found it was quickest to get my head around how I can use it to get targets that do the shell invocations I do in WSL.

## References

- [jekyll-home]
- [how-to-install-jekyll]
- [just-the-docs]
- [mkdocs-jekyll]
- [kramdown-toc]
- [blog-jekyll-toc]
- [ouyi-jekyll-toc]
- [github-sitemap-plugin]
- [donalmee-rake-file]

[jekyll-home]: https://jekyllrb.com/
[how-to-install-jekyll]: https://jekyllrb.com/docs/installation/ubuntu/
[just-the-docs]: https://pmarsceill.github.io/just-the-docs/
[mkdocs-jekyll]: https://vsoch.github.io/mkdocs-jekyll/
[kramdown-toc]: https://kramdown.gettalong.org/converter/html.html
[blog-jekyll-toc]: https://blog.webjeda.com/jekyll-toc/
[ouyi-jekyll-toc]: https://ouyi.github.io/post/2017/12/31/jekyll-table-of-contents.html
[github-sitemap-plugin]: https://github.com/jekyll/jekyll-sitemap
[donalmee-rake-file]: https://github.com/ddmee/donalmeecom/blob/master/Rakefile
[donalmee-sitemap]: https://github.com/ddmee/donalmeecom/tree/master/docs/sitemap.xml
