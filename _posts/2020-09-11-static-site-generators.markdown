---
layout: post
title:  "Static site generators"
date:   2020-09-11 11:24:00 +0100
---

# Static Site Generators
{:.no_toc}

* TOC
{:toc}


I'm inclined to think that almost everyone should use a static-site generator. A static-site generator takes something like markdown and spits out something like HTML. For most websites, a static-site generator is probably the optimum solution. There are some significant advantages to static site generators over dynamically produced sites.

Static site generators are less complicated for beginners to understand. You write your website using something like [markdown](markdown-guide). Then you install something like [python](python-org) and some libraries like [sphinx](sphinx-home). You run sphinx over the markdown and out pops a full website. (This is how this website is created.) To make your website publically available, you can then use something like [Github Pages](github-pages) that will serve the website on your domain. (Again, this is how this site works.) This is less complicated, I think, than setting up a web-site server and then getting it to produce web-pages. The workflows are really quite nice and it isn't too difficult to get comfortable with it.

## Desirable prior experience

It would be helpful, if you want to build a static-site, to have some experience with the following:

- A basic understanding HTML and CSS and maybe JavaScript. After-all, these are the things the static generator will be creating. So it's helpful to understand what you are producing.
- A basic understanding of a programming language. I imagine decent static site generators are almost certainly available in all the major programming languages. Given the ubiquity of the web, most languages will be able to generate static websites. Off the top of my head, I have used generators written in python and ruby generators, and I have probably used generators in other languages as well. And within those two languages, there are quite a few generators to chose from. So which language you've played around with, isn't important. Just find a generator built in the language you've tried.
- An understanding of how to use git or some version-control software. Saving the state of your website is super useful and using some version control software will make that go smoothly. It's also how we deploy websites to Github Pages.


## Advantages of static site generation

Generally, I think static sites have the 'simplicity' advantage over dynamically generated sites. This simplicity helps a lot.

**The content of the site can be kept in version control**

Static sites can be contained entirely within a version control system like git. This means that it's very easy to evolve and change your website, and you have the peace-of-mind that your website's content is backed up within git.

**Speed, security, cost and maintanence**

Static sites tend to have the benefit of speed and security and cost and maintanence.

The first, speed. Static websites are (generally) faster than dynamic websites. Because every single page is already generated, the webserver only needs to find out which page the user is requesting and then can fling it back at them without thinking. Whereas, a dynamic site will require some server-side processing.

Second, because the server does almost _no_ processing of the request, hosting the site poses limited security risks. A user can't really do anything except request a page, and that doesn't result in any 'leaky' or problematic processing on the server. What kind of security risk is there? The request is just sending back fixed responses. Are there security risks? Yes, there can be. But the attack surface is greatly reduced.

**Cost and maintanence**

Third, static sites are so simple you can use something like Github Pages to serve your website. This means you don't have to run or maintain the webserver. Thus your cost to host is zero and you pass almost all maintanence and security considerations onto the hoster - Github. And Github Pages even makes it _free_ for you to host your website with them. (Provided the website's repository is public. I think you might have to pay a small fee if you want to keep the repository private.). It's that easy for them to do it.

Because your pages are static, the hosting company can put the website behind a content-delivery-network that uses caching and other tricks to allow your website to handle huge volumes of page requests super-fast.

In addition, if Github Pages were ever to decide that it did not want to host your website (I believe that is _unlikely_), there are lots of free providers out there. For example, I could host my site on [Read the Docs](read-the-docs-home) just as easily. As they basically use the same build process I use (git -> python -> sphinx). Or if I wanted too, I could easily run my own webserver like nginx to host the site. Or whatever other webserver you might want to use.

**Edit and publish from almost anywhere**

To edit your website, all you need is a computer with the git repository on it (presuming git is your version control system). You simply clone the repository onto your laptop and fetch the latest version. Then you can use a text-editor like [Sublime](sublime-home) to make your changes. And then, you can build your website using your generator. Finally, to deploy the site, you just comit your changes and push to the server. I personally find that quite a lot easier than using a web-gui like the type you find on WordPress sites. All you really need to deploy is an internet connection. And because you push the data once your happy the site is ready, you don't need internet when your editing. And you only need a small amount of internet to push the site to the server, once your ready.

## When aren't static sites enough?

In some ways, I think static generation should be the defacto way for reasonably-technical users to create websites. They require so little to get working and out-perform the alteratives, that there are only some cases when you'd consider an alternative. The most important is if you want to create a dynamic site that does something like process information that is specific to each user visiting the site (like a shopping website or a social media website). If your website needs to know and do things for every user, then making the site dynamic becomes more important and you might begin to consider what is appropriate to do on your webserver's backend. However, even in those circumstances, you'll often have a large amount of static content. And so you may even be able to use a static site generator combined with a dynamic backend. I haven't experimented with that because I haven't needed to, but I don't see why it wouldn't work very well.


## Resources

As typical for the Hitchhikers guide to Python, they have a pretty great section on documentation that includes a lot of information about how to use static-generators to document your code. https://docs.python-guide.org/writing/documentation/

## References

- [markdown-guide]
- [python-org]
- [sphinx-home]
- [github-pages]
- [sublime-home]
- [read-the-docs-home]

[markdown-guide]: https://www.markdownguide.org/
[python-org]: https://www.python.org/
[sphinx-home]: https://www.sphinx-doc.org/en/master/
[github-pages]: https://pages.github.com/
[sublime-home]: https://www.sublimetext.com/
[read-the-docs-home]: https://readthedocs.org/