---
layout: default
title:  Powershell
date:   2020-08-19 16:37:49 +0100
categories: powershell programming
permalink: /powershell/
---

# Powershell
{:.no_toc}

* TOC
{:toc}

Everything in powershell is an object. Which means it has a type. The typing system can be quite tricky because it's dynamic. And also powershell will do a lot for you to try to help make things less verbose.

Because powershell is a shell, (as well as a scripting language), it outputs all evaluations of expressions to stdout. This makes it different from say python, where you need to explicitly call a print statement. For powershell, this even applies inside functions. The return value of a function is more like a control-flow keyword. IF you store the output/return-value of a function, you're actually going to get anything that was printed to stdout and not explicitly caught. Explicitly catching output going to the stdout from expression evalution is done by assigning it to a variable or dealing with the output in some other way.

The other thing is that powershell runs on the .dotnet runtime and it's very analogous to c#. So it's apparently pretty easy to convert c# code into powershell and vice versa. The benefit of c# is that it'll probably run faster than powershell code.

There are a few types of source-code.

__Cmdlets__

A command-let is something implementing by a .NET class that derives from the Cmdlet base-class in the powershell sdk. Building a cmdlet requires the powershell sdk, which is freely available. This category of command is compiled into a dynamic link library and then loaded into the powershell process. Basically corresponds to a built-in command. Though anyone can add and create their own.

__Functions__

Created in memory and is discarded by the interpeter when it exits. There's also something called a workflow.

__Scripts__

Read from a .ps1 text file and then stored in memory.

__Native commands (applications)__

These are just win32 executable that you can call, like choco.exe. They handle their own parameters and output. It also requires another process to load. 

### Get the type of something

Types are useful to know what you're working with. But, in a dynamic language, you tend to care what methods/properties are available and you care less about types, potentially.

How to get the type: $object.GetType()

{% highlight powershell %}
$hello = "helloworld"
$hello.GetType()
$hello.GetType().FullName
{% endhighlight %}

How to get the methods and properties: get-member

Becarefull using the get-member. get-member command returns the properties and methods on an object. Useful for discovering what can be accessed on an object.

{% highlight powershell %}
$hello = 'helloworld'
# Find all the methods and properties available on the string $hello
get-member -inputobject $hello
{% endhighlight %}

For a while, I thought you could pipe the variable to the get-member. Which seemed shorter that writing ```get-member -inputobject $hello.```

{% highlight powershell %}
$hello = 'helloworld'
$hello | get-member
{% endhighlight %}

However, this is pretty dangerous. Let's say you have an object which is a list, and you want to find the members and properties on the list

{% highlight powershell %}
$a = 1,2,3
$a | get-member
> TypeName: System.Int32
...
{% endhighlight %}

This actually has passed an element from the list a, which is an int, and told you the properties/methods on it. Interestingly, because the array is only made up of int, it only printed the methods/properties once rather than three times.

If you make the list or collection with different types in the elements, then it seems to print each methods/properties for the different elements.

{% highlight powershell %}
$a = 1, 'abc', @{d=5}
$a | get-member
> # prints methods/proprties for the int, string and hashtable. Nice.
{% endhighlight %}

### Type literals

### Arrays

There actually isn't a list literal syntax in powershell. In python you can write 'a = [1,2,3]', which assign the variable name a to the list of integers.

In powershell, strangely, it doesn't have something like this. But it does, of course, have arrays. Instead, you can do something like this with commands

{% highlight powershell %}
$a = 1,2,3
{% endhighlight %}

It'll create the variable a, with the underlying type [object[]], which is a dotnet array.

Apparently things in pipelines, since posh v3, will return arrays. This is because people writing pipeline code tend to expect to be working on a list of inputs, and so pipelines should default to returning lists of stuff even if there's only one element in the array.

E.g., this creates a list:

{% highlight powershell %}
$out = get-childitem | where {$_.extension -eq '.json'}
# the $out is an array, i.e. [object[]]
$out.GetType().Fullname
{% endhighlight %}

Apparently, all objects have the .Count() method to behave in a puesdo-array type-way for the benefit of pipelines:

"""Since PowerShell v3, any object is treated as a pseudo-array and has a Count property. This is to remove issues where pipelines could return one, or many, objects. The single object case would cause errors in code designed for a collection of many objects.""" from Powershell In Depth, Manning


__Dangerous arrays__

In python, if a points to a list, and then b points to a, b actually points to the list. This is the same in powershell.

{% highlight powershell %}
$a = 1,2,3
$b = $a
write-host $b
> 1,2,3
{% endhighlight %}

If you mutate the contents of $a, then $b changes too.

{% highlight powershell %}
$a[0] = 'one'
write-host $b
> 'one',2,3
{% endhighlight %}

But this doesn't hold true in powershell if you reassigns using += or -=, ahh!!

{% highlight powershell %}
$a = 1,2,3
$b = a
$a += 4 
write-host $a
> 1,2,3,4
write-host $b
> 1,2,3
{% endhighlight %}

Ahhh! This is because when assignment happens, using +=, powershell copies the list $ points to, adds the new 4 and then points $a to the new list.
It doesn't actually mutate the underlying list. It creates a brand new once at a different memory location. Ahh!! This seems pretty dangerous. Or at least, likely to cause some bugs you haven't thought about. Hmm....

Python doesn't suffer this problem. Because it mutates the underlying list rather than copy and add on a new list.

```python
a = 1,2,3
b = a
a[0] = 'one'
assert b == a  # true
a += [4,]
print a
assert b == a  # true
```

You can also creates arrays like this:

{% highlight powershell %}
(, 1).length   # though this is really evalute the expression ',1' first rather than a special array notation
> 1
@().length  # rather than @{} curly-braces for hashtables, it makes sure whatever is return is always an array!
> 0
{% endhighlight %}

### Hashtables (dictionaries)

Beautiful hashtables are pretty easy to create and use

It begins with @{}, and uses newline to create next entry, where = is used to assign.

{% highlight powershell %}
$person = @{
    firstname = 'donal'
    lastname = 'mee'
    age = 999
}
# Though this could be truncated to:
$person = @{firstname = 'donal'; lastname = 'mee'; age=999}
{% endhighlight %}

You can do the typical [] to look-up a key in the hashtable, and you can also use the dot property

{% highlight powershell %}
$person['firstname']
$person.lastname

# Interestingly, this just returns $Null and doesn't throw an error
$person['doesntexit']
# And key looksup are also case-insenstive
$person['FIRSTNAME']
{% endhighlight %}

The weird thing perhas is that when you want to iterate over a hashtable, the is a bit unnatural.

You must explicitly call GetEnumerate() in the for loop. Otherwise, the first and only value return is the entire hashtable itself.

{% highlight powershell %}
# Weirdness!
# reusing person about
foreach ($pair in $person) {
    $pair
    count ++
}
> # Just prints the entire hashtable 
write-host $count
> 1

# Must explicitly call the enumeration, lord knows why
$count = 0  # reset count
foreach ($pair in $person.GetEnumerate()) {
    $pair
    count ++
}
> prints each pair once
write-host count
> 3
{% endhighlight %}

There's also something called an ordered hashtable. Hashtables don't return their contents in the same order the pairs were placed into the hashtable (unsurprisingly). But you can get this behaviour using the ordered hashtable cast, which is quite cool (like pythons ordered dictionary)

{% highlight powershell %}
$a = [ordered] @{
    a = 1
    b = 2
    c = 3
}
write-host $a[0]
> 1
write-host $a[1]
> 2
{% endhighlight %}


If you want to extend an existing hashtable

{% highlight powershell %}
$a = @{
    a = 1
    b = 2
}
$a.Add(c, 3)
{% endhighlight %}

### Create your own new object

Classes, in most programming languages, are the means to create new types of objects. However, Powershell seems to be particularly relaxed about the idea of classes. Classes were only introduced in version 5 of the language. The keyword 'class' had been reserved for 10 years before this. It took them this long to get around to creating classes! Which is partly because they wanted to do it write and partly because Powershell is happy for users to create objects dynamically.

It seems that in particular, the most useful is

{% highlight powershell %}
$mything = New-Object PSObject -Property @{
    Name  = 'Adam'
    Age = 28
}
$mything.Name
$mything.Age
{% endhighlight %}

**Extending existing objects**

You can also add or extend a property. Using the Add-Member commandlet.

{% highlight powershell %}
# Create two new objects
$two = New-Object psobject
$two | Add-Member -MemberType NoteProperty -Name even -Value $true
$three = New-Object psobject
$three | Add-Member -MemberType NoteProperty -Name even -Value $false
# Group the objects by whether the even property is true
$two, $three | group-object -Property even
{% endhighlight %}

Be VERY careful with Add-Member. I had initally, and painful tried this for a while.
And OMG, it appears that I didn't quite correct a property on the objects even though it seems
like I sort of had...

{% highlight powershell %}
# Create two new objects
$two = New-Object psobject
$two | Add-Member -NotePropertyName even -NotePropertyValue $true
$three = New-Object psobject
$three | Add-Member -NotePropertyName even -NotePropertyValue $false
# Group the objects by whether the even property is true
$two, $three | group-object -Property even
`
{% endhighlight %}

HANG on. That worked! Wtf... There must be something else going on...


#### Copy an object

You can also copy you own custom objects and potentially other objects. Let's say you write a function
that needs to temporarily mutate the object is it passed. And you don't want to really mutate the original
object.

{% highlight powershell %}
function Nasty-Mutator ($thing) {
    $thing.symbol = 'Mutated!'
    write-host "The thing now is: $thing"
}

$demon = New-Object -typename psobject -property @{ name = 'donal'; symbol=666}
Nasty-Mutator -thing $demon
$demon

function No-Mutations ($thing) {
    $thing = $thing.psobject.copy()
    $thing.symbol = "make me a princess!"
    write-host "The thing now is: $thing"
}

$frog = New-Object -typename psobject -property @{ name = 'princess'; symbol=7}
No-Mutations -thing $frog
$frog

{% endhighlight %}

#### Compare Object

Comparing objects in powershell can be a right pain. Largely because it's hard to know what's it default comparison operator is between objects and it doesn't encourage types, so it's not like you can rely upon controlling comparsion by type. 

Let's say you have a complicated type that is your own custom powershell object. Just comparing the two of them, even if they seem to be the same, will produce False.

{% highlight powershell %}
$thing1 = [PSOBject]@{a='hello'; b='world'}
$thing2 = [PSOBject]@{a='hello'; b='world'}

$thing1 -eq $thing2
>>False
{% endhighlight %}

Note just how sad this is! In fact, this is sort of like python. If we compared just a straight hashtable rather than via a psobject, then the comparison would be fine. Hang on! That's actually not correct. Comparing two hashtables that are the same still produces False. Wtf.

{% highlight powershell %}
$thing1 = [PSOBject]@{a='hello'; b='world'}
$thing2 = [PSOBject]@{a='hello'; b='world'}

$thing1 -eq $thing2
>>False
{% endhighlight %}

We can use the explicit Compare-Object, but even it seems to suck balls for hashtables! It doesn't seem to be able to handle comparing keys and values at the same time...

There is the Compare-Object which seems to work.... for something like a PSObject

{% highlight powershell %}
$x = [PSOBject]@{a='hello'; b='world'}
$y = [PSOBject]@{a='hello'; b='world'}
Compare-Object $x $y
{% endhighlight %}


### Enumerations

In powershell v5, enumerations were added. Before that, posh users had to create enumerations using c#.

For background, see these two articles:
* [https://devblogs.microsoft.com/scripting/working-with-enums-in-powershell-5/](https://devblogs.microsoft.com/scripting/working-with-enums-in-powershell-5/)
* [https://devblogs.microsoft.com/scripting/new-powershell-5-feature-enumerations/](https://devblogs.microsoft.com/scripting/new-powershell-5-feature-enumerations/)

An enumeration can now be created like:

{% highlight powershell %}
Enum Stuff {
    Apple = 10
    Bear = 33
    David = 666
}
{% endhighlight %}

The weird thing is that it's a bit hard to get the values of the enumeration.
Anyway, Stuff becomes a new type.

{% highlight powershell %}
[Stuff]
[Stuff]::Apple
[Stuff]::Bear
{% endhighlight %}

The weird thing is each enumeration has a value__ property. Yes that really is a double underscore.
Fuck me! Why did powershell do that? I have no idea.

{% highlight powershell %}
[Stuff]:Apple.value__  # will print 10
{% endhighlight %}

To iterate over the enumeration, you need to use a method on [Enum] type.

{% highlight powershell %}
# or could write [enum]::GetValues([type]$enum)
ForEach ($thing in [enum]::GetValue([Stuff])) {
    $thing, $thing.value__
}

{% endhighlight %}

So let's say you want to find all the things in a particular enumeration, say the powerpoint file type enumeration

{% highlight powershell %}
# Might first have to import the assembly, or have it done for you like
# $ppt = New-Object -ComObject 'Powerpoint.Application'
$enum = [Enum][Microsoft.Office.Interop.Powerpoint.PpSaveAsFileType]
$pptStuff = @{}
ForEach ($_e in [enum]::getvalue($enum)) {
    $pptStuff.Add($_e, $_e.value__)
}
$pptStuff
{% endhighlight %}

### Parameters


{% highlight powershell %}
# At the top of a script, or function, place
Param(
    [Parameter(Mandatory=$true, Position=0, HelpMessage="First param called first")]
    $First, # comma between parameters, params are capital case by convention
    [Parameter(HelpMessage="Second Param has a default value")]
    $Second = "myDefault",
    [switch]$Flag, # switch parameter
)

{% endhighlight %}

Parameters are pretty interesting in powershell. There is something in the interpreter called the parameter binder. This is responsible for converting parameters (names of arguments) and arguments (the value itself) into a sensible type. Powershell is pretty generous. The parameter binder will try to convert values to required values. Etc.

### Splatting

Splatting is a nice way to feed params to a command. It's like pythons unpacking `hello(*pass)`.
Let's say there is a command I call in the same place with the same options. I don't want to repeat
those arguments each time, or at least, manually.

{% highlight powershell %}
# create an array of the options
# we could use a hash table to do keywords
$gitOptions = "git", "--params", "/GitOnlyOnPath /NoGitLfs /SChannel /NoShellIntegration"
# and then we unpack, we goes in the order unpacked
choco install -y @gitOptions
{% endhighlight %}


### Copying files and folders

Perhaps you want to copy the contents of a directory into the current directory.

This will copy all the contents of the remote directory into the current directory. The -recurse is pretty important, otherwise, you'll get just the top level of the files. The next handy feature is the star. Without the star, you get the contents of the 'copy' directory as a new directory in the current working directory.

{% highlight powershell %}
# get-alias -name cp
# get-alias -definition copy-item
copy-item the\folder\to\copy\* -recurse
{% endhighlight %}

### Find files in a directory

It's pretty typical that you'll have a directory, and you want to look for a particular file. Perhaps you want to find just the json files.

{% highlight powershell %}
# the -file parameter means don't consider directories to be items themselves, which isn't strictly necessary
get-childitem -recurse -path \folder\to\search\ -filter ".json" -File
{% endhighlight %}

While filter is efficient, it isn't that flexible (other than wildcards), because it's limited to filtering on 1 critera. But perhaps you want to filter off and .log, .png, and .txt files, and then get whatever is left. Welcome the `where-object` command, which is like select-string except it drops any object that doesn't match the criteria.

{% highlight powershell %}
# get-alias -definition get-childitem -> ls
# get-alias -definition where-object -> where, ?
# this command says get every file within the search folder, and then drop any files with extensions .json or .png or .log
get-childitem -recurse -file -path \folder\to\search | where-object {$_.extension -NotIn ".json", ".png", ".log"}
# equivalent to this
ls -recurse -file -path \folder\to\search | ? {$_.extension -NotIn ".json", ".png", ".log"}
{% endhighlight %}


### Get event logs from the system!

* Creating a boottime when the machine started today
* Then getting all the error logs

{% highlight powershell %}
$boottime = get-date -year 2019 -month 3 -day 12 -hour 09 -minute 44
get-eventlog -logname system -after -entrytype Error
{% endhighlight %}

* This prints a summary of the log information. But we might want to see everything. Do this:

{% highlight powershell %}
get-eventlog -logname system -after -entrytype Error | Select-Object -Property *
{% endhighlight %}

### Grep for lines in a text file

Or perhaps your trying to select lines with particular string? This prints out all lines with 'success'.

{% highlight powershell %}
get-content $filename | select-string "success"
# The alias for select-string is 'sls'
{% endhighlight %}

The select-string actually has some quite nice in-built functionality to search across directories or files. You can combine this:

{% highlight powershell %}
# Look through all the files in logfiles directory, drop any files not ending in .log, get the contents of the file
# and then search the contents for 'success'
get-childitem \path\to\logfiles | where-object {$_.extension -eq ".log"} | get-content | select-string "success"
{% endhighlight %}


In just one call

{% highlight powershell %}
select-string -path \path\to\logfiles*.log -pattern "success"
{% endhighlight %}

### Get the date!

This prints the date now, which I think using some system type

{% highlight powershell %}
$([DateTime]::Now)
{% endhighlight %}

But there is a whole powershell commandlet for it

{% highlight powershell %}
# prints date & time in a timestamp format, though not suitable for filenames
Get-Date -Format o
# custom one for filenames
Get-Date -UFormat "%Y-%m-%d_%Hh%Mm%Ssec"
{% endhighlight %}

### Mark as script as admin only

Quite a few scripts will require administrator privileges to be effective. Powershell provides a way to mark a script as needing higher privileges. You can use this directive. It a lot of ways it looks like a comment, but it isn't without an effective. Put it at the top of the script.

{% highlight powershell %}
#Requires -RunAsAdministrator
{% endhighlight %}


### Create an background job

* Creating a background job to cp test result into investigating dir. Note, I've already set $invest
* Start-Job pwd is not the cwd. It's cwd is in your Documents folder for some reason.

{% highlight powershell %}
Start-Job -ScriptBlock {cp -recurse \\<filepath> $invest}
# This will get information about status of the background job
Get-Job -Id 1
{% endhighlight %}

* ExpertT also suggested trying asychronous cp alternative `get-command -noun bitstransfer`

### Debugging

Commands:

* Enter-PSHost
    - This allows you to grab other powershell process and begin debugging them. You cannot debug the process this is invoked in. It is only for other powershell processes. Not the current one.

* Debug-Runspace
    - Not sure what this does. But I think that multiple powershell processes can be hosted in a single runspace, or something. Again, you can't debug the 'default' or current runspace which you can find through "$ExecutionContext.Host.Runspace".

* Set-PSDebug -Trace 1
    - Doesn't start an interactve debugger but does trace every call. Which is very useful.

* Set-PSDebug -Step
    - This is the normal stepwise debugger! Yes!

To stop the debugger type

* Set-PSDebug -off


This will trace how the parameters are bound in the expression. Parameter binding in powershell is quite complicated.
{% highlight powershell %}
Trace-Command -Name ParameterBinding  -Option All -Expression { 123 | Write-Output } -PSHost
{% endhighlight %}

Actually [this article](https://devblogs.microsoft.com/scripting/use-the-powershell-debugger-to-troubleshoot-scripts/) perhaps is most useful, if you want to run the code and then let it hit the exception. 

You can use `Set-PSBreakPoint` to set a line on a script that will trigger the debugger.

{% highlight powershell %}
Set-PSBreakpoint -Script .\wake-on-lan.ps1 -Line 64
# then just run the script
.\wake-on-lan.ps1
# and at line 64 the debugger will open, use ? or h to get the help for the debugger.
{% endhighlight %}


#### Tracing/Capturing session output with a transcript

Sometimes, especially with remote machines and when you're calling powershell through some third party like ruby, you want a way to record what the is happening when you run a script and you want to store all the output you see at the console.

You can use `Start-Transcript` and `Stop-Transcript` and point the transcript to a file, like `Start-Transcript -Path 'posh.log'`

### Error behaviour

The default behaviour of powershell - unlike python - is to continue if it hits an error. This is actually somewhat sane given it's a system admin shell. The sensitivity of python to exceptions can make it fiddly and certainly more likely to stop doing work that could be useful.

However, Powershell provides the user with a way to control the error behaviour by setting a session variable called the ErrorActionPerference. The variable determines whether to treat unhandled errors as terminating or non-terminating errors.

```
$ErrorActionPreference = "Stop"  # Or one of 'Continue', 'SilentlyContinue', 'Stop', 'Inquire', 'Suspend'
```

#### Terminating errors

Terminating errors are very important and a potential trip-up. Just because something appears to write an error does not mean it is a terminating error. A terminating error in powershell is one that will throw an unhandled exception and will stop your program unless it's caught by a try catch. However, most?/many errors in powershell are **non-terminating** by default. For good reason, because powershell wants your code to do as much work as possible.

However, observe:

{% highlight powershell %}
C:\dev\repo [donal_branch ≡ +2 ~0 -0 !]> Import-Module 'DOES NOT EXIST'
Import-Module : The specified module 'DOES NOT EXIST' was not loaded because no valid module file was found in any module directory.
At line:1 char:1
+ Import-Module 'DOES NOT EXIST'
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ResourceUnavailable: (DOES NOT EXIST:String) [Import-Module], FileNotFoundException
    + FullyQualifiedErrorId : Modules_ModuleNotFound,Microsoft.PowerShell.Commands.ImportModuleCommand

C:\dev\repo [donal_branch ≡ +2 ~0 -0 !]> try { Import-Module 'DOES NOT EXIST'} catch { write-host 'Hello from the catch' }
Import-Module : The specified module 'DOES NOT EXIST' was not loaded because no valid module file was found in any module directory.
At line:1 char:7
+ try { Import-Module 'DOES NOT EXIST'} catch { write-host 'Hello from  ...
+       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ResourceUnavailable: (DOES NOT EXIST:String) [Import-Module], FileNotFoundException
    + FullyQualifiedErrorId : Modules_ModuleNotFound,Microsoft.PowerShell.Commands.ImportModuleCommand

C:\dev\repo [donal_branch ≡ +2 ~0 -0 !]> try { 1/0 } catch { write-host 'Hello from the catch' }
Hello from the catch
C:\dev\repo [donal_branch ≡ +2 ~0 -0 !]> $error[0]
Attempted to divide by zero.
At line:1 char:7
+ try { 1/0 } catch { write-host 'Hello from the catch' }
+       ~~~
    + CategoryInfo          : NotSpecified: (:) [], RuntimeException
    + FullyQualifiedErrorId : RuntimeException

C:\dev\repo [donal_branch ≡ +2 ~0 -0 !]> $error[1]
Import-Module : The specified module 'DOES NOT EXIST' was not loaded because no valid module file was found in any module directory.
At line:1 char:7
+ try { Import-Module 'DOES NOT EXIST'} catch { write-host 'Hello from  ...
+       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ResourceUnavailable: (DOES NOT EXIST:String) [Import-Module], FileNotFoundException
    + FullyQualifiedErrorId : Modules_ModuleNotFound,Microsoft.PowerShell.Commands.ImportModuleCommand

C:\dev\repo [donal_branch ≡ +2 ~0 -0 !]> try { Import-Module 'DOES NOT EXIST' -ErrorAction stop } catch { write-host 'Hello from the catch' }
Hello from the catch
C:\dev\repo [donal_branch ≡ +2 ~0 -0 !]> $error[0]
Import-Module : The specified module 'DOES NOT EXIST' was not loaded because no valid module file was found in any module directory.
At line:1 char:7
+ try { Import-Module 'DOES NOT EXIST' -ErrorAction stop } catch { writ ...
+       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ResourceUnavailable: (DOES NOT EXIST:String) [Import-Module], FileNotFoundException
    + FullyQualifiedErrorId : Modules_ModuleNotFound,Microsoft.PowerShell.Commands.ImportModuleCommand
{% endhighlight %}

Note, the importance of this:
- Just because an error occurs inside a try/catch does not mean it's always going to trigger the catch
- Some types of errors default to be terminating (i.e. divide by zero)
- Other types of errors default to be non-terminating (like the import-module)
- For cmdlets, you can use the -ErrorAction to make a non-terminating error terminating

There is an discussion about this online at [https://github.com/MicrosoftDocs/Powershell-Docs/issues/1583](https://github.com/MicrosoftDocs/Powershell-Docs/issues/1583)


#### Exception does not print line error occurred?

My shell, I put in:

{% highlight powershell %}
function Badness {
    param (
        [Parameter(Mandatory=$true)]
        $Url
    )
    Nested -Url $Url
}
function Nested {
    param($Url)
    Invoke-RestMethod -Url $Url
}
Badness -Url 'www.google.com'
{% endhighlight %}

ExpertT's shell showed, and he said _"the error stack is very nice because even if something deep down a call emits an error, it'll be in the error stack which means you don't necessarily have to redo the erroring operation with a debugger or add logging a snippet of the error record automatically rendered in my shell:"_

{% highlight powershell %}
(109)C:\dev\repo> Badness -Url 'www.google.com'
Invoke-RestMethod : A parameter cannot be found that matches parameter name 'Url'.
At line:10 char:23
{% endhighlight %}

..._Which is what you wanted to see? and the error record has the useful invocationinfo property as we explored earlier also another property:_

{% highlight powershell %}
> $e.ScriptStackTrace
at Nested, <No file>: line 10
at Badness, <No file>: line 6
at <ScriptBlock>, <No file>: line 1
{% endhighlight %}

_...Which is useful too inside the errorrecord object is also the exception...(object, OF COURSE): ExpertT: an interesting property on that_

{% highlight powershell %}
>$e.Exception.targetsite
Name                       : VerifyArgumentsProcessed
DeclaringType              : System.Management.Automation.CmdletParameterBinderController
ReflectedType              : System.Management.Automation.CmdletParameterBinderController
MemberType                 : Method
MetadataToken              : 100671752
Module                     : System.Management.Automation.dll
... ## snipped
{% endhighlight %}

_...which looks like it is showing the parameter binding exception"._

Donal said _"That isn't what my shell shows. It shows:"_

{% highlight powershell %}
C:\Users\donal.mee> Badness -Url 'www.google.com'
Badness : A parameter cannot be found that matches parameter name 'Url'.
At line:1 char:1
+ Badness -Url 'www.google.com'
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidArgument: (:) [Badness], ParameterBindingException
    + FullyQualifiedErrorId : NamedParameterNotFound,Badness
{% endhighlight %}

ExpertT says _"I suspect you have $ErrorActionPreference='stop' which is not a canonical way to drive the pipeline so I recommend you set it to Continue the idea is usually to drive a pipeline as much as you can, then collect errorrecords and decide if you want to retry or not or do something alternative the idea isn't usually to panic and stop. the difference between 'ignore' and 'silentlycontinue' is whether an errorrecord is popped onto the error stack. You will find that the type of object you get back off the errorstack differs when erroractionpreference='stop'. System.Management.Automation.CmdletInvocationException  vs  System.Management.Automation.ErrorRecord"_


### Catching an exception

When powershell writes an error to stdout, it often gives it name that you can't then catch. What? I must not understand something about powershell exceptions. For example, ls a directory that doesn't exist.

```
C:\dev\infra [master ↑3 +0 ~4 -1 | +10 ~3 -0 !]> ls __init__.pycas
ls : Cannot find path 'C:\dev\infra\__init__.pycas' because it does not exist.
At line:2 char:1
+ ls .\__init__.pycas
+ ~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (C:\dev\infra\__init__.pycas:String) [Get-ChildItem], ItemNotFoundException
    + FullyQualifiedErrorId : PathNotFound,Microsoft.PowerShell.Commands.GetChildItemCommand
```

You'd think you could catch this with something like this

{% highlight powershell %}
try {
    ls .\__init__.pycas
}
catch [Microsoft.PowerShell.Commands.GetChildItemCommand] {
    write-host "caught!"
}
{% endhighlight %}

Alas not! The ErrorID is not the thing to catch. Not is `[ItemNotFound]` or anything else in the stdout. Ahh!

However, there is a way to discover the error type to catch and the error type to catch is suprising.

{% highlight powershell %}
try {
    ls .\__init__.pycas
}
catch {
    $_.exception.gettype().fullname
}
{% endhighlight %}

Which will print `System.Management.Automation.ItemNotFoundException`. WTF! Yeah. So to catch this you'd write

There's also the error exception stack. Which has the last errors on the stack.

{% highlight powershell %}
>$e = $error[0]  # get the most error
>$e.Exception.GetType().fullname
System.Management.Automation.ItemNotFoundException
{% endhighlight %}


{% highlight powershell %}
try {
    ls .\__init__.pycas
}
catch [System.Management.Automation.ItemNotFoundException] {
    write-host "finally caught!"
}
{% endhighlight %}

**Note!** Just because something is in the `$error` stack it does not mean it was a _terminating_ error and you writing try/catch will not neccessarily catch it. See above on terminating errors.

### Throwing exceptions

Perhaps you want to throw an exception. Why wouldn't you? This is were the `throw` keyword comes in.

Let's say I have been writing a function, but it's not finished. And I'd like to throw an error if
the user tries to call it.

{% highlight powershell %}

function Do-Plumbing() {
    # We all know Plumbers never finish their work.
    throw [System.NotImplementedException]
}
{% endhighlight %}

Interesting, the throw can throw any object, like a user message or a string. Lolcats. Yes indeed.

{% highlight powershell %}

function Call-Plumber() {
    # We all know plumbers don't answer their phones either
    throw "This is Dave. I'm not available now. Leave a message."
}
{% endhighlight %}

And, like in Powershell, there is a Command-let for everything. There is the Write-Error commandlet. But this just writes to the stderr. It does not generate a terminating error.

{% highlight powershell %}
write-error 'Well, if you hit an error, why would you want to stop?'
{% endhighlight %}

### Remote commands

There is a pretty detailed PS doc section [here](https://docs.microsoft.com/en-us/powershell/scripting/learn/remoting/running-remote-commands?view=powershell-5.1)
- [Tutorial on remoting](https://www.youtube.com/watch?v=PMRkM9jlMMw)
- [Overview of remoting](https://www.youtube.com/watch?v=MyQGk29w-BM)

Needs to be enabled on the remote machine first, and you also need to enable remoting on the client.

{% highlight powershell %}
Enable-PSRemoting -Force
# There is also the older but I guess almost equivalent
winrm quickconfig
# This should set the WinRM service to run and enable relevant firewall rules
Get-NetFirewallRule -Name *winrm*
{% endhighlight %}

Please note that Powershell Remoting is a complicated topic. But WinRM is one of the transport layers that Posh remoting can work over. There are a bunch of others, including SSH.

This works provided your on the same AD domain. Otherwise, you'll need to specify some trusted machines that are allowed to connect. See [here](https://www.howtogeek.com/117192/how-to-run-powershell-commands-on-remote-computers/)

There are quite a number of settings. On the client machine, the relevant area is in

{% highlight powershell %}
ls wsman:localhost\client
# We can very generously set all possible hosts as trusted.
Set-Item wsman:localhost\client\TrustedHosts *
# Also the relevant authenication methods that are allowed by the client are, set the ones you care about to true
ls wsman:localhost\client\auth
{% endhighlight %}

* Test the connection to the server:

{% highlight powershell %}
Test-WsMan <COMPUTERNAME>
{% endhighlight %}

You may find it's hard to connect to the computer. This is normally a networking issue. Check whether the machine is on the domain and whether the full-qualified domain host (FQDN) is resolvable. If it is not resolvable, then you can't use that name to connect to the machine. Instead, you'll need to use the IP address. Some of the authencation options, like CredSsp, don't seem to work well with IP addresses.

Thus try using default authentication

{% highlight powershell %}
$tbhr = Get-Credential -UserName <username> -Message 'Connecting to machine'
# Also, note user is an admin on the machine, then you can probably use that account to connect. However, what users are allowed to connect to a machine via RDP is a configurable property.

$donzer = New-PSSession -Credential $tbhr -Authentication default -ComputerName 10.14.2.213
Invoke-Command -Session $donzer -ScriptBlock { dir \ }
{% endhighlight %}

How to check whether a name is resolvable? nbtstat loops through

{% highlight powershell %}
nbtstat -a machinex.test.corpb.local
{% endhighlight %}

There are also some powershell commands

{% highlight powershell %}
> Resolve-DnsName vmaas-466265                                              
                                                                                              
Name                                           Type   TTL   Section    IPAddress              
----                                           ----   ---   -------    ---------              
vmaas-466265.corpb.net                       A      0     Answer     92.242.132.24          
                                                                                              
                                                                                              
> Resolve-DnsName vmaas-466265.test.corpb.local                           
                                                                                              
Name                                           Type   TTL   Section    IPAddress              
----                                           ----   ---   -------    ---------              
vmaas-466265.test.corpb.local                A      1200  Answer     10.14.2.213            
                                                                                              
                                                                                              
> Resolve-DnsName vmaas-466265                                              
                                                                                              
Name                                           Type   TTL   Section    IPAddress              
----                                           ----   ---   -------    ---------              
vmaas-466265.corpb.net                       A      0     Answer     92.242.132.24          
                                                                                              
# Note! The 92.242.132.24 are misleading responses. Use nslookup to check the domain.
# It is barefruit.co.uk which VirginMedia uses to serve a page of search results as this is effectively
# a DNS miss. Pretty annoying!
{% endhighlight %}

A powershell command a bit like ping or traceroute is Test-NetConnection. Note quite a lot of networks don't allow pings so traceroute can suffer from these black holes :-(

{% highlight powershell %}
>Test-NetConnection vmaas-466265.test.corpb.local
>tracert.exe "vmaas-466265.test.corpb.local"
{% endhighlight %}

Netstat is also a super useful command that will display what TCP/IP ports are active on your machine

{% highlight powershell %}

{% endhighlight %}

* Invoke a single command

`
Invoke-Command -ComputerName COMPUTER -ScriptBlock { COMMAND } -credential USERNAME
`

* Enter a remote session

`
Enter-PSSession -ComputerName COMPUTER -Credential USER
`

### Create a transcript

You can create a transcript of everything that is typed and output to a powershell script using `Start-Transcript`. It outputs a timestamped file into your documents. Call `Stop-Transcript` to end.

### Convert something to a bool

The [boolean] placed in front of stuff does a good job of truthy conversion.

{% highlight powershell %}
function _chocoInstalled($package) {
    return ![boolean](choco info $package --local-only | Where {$_ -match "0 packages installed"})
}
{% endhighlight %}

### Delayed execution, lambda/anonomous functions

The excellent {} syntax provides a way to have a callable bit of code that is later executed.

{% highlight powershell %}
$vmaasInstallation = {Test-Path "C:\Program Files (x86)\Git\cmd\git.exe"}
& $vmaasInstallation
{% endhighlight %}

### Function decorators

Basic syntax for writing a decorator

{% highlight powershell %}

function test { iwr google.com }

rename-item function:\test wrapped-test

function test { write-host "wrapping test"; wrapped-test }
{% endhighlight %}

Writing a cache using a decorator that does some memoisation.

{% highlight powershell %}
function get-url($url) { iwr $url }

rename-item function:\get-url wrapped-get-url

$_RESULT = @{}

function get-url($url) {
  if (-not $_RESULT[$url]) {
    write-host "$url not in cache"
    $_RESULT[$url] = wrapped-get-url -url $url
  }
  else {
    write-host "$url in cache"
  }
  $_RESULT[$url]
}
{% endhighlight %}

I had originally wanted "Does powershell have a memoisation decorator type function like python's [lru_cache](https://docs.python.org/3/library/functools.html#functools.lru_cache)? I have IO bound file query thing that would be nice to use something like lru_cache for. Otherwise, I'm going to use a global dictionary"

### Reimporting a module

Debugging a module you'll often have to reload it.  Use -force

{% highlight powershell %}
Import-Module tooDebug.ps1
# do debuging, edit file, save and wish to reload it
Import-Module tooDebug.ps1 -force
{% endhighlight %}

### Find current file location's

In general, a stack overflow suggested inspecting the help about automatic variables:

{% highlight powershell %}
get-help about_Automatic_Variables -full
{% endhighlight %}

However, to answer the question, Powershell equivalent of python's __file__ is:

{% highlight powershell %}

$__file__ = $MyInvocation.MyCommand.Definition
# Can get the directory like
$__dir__ = Split-Path $__file__
{% endhighlight %}

Though the name I've given it, with double-duners makes me wonder whether powershell enforces public/private names with underscores?

### Scopes

```BASH
@'
>> function lfunc { $x = 100; $script:x = 10; "lfunc: x = $x"}
>> lfunc
>> "my-script:x = $x"
>> "global:x = ${global:x}"
>> '@ > myscript.ps1
```

There's a global scope that can be accessed using "$global:"  the colon is important. Then there is a script scope in scripts "$script:".

### Try to return last-exit code only from a function

In python, when we return something from a function, we need to be explicit and use 'return' otherwise the function will return None.

However, in powershell, it implicitly returns things from the function. This is because powershell is a shell, it doesn't return results - it writes output or emits objects. This makes some difference!

For example, this code is trying to determine whether the linter passed or failed

{% highlight powershell %}
function Lint-Bem {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="Select a Linter")]
        [ValidateSet('pylint', 'flake8')]
        [string]$Linter
    )
    # Note Linter directly maps to the name of the test within selftests
    # but cannot add .py to the end, otherwise test-discovery fails.
    python $_run_script "py.selftests.test_$Linter"
    if ($LastExitCode -eq 0) {
        write-host "last-exit code is $LastExitCode"
        return $True
    }
    else {
        write-host "last-exit code is $LastExitCode"
        return $False
    }
}


function Lint-Interactive {
    Param(
        [string]$Linter
    )
    $resp = Read-Host "Run ${Linter}? Y/N"  # User may want to skip a linter
    if ($resp -match "y") {
        $result = Lint-Bem $Linter
        
        if (-not $result) {  # It the linting fails
            $resp = Read-Host "$Linter linting failed. Ignore? Y/N"
            if ($resp -match "n") {  # User cares that the linter has failed, exit 1
                Write-host "Stopping linting. Exit 1"
                exit 1
            }
            # else use is ignoring faiure and continuing
        }
        else {
            write-host "result is $result"
        }
        # else linter passed
    }
    # else user is skipping this linter
}
{% endhighlight %}

The problem is that even if the $LastExitCode in Lint-Bem is not zero, the 'if (-not $result)' does not resolve to True and so the user is never asked whether the want to ignore the failed result. Ahh!

It's because the $result is actually filled with all the objects written to the output and not use a boolean. Ahh!

It looks like this:

```
last-exit code is 1
result is C:\dev\repo\tests\py\log.py:7:1: E302 expected 2 blank lines, found 1  C:\dev\repo\tests\py\log.py:38:43: F823 local variable 'proc' (defined in enclosing scope on line 19) referenced before assignment  C:\dev\repo\tests\py\log.py:58:16: F821 undefined name 'connect'  C:\dev\repo\tests\py\log.py:59:27: F821 undefined name 'connect'   2019-04-16 12:00:30,256 ERROR [plugins:addFailure:59] Test failure for py.selftests.test_flake8.Flake8Tests.test_flake8 2019-04-16 12:00:30,266 INFO [run:main:138] Exiting with True False
```

### Returning things from functions

Perhaps you want to return a custom object. That's very useful. Let's say we have matched upon a URL, and extract some useful information about the object.

Like in python, we can return a tuple of stuff. But that's not as useful as returning a nicely structured object.

For example,

{% highlight powershell %}

<#
    .SYNOPSIS
    Useful for providing a jenkins URL and getting back useful information extracted from
    the URL. Meant as a helper function.
#>
function Match-JenkinsJobUrl {
    Param(
        [Parameter(HelpMessage="Jenkins URL to extract a job and number from. Does not currently handle urls without a jobname and build number in them.",
                   Mandatory=$true)]
        [string]
        $Url
    )
    # expecting URl to be something like https://jenkins.uk.corpb.net/job/cam_Component_Tests_On_Vmaas/3097/console
    # or perhaps https://jenkins.uk.corpb.net/job/cam_Component_Tests_On_Vmaas/3097/
    $Url -match "(.*corpb\.net\/)job\/(\w+)\/(\d*)" | out-null
    if ($matches) {
        $hostname = $matches[1]
        $Jobname = $matches[2]
        $BuildNumber = $matches[3]

        return New-Object PSObject -Property @{
            Url = $Url
            Hostname = $hostname
            Job = $Jobname
            JobUrl = "${hostname}job/${Jobname}"
            Build = $BuildNumber
            BuildUrl = $matches[0]
        }

    }
    else {
        # don't actually prnt the url, use escape of $ variable expansion with ''
        throw '$url does not match regex.'
    }
}
{% endhighlight %}

The useful command here is the ++New-Object++ command.

## The AST

Powershell really opens the interpreter to you. The AST is available to you. Letting you do meta programming stuff.

For example, the peskiness of erroaction means you need to check whether a command may at some point use 'throw' because other -erroraction is insufficent to continue if there's an error. Lets write a function that at least checks whether any commands written in posh contain a throw. Lets look at the AST

```posh
filter test-throws {
    if (-not $_.scriptblock) {
        write-warning "no script found for $_"
        return
    }
    else {
        [bool]$_.Scriptblock.ast.findall({$args[0] -is [System.Management.Automation.Language.ThrowStatementAst]}, $true)
    }
}
```

## POSH things that suck

The requirement for some things where one uses '-confirm -force' and it still asks for user input, e.g.
(Though I believe this a faulty implementation by those who made this commandlet.)

I believe the fix here is to run powershell in NonIteractive mode! E.g. see https://serverfault.com/a/642848 

{% highlight powershell %}
function SetUSUKKeyboard() {
    Write-Verbose "Setting uk and us keyboard"
    # set call here doesn't care, always stop and waits for user input
    set-winuserlanguagelist en-GB, en-US -Confirm -Force
}
{% endhighlight %}

NO! The posh above is wrong, this works

```posh
    set-winuserlanguagelist en-GB, en-US -Force
```

The -confirm is actually to ask the user to confirm.... Ruby would have named the parameter Confirm?

Does not have any context-manager equivalent to 'with' that python has! As far as I can tell. I think you are required to rely upon try and catch. A common example, a script can only be run from a particular directory. Need to write cd to the directory and if script errors, switch back out of the directory in the catch. Or something like that.

### Namespaces

In powershell, if you want to get access to some .net class, you can use the full name like this:

{% highlight powershell %}
# For windows form, we first need the load the assembly
using assembly System.Windows.Forms
# The [] is the type operator, it says we are specifying the class/type name
# This specifies the windows form type
[System.Windows.Forms.Form]
# But this is obviously quite long to write, so we can load in the namespace which
# means we can use [Form] the class
using namespace System.Windows.Forms

$form = [Form] @{
 Text = 'My First Form'
}
$button = [Button] @{
 Text = 'Push Me!'
 Dock = 'Fill'
}
$button.add_Click{
 $form.Close()
}
$form.Controls.Add($button)
$form.ShowDialog()
{% endhighlight %}

However, the namespace syntax is just like pythons `from Forms import *`. Ahh! How can one know that the [Form] is from System..Windows.Forms rather than some other library? You can't...

The `using namespace <name>` means load in a .NET class. Whereas, if you want to load in a powershell module you would write `using module <name>`.

I assume the `using assembly <name>` means something like load in a dll?

Extract from Powershell in Action about using assembly,

    """Here are a couple of important points to remember about the using statement. First,
    it has to be the first non-comment statement in a script or module. This is because,
    with using, types are resolved at compile time instead of runtime. This is a good thing
    because it helps you catch your errors sooner. Second, you have to have the assembly containing the reference type namespace loaded before you can run your script.
    Because a lot of things are loaded by PowerShell by default this isn’t that much of a
    problem. This is what using assembly <...> is intended for. By specifying both statements as shown in the example, everything will work fine."""


### Out-string, tricky strings!

Ah it's easy to get tricked with powershell's automatic conversion of objects to strings. I had the contents of a file from `$lines = Get-Content file.log`, when I tried to put it into a string "$lines", all the newlines were gone. Whoops. Took me a while to find out I needed to use Out-String.


From ExpertT: _"what you're seeing is the inbuilt default "Out-Default" function draining remaining objects in the pipeline and rendering them in the 'default' way (which is amazingly rich and complex as it happens) but the one truth about powershell is what looks like a string very likely isn't"_

### Conver between user names and ssids

Coming from [https://community.spiceworks.com/how_to/2776-powershell-sid-to-user-and-user-to-sid](https://community.spiceworks.com/how_to/2776-powershell-sid-to-user-and-user-to-sid)

This will give you a Domain User's SID
{% highlight powershell %}
$objUser = New-Object System.Security.Principal.NTAccount("DOMAIN_NAME", "USER_NAME")
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$strSID.Value
{% endhighlight %}


This will allow you to enter a SID and find the Domain User
{% highlight powershell %}
$objSID = New-Object System.Security.Principal.SecurityIdentifier `
("ENTER-SID-HERE")
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount])
$objUser.Value
{% endhighlight %}

Convert from local user to sid.
{% highlight powershell %}
$objUser = New-Object System.Security.Principal.NTAccount("LOCAL_USER_NAME")
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$strSID.Value
{% endhighlight %}

### Certicates

Powershell provides access to the certstore. That's where the machines certificates are kept

{% highlight powershell %}
> ls Cert:
                                                                                 
Location   : CurrentUser                                                         
StoreNames : {TrustedPublisher, ClientAuthIssuer, Root, UserDS...}               
                                                                                 
Location   : LocalMachine                                                        
StoreNames : {TestSignRoot, ClientAuthIssuer, Remote Desktop, Root...}           
                                                                                 
                                                                                 
                                                                                 
{% endhighlight %}

### Conflicting powershell commands

Powershell doesn't prevent you importing or overwriting commands with the same name. For instance, the s0s shell defines it's own Compare-Object command.

{% highlight powershell %}
C:\Users\donal.mee> get-command compare-object                                                                          
                                                                                                                        
CommandType     Name                                               Version    Source                                    
-----------     ----                                               -------    ------                                    
Function        Compare-Object                                     0.0.2      s0s                                       
                                                                                                                        
                                                                                                                        
C:\Users\donal.mee> get-command -name *compare-object*                                                                  
                                                                                                                        
CommandType     Name                                               Version    Source                                    
-----------     ----                                               -------    ------                                    
Function        Compare-Object                                     0.0.2      s0s                                       
Cmdlet          Compare-Object                                     3.1.0.0    Microsoft.PowerShell.Utility              
                                                                                                                        
                                                                                                                        
{% endhighlight %}

One way to select the want you want is to remove the offending module

{% highlight powershell %}
remove-module s0s
{% endhighlight %}

But, you can also provide the module name before invoking the command, to be more specific. The source seems to be where to select this.

{% highlight powershell %}
microsoft.powershell.utility\Compare-Object
{% endhighlight %}

{% highlight powershell %}
s0s\Compare-Object
{% endhighlight %}

### Comparing nested objects

There is an in-built compare-object, but try to compare two hashes. Even if their contents are the different or the same the compare-object is useless. It cannot compare nested objects or really objects of much complexity.

You need to select the properties that you want to compare it with. ExpertT's shell has an enhanced compare object and compare dictionary function. The inbuilt one is pretty crap.

### Write-host host console wtf?

It's actually hard to capture all the output of the powershell console. It has the idea of streams but a lot of stuff doesn't write to the streams. This is the problem with write-host. It writes directly to the host program, skips the streams so the user can see it but the console buffers don't see if. Thus you can't actually capture the output to a text file. This sucks!

```posh
powershell.exe *>&1 > posh.log -command <script that writes to the host directly>
# However, the posh.log will only contain output to the host, like the stuff from set-psdebug -trace 1 but it will not contain
# the input commands, so all you have is output which is half the puzzle...
```

And even more annoying, lets say you want to trace the execution of a program with set-psdebug -trace 1 and redirect that output to a file. Nope, no luck. It writes directly to the host, not the console. So you effectively can't capture it.

### Verbose perference

It doesn't seem to work. Its not a global thing if it's set in a script. So your subsequent calls don't see the verbose preference being set. You probably have to set it as a global preference or something.

### Classes

POSH classes suck. They are available but can only be loaded as dotnet runtime classes and so you can't actually load them through the import-module stuff. It's actually bound once into the runtime and can't re unloaded, unless there's some dotnet tricks that will let you do it.

POSH seems to expect everyone to use dynamic method/attribute addition methods to build 'objects'. But it's sucky objects in my opinion.


### Catching errors with -erroraction

Actually, you'd think erroraction is respected. It's not... There's some commentary above.

But basically you can't know ahead of time whether something is going to use 'throw' and so whether you need to wrap it in a try/catch. You basically have to write a parser... see the abstract. Note, how to write a parser for dotnet code is more tricky I suspect.


### GUIs with Powershell

From Mr Powershell.

{% highlight powershell %}
Add-Type -AssemblyName System.Windows.Forms
$Form = New-Object system.Windows.Forms.Form
$Form.Text = "Form"
$Form.TopMost = $true
$Form.Width = 200
$Form.Height = 200
$GetDate = New-Object system.windows.Forms.Button
$GetDate.Text = "GetDate"
$GetDate.Width = 100
$GetDate.Height = 30
$GetDate.Add_Click({
#add here code triggered by the event
    $Results.Text = Get-Date
})
$GetDate.location = new-object system.drawing.point(60,60)
$GetDate.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($GetDate)
$Results = New-Object system.windows.Forms.TextBox
$Results.Text = ""
$Results.Width = 100
$Results.Height = 20
$Results.location = new-object system.drawing.point(40,23)
$Results.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($Results)
[void]$Form.ShowDialog()
$Form.Dispose(); write-host "Date entered is $($Results.text)"
{% endhighlight %}

### Trap statements

You can write a trap {} statement at the top of a module and any unhandled error will pop up into this trap. It's very strange.

```
help about_trap
```

```
param(
    $whatever
)
trap {
    write-warning "TRAP HANDLER"
    $_
    exit 1
}

# other scripting here if hits an error
...
# the error is caught by the trap.
```

you could throw, and have a top-level trap which will run if exceptions are not caught - that way you can log into the Jenkins console the uncaught exception, then always return the appropriate exit code too

It's handy in the model of: modules of lots of functions, plus one top-use-case-level-script using whichever functions it wants...in that one use-case-level-script you bang in a trap to turn powershell error objects into serialised objects and some console printing, then exit.

say instead of doing this

```
# Execute each supplied action, switching on the action
ForEach ($Act in $Actions) {
    switch($Act) {
        "Seed" { $result = Step-FoodparkSeed -VmaasUser $VmaasUser -VmaasToken $VmaasToken @ExtraParams }
        "Build" { $result = Step-FoodparkBuild @ExtraParams }
        "Test" { $result = Step-FoodparkTest @ExtraParams }
        "Finalize" { $result = Step-FoodparkFinalize @ExtraParams }
    }
    if ($result.exitCode -ne 0) {
        # Need to signal to jenkins or whatever build system that the step failed.
        write-warning "Step-Foodpark$Act result.exitCode=$($result.exitCode), exiting pipeline"
        exit $result.exitCode
    }
    else {
        # all good
        write-verbose "Step-Foodpark$Act result.exitCode=0"
    }
}
```

you could throw, and have a top-level trap which will run if exceptions are not caught - that way you can log into the Jenkins console the uncaught exception, then always return the appropriate exit code too

you can throw from each place, but the single trap is to catch all uncaught exceptions - so you just have the one, typically at the top of a script.

```
(33)C:\tmp\suvp2010woe> & { trap {"oops! $_"}; sillycommand1; sillycommand2}
oops! The term 'sillycommand1' is not recognized as the name of a cmdlet, function, script file, or operable program. Check the spelling of the name, or if a path was included, verify that the path is correct and try again.
sillycommand1 : The term 'sillycommand1' is not recognized as the name of a cmdlet, function, script file, or operable program. Check the spelling of the name, or if a path was included, verify that the path is correct and try
again.
At line:1 char:24
+ & { trap {"oops! $_"}; sillycommand1; sillycommand2}
+                        ~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (sillycommand1:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException

oops! The term 'sillycommand2' is not recognized as the name of a cmdlet, function, script file, or operable program. Check the spelling of the name, or if a path was included, verify that the path is correct and try again.
sillycommand2 : The term 'sillycommand2' is not recognized as the name of a cmdlet, function, script file, or operable program. Check the spelling of the name, or if a path was included, verify that the path is correct and try
again.
At line:1 char:39
+ & { trap {"oops! $_"}; sillycommand1; sillycommand2}
+                                       ~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (sillycommand2:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException
```


### Exit codes aren't what they seem

https://stackoverflow.com/questions/10666101/lastexitcode-0-but-false-in-powershell-redirecting-stderr-to-stdout-gives

Sometimes $? can be $true but the $lastexitcode is greater than 0.

### Variable squashing


```
[10/28 8:57 AM] Howes, Tim
    A nice thing in interactive Powershell, especially when working through with someone else remotely: "variable squeezing"
(1 liked)​[10/28 8:57 AM] Howes, Tim
    
> ($toUseAgain=get-date)
28 October 2020 08:56:57
> $touseagain
28 October 2020 08:56:57

​[10/28 8:58 AM] Howes, Tim
    obvs that's a daft example, but if you have a long running operation you want to cache the answer into a variable. But you often want to see something straight away, at least to see if the operation worked. So here you get to stuff the result in the variable, and immediately see the pipeline output
​[10/28 8:58 AM] Howes, Tim
    ordinarily without the squeeze:
​[10/28 8:58 AM] Howes, Tim
    
> $toUseAgain=get-date

​[10/28 8:59 AM] Howes, Tim
    yields nothing to the pipeline
<https://teams.microsoft.com/l/message/19:f7005fe988bb4e3d8cc29551634a88d7@thread.tacv2/1603875432324?tenantId=ca7981a2-785a-463d-b82a-3db87dfc3ce6&amp;groupId=30e1feec-9271-415b-9876-5a5429fc02d5&amp;parentMessageId=1603875432324&amp;teamName=Bromium&amp;channelName=Powershell help desk&amp;createdTime=1603875432324>
```


### Queues and Sets

```
[1:15 PM] Howes, Tim
    Reminder!  Although Powershell has "as you'd expect" synactic sugar for arrays and dictionaries, you still have the colossal .net under the hood; so you can use whatever collections you like - albeit without sugar.  However, what is fun is that if you type an object strongly you can keep using that interactively.  Say you might want to use a queue :  
​[1:15 PM] Howes, Tim
    
[System.Collections.Queue]$queue=@()

​[1:16 PM] Howes, Tim
    from then on any array you assign into $queue will be converted into a queue
​[1:16 PM] Howes, Tim
    using the squashing we learnt about recently:
​[1:17 PM] Howes, Tim
    
(353)C:\dev\stage0> ($queue=dir \ -file)

    Directory: C:\

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       26/03/2020     09:23            284 .gitconfig
-a----       26/05/2020     11:13        9240136 bromium_secure_platform_x64_4_1_9_2079.xml
-a----       21/10/2019     15:50        1159710 installAgent.log
-a----       14/05/2019     10:28       58720256 kernel.etl
-a----       26/05/2020     11:12          12928 msi.xsl
-a----       06/12/2019     15:47           4361 stage0.ps1
-a----       18/11/2019     14:33            228 _stage0.imaging

​[1:17 PM] Howes, Tim
    (yeah that's a load of crap in my root)
​[1:17 PM] Howes, Tim
    reminder - the "squash" meant we assigned into our variable and got output
​[1:17 PM] Howes, Tim
    so now we have a directory as a queue, which we can pop things off:
​[1:17 PM] Howes, Tim
    
(354)C:\dev\stage0> $queue.dequeue()

    Directory: C:\

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       26/03/2020     09:23            284 .gitconfig

​[1:18 PM] Howes, Tim
    
(355)C:\dev\stage0> $queue.dequeue()

    Directory: C:\

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       26/05/2020     11:13        9240136 bromium_secure_platform_x64_4_1_9_2079.xml

<https://teams.microsoft.com/l/message/19:f7005fe988bb4e3d8cc29551634a88d7@thread.tacv2/1605014141150?tenantId=ca7981a2-785a-463d-b82a-3db87dfc3ce6&amp;groupId=30e1feec-9271-415b-9876-5a5429fc02d5&amp;parentMessageId=1605014141150&amp;teamName=Bromium&amp;channelName=Powershell help desk&amp;createdTime=1605014141150>

[1:20 PM] Howes, Tim
    You can do this with sets too
​[1:21 PM] Howes, Tim
    sets are templated, but for powershell you might as well set the template type to psobject
​[1:21 PM] Howes, Tim
    eg
​[1:21 PM] Howes, Tim
    
[System.Collections.Generic.HashSet[psobject]]$set=@()

​[1:21 PM] Howes, Tim
    then you can interactively "diff" things quite nicely:
​[1:21 PM] Howes, Tim
    
(368)C:\dev\stage0> $set=get-process | % name
(369)C:\dev\stage0> calc
(370)C:\dev\stage0> $set2=get-process | % name
(371)C:\dev\stage0> $set2.exceptwith($set)
(372)C:\dev\stage0> $set2
Calculator

<https://teams.microsoft.com/l/message/19:f7005fe988bb4e3d8cc29551634a88d7@thread.tacv2/1605014435235?tenantId=ca7981a2-785a-463d-b82a-3db87dfc3ce6&amp;groupId=30e1feec-9271-415b-9876-5a5429fc02d5&amp;parentMessageId=1605014141150&amp;teamName=Bromium&amp;channelName=Powershell help desk&amp;createdTime=1605014435235>

```
