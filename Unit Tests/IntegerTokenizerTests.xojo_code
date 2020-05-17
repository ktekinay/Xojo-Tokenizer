#tag Class
Protected Class IntegerTokenizerTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub BasicTest()
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
		Sub InvalidTokenTest()
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


End Class
#tag EndClass
