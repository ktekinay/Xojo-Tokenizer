#tag Class
Protected Class Interpreter
Implements M_Token.InterpreterInterface
	#tag Method, Flags = &h0
		Sub Interpret(tokens() As M_Token.Token, mb As MemoryBlock, currentBytePos As Integer)
		  
		  
		  
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Interpret(tokens() As M_Token.Token, mb As MemoryBlock, currentBytePos As Integer)
	#tag EndHook


End Class
#tag EndClass
