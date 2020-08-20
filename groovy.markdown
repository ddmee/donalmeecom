---
layout: default
title:  Groovy
date:   2020-08-20 07:00:00 +0100
categories: groovy programming jvm
permalink: /groovy/
---

# Groovy
{:.no_toc}

* TOC
{:toc}

Groovy is a java-based scripting language a ‘java-script’ - haha.

There’s not really such a thing as the groovy runtime. Groovy is a way to generate bytecode for the JVM. Groovy source-code goes through the groovy compiler (which itself runs on the JVM I presume) to produce JVM byte-code.

[groovy-download]

## Groovy.bat

{% highlight powershell %}
C:\Users\donal.mee> get-command groovy.bat | select -ExpandProperty source                                     
C:\tools\groovy-2.5.1\bin\groovy.bat                                                                           
C:\Users\donal.mee> groovy.bat                                                                                 
error: neither -e or filename provided                                                                         
Usage: groovy [options] [filename] [args]                                                                      
The Groovy command line processor.                                                                             
      -cp, -classpath, --classpath=<path>                                                                      
                             Specify where to find the class files - must be first                             
                               argument                                                                        
  -D, --define=<property=value>                                                                                
                             Define a system property                                                          
      --disableopt=optlist[,optlist...]                                                                        
                             Disables one or all optimization elements; optlist can                            
                               be a comma separated list with the elements:                                    
                             all (disables all optimizations),                                                 
                             int (disable any int based optimizations)                                         
  -d, --debug                Debug mode will print out full stack traces                                       
  -c, --encoding=<charset>   Specify the encoding of the files                                                 
  -e= <script>               Specify a command line script                                                     
  -i= [<extension>]          Modify files in place; create backup if extension is                              
                               given (e.g. '.bak')                                                             
  -n                         Process files line by line using implicit 'line'                                  
                               variable                                                                        
  -p                         Process files line by line and print result (see also                             
                               -n)                                                                             
      -pa, --parameters      Generate metadata for reflection on method parameter                              
                               names (jdk8+ only)                                                              
  -l= [<port>]               Listen on a port and process inbound lines (default:                              
                               1960)                                                                           
  -a, --autosplit[=<splitPattern>]                                                                             
                             Split lines using splitPattern (default '\s') using                               
                               implicit 'split' variable                                                       
      --indy                 Enables compilation using invokedynamic                                           
      --configscript=<script>                                                                                  
                             A script for tweaking the configuration options                                   
  -b, --basescript=<class>   Base class name for scripts (must derive from Script)                             
  -h, --help                 Show this help message and exit                                                   
  -v, --version              Print version information and exit 
{% endhighlight %}

This let’s you run your groovy code using a file.

Define a file called `myfirst.groovy` and then put the following code in it

{% highlight groovy %}
println ‘helloworld!’
{% endhighlight %}

Then execute it by running

{% highlight bash %}
>groovy myfirst.groovy
helloworld!
{% endhighlight %}

## Groovy repl

There is also a groovy repl-like shell at `groovysh` [groovy-sh]

## Debugger

What about a debugger? There doesn’t seem to be any in-built debugger, instead people rely upon the debugger from Eclipise or IDEA (jetbrains). Lol, no built-in debugger wtf.

At this point, it’s probably sane to say, just use IDEA to develop Groovy code. It’s pretty nice.

## Groovy console

There is a groovy console at ‘groovyconsole.bat’ which is a little inbuilt ide

![groovy console](/assets/images/groovy-console.png)

`def` allocate a variable, not a function definition.

![groovy console 2](/assets/images/groovy-console-2.png)

You can use a colon to write a message.

{% highlight groovy %}
def x = 5
x += 5 
println x
assert x == 11: "Value wasn't eleven"
{% endhighlight %}

## Data types

Groovy is an ‘optional typed’ language, meaning we can define the type being used or let groovy guess or interpret the type at runtime.

You can also avoid a type definition at all.

Let’s look at some basic datatypes.

| Data type    | Groovy keyword      | Same data     |
|:-------------|:--------------------|:--------------|
| Strings      | `String`            | "hello there" |
| Integers     | `int`               | 0,1,2,3       |
| Floats       | `float`             | 0.5, 3.8      |
| Boolean      | `Boolean`           | true, false   |

![groovy console 3](/assets/images/groovy-console-3.png)

The groovy runtime has coerced the different types into string types.

We can improve upon the coercion

{% highlight groovy %}
>println name + "is a programmer? " + isProgrammer.toString().capitalize()
donal mee is a programmer? True
{% endhighlight %}

The formatting of the float is a bit sucky. There is built-in formatting that we can use, the normal C type string formatting.

{% highlight groovy %}
>println name + “ wishes his salary was \$” + String.format(“%.2f”, salary)
donal mee wishes his salary was $100000.00
{% endhighlight %}

Oh bummer! That didn’t work. It still rounded up the float. We can change from using a float to using the BigDecimal datatype.

{% highlight groovy %}
>BigDecimal salary = 999999.99
>println name + “wishes his salary was \$” + String.format(“%.2f”, salary)
donal mee wishes his salary was $99999.99
{% endhighlight %}

Or we can just output the raw string conversion and that gives us what we want.

{% highlight groovy %}
>BigDecimal salary = 999999.99
>println name + “wishes his salary was \$” + salary
donal mee wishes his salary was $99999.99
{% endhighlight %}

You can also do multiple assignment on a single line

{% highlight groovy %}
def (String x, int y) = [‘foo’, 42]
{% endhighlight %}

In summary:
- You can use optional `def` to which is basically like `auto`, just let groovy automatically determine the type.
- Or you can be explicit like `String donal = "hello"`.
- Semi-colons are also optional, perform the same thing as a C semi-colon. A line ending is the same thing as a semi-colon. 'Optional' semicolons.

## Control structures

Quite good documentation here [groovy-docs-semantics]

The if statement looks like most if statements

{% highlight groovy %}
if ( ... ) {
    ...
} else if (...) {
    ...
} else {
}
{% endhighlight %}

Loops look pretty normal too

{% highlight groovy %}
String message = ‘’
for (int i = 0; i < 3; i++) {
  message += ‘Hi ‘
}
assert message == ‘Hi Hi Hi ’
{% endhighlight %}

You can also do a more elaborate, comma-separate expression for loop

{% highlight groovy %}
def facts = []
def count = 5
for (int fact = 1, i = 1; i <= count; i++, fact *= i) {
  facts << fact
}
assert facts == [1,2,6,24,120]
{% endhighlight %}

And also, you can use the good old for-in for which works for any kind of collection etc

{% highlight groovy %}
// iterate over a range
def x = 0
for ( i in 0..9) {
  x += i
}
assert x == 45

// over a list
def x = 0
for ( i in [0,1,2,3,4] ) {
  x += i
}
assert x == 10

// iterate over a map (hashtable)
def x = 0
def map = [‘abc’:1, ‘def’:2, ‘xyz’:3]
for ( v in map ) {
    x += v.value
}
assert x == 6
{% endhighlight %}

And there’s also the good old while loop

{% highlight groovy %}
def (x, y) = [0, 5]
while (y-- > 0) {
  x++
}
assert x == 5
assert y == 0
{% endhighlight %}

We can also use a ruby-like .each for iteration

{% highlight groovy %}
def singers = [0,1,2,3,4]
singers.each{x -> println(x)}
// or we could use the ‘it’ keyword to do the same thing
singers.each{println it}
{% endhighlight %}

## Functions

You can define a function that’s return type is determined at runtime using def

{% highlight groovy %}
def callMe() {
  ‘Call me on 07812301129’
}
assert callMe() == ‘Call me on 07812301129’
{% endhighlight %}

This shows an interesting thing about groovy, just like ruby or powershell. The last thing evaluated in the function is returned. I.e. the ‘return’ keyword is optional. [groovy-docs-semantics-optional-keyword].

Also, by default, all classes and methods are public, thus there is no need to write

```
public def callMe() {…}
```

But of course, being explicit with your types may be better or make things more readable

{% highlight groovy %}
String getUserName(String firstName, String lastName) {
  return firstName.substring(0,1).toLowerCase() + lastName.toLowerCase();
}
assert getUserName("Chris", "Behrens") == "cbehrens" : "getUsername isn't working"
{% endhighlight %}

There is a void keyword that we can use to say a function won’t return anything

{% highlight groovy %}
void printCred(cred) {
  // and here we use in-built string interpolation g-string
  println(“UserName is ${cred}”)
}
printCred(“Donal Mee”)
{% endhighlight %}

## Closures

Closures are like anonymous functions, they are defined and then only executed when called

{% highlight groovy %}
def close = { println ‘hello’ }
close()
{% endhighlight %}

They are defined using {} curly-braces.

What’s the difference between a function and a closure? Quite a few functions in groovy will take a closure as an argument, like the `.each()` method. So you can write:

{% highlight groovy %}
(1..3).each({close})
{% endhighlight %}

I assume it’s the use of closures that help create a DSL in groovy. I’m not sure. This is interesting to know. We can pretty easily define parameters a closure takes using the `->` symbol.

{% highlight groovy %}
def twoParams = { pm1, pm2 ->
  println “pm1: $pm1, pm2: $pm2”
}
twoParams “calif
{% endhighlight %}

## Classes

Classes are pretty much the same as Java. The relevant documentation is here [groovy-docs-oop].

They seem pretty straightforward, for example here’s some code

{% highlight groovy %}
class User {
  String lastName;
  String firstName;
  // initaliser method would be called User

  public String fullName(){
    return this.firstName.substring(0,1).toLowerCase() + this.lastName.toLowerCase()
  }
}

String[] firstNames = ["Bob", "Jeff", "Roy"]
String[] lastNames = ["Tibi", "Trump", "Rogan"]
{% endhighlight %}

The transpose function is acting like pythons zip.

{% highlight groovy %}
[firstNames, lastNames].transpose().each{ fN, fY ->
    User u = new User(firstName: fN, lastName: fY)
    println ("Username is ${u.fullName()}")
}
{% endhighlight %}

Groovy supports inheritance and interfaces. It also supports abstract class.

And abstract class is one you cannot directly instantiate. Instead, you can define a new class that implements the abstract class and you can instantiate that class. The abstract class itself can define things that are then shared by concrete implemnenter classes. It’s a way of sharing code between classes.

There is an `abstract` and `extends` keyword.

{% highlight groovy %}
// abstract class cannot be directly instantiated
abstract class Person {
  String lastName;
  String firstName;

  public String fullName(){
    return this.firstName.substring(0,1).toLowerCase() + this.lastName.toLowerCase()
  }
}

// two concrete implementations of the abstract class
class Artist extends Person {
    public String[] Songs;
}

class Producer extends Person {
    // just a stub method
    public void Produce(){};
}

Artist dillon = new Artist(firstName: "Bob", lastName: "Dillon")
Producer michael = new Producer(firstName: "Michael", lastName: "Producer")
println dillon.fullName()
println michael.fullName()
{% endhighlight %}

## Knowing how to do stuff

In an above example, I worked out how to get something like python’s zip, which is known as traverse in groovy.

The documentation for groovy isn’t as good as python’s. But with a bit of searching, you can find stuff.

There seems to be a bit of a lack of standard library documentation. From what I can see, a place that has a list of useful things to know is here [groovy-docs-dev-kit].

## Importing packages

There are some default imports with groovy.

Information around imports and packages can be found at [groovy-docs-structure].

There’s an import and package keyword.

{% highlight groovy %}
// importing the class MarkupBuilder from the groovy.xml package
import groovy.xml.MarkupBuilder
// now you can use the MarkupBuilder
def xml = new MarkupBuilder()
{% endhighlight %}

There’s also a star syntax like python’s import, except it’s appended

{% highlight groovy %}
// import everything from groovy.xml
import groovy.xml.*
{% endhighlight %}

You can also alias import like python

{% highlight groovy %}
Import java.sql.Date as SQLDate
{% endhighlight %}

## External packages, Grape

Like NPM or Nuget, we can install and import external packages using a dependency manager called 'Grape.'

{% highlight groovy %}
// This will get the spring-orm package from mvnrepository.com (maven)
@Grab(group=’org.springframework’, module=’sprint-orm’, version=’5.2.4.RELEASE’)
// this will then enable this class to be imported that doesn’t come as standard
import org.springframework.jdbc.core.JdbcTemplate
{% endhighlight %}

Documentation is available at [grape-docs]

More information about the maven repo at [maven]

Note, @grab does not work in pipeline scripts. Instead, you need to install a plugin that provides functions you want.


## References

- [groovy-download]
- [groovy-sh]
- [groovy-docs-semantics]
- [groovy-docs-semantics-optional-keyword]
- [groovy-docs-oop]
- [groovy-docs-dev-kit]
- [groovy-docs-structure]
- [grape-docs]
- [maven]
- [pluralsight-groovy-fundamentals]

[groovy-download]: https://groovy.apache.org/download.html
[groovy-sh]: https://groovy-lang.org/groovysh.html
[groovy-docs-semantics]: http://groovy-lang.org/semantics.html
[groovy-docs-semantics-optional-keyword]: http://groovy-lang.org/semantics.html#_optional_return_keyword
[groovy-docs-oop]: http://groovy-lang.org/objectorientation.html
[groovy-docs-dev-kit]: http://groovy-lang.org/groovy-dev-kit.html
[groovy-docs-structure]: https://groovy-lang.org/structure.html
[grape-docs]: http://docs.groovy-lang.org/latest/html/documentation/grape.html
[maven]: https://mvnrepository.com/
[pluralsight-groovy-fundamentals]: https://www.pluralsight.com/courses/groovy-fundamentals
