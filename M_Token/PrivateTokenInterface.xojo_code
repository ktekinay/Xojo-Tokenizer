#tag Interface
Private Interface PrivateTokenInterface
	#tag Method, Flags = &h0
		Function GetNextToken(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, tokens() As M_Token.Token, tag As Variant) As M_Token.Token
		  
		End Function
	#tag EndMethod


End Interface
#tag EndInterface
