Fighting for Windows in Windows.

---
Q? Tutorial/References for Microsoft's UI Automation [closed]

Closed. This question does not meet Stack Overflow guidelines. It is not currently accepting answers.
Want to improve this question? Update the question so it's on-topic for Stack Overflow.

Closed 5 years ago.

I recently implemented a program using the Microsoft Accessibility API, but have since been told that the new UI Automation has replaced it. Seems like it would be a good investment for next time to learn the newer tool for the job.

So, what are the best references, and hopefully actual tutorials, for programming UI Automation? Specifically, I'm looking for programming "client" applications, i.e. the ones doing the accessing to other program's UI, not just providing access to my own UI.

https://stackoverflow.com/questions/1559994/tutorial-references-for-microsofts-ui-automation


A: Basically links to this webpage http://blog.functionalfun.net/2009/06/introduction-to-ui-automation-with.html

Which says 

"The UI Automation framework reduces the entire contents of the Windows Desktop to a tree of AutomationElement objects. Every widget of any significance, from Windows, to Menu Items, to Text Boxes is represented in the tree. The root of this tree is the Desktop window. You get hold of it, logically enough, using the static AutomationElement.RootElement property. From there you can traverse your way down the tree to just about any element on screen using two suggestively named methods on AutomationElement, FindAll and FindFirst.

Each of these two methods takes a Condition instance as a parameter, and it uses this to pick out the elements you’re looking for. The most useful kind of condition is a PropertyCondition. AutomationElements each have a number of properties like Name, Class, AutomationId, ProcessId, etc, exposing their intimate details to the world; these are what you use in the PropertyCondition to distinguish an element from its siblings when you’re hunting for it using one of the Find methods.

Finding Elements to automate
Let me show you an example. We want to automate Paint.Net, so first we fire up an instance of the Paint.Net process:

private string PaintDotNetPath = @"C:\Program Files\Paint.NET\PaintDotNet.exe";

...

var processStartInfo = new ProcessStartInfo(paintDotNetPath);
var process = Process.Start(processStartInfo);
Having started it up, we wait for it to initialize (the Delay method simply calls Thread.Sleep with the appropriate timespan):

process.WaitForInputIdle();
Delay(4000);
At this point, Paint.Net is up on screen, waiting for us to start doodling. This is where the UIAutomation bit begins. We need to get hold of Paint.Net’s main Window. Since we know the Process Id of Paint.Net, we’ll use a PropertyCondition bound to the ProcessId property:

var mainWindow = AutomationElement.RootElement.FindChildByProcessId(process.Id);
---

### Thats great but how do you load AutomationElement in Powershell? I couldnt find it, even though I know it's a dotnet assembly. 

I can't for instance find `[System.Windows.Automation]` or anything like it. Apparently that has been decrepated. https://stackoverflow.com/questions/41768046/system-windows-automation-is-extremely-slow/41768047#41768047

Which says things like 

"or Windows 7, the API has been rewritten in the Component Object Model (COM). Although the library functions introduced in the earlier version of UI Automation are still documented, they should not be used in new applications. The solution to slow performance is to use the new IUIAutomationElement COM interface instead of the old System.Windows.Automation C# interface. After that the code will be running lightning fast!"

So apparently we're working with a com interface and a newer implementation. Anyway, how do you freaking load it in powershell?

This other stackoverflow question, there's an answer https://stackoverflow.com/questions/42160480/how-to-use-iuiautomation-in-powershell

```
Add-Type -AssemblyName @('UIAutomationClient', 'UIAutomationTypes')
$ae = [System.Windows.Automation.AutomationElement]
$obj1 = $ae::FromHandle($winHandle)
```

Hmm, so were is this all documented? Well it seems to be part of the win32 api https://docs.microsoft.com/en-us/windows/win32/api/uiautomationclient/
That seems to be the native api

Which is maybe part of the wider-accessibility features of windows https://docs.microsoft.com/en-us/windows/win32/winauto/uiauto-clientportal

Then there are dotnet documents https://docs.microsoft.com/en-us/dotnet/api/system.windows.automation.automationelement.rootelement?redirectedfrom=MSDN&view=netframework-4.0#System_Windows_Automation_AutomationElement_RootElement

Microshaft have a youtube video describing some of the api https://www.youtube.com/watch?v=6b0K2883rXA&ab_channel=MSFTEnable


### More code


```
Add-Type -AssemblyName @('UIAutomationClient', 'UIAutomationTypes')

> $ae = [System.Windows.Automation.AutomationElement]
# The following example code retrieves a collection of all the immediate children of the desktop.
> $root = [System.Windows.Automation.AutomationElement]::RootElement
> $children = $root.FindAll([System.Windows.Automation.TreeScope]::Children, [System.Windows.Automation.Condition]::TrueCondition)
# returns a list, so you can access an item, there is a 'cached' and 'current' property whatever that is.
> $children[4].Current

ControlType          : System.Windows.Automation.ControlType
LocalizedControlType : pane
Name                 : AutomationElement.RootElement Property (System.Windows.Automation) | Microsoft Docs - Google Chrome
AcceleratorKey       :
AccessKey            :
HasKeyboardFocus     : False
IsKeyboardFocusable  : True
IsEnabled            : True
BoundingRectangle    : -8,-8,2576,1416
HelpText             :
IsControlElement     : True
IsContentElement     : True
LabeledBy            :
AutomationId         :
ItemType             :
IsPassword           : False
ClassName            : Chrome_WidgetWin_1
NativeWindowHandle   : 67858
ProcessId            : 3908
IsOffscreen          : False
Orientation          : None
FrameworkId          : Win32
IsRequiredForForm    : False
ItemStatus           :

```

And you can do stuff like finding the element that is currently in focus (i.e the window the user has last clicked or interacted with)

```
> $children.current | where-object haskeyboardfocus



ControlType          : System.Windows.Automation.ControlType
LocalizedControlType : window
Name                 : Windows PowerShell (Admin)
AcceleratorKey       :
AccessKey            :
HasKeyboardFocus     : True
IsKeyboardFocusable  : False
IsEnabled            : True
BoundingRectangle    : 1273,0,1294,1407
HelpText             :
IsControlElement     : True
IsContentElement     : True
LabeledBy            :
AutomationId         :
ItemType             :
IsPassword           : False
ClassName            : VirtualConsoleClass
NativeWindowHandle   : 657108
ProcessId            : 14536
IsOffscreen          : False
Orientation          : None
FrameworkId          : Win32
IsRequiredForForm    : False
ItemStatus           :
```

And what if I know the process id and want to find the window for a particular process?

Like I'm writing this in sublime 

```
> get-process subl*

Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
-------  ------    -----      -----     ------     --  -- -----------
    616      25    69768      88776      17.44   8480   1 sublime_text

```

So I need to find all the children of the root element, and write a condition that matches the process id 8480

```
# params for $root.FindAll() are
# System.Windows.Automation.AutomationElementCollection FindAll(System.Windows.Automation.TreeScope # scope, System.Windows.Automation.Condition condition)
```

So how do we create a condition that looks for procid 8480? 
There is the type ` [System.Windows.Automation.PropertyCondition]` This types ::new() constructor takes parameters

```
System.Windows.Automation.PropertyCondition new(System.Windows.Automation.AutomationProperty property, System.Object value)
System.Windows.Automation.PropertyCondition new(System.Windows.Automation.AutomationProperty property, System.Object value, System.Windows.Automation.PropertyConditionFlags flags)
```

And there is a new for AutomationElement that is an object with a whole bunch of static properties

```
> [System.Windows.Automation.AutomationElement]::ProcessIdProperty
AcceleratorKeyProperty                       IsItemContainerPatternAvailableProperty      LayoutInvalidatedEvent
AccessKeyProperty                            IsKeyboardFocusableProperty                  LocalizedControlTypeProperty
AsyncContentLoadedEvent                      IsMultipleViewPatternAvailableProperty       MenuClosedEvent
AutomationFocusChangedEvent                  IsOffscreenProperty                          MenuOpenedEvent
AutomationIdProperty                         IsPasswordProperty                           NameProperty
AutomationPropertyChangedEvent               IsRangeValuePatternAvailableProperty         NativeWindowHandleProperty
BoundingRectangleProperty                    IsRequiredForFormProperty                    NotSupported
ClassNameProperty                            IsScrollItemPatternAvailableProperty         OrientationProperty
ClickablePointProperty                       IsScrollPatternAvailableProperty             PositionInSetProperty
ControlTypeProperty                          IsSelectionItemPatternAvailableProperty      ProcessIdProperty
CultureProperty                              IsSelectionPatternAvailableProperty          RootElement
FocusedElement                               IsSynchronizedInputPatternAvailableProperty  RuntimeIdProperty
FrameworkIdProperty                          IsTableItemPatternAvailableProperty          SizeOfSetProperty
HasKeyboardFocusProperty                     IsTablePatternAvailableProperty              StructureChangedEvent
HelpTextProperty                             IsTextPatternAvailableProperty               ToolTipClosedEvent
IsContentElementProperty                     IsTogglePatternAvailableProperty             ToolTipOpenedEvent
IsControlElementProperty                     IsTransformPatternAvailableProperty          Equals
IsDockPatternAvailableProperty               IsValuePatternAvailableProperty              FromHandle
IsEnabledProperty                            IsVirtualizedItemPatternAvailableProperty    FromLocalProvider
IsExpandCollapsePatternAvailableProperty     IsWindowPatternAvailableProperty             FromPoint
IsGridItemPatternAvailableProperty           ItemStatusProperty                           ReferenceEquals
IsGridPatternAvailableProperty               ItemTypeProperty
IsInvokePatternAvailableProperty             LabeledByProperty

static System.Windows.Automation.AutomationProperty ProcessIdProperty {get;}

```

So looks like we can do this to create the condition

```
> [System.Windows.Automation.PropertyCondition]::new([System.Windows.Automation.AutomationElement]::ProcessIdProperty, 8480)

Property                                     Value Flags
--------                                     ----- -----
System.Windows.Automation.AutomationProperty  8480  None

```


Thus when we have our condition, we have now call the findall method.

```
> $cond = [System.Windows.Automation.PropertyCondition]::new([System.Windows.Automation.AutomationElement]::ProcessIdProperty, 8480)
>$elems = $root.FindAll([System.Windows.Automation.TreeScope]::Children, $cond)
```

And indeed, there is a single element returned that contains the sublime window.

## How do we actually inspect ui elements?

There are tools like Inspect or UISpy from Microsoft. But lets try this one: https://github.com/FlaUI/FlaUInspect


https://chocolatey.org/packages/flauinspect

```
choco install flauinspect
```


Add-Type -AssemblyName @('UIAutomationClient', 'UIAutomationTypes')
> $ae = [System.Windows.Automation.AutomationElement]
# The following example code retrieves a collection of all the immediate children of the desktop.
> $root = [System.Windows.Automation.AutomationElement]::RootElement
# find all the windows
> $root.FindAll([System.Windows.Automation.TreeScope]::Children, [System.Windows.Automation.Condition]::TrueCondition)
# find window of a specific process pid 8480
> $cond = [System.Windows.Automation.PropertyCondition]::new([System.Windows.Automation.AutomationElement]::ProcessIdProperty, 8480)
> $root.FindAll([System.Windows.Automation.TreeScope]::Children, $cond)
# find the window with the name 'Spotify Premium'
> $cond2 = [System.Windows.Automation.PropertyCondition]::new([System.Windows.Automation.AutomationElement]::NameProperty, 'Spotify Premium')

> choco install flauinspect


## Hyperlink control type (button)

hyperlink control type

https://docs.microsoft.com/en-us/windows/win32/winauto/uiauto-controltype-ids
UIA_ImageControlTypeId
50006
Identifies the Image control type.

https://docs.microsoft.com/en-us/windows/win32/winauto/uiauto-supporthyperlinkcontroltype

### How can I find a particular descendant control type and click on it?

So even if I can find the element as a descendant of the root element, like say spotify element. How do I then find things that are descendant of it?

{% quote %}
"In the UI Automation tree is a root element that represents the Windows desktop window ("the desktop") and whose child elements represent application windows. Each of these child elements can contain elements that represent pieces of the UI, such as menus, buttons, toolbars, and list boxes. These elements can contain elements, such as list items."

The raw view of the UI Automation tree is the full tree of automation elements for which the desktop is the root. The raw view closely follows the native programmatic structure of an application, and is the most detailed view available.

The raw view is obtained by searching for elements without specifying properties or by using the IUIAutomation::RawViewWalker to get an IUIAutomationTreeWalker interface for navigating the tree.

The control view is a subset of the raw view. It includes only those UI items that have the IUIAutomationElement::IsControlElement property set to TRUE.

The control view is obtained by searching for elements that have the IUIAutomationElement::IsControlElement property set to true, or by using ControlViewWalker to get an IUIAutomationTreeWalker interface for navigating the tree.

The content view of the UI Automation tree is a subset of the control view. It includes only those UI items that have both the IUIAutomationElement::IsControlElement and the IUIAutomationElement::IsContentElement property set to TRUE.

The content view contains UI items that convey the actual information in a user interface, including UI items that can receive keyboard focus and some text that is not a label on a UI item. These are the UI items that are most interesting to a screen reader application. For example, the values in a drop-down combo box appear in the content view because the values represent information being used by an end use

The content view is obtained by searching for elements that have both the IsControlElement and the CurrentIsContentElement property set to TRUE, or by using IUIAutomation::ContentViewWalker to get an IUIAutomationTreeWalker interface for navigating the tree.
{% quote %}

https://docs.microsoft.com/en-us/windows/win32/winauto/uiauto-treeoverview

Anyway that background is not as pratical as you'd want...

So lets return to having grabbed the spotify element.

```
# on my desktop, there's one spotify window
> $spot = $root.FindAll([System.Windows.Automation.TreeScope]::Children, $cond2)[0]
# and now we're back to looking for elements with particular properties...
> $spot.FindAll([System.Windows.Automation.TreeScope]::Children, [System.Windows.Automation.Condition]::TrueCondition)
```



### How can I wait for something to appear?


### Overview of UI api

1. Types of controls (button, slider, checkbox, hyperlink)
2. Properies (name, shortcut)
3. Patterns/behaviours (toggle, select, expand/collapse)
4. layout the hierarchy for expected behaviour


1. Types of controls

If you think of a Window or a GUI, it's basically a rectangle with stuff inside it. Everything the user can click on or interact with, that is an instance of a 'control type'. There are different control types depending on what the button or thing can do. So, some are simple buttons. Like the 'pause' button on spotify, is a ControlType Button. Whereas, the 'like' button might be a 'toggle' button because it can either be liked or not. And then perhaps there's a link to a webpage that might be a 'hyperlink' control type or whatever.

2. Properties

These are just things that describe the control type and what it does in a bit more detail.

3. Patterns/behaviours

These are things a user can do to the button like click on it or whatever. Maybe they can resize it.

4. Layouts are hierarchical.

That means that inside a GUIs rectangle, the master rectangle, all the smaller controls and views are descendant shapes that cover a different area of space. It's a 'heirarchy' of these shapes, with the GUI subdivided into smaller and smaller spaces. Each space can contain more buttons or more descendant spaces.

## AccEvent

AccEvent is a way to see events that happen to GUI. Look at UIAEvents



### Plain old simples

Recommended by Mr Powershell

```
> $shell = New-Object -ComObject WScript.Shell
> calc; sleep 2; $shell.AppActivate("Calculator"); $shell.SendKeys("{ESCAPE}"); sleep -Milliseconds 100; $shell.SendKeys("1"); sleep -Milliseconds 100; $shell.SendKeys("{+}");sleep -Milliseconds 100; $shell.SendKeys("2"); sleep -Milliseconds 100; $shell.SendKeys("=")
```
