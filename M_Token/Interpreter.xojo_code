#tag Class
Protected Class Interpreter
Implements M_Token.InterpreterInterface
	#tag Method, Flags = &h0
		Sub Interpret(tokens() As M_Token.Token, mb As MemoryBlock, currentBytePos As Integer)
		  RaiseEvent Interpret( tokens, mb, currentBytePos )
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0, Description = 496E746572707265742074686520676976656E20746F6B656E732E20496620616E20496E74657270726574657220697320676976656E206173206120706172616D6574657220746F2050617273652C207468697320697320726169736564207768656E20697420656E636F756E7465727320616E20456E64426C6F636B546F6B656E20616E642061742074686520656E64206F662074686520646F63756D656E742E
		Event Interpret(tokens() As M_Token.Token, mb As MemoryBlock, currentBytePos As Integer)
	#tag EndHook


End Class
#tag EndClass
