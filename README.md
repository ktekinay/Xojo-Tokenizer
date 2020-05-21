# Xojo-Tokenizer

Xojo module to convert a string into a series of tokens and, optionally, interpret them in stages.

## Overview

The concept is to create a series of classes that represent the tokens that might be found in the string and implement an event in each that will return the token after it.

## Installation

Open the Harness project and copy the M_Token module to your project.

**Important**: Do not drag the M_Token files directly from the folder into your project as it won't work right.

## Step By Step

### Basic

The basic steps are:

* Create a `M_Token.Token` subclass to represent the tokens that might appear in your string.
* Implement the `GetNextToken` event to return the next `Token` in the string, or nil if no valid token is found.
* Call `M_Token.Parse` to convert the string into an array of `Token`. Optionally give it an instance of your `M_Token.InterpreterInterface` object to convert the token stream into data.

### Detailed

To create your own tokenizer:

* Create a series of `M_Token.Token` subclasses that represent your tokens.
  * Each `Token` can represent different strings that mean the same thing, e.g., "Int", "Integer", and "Int32".
  * Use the special `M_Token.Token` subclasses `BeginBlockToken` and `EndBlockToken` to represent blocks in the token stream.
  * Use the special subclass `M_Token.IgnoreThisToken` to represent necessary items in your string that must be present but that do not have to be included in the token stream, e.g., commas.
* In each `Token` subclass, implement the `GetNextToken` event that will test the upcoming characters for a valid string that would logically follow and, if matched, return a new instance of one of your `Token` subclasses.
* Call `M_Token.Parse` on your string and give it an intial `Token` that represents the start of your document (This will not be incluced in the ultimate token stream).

## How It Works

The `Parse` function will ask the initial `Token` for the first `Token` in the stream through its `GetNextToken` event. Then it will ask that `Token`, and repeat until all the bytes in the string are consumed.

You may optionally feed the `Parse` methods a "Tag" object that will be relayed to the `Token` instances. These "Tag" can be anything you desire and can be used to change the overall operation of the token parsers. It can also be a vehicle through which a `Token` can send messages to subsequent `Token` instances.

You may optionally give the `Parse` function an instance of an interpreter (an object that implements the `M_Token.InterpreterInterface` or a subclass of `M_Token.Interpreter`) that will be called every time it encounters an `EndBlockToken` and again once all the bytes of the string have been consumed.

## Byte By Byte

The `Parse` function will convert your string to a MemoryBlock, and each `Token`'s `GetNextToken` event will be called with that MemoryBlock, a Ptr to the MemoryBlock, and a byte position that your code will update. Why do it this way instead of, say, an array of character or the string itself?

Speed.

Testing bytes in a `MemoryBlock` through a `Ptr` is really fast as the `Ptr` operations are operators, not functions. You can access memory directly instead of copying bytes as you would with a string. This makes it harder to deal with, especially if you've never used a `MemoryBlock`, and you must take precautions to prevent weird errors, like manually checking your position to make sure you won't read past the end of the `MemoryBlock`. But the ultimate payoff should be worth it.

## API



## Dos and Don'ts

The included examples show various tokenizers and interpreters that you can follow as a guide, but there are some dos and don'ts that may not be obvious.

* *DO* prepare the string before calling Parse.
  * Before it is converted to a MemoryBlock, you will need to know what form the bytes will be in.
  * Ensuring that the string is of a known encoding, like UTF-8, and trimming it if leading and trailing spaces are not important is a good idea.
* **DON'T**

## Examples

The included examples illustrate various tokenizers and interpreters. <u>These are not meant to be production-quality</u> but simply an illustration of how various strings can be tokenized and converted to useful data. As of this writing, they include:

* Calculator (interprets simple equations)
* JSON (emulates the native `ParseJSON`)
* Integer and Double tokenization (basic example)

## Walkthrough

Let's walk through one of these examples, the Calculator.

**NOTE**: *The code below is similar to the example code in the included project, but not the same. You will not be able to copy-and-paste this without modifications to that project.*

We start by defining the allowable tokens: Operators `*`, `/`, `+`, and `-`, and numbers. We will use `(` and `)` to define groups.

Next we outline the rules of how the equation string may be laid out:

* Whitespace is irrelevant.
* The start of the string is a virtual group that encompases the entire equation.
* At the start of the string, or after a `(`, may come another `(` or a number.
* After a number may come an operator or `)` to close the group.
* After an operator may come a number or `(` to start another group.
* After a `)` may come another `)` or an operator.
* Numbers may be positive or negative integers, doubles, or scientific notation.

We also define how we will preprocess the equation string:

1. Strings will be UTF-8-encoded and trimmed.
1. The current position will always point to the next byte that is not whitespace.

With these in mind we define our `Token` subclasses:

```Xojo
ValueToken As M_Token.Token
OperatorToken As M_Token.Token
GroupToken As M_Token.BeginBlockToken
GroupEndToken As M_Token.EndBlockToken
```

Implement the `GetNextToken` event for each token. This is where the subclass will examine the byte at the current position and deterine the _next_ `Token` that represents it of them. For example, the `ValueToken` will see of the next byte is `)` and return a `GroupEndToken`, one of the operators and return an `OperatorToken`, or neither and return Null. If it does return a `Token`, it will first call `M_Token.AdvancePastWhiteSpace` to leave the `bytePos` at the next availble byte that might start a new token.

That's it. We are now ready to call `M_Token.Parse` on an equation like this:

```Xojo
var tokens() as M_Token.Token = M_Token.Parse( equation, new GroupToken )
```

**Note**: *`new GroupToken` defines the starting point of the process since equation is considered one large group. In other situations, you may define a special `Token` to represent the start of your string.*

`Parse` will return an array of your `Token` subclasses that you may use to convert to a number. The easiest way to do that is to define an interpreter subclass of `M_Token.Interpreter`. The role of the interpreter is to... well, interpret the `Token` array and ultimately convert that to a value (or whatever else is appropriate).

You can look at the interpreter code in the included project but the short version is this:

```Xojo
var interpreter as new CalcInterpreter
call M_Token.Parse (equation, new GroupToken, nil, interpreter )
var result as double = interpreter.Value
```

If the equation is invalid, the tokenizer or interpreter will raise a RuntimeException, and we should be prepared for that too:

```Xojo
try
  var interpreter as new CalcInterpreter
  call M_Token.Parse( equation, new GroupToken, nil, interpreter )
  var result as double = interpreter.Value

catch err as M_Token.TokenizerException
  MessageBox "Bad equation!"
end try
```

## Who Did This?

This was created by Kem Tekinay of MacTechnologies Consulting.
ktekinay at mactechnologies dot com

See the included LICENSE file for the legal stufff.

## Release Notes

**1.0** (__)

* Initial release