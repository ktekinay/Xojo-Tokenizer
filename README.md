# Xojo-Tokenizer

Xojo module to convert a string into a series of tokens and, optionally, interpret them in stages.

## Overview

The concept is to create a series of classes that represent the tokens that might be found in the string, and series of parser methods that will identify and return those tokens. The token class will return one or more parsers for what might come after that token.

## Installation

Open the Harness project and copy the M_Token module to your project.

**Important**: Do not drag the M_Token files directly from the folder into your project as it won't work right.

## Step By Step

To create your own tokenizer:

* Create a series of `M_Token.Token` subclasses that represent your tokens.
  * Use the special `M_Token.Token` subclasses `BeginBlockToken` and `EndBlockToken` to represent blocks in the token stream.
  * Use the special subclass `M_Token.IgnoreThisToken` to represent necessary items in your stream that must be present but that do not have to be included in the token stream, e.g., commas.
* Create a series of parser methods based on `M_Token.ParserDelegate` that will test the string and, if matched, return a new instance of one of your `Token` subclasses.
* Implement the `GetNextTokenParsers` event to return parser methods for the tokens that might logically follow.
* Call `M_Token.Parse` on your string and give it an intial `Token` from where it may draw its first parsers. (This will usually some sort of "Begin Document" token).

## How It Works

The `Parse` function will draw its parser methods from the initial `Token` and use it to determine the first `Token` in the stream. From that will get the next parsers and repeat until all the bytes in the string are consumed.

You may optionally feed the `Parse` methods a "Settings" object that will be relayed to the parser methods and to the `Token` instances when getting the next parsers. These "Settings" can be anything you desire and can be used to change the overall operation of the parsers, or which parsers are returned by each `Token`.

You may optionally give the `Parse` function an instance of an interpreter (an object that impelments the `M_Token.Interpreter.Interface` or a subclass of `M_Token.Interpreter`) that will be called with the token stream every time it encounters an `EndBlockToken` and again once all the bytes of the string have been consumed.

## Who Did This?

## Release Notes

**1.0** (__)

* Initial release