---
layout: default
title:  Jenkins and Groovy
date:   2020-08-20 09:00:00 +0100
categories: groovy jenkins programming jvm
permalink: /jenkins-and-groovy/
---

# Jenkins and Groovy
{:.no_toc}

* TOC
{:toc}

## Basics

I can recommend this course as pretty good: [pluralsight-automating-jenkins-groovy].

Jenkins works with a plug-in model. Applications that conform to the plug-in standard. Groovy support is implemented as a plugin.

When we install and enable the groovy plugin, we get two extra build steps, `groovy script` and `groovy system script`.

When we’re running groovy inside Jenkins, we get a few extra default imports:

{% highlight groovy %}
import jenkins.*
import Jenkins.model.Jenkins
import hudson.*
import Hudson.model.*
{% endhighlight %}

The formal documentation for the Jenkins api is available at [javadoc-jenkins-ci]

You can run groovy scripts to configure Jenkins when it starts by placing groovy files in a folder `init.groovy.d`. These scripts are run alphabetically, and can be used to dynamically configure Jenkins on start-up.

There is this very important thing at `http://<jenkinsurl>/pipeline-syntax`

There’s also the general documentation here [jenkins-book-pipeline]

And it seems the following page is a reference of steps [jenkins-book-pipeline-steps]

## Creating a test job for jenkinsfile code

If you want to try out a Jenkinsfile on a local Jenkins, without using source-control, just to check whether the jenkinsfile will even run, you can create a Jenkins job

Go to Jenkins front-page, then ‘new-item’, then select ‘pipeline’ and an item name like ‘tempjob’. Then in the job configuration, there’s a pipeline section. With ‘Pipeline script’ as the definition, you can paste in the contents of a Jenkinsfile and run the job, to see what happens.

![jenkins pipeline configuration](/assets/images/jenkins-pipeline-config.png)


## References

- [javadoc-jenkins-ci]
- [jenkins-book-pipeline]
- [jenkins-book-pipeline-steps]
- [pluralsight-automating-jenkins-groovy]

[javadoc-jenkins-ci]: https://javadoc.jenkins-ci.org/
[jenkins-book-pipeline]: https://www.jenkins.io/doc/book/pipeline/
[jenkins-book-pipeline-steps]: https://www.jenkins.io/doc/pipeline/steps/
[pluralsight-automating-jenkins-groovy]: https://www.pluralsight.com/courses/automating-jenkins-groovy
