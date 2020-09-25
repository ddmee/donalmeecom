---
layout: page
title: DotNet
permalink: /dotnet/
---

# Dotnet

{:.no_toc}

* TOC
{:toc}

## Dotnet assemblies

https://www.linkedin.com/learning/clr-assemblies-deployment-for-dot-net-developers/

### What is an assembly?

It is a unit of deployment (a binary type thing?) in the common-language runtime. It is also a unit of version control, in you can describe the version of the assembly your working with. Assemblies play a role in the security of dotnet.

Assemblies are a collection of types (like interfaces, classes etc). The assembly gathers them together to form a logical library of functionality.

Assembly provides the CLR with data to know about the collection of types, including some meta-data of the types. Microsoft created the assembly context from writing c and c++ and having experienced DLL hell. They wanted to improve on this situation when they developed the assembly.

Core principal: assemblies are self-describing, everything the CLR needs to execute the assembly is inside the assembly. This is unlike compiled code in c or c++ but you also needed a header file to understand how to complied coded-work. The assembly however is entirely self-descriptive.

Assemblies are also platform independent. Which gives the assembly portability.

Assemblies are bound by name.

Assembly loading is senstive to version and policy. This isn't describe here, but you can get information at https://www.linkedin.com/learning/clr-assembly-runtime-loading-for-developers/

Assemblies are validated by the CLR, it will enforce no unauthorised or tampered code.

### What's in an assembly?

A COFF/PE file package. [COFF](https://en.wikipedia.org/wiki/COFF) is an old unix format. COFF has been largely replaced in unix by newer [ELF|https://en.wikipedia.org/wiki/Executable_and_Linkable_Format].  From wiki "perhaps the most widespread use of the COFF format today is in Microsoft's Portable Executable (PE) format". PE is microsofts extensions or modifications to COFF.. [PE wiki](https://en.wikipedia.org/wiki/Portable_Executable)

Contains:
- An assembly manifest (describes whats in the assembly) file
- A set of metadata tables in a relational format
- A set of non-code resources

Optional cryptographic hash to secure the contents of the assembly from tampering.

### Lets make one

So, in visual studio, create a c# console-application project, that's a simple hello-world example with code like so in Program.cs:

```c#
// helloworld assembly, Program.cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace helloworld
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello world");
        }
    }
}
```

When we build the application, we get the helloworld.exe binary. This is apparently a CLR assembly. It's in binary, so we could look at it with a binary tool. But it would be better to use a binary CLR decoder. Microsoft makes a tool called `ildasm`. (You can find `ildasm` is you open the visual-studio developer command prompt. ildasm is also available in visual-studio menus until 'tools')

![ildasm helloworld debug](/assets/images/dotnet-assembly-ildasm-helloworld.png)


With il-dasm we can see what exactly the binary means, and we can see the contents of the manifest along with the contents and machine instructions (or CLR equivalents, known as [(common) intermediate language code](https://en.wikipedia.org/wiki/Common_Intermediate_Language) (C/IL)) for the main program inside the hellloworld namespace. All very cool.

![ildasm helloworld all](/assets/images/dotnet-assembly-ildasm-helloworld-all.png)

.ctor is the default constructor that c# compiler creates for the programmer if they didn't create one.

The red-triangle above .ctor provides some class meta-data for the Hellworld.Program. The meta-data is part of the CLR specifiction to help the CLR understand the class.

Inside the .main, we see the CIL itself.

### Creating a class library

Assemblies track the other assemblies they are dependent on. So lets create a c# class library, calling it the People component, by adding a new project to the current visual-studio solution.

Let's create a simple Person class within the People assembly/project that we then want to re-use or reference in the helloworld project.

```c#
// People assembly, Person.cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace People
{
    public class Person
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int Age { get; set; }

        public Person(string fn, string ln, int a)
        {
            this.FirstName = fn;
            this.LastName = ln;
            this.Age = a;
        }

        public override string ToString()
        {
            return String.Format("[Person fn:{0}, ln:{1}, a:{2}]", this.FirstName, this.LastName, this.Age);
        }
    }
}
```

Then we say we want to use it in hellworld program.cs

```c#
// helloworld assembly, Program.cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using People;

namespace helloworld
{
    ...
```

We have to add a reference to the assembly to the helloworld project, as it doesn't otherwise know where People is coming from.

![ildasm helloworld all](/assets/images/dotnet-assembly-reference-people.png)

So let's update hellworld program to use the Person class.

```c#
// helloworld project, program.cs

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using People;

namespace helloworld
{
    class Program
    {
        static void Main(string[] args)
        {
            var bloke = new Person("Bloke", "Thing", 55);
            Console.WriteLine("Hello {0}", bloke);
        }
    }
}
```

Then when we build and run the binary we get

```shell
helloworld\bin\Debug>helloworld.exe
Hello [Person fn:Bloke, ln:Thing, a:55]
```

So now, the helloworld.exe assembly should be updated to track the People assembly. Lets look at it with ildasm.

![ildasm helloworld people reference](/assets/images/dotnet-assembly-helloworld-people.png)

As we see, it references the new People assembly. Like so:


```manifest
.assembly extern People
{
  .ver 1:0:0:0
}
```

We can also use ildasm on the People.dll, which is copied into the build output beside helloworld.exe.

```shell
helloworld\helloworld\bin\Debug>dir
 Volume in drive C is Windows
 Volume Serial Number is 82E3-8976

 Directory of 
 helloworld\helloworld\bin\Debug

25/09/2020  10:59    <DIR>          .
25/09/2020  10:59    <DIR>          ..
25/09/2020  10:59             5,120 helloworld.exe
25/09/2020  10:05               189 helloworld.exe.config
25/09/2020  10:59            11,776 helloworld.pdb
25/09/2020  10:05            22,696 helloworld.vshost.exe
25/09/2020  10:05               189 helloworld.vshost.exe.config
19/03/2019  05:46               490 helloworld.vshost.exe.manifest
25/09/2020  10:53             5,120 People.dll
25/09/2020  10:53            13,824 People.pdb
               8 File(s)         59,404 bytes
               2 Dir(s)  158,143,741,952 bytes free
```

### Assembly modules

At the bottom of a manifest, you'll see references to modules. For example in the People dll manifest:

```manifest
.module People.dll
// MVID: {A4055DBE-97F0-48AA-8335-A76CC7147602}
.imagebase 0x10000000
.file alignment 0x00000200
.stackreserve 0x00100000
.subsystem 0x0003       // WINDOWS_CUI
.corflags 0x00000001    //  ILONLY
// Image base: 0x08B20000
```

Assemblys can contain one or more modules. Turns out the feature isn't typically used much, most assemblies stick to one module.

### Assemblies scope types

Each type defined within an assembly has the assembly name prefixed as a part of the formal or full name of the type.

```manifest
[mscorlib]System::Object
```

Note mscorlib is [the original name](https://stackoverflow.com/questions/15061977/what-does-mscorlib-stand-for) for the clr, or when it was called common object runtime library or something. So the base Object type comes from the clr assembly. From one of the stackoverflow answers, the mscorlib is the primary library for the common library and contains the following namespaces:

```text
 System
 System.Collections
 System.Configuration.Assemblies
 System.Diagnostics
 System.Diagnostics.SymbolStore
 System.Globalization
 System.IO
 System.IO.IsolatedStorage
 System.Reflection
 System.Reflection.Emit
 System.Resources
 System.Runtime.CompilerServices
 System.Runtime.InteropServices
 System.Runtime.InteropServices.Expando
 System.Runtime.Remoting
 System.Runtime.Remoting.Activation
 System.Runtime.Remoting.Channels
 System.Runtime.Remoting.Contexts
 System.Runtime.Remoting.Lifetime
 System.Runtime.Remoting.Messaging
 System.Runtime.Remoting.Metadata
 System.Runtime.Remoting.Metadata.W3cXsd2001
 System.Runtime.Remoting.Proxies
 System.Runtime.Remoting.Services
 System.Runtime.Serialization
 System.Runtime.Serialization.Formatters
 System.Runtime.Serialization.Formatters.Binary
 System.Security
 System.Security.Cryptography
 System.Security.Cryptography.X509Certificates
 System.Security.Permissions
 System.Security.Policy
 System.Security.Principal
 System.Text
 System.Threading
 Microsoft.Win32 
```

### Assembly names

The assembly name is not the file-name. In c/c++, the name of the dll is the point of uniquness and a lot of different builds of the dlls had the same filename that helped cause the dll hell. Assemblys, to solve that, determined that the file-name was not an appropriate unique id.

The assembly name is made up of 4 parts:
- the title of the assembly (common used name)
- a version number (four-part digited number: major.minor.buildnumber.arbitray-number)
- optional culture-code (helps with internationalisation so a given assembly can have different resources if it's a GB version or french version or whatever)
- public key token

These four parts uniquely identify an assembly. So even if two developers choose the same name, the full name can be different.

Looking at the manifest reference for the People dll in helloworld.exe manifest

```manifest
.assembly extern People
{
  .ver 1:0:0:0
}
```

If we look at the .assembly section of the helloworld assembly, this bit of the manifest describes the helloworld assembly itself, with things like who the author is, the copyright notice, what dotnet framework version is used, a unique guid.

The stuff in brackets () is the ascii hexademical representation of the value for each of these pieces of meta data and on the right, isdalm has converted it to strings.

```manifest
// Metadata version: v4.0.30319
.assembly extern mscorlib
{
  .publickeytoken = (B7 7A 5C 56 19 34 E0 89 )                         // .z\V.4..
  .ver 4:0:0:0
}
.assembly extern People
{
  .ver 1:0:0:0
}
.assembly helloworld
{
  .custom instance void [mscorlib]System.Runtime.CompilerServices.CompilationRelaxationsAttribute::.ctor(int32) = ( 01 00 08 00 00 00 00 00 ) 
  .custom instance void [mscorlib]System.Runtime.CompilerServices.RuntimeCompatibilityAttribute::.ctor() = ( 01 00 01 00 54 02 16 57 72 61 70 4E 6F 6E 45 78   // ....T..WrapNonEx

  // --- The following custom attribute is added automatically, do not uncomment -------
  //  .custom instance void [mscorlib]System.Diagnostics.DebuggableAttribute::.ctor(valuetype [mscorlib]System.Diagnostics.DebuggableAttribute/DebuggingModes) = ( 01 00 07 01 00 00 00 00 ) 

  .custom instance void [mscorlib]System.Reflection.AssemblyTitleAttribute::.ctor(string) = ( 01 00 0A 68 65 6C 6C 6F 77 6F 72 6C 64 00 00 )    // ...helloworld..
  .custom instance void [mscorlib]System.Reflection.AssemblyDescriptionAttribute::.ctor(string) = ( 01 00 00 00 00 ) 
  .custom instance void [mscorlib]System.Reflection.AssemblyConfigurationAttribute::.ctor(string) = ( 01 00 00 00 00 ) 
  .custom instance void [mscorlib]System.Reflection.AssemblyCompanyAttribute::.ctor(string) = ( 01 00 00 00 00 ) 
  .custom instance void [mscorlib]System.Reflection.AssemblyProductAttribute::.ctor(string) = ( 01 00 0A 68 65 6C 6C 6F 77 6F 72 6C 64 00 00 )    // ...helloworld..
  .custom instance void [mscorlib]System.Reflection.AssemblyCopyrightAttribute::.ctor(string) = ( 01 00 12 43 6F 70 79 72 69 67 68 74 20 C2 A9 20   // ...Copyright .. 
  .custom instance void [mscorlib]System.Reflection.AssemblyTrademarkAttribute::.ctor(string) = ( 01 00 00 00 00 ) 
  .custom instance void [mscorlib]System.Runtime.InteropServices.ComVisibleAttribute::.ctor(bool) = ( 01 00 00 00 00 ) 
  .custom instance void [mscorlib]System.Runtime.InteropServices.GuidAttribute::.ctor(string) = ( 01 00 24 33 63 61 30 38 30 34 63 2D 30 30 37 31   // ..$3ca0804c-0071
  .custom instance void [mscorlib]System.Reflection.AssemblyFileVersionAttribute::.ctor(string) = ( 01 00 07 31 2E 30 2E 30 2E 30 00 00 )             // ...1.0.0.0..
  .custom instance void [mscorlib]System.Runtime.Versioning.TargetFrameworkAttribute::.ctor(string) = ( 01 00 1C 2E 4E 45 54 46 72 61 6D 65 77 6F 72 6B   // ....NETFramework
  .hash algorithm 0x00008004
  .ver 1:0:0:0
}
.module helloworld.exe
// MVID: {5313BE15-88A5-47B5-95F9-B674A6F1D521}
.imagebase 0x00400000
.file alignment 0x00000200
.stackreserve 0x00100000
.subsystem 0x0003       // WINDOWS_CUI
.corflags 0x00020003    //  ILONLY 32BITPREFERRED
// Image base: 0x032B0000

```

The custom attributes like description and author come from the visual-studio generated AssemblyInfo.cs file in the properties area of the project. If you look in there, you see whether they are coming from.

```c#
// helloworld-project, AssemblyInfo.cs
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

// General Information about an assembly is controlled through the following 
// set of attributes. Change these attribute values to modify the information
// associated with an assembly.
[assembly: AssemblyTitle("helloworld")]
[assembly: AssemblyDescription("")]
[assembly: AssemblyConfiguration("")]
[assembly: AssemblyCompany("")]
[assembly: AssemblyProduct("helloworld")]
[assembly: AssemblyCopyright("Copyright ©  2020")]
[assembly: AssemblyTrademark("")]
[assembly: AssemblyCulture("")]

// Setting ComVisible to false makes the types in this assembly not visible 
// to COM components.  If you need to access a type in this assembly from 
// COM, set the ComVisible attribute to true on that type.
[assembly: ComVisible(false)]

// The following GUID is for the ID of the typelib if this project is exposed to COM
[assembly: Guid("3ca0804c-0071-4e50-9a58-8a8d1ed584a4")]

// Version information for an assembly consists of the following four values:
//
//      Major Version
//      Minor Version 
//      Build Number
//      Revision
//
// You can specify all the values or you can default the Build and Revision Numbers 
// by using the '*' as shown below:
// [assembly: AssemblyVersion("1.0.*")]
[assembly: AssemblyVersion("1.0.0.0")]
[assembly: AssemblyFileVersion("1.0.0.0")]
```

### Strongly named assemblies

Requires a public/private key pair. Digitally signed using that pair. This helps secure the assembly from tampering. When you create, compile and deploy code, dotnet should be able to discover and preventing the code being loaded if it's been tampered with.

The `sn` tool can be used after the assembly is compiled to doing the signing.

You want to use sn to create the key pair, and output it to a file you name

```shell
sn -k output.snk
```

Then inside the AssemblyInfo.cs we can use the attribute AssemblyKeyFile to tell the compiler to use it to produce a strongly named assembly.

```c#
// AssemblyInfo.cs, note the file-path is relatively to the project directory.
[assembly: AssemblyKeyFile("output.snk")]
```
