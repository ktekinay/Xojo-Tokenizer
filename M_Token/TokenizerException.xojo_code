#tag Class
Protected Class TokenizerException
Inherits RuntimeException
	#tag Method, Flags = &h0
		Sub Constructor(message As String)
		  super.Constructor
		  
		  self.Message = message
		  
		End Sub
	#tag EndMethod


End Class
#tag EndClass
