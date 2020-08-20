---
layout: default
title:  Chef
date:   2020-08-20 08:00:00 +0100
categories: chef programming ruby
permalink: /chef/
---

# Chef Kitchen
{:.no_toc}

* TOC
{:toc}

##Background

Un-testable infrastructure is more hassle than it’s worth. Or at least, it’s difficult to deploy updates to the infrastructure, unless you’re already very familiar with it.

Chef is a configuration-management toolkit written in Ruby. You can write ‘recipes’ (scripts) that will setup a machine for you. It’s part of the infrastructure-as-code movement.

In dev-ops, if it deploys it works. That is the test. Correct? Well, I disagree. I think dev-ops requires solid automated tests, just like any other bit of your code-base. General cavets apply.

Why introduce something like Chef if it becomes hard to change? While Chef offers the possibility of reducing your operation burden provisioning machines, untested Chef recipes increase your deployment friction. Thus, I believe, it’s important to consider how you can test recipes as you write ones for your environment.

I.e. Chef might be great at helping you setup lots of machines, but how do you change your Chef setup without knowing you haven’t borked all your machine setups? Hmm.

Thankfully, Chef provides some tools to help you do your job.

## What is Chef?

You can find out about Chef at https://www.chef.io/

You’ll find the company has really over-used the chef/kitchen/food/knife/supermarket analogy. Every bit of their product seems to be named after some part of the food preparation process. I guess they are analogising cooking your machines with provisioning your food. But I find the naming convention a bit irritating. However, it is distinctive.

## Chef Infra

While Chef offers a few products, I believe the core of the project started around what is now called Chef Infra https://www.chef.io/products/chef-infra/ Visit the website for their sales pitch around how Chef makes your sex-life better.

I believe, in essence, Chef runs an executable on each machine you want to configure via chef. This is called the Chef client. You pass the chef client a recipe or a bunch of recipes, written in a Ruby-based Chef-developed domain-specific-language. The important idea is the recipes are meant to be idempotent (idempotent means the recipe can be run again and again and the result will always be the same). This is meant to mean that you can bring your machine into ‘compliance’ with the recipe by just re-running it whenever. As chef recipes are extendable and you can write your own, obviously you can break the idempotency of the recipe. But that’s your responsibility.

Apart from the idea of idempotency and providing a toolkit of recipes you can use, I don’t think there’s much else special about Chef. It is written in Ruby which will please some and annoy others. There are competitors, for example like Ansible written in Python. And for your environment, you may just be best considering the language your team is most comfortable with. There’s not a whole lot of point introducing Chef if your working environment has a strong preference for Python. Opt for ansible then. Or, etc, whatever configuration toolkit uses a language your team members are most familiar with.

Infra documentation begins at https://docs.chef.io/chef_overview/

## Starting out with Chef

Chef have quite polished tutorials at https://learn.chef.io. Though, they also leave a lot of questions unanswered. They aren't particularly comprehensive. But give a reasonable introduction.

You want to check that you have chef installed on your development machine. Run

{% highlight bash %}
>chef --version
ChefDK version: 4.7.73
Chef Infra Client version: 15.7.32
Chef InSpec version: 4.18.51
Test Kitchen version: 2.3.4
Foodcritic version: 16.2.0
Cookstyle version: 5.20.0
{% endhighlight %}

Note, Chef is fundamentally about provisioning machines. So, unless you want to alter your development machine, you need some way to spawn new machines. Chef typically uses this Test Kitchen to run tests on recipes.

Check Test Kitchen is available, run

{% highlight bash %}
>kitchen --version
Test Kitchen version 2.3.4
{% endhighlight %}

Test kitchen can be extended to start any sort of machine, but most of the tutorials show you have to use VirtualBox and Vagrant to start machines.

Check Vagrant is available, run

{% highlight bash %}
>vagrant --version
vagrant 2.2.9
{% endhighlight %}

What is Vagrant? It’s a tool for managing (starting/stopping/deleting) virtual-machines, using providers like VMWare, AWS, Docker, VirtualBox etc.

Create a directory called ‘learn-chef-infra’ then generate the minimum required files using a generate command. Run

{% highlight bash %}
>mkdir chef-learn-infra
>cd chef-learn-infra
>chef generate cookbook learn_chef
{% endhighlight %}

Generating cookbook learn_chef
- Ensuring correct cookbook content
- Committing cookbook files to git

Your cookbook is ready. Type `cd learn_chef` to enter it.

There are several commands you can run to get started locally developing and testing your cookbook.

Type `delivery local --help` to see a full list of local testing commands.

Why not start by writing an InSpec test? Tests for the default recipe are stored at:
`test/integration/default/default_test.rb`

If you'd prefer to dive right in, the default recipe can be found at:
`recipes/default.rb`

You’ll see that this has created a bunch of files in the directory.

```
C:\dev\chef\learn-chef-infra\learn_chef
C:\dev\chef\learn-chef-infra\learn_chef\.delivery
C:\dev\chef\learn-chef-infra\learn_chef\recipes
C:\dev\chef\learn-chef-infra\learn_chef\spec
C:\dev\chef\learn-chef-infra\learn_chef\test
C:\dev\chef\learn-chef-infra\learn_chef\.gitignore
C:\dev\chef\learn-chef-infra\learn_chef\CHANGELOG.md
C:\dev\chef\learn-chef-infra\learn_chef\chefignore
C:\dev\chef\learn-chef-infra\learn_chef\kitchen.yml
C:\dev\chef\learn-chef-infra\learn_chef\LICENSE
C:\dev\chef\learn-chef-infra\learn_chef\metadata.rb
C:\dev\chef\learn-chef-infra\learn_chef\Policyfile.rb
C:\dev\chef\learn-chef-infra\learn_chef\README.md
C:\dev\chef\learn-chef-infra\learn_chef\.delivery\project.toml
C:\dev\chef\learn-chef-infra\learn_chef\recipes\default.rb
C:\dev\chef\learn-chef-infra\learn_chef\spec\unit
C:\dev\chef\learn-chef-infra\learn_chef\spec\spec_helper.rb
C:\dev\chef\learn-chef-infra\learn_chef\spec\unit\recipes
C:\dev\chef\learn-chef-infra\learn_chef\spec\unit\recipes\default_spec.rb
C:\dev\chef\learn-chef-infra\learn_chef\test\integration
C:\dev\chef\learn-chef-infra\learn_chef\test\integration\default
C:\dev\chef\learn-chef-infra\learn_chef\test\integration\default\default_test.rb
```

• The things inside the `\.directory` can be ignored.
• `\spec` directory basically contain unit-tests for your ruby recipes
• `\recipes` are where you use Chef’s Ruby DSL to describe how you want your machines configured
• `\test` provide integration tests that Test Kitchen can run. This will allow you to check the recipes actually work as expected on specific machines.
• The rest of the files are basically configurations files

You’ll probably notice the new directory generated is also a git repository.

If you have vagrant installed, you should be able to run kitchen list. (Note, kitchen list is specific to the directory you are in. It reads the configuration files, primarily `kitchen.yml`. So you must be in the correct directory to run it.)

{% highlight bash %}
>cd learn_chef
>kitchen list
Instance             Driver   Provisioner  Verifier  Transport  Last Action    Last Error
default-ubuntu-1804  Vagrant  ChefZero     Inspec    Ssh        <Not Created>  <None>
default-centos-7     Vagrant  ChefZero     Inspec    Ssh        <Not Created>  <None>
{% endhighlight %}

This lists the (virtual) machines that the `kitchen.yml` is configured to run the integration tests against. Note, the default driver is Vagrant. You can create your own drivers if you’re environment has specific ways to create virtual-machines or you can use the provided drivers for things like Google, AWS, etc.

The listed machines haven’t actually been created yet. You can get Kitchen to create the virtual machines, will itself will just ask Vagrant to do this, and then will wait for an SSH server to start on the new VMs. (As the transport is also set to SSH. Again, this can be changed if you need.) Once the SSH is started, it will connect to the machine and then will issue commands to install the chef client executable on the VM. It will transfer the recipe across to the machine and then will run the recipe of the machine. You do all this in one go by running `kitchen converge`. Pretty neat.

{% highlight bash %}
>kitchen converge
… <runs off>
{% endhighlight %}

Then you can run `kitchen list` again and it’ll indicate the last action on the machines worked out.

{% highlight bash %}
>kitchen list
Instance             Driver   Provisioner  Verifier  Transport  Last Action  Last Error
default-ubuntu-1804  Vagrant  ChefZero     Inspec    Ssh        Converged    <None>
default-centos-7     Vagrant  ChefZero     Inspec    Ssh        Converged    <None>
{% endhighlight %}

You can login to the machine that Kitchen has created using ‘kitchen login’.
Writing a recipe

You can write recipes in either yaml or ruby. I’ll use Ruby given I like the flexibility of a programming language.

You can write the recipe inside the default.rb (i.e. at `learn-chef-infra/learn_chef/recipes/default.rb`) or you can create a new ruby file and import it into default.rb.

Create a file at `learn-chef-infra/learn_chef/recipes/learn-chef.rb`

{% highlight ruby %}
include_recipe "learn_chef::learn-chef"
{% endhighlight %}

For a ruby recipe, you use a `do..end` ruby block (basically a closure)

{% highlight ruby %}
file "/etc/mota" do
    content "its better in ruby though"
end
{% endhighlight %}

Or you can start a web server like so
package 'apache2'

{% highlight ruby %}
file "/var/www/html/index.html" do
    content "hello moto"
end

service 'apache2' do
    action [:enable, :start]
end
{% endhighlight %}

I think it’s probably worth noting that recipes are executed from top to bottom. I believe.

You can get rid of the stuff created by kitchen with `kitchen destroy`. Otherwise, kitchen leaves the machines around between converges, which does help to speed up the tests.

{% highlight bash %}
>kitchen destroy
-----> Starting Test Kitchen (v2.3.4)
-----> Destroying <default-ubuntu-1804>...
       ==> default: Forcing shutdown of VM...
       ==> default: Destroying VM and associated drives...
       Vagrant instance <default-ubuntu-1804> destroyed.
       Finished destroying <default-ubuntu-1804> (0m8.63s).
-----> Test Kitchen is finished. (0m10.80s)
{% endhighlight %}

## Chef-Run

Chef-run is a tool to execute ad-hoc tasks on one or more target nodes using Chef. (Documentation here https://www.chef.sh/docs/reference/chef-run/) It is installed if you install Chef Workstation (which is basically a sort of development environment, documentation here https://www.chef.sh/docs/chef-workstation/getting-started/).

You can use it to run recipes or resources on machines, in an ad-hoc fashion.

{% highlight bash %}
>chef-run web1 file hello.txt content=’hello world’
[✔] Packaging cookbook... done!
[✔] Generating local policyfile... exporting... done!
[✔] Applying file[hello.txt] from resource to target.
└── [✔] [web1] Successfully converged file[hello.txt].
{% endhighlight %}

This will connect to a machine called ‘web1’ (note, this would need to be configured as an alias), and it will create the file on the machine. Likewise, we could then check the contents of the file, and then run another ad-hoc command to delete the file.

{% highlight bash %}
>ssh web1 cat /hello.txt
hello world
>chef-run web1 file hello.txt action=delete
[✔] Packaging cookbook... done!
[✔] Generating local policyfile... exporting... done!
[✔] Applying file[hello.txt] from resource to target.
└── [✔] [web1] Successfully converged file[hello.txt].
{% endhighlight %}

Rather than just running ad-hoc resources invocations, we can also run recipes or cookbooks.

{% highlight bash %}
>chef-run web1 recipe.rb
>chef-run web1 cookbook1
{% endhighlight %}

Note, that a recipe is a standalone file. Whereas, a cookbook is a directory with a metadata.rb and a recipes directory. 

metadata.rb contains information like what other cookbooks this cookbook depends upon, plus states a version number of the cookbook. A metadata file looks something like this:

{% highlight ruby %}
name 'base'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'All Rights Reserved'
description 'Installs/Configures base'
long_description 'Installs/Configures base'
version '0.1.0'
chef_version '>= 13.0'

depends 'os-hardening'
{% endhighlight %}

Note, while a metadata file might describe what the cookbook depends upon, it doesn’t tell chef how to find those dependencies. That is control by a berksfile or a policyfile. For example, the hardening cookbook can be found at https://supermarket.chef.io/cookbooks/os-hardening.  See the section on PolicyFiles for more information.

Recipes directory contains other recipes, the default being ‘default.rb’

A cookbook can also contain a ‘templates’ directory, that contains ‘.erb’ files (Ruby template files). There is a template resource (documentation here https://docs.chef.io/templates/ ) can use the template to create files on the clients.

{% highlight ruby %}
template ‘/var/www/html/index.html’ do
  source ‘index.html.erb’
end
{% endhighlight %}

This would create the index.html on the client provided the templates directory contains an ‘index.html.erb’ file like so

{% highlight html %}
<html>
  <body>
    <p>This is chef client node <%=node[‘hostname’]%> </p>
  </body>
</html>
{% endhighlight %}

A cookbook can also contain an attributes directory. Attributes can be generated with
chef generate attribute `<cookbook_path> <name>`

A cookbook can also contain a files directory.

## Policyfiles/Berkshelf/Knife

The older version of a PolicyFile was the Berks file. Basically, they are about specifying where dependencies ought to be fetched from. I believe knife is basically a way of fetching/installing dependencies. For example, for https://supermarket.chef.io/cookbooks/os-hardening it lists as ways to install it:

- Berkshelf
`cookbook ‘os-hardening’, ‘~> 4.0.0’`
- Policyfile
`Cookbook ‘os-hardening’, ‘~> 4.0.0’, :supermarket`
- Knife
```
knife supermarket install os-hardening
knife supermarket download os-hardening
```

### Policyfiles

A policyfile is “Policyfile.rb” that sits alongside the metadata.rb of a recipe.

“A Policyfile declares the name, run_list, sources, and attributes for a node or group of nodes. Policyfiles also handle all dependency resolution for your cookbooks.”…“Policyfiles give you the confidence that the version of cookbook you specify will always be the one deployed.”…“Policyfiles give you the confidence that the version of cookbook you specify will always be the one deployed.”

You can generate a policyfile when generating the cookbook by using -P switch

```
chef generate cookbook <name> -P
```

Or you can generate a policyfile with a separate invocation

```
chef generate policyfile <name>
```

A policyfile looks like this

{% highlight ruby %}
# Policyfile.rb - Describe how you want Chef Infra Client to build
# your system.
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef
# does. Used to reference this policyfile on Chef server and must be
# thus unique.
name 'base'

# Where to find external cookbooks if they are not specifically
# declared in the cookbook section below
default_source :supermarket

# run_list: chef-client will run these recipes in the order 
# specified. 
run_list 'base::default'

# Specify a custom source for a single cookbook. Provide local 
# cookbooks that if are specified as a dependency will  be found
# before chef looks in supermarket.
cookbook 'base', path: '.'
cookbook 'hardening', path: '../hardening'
{% endhighlight %}

Having defined the policyfile, we need to resolve the listed dependencies to produce a Policyfile.lock.json that ensures reproduction.

We run

{% highlight bash %}
>chef install cookbooks/base/Policyfile.rb
Building policy base
Expanded run list: recipe[base::default]
Caching Cookbooks...
Installing base      >= 0.0.0 from path
Installing hardening >= 0.0.0 from path
Using      os-hardening            4.0.0
Using      windows-hardening       0.9.1
Using      windows-security-policy 0.3.9

Lockfile written to C:/dev/chef/lcr-policyfiles-getstarted/cookbooks/base/Policyfile.lock.json
Policy revision id: ca474c6e5bca2eda927549bd33efe1f9ccc7e74e26c2922b0a4d57805555cef5
{% endhighlight %}

Then if we re-run the same command, it just uses the lockfile direct

{% highlight bash %}
>chef install cookbooks/base/Policyfile.rb
Installing cookbooks from lock
Installing base                    0.1.0
Installing hardening               0.1.0
Using      os-hardening            4.0.0
Using      windows-hardening       0.9.1
Using      windows-security-policy 0.3.9
{% endhighlight %}

Running chef install reads the Policyfile.rb and creates a Policyfile.lock.json file. This Policyfile.lock.json file is the actual policy used by Chef Client and contains unique references to the cookbooks in the run_list. The Policyfile.rb file is really only used as a human readable/editable file used to create the related Policyfile.lock.json file.

The Policyfile.lock.json file consolidates all dependencies in the run_list. This file gets downloaded to your node and read by chef-client. The chef-client will then download the precise versions of all dependencies and run them locally.

The Policyfile.lock.json specifies not only the cookbooks required, but also the exact SHA fingerprint of all of the associated files and a checksum of the cookbook contents. If the contents change in any way, then the checksum will change and chef-client not run the policy.

If you were to use this same lock file on another workstation, then you can be certain it will use the same version of the cookbooks. If it cannot find these versions, then chef-client will return an error.

If you have made changes to the policyfile, you can update it with

```
>chef update Policyfile.rb
```
 
## Attributes

The attributes folders basically seems to be a way of storing variables that recipes can access. When OHAI runs, it sets the attributes of a node (a node is an object that represents the machine being configured by chef). So you can get attributes that inform you about what platform or machine the recipe is being run on, so that’s pretty good for dynamic data. But you can also define your own attributes, which seem to be more or less arguments to the recipes you’ve created, I think.

This seems to explain it more https://docs.aws.amazon.com/opsworks/latest/userguide/cookbooks-101-basics-attributes.html

## Resource guards

Quite often you only want to run a resource if something is missing or whatever. This is what is a resource ‘guard’ is for, and you can use them on any resource. There seem to be two ‘only_if’ and ‘not_if’. Only_if means the resource will run if the condition is true. Not_if prevents the resource is not run if true.

{% highlight ruby %}
powershell_script "Connect to #{path}" do
        code "net use #{path} /USER:<username> /PERSISTENT:YES <pass>"
        # Only run if the directory isn't already available
        not_if { ::Dir.exist?(path) }
end
{% endhighlight %}

## Iteration

Maybe you want to do the same resource for multiple things? Luckily, you can just run an iteration loop. I suppose this really shows that the DSL is just ruby. AWS documentation has some nice examples on this https://docs.aws.amazon.com/opsworks/latest/userguide/cookbooks-101-basics-ruby.html#cookbooks-101-basics-ruby-iteration

{% highlight ruby %}
[ "/srv/www/config", "/srv/www/shared" ].each do |path|
  directory path do
    mode 0755
    owner 'root'
  end
end
{% endhighlight %}

And you can iterate over whatever iterable ruby allows, including hash tables

{% highlight ruby %}
{ "/srv/www/config" => 0644, "/srv/www/shared" => 0755 }.each do |path, mode_value|
  directory path do
    mode mode_value
    owner 'root'
    group 'root'
    recursive true
    action :create
  end
end
{% endhighlight %}

## Winrm second hop

There is an authentication issue with win-rm accessing remote fileshares called the second hop problem. I was searching for a while how to fix it, and I struggled. Eventually I found there’s a parameter called ‘elevated’ that if you set to true for the winrm transport, it’ll run as a service and this seems to get around the second hop issues. I.e. like this in the kitchen.yml

{% highlight yaml %}
---
driver:
  name: custom-vms
  vm_user: <user>
  vm_token: <token>

platforms:
  - name: test-win10-20h1
    driver:
      vmtemplate: test-win10-20h1
    transport:
      name: winrm
      elevated: true
      username: <user>
      password: <pass>
{% endhighlight %}

I had found this problem doesn’t exist with OpenSSH, so you can install it but you need to configure the private key etc.

{% highlight ruby %}
pub_key = <<-EOH
<PUBLIC SSH KEY HERE>
EOH

ssh_script = <<-EOH
choco install OpenSSh -y --params /SSHServerFeature
Set-Service -Name sshd -StartupType 'Automatic'
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
New-ItemProperty -Path "HKLM:\\SOFTWARE\\OpenSSH" -Name DefaultShell -Value "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe" -PropertyType String -Force
EOH

powershell_script 'Setup Open-Ssh service' do
    code ssh_script
end

file 'C:\ProgramData\ssh\ssh_host_rsa_key.pub' do
    content pub_key
end

file 'C:\ProgramData\ssh\ssh_host_rsa_key' do
    action :delete
end
{% endhighlight %}

## How to customise an existing resource?

Let’s say I want to use in the in-built chef recipe, chocolatey_package, but I need to customise it so that after it runs, it also runs ‘refreshenv.bat’. I had a problem that even though I’ve installed a resource, the shell sessions path isn’t updated to know where Java is.


## Chocolately package

{% highlight ruby %}

# Install Java from a local chocolately mirror
chocolatey_package 'OpenJDKJre' do
   package_name 'OpenJDKjre'
   source '\\\\test.corpb.local\\ChocolateyMirror'
   version "11.0.7.10"
end

# I end up doing a hack, otherwise java executable can’t be found
# Seems there may be an issue getting new envvars.
Powershell_script ‘run java’ do
   code <<-EOH
import-module "C:\\ProgramData\\chocolatey\\helpers\\chocolateyProfile.psm1"
Update-SessionEnvironment
java -jar 'C:\\jenkins-swarm\\swarm-client-3.9.jar'
EOH
end
{% endhighlight %}

## Resources

- https://zwischenzugs.com/2017/11/25/ten-things-i-wish-id-known-about-chef/
- AWS actually has some really good documentation to help people become acquainted with chef.
 https://docs.aws.amazon.com/opsworks/latest/userguide/cookbooks-101-basics-ruby.html
