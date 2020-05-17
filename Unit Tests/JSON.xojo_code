#tag Module
Protected Module JSON
	#tag Method, Flags = &h21
		Private Function CharToByte(char As String) As Integer
		  return char.AscByte
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseArrayEnd(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, settings As Variant) As M_Token.Token
		  static endBracket as byte = CharToByte( "]" )
		  if p.Byte( bytePos ) = endBracket then
		    bytePos = bytePos + 1
		    M_Token.AdvancePastWhiteSpace mb, p, bytePos
		    return new ArrayEndToken
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseArrayStart(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, settings As Variant) As M_Token.Token
		  static bracket as byte = CharToByte( "[" )
		  if p.Byte( bytePos ) = bracket then
		    bytePos = bytePos + 1
		    M_Token.AdvancePastWhiteSpace mb, p, bytePos
		    return new ArrayToken
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseColon(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, settings As Variant) As M_Token.Token
		  static colon as byte = CharToByte( ":" )
		  if p.Byte( bytePos ) = colon then
		    bytePos = bytePos + 1
		    M_Token.AdvancePastWhiteSpace mb, p, bytePos
		    return new ColonToken
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseComma(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, settings As Variant) As M_Token.Token
		  static comma as byte = CharToByte( "," )
		  if p.Byte( bytePos ) = comma then
		    bytePos = bytePos + 1
		    M_Token.AdvancePastWhiteSpace mb, p, bytePos
		    return new CommaToken
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseKey(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, settings As Variant) As M_Token.Token
		  static quote as byte = CharToByte( """" )
		  if p.Byte( bytePos ) <> quote then
		    return nil
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseObjectEnd(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, settings As Variant) As M_Token.Token
		  static endBrace as byte = CharToByte( "}" )
		  if p.Byte( bytePos ) = endBrace then
		    bytePos = bytePos + 1
		    M_Token.AdvancePastWhiteSpace mb, p, bytePos
		    return new ObjectEndToken
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseObjectStart(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, settings As Variant) As M_Token.Token
		  static brace as byte = CharToByte( "{" )
		  if p.Byte( bytePos ) = brace then
		    bytePos = bytePos + 1
		    M_Token.AdvancePastWhiteSpace mb, p, bytePos
		    return new ObjectToken
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseString(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer) As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseValue(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, settings As Variant) As M_Token.Token
		  
		End Function
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
