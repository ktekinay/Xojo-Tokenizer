#tag Module
Protected Module M_Token
	#tag DelegateDeclaration, Flags = &h1
		Protected Delegate Function ParseToTokenDelegate(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer) As M_Token.Token
	#tag EndDelegateDeclaration


End Module
#tag EndModule
