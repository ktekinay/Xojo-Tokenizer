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
* Call `M_Token.Parse` on your string and give it an intial `Token` that represents the start of your document (This will not be added the ultimate token stream).

## How It Works

The `Parse` function will ask the initial `Token` for the first `Token` in the stream through its `GetNextToken` event. Then it will ask that `Token`, and repeat until all the bytes in the string are consumed.

You may optionally feed the `Parse` methods a "Settings" object that will be relayed to the `Token` instances. These "Settings" can be anything you desire and can be used to change the overall operation of the parsers, or which parsers are returned by each `Token`. It can also be a vehicle through which a `Token` can send messages to subsequent `Token` instances.

You may optionally give the `Parse` function an instance of an interpreter (an object that implements the `M_Token.Interpreter.Interface` or a subclass of `M_Token.Interpreter`) that will be called every time it encounters an `EndBlockToken` and again once all the bytes of the string have been consumed.

## Who Did This?

## Release Notes

**1.0** (__)

* Initial release