#tag Class
Protected Class NumberTokenizerTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub DoubleTest()
		  var stream as string = "1. 2.2 -3.5"
		  var position as integer
		  var tokens() as M_Token.Token = M_Token.Parse( stream, position, new DoubleToken )
		  Assert.AreEqual 3, Ctype( tokens.Count, integer ), "Improper count"
		  Assert.AreEqual 1.0, tokens( 0 ).Value.DoubleValue
		  Assert.AreEqual 2.2, tokens( 1 ).Value.DoubleValue
		  Assert.AreEqual -3.5, tokens( 2 ).Value.DoubleValue
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IntegerTest()
		  var stream as string = "1 2 -3 12"
		  var position as integer
		  var tokens() as M_Token.Token = M_Token.Parse( stream, position, new IntegerToken )
		  Assert.AreEqual 4, Ctype( tokens.Count, integer ), "Improper count"
		  Assert.AreEqual 1, tokens( 0 ).Value.IntegerValue
		  Assert.AreEqual -3, tokens( 2 ).Value.IntegerValue
		  Assert.AreEqual 12, tokens( 3 ).Value.IntegerValue
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InvalidDoubleTokenTest()
		  var stream as string = "1. 2 3 12"
		  var position as integer
		  
		  #pragma BreakOnExceptions false
		  try
		    call M_Token.Parse( stream, position, new IntegerToken )
		    Assert.Fail "Exception was not raised"
		  catch err as M_Token.InvalidTokenException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default 
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InvalidIntegerTokenTest()
		  var stream as string = "1 2 3xx 12"
		  var position as integer
		  
		  #pragma BreakOnExceptions false
		  try
		    call M_Token.Parse( stream, position, new IntegerToken )
		    Assert.Fail "Exception was not raised"
		  catch err as M_Token.InvalidTokenException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default 
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NumberTest()
		  var stream as string = "1. 2.2 6 -3.5 4"
		  var tokens() as M_Token.Token = M_Token.Parse( stream, new IntegerToken, true )
		  Assert.AreEqual 5, Ctype( tokens.Count, integer ), "Improper count"
		  Assert.IsTrue tokens( 0 ) isa DoubleToken
		  Assert.IsTrue tokens( 2 ) isa IntegerToken
		  Assert.AreEqual 1.0, tokens( 0 ).Value.DoubleValue
		  Assert.AreEqual 2.2, tokens( 1 ).Value.DoubleValue
		  Assert.AreEqual 6, tokens( 2 ).Value.IntegerValue
		  Assert.AreEqual -3.5, tokens( 3 ).Value.DoubleValue
		  
		End Sub
	#tag EndMethod


End Class
#tag EndClass
