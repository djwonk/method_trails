MethodTrails Details
====================

## Objectives ##

I hope that visualizations created by MethodTrails give these benefits:

1. Reduce the time it takes to familarize oneself with unfamilar Ruby code.

2. Improve overall, big-picture understanding of such code.

3. Ease integration with existing libraries, by making it clear which method are high level and thus intended to be used.

## Design Constraints ##

To implement these objectives, I wanted to satisfy two design criteria (i.e. constraints):

1. Be able to visualize an arbitrary Ruby source file -- even if it does not
have a test suite.

2. Be able to see what method calls occur inside of methods.

## Design Decisions ##

There are quite a few visualization tools that already existed for Ruby and/or
Rails. (See the section below for more information.) Generally speaking, these
tools use one or more of these techniques:

* Read Ruby source directly (i.e. using parsing of some kind)
* Load Ruby source into an interpreter and reflect (i.e using ObjectSpace and other reflection methods)
* Hook into Ruby source at runtime (i.e with DTrace or similar)

Given the dynamic nature of the Ruby language, potentially the most powerful
way to construct a method call graph is to do so at runtime. In a perfect
world, all code would be tested thoroughly with unit and integration tests,
with various dangerous and expensive operations mocked. Such a test suite, in
tandem with runtime hooks, would be extensive enough to generate a detailed
call graph. As great as that sounded, my first design constraint (i.e. not
assuming an exhaustive test suite would be present) steered me away from using
runtime hooks.

My second constraint bumped up against the limits of Ruby introspection, at
least as I understand it. ObjectSpace and various metaphysical (ok, just
meta-programming) methods give information about class hierarchies, objects,
and their contained method. They do not, however, pierce the veil of a method
definitions. To give an ironic self-referential example, these techniques
can't peek inside a method definition of `rawls` and see that it calls the
`veil_of_ignorance` method. Therefore, reflection would not be a sufficient
means to accomplish my objectives.

Not surprisingly, given the nature of my problem and the process of elimination, it was clear that I would need to rely on parsing.

It turns out that the parsing was quite easy. MethodTrail relies on Ripper for
parsing Ruby source. Ruby 1.9 includes Ripper as part of its standard library.
It is quite simple; you pass in the Ruby file and you get out an s-expression.

## S-Expression Extraction ##

Though the parsing was easy thanks to Ripper, extracting the proper information out of the s-expression was not quite as straightforward.  In my first attempts, I wrote specific, targeted recursive functions that went digging in the s-expression for exactly the information they needed while navigating around the various s-expression symbols.  This approach appeared to be the simplest at first, but it turned out to have many drawbacks:

1. It was hard to test.

2. It was brittle. Several times I needed to tweak the way that I extracted
information. Each such modification involved a rather painful change to the
recursive functions.

3. It wasn't very elegant. Come on, this was supposed to be a fun project, not
a hack. Elegance matters.

4. It wasn't very generalizable.  Why write multiple, hard-coded, one-off recursive descent processors when you could write one general one instead?

These drawbacks motivated me to redesign the code.

## S-Expression Selector Engine ##

At the heart of MethodTrail is a selector engine. This engine takes a selector
rule as an input, parses the s-expression (which represents the Ruby source
code) and returns the information you ask for. MethodTrail then chews on this
information and then spits out a dot file that you can open up using Graphviz.

My first attempt at the selector engine did a tail-first match. In other
words, it matched the end of a rule first, then worked its way backwards. I am
only recently learning about parsers, but I think this approach might be a bottom-up parse. This approach worked well initially.
However, I ran into problems with it; I'm not sure if they were inherent
limitations of the approach or my own understanding of it.

My second attempt used a head-first match, where the front of a rule is
matched first, and then works its way forward. This approach seemed more
elegant. I am not sure if the approach was intrinsically superior or only a
result of the clearer thinking that comes from a second iteration.

If you look at the selector rule syntax and you are not scared away
immediately, you will realize that selector rules are also s-expressions. This
makes them very flexible. You can construct a simple selector rule such as:

    [:__child, "a", "b"]
    # Matches when "b" is the child of "a"
    
Or a more complicated rule such as:

    [[:__child, :__general_sibling], "a", "b", "c"]
    # Matches when both of the following are true:
    # 1. "b" is the child of "a"
    # 2. "c" is a sibling of the same "a" as above

Try doing something like that with CSS selectors. I realize and am not
necessarily ashamed that this syntax appears to be some evil variant of
reverse polish notation.

BTW, if anyone would like to help write a DSL to make the selector rules easier to read for humans, please contact me.  I think this would be a fun TreeTop project.

Of course, you don't need to know any of this to use MethodTrails.  But I thought I would share this in case you want to leverage the s-expression selector engine.

## History ##

As if you haven't had enough history of the design decisions and
implementation already! But here you get a different history -- the motivation
of the project itself.

I guess you could say that I've been wanting a tool like MethodTrail for quite
a while. Around April 2007, I created a patch for ActiveRecord. While doing
so, I made lots of little notes and visuals to keep track of the relationships between methods.  Having a tool to help would have been useful.

A more recent example from May 2008 actually drove me to create this library.
I read several examples online of how to use Net::HTTP to make an SSL HTTP
request. There seemed to be many ways to do it; the most appropriate way
seemed to depend on how much granuality or control one needed over the
process. I was curious and wanted to understand my options better, so I opened
up the standard library source code and took a look.

The understanding I sought is not easily conveyed in textual form. Even well
designed, written, and documented code cannot communicate information like a
graphical image.

## Tool Comparison ##

There are many visualization tools for Ruby in the wild. In the future, I hope
to list them in this section so that readers may find tools best suited to
their needs.

