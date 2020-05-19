#tag Module
Protected Module JSON
	#tag Method, Flags = &h21
		Private Sub AppendValueParsers(appendTo() As M_Token.ParserDelegate)
		  appendTo.AddRow AddressOf JSON.ParseArrayStart
		  appendTo.AddRow AddressOf JSON.ParseObjectStart
		  appendTo.AddRow AddressOf JSON.ParseNull
		  appendTo.AddRow AddressOf JSON.ParseTrue
		  appendTo.AddRow AddressOf JSON.ParseFalse
		  appendTo.AddRow AddressOf JSON.ParseString
		  appendTo.AddRow AddressOf JSON.ParseNumber
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CharToByte(char As String) As Integer
		  return char.AscByte
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IdentifyString(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer) As String
		  //
		  // This should only be called starting at the first character after a double-quote
		  //
		  // Note:
		  // 
		  // Because this is only for testing, this code will not interpret special characters
		  //
		  
		  static backslash as byte = CharToByte( "\" )
		  static quote as byte = CharToByte( """" )
		  
		  var startPos as integer = bytePos
		  var mbSize as integer = mb.Size
		  
		  do
		    if bytePos >= mbSize then
		      raise new JSONException( "Unexpected end of string starting at byte " + startPos.ToString )
		    end if
		    
		    select case p.Byte( bytePos )
		    case quote
		      var length as integer = bytePos - startPos
		      var result as string
		      if length <> 0 then
		        result = mb.StringValue( startPos, length )
		      end if
		      bytePos = bytePos + 1
		      M_Token.AdvancePastWhiteSpace mb, p, bytePos
		      return result
		      
		    case backslash
		      bytePos = bytePos + 1
		      
		    end select
		    
		    bytePos = bytePos + 1
		  loop
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseArrayEnd(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, settings As Variant) As M_Token.Token
		  #pragma unused settings
		  
		  if context isa ArrayToken then
		    static endBracket as byte = CharToByte( "]" )
		    if p.Byte( bytePos ) = endBracket then
		      bytePos = bytePos + 1
		      M_Token.AdvancePastWhiteSpace mb, p, bytePos
		      return new ArrayEndToken
		    end if
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseArrayStart(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, settings As Variant) As M_Token.Token
		  #pragma unused context
		  #pragma unused settings
		  
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
		  #pragma unused settings
		  
		  if context isa ObjectToken then
		    static colon as byte = CharToByte( ":" )
		    if p.Byte( bytePos ) = colon then
		      bytePos = bytePos + 1
		      M_Token.AdvancePastWhiteSpace mb, p, bytePos
		      return new ColonToken
		    end if
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseComma(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, settings As Variant) As M_Token.Token
		  #pragma unused context
		  #pragma unused settings
		  
		  static comma as byte = CharToByte( "," )
		  if p.Byte( bytePos ) = comma then
		    bytePos = bytePos + 1
		    M_Token.AdvancePastWhiteSpace mb, p, bytePos
		    return new CommaToken
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseFalse(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, settings As Variant) As M_Token.Token
		  #pragma unused context
		  #pragma unused settings
		  
		  static f as byte = CharToByte( "f" )
		  static a as byte = CharToByte( "a" )
		  static l as byte = CharToByte( "l" )
		  static s as byte = CharToByte( "s" )
		  static e as byte = CharToByte( "e" )
		  
		  const kLen as integer = 5
		  
		  if ( mb.Size - bytePos ) >= kLen and _
		    p.Byte( bytePos + 0 ) = f and _
		    p.Byte( bytePos + 1 ) = a and _
		    p.Byte( bytePos + 2 ) = l and _
		    p.Byte( bytePos + 3 ) = s and _ 
		    p.Byte( bytePos + 4 ) = e then
		    var token as new ValueToken( bytePos, false )
		    bytePos = bytePos + kLen
		    M_Token.AdvancePastWhiteSpace mb, p, bytePos
		    return token
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseKey(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, settings As Variant) As M_Token.Token
		  #pragma unused settings
		  
		  if context isa ObjectToken then
		    static quote as byte = CharToByte( """" )
		    
		    if p.Byte( bytePos ) <> quote then
		      return nil
		    end if
		    
		    var startPos as integer = bytePos
		    bytePos = bytePos + 1
		    
		    var result as string = IdentifyString( mb, p, bytePos )
		    M_Token.AdvancePastWhiteSpace mb, p, bytePos
		    return new KeyToken( startPos, result )
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseNull(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, settings As Variant) As M_Token.Token
		  #pragma unused context
		  #pragma unused settings
		  
		  static n as byte = CharToByte( "n" )
		  static u as byte = CharToByte( "u" )
		  static l as byte = CharToByte( "l" )
		  
		  const kLen as integer = 4
		  
		  if ( mb.Size - bytePos ) >= kLen and _
		    p.Byte( bytePos + 0 ) = n and _
		    p.Byte( bytePos + 1 ) = u and _
		    p.Byte( bytePos + 2 ) = l and _
		    p.Byte( bytePos + 3 ) = l then
		    var token as new ValueToken( bytePos, nil )
		    bytePos = bytePos + kLen
		    M_Token.AdvancePastWhiteSpace mb, p, bytePos
		    return token
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseNumber(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, settings As Variant) As M_Token.Token
		  #pragma unused context
		  #pragma unused settings
		  
		  var startingPos as integer = bytePos
		  
		  var number as variant = M_Token.ExtractNumber( mb, p, bytePos )
		  if number is nil then
		    return nil
		  end if
		  
		  var result as new ValueToken( startingPos, number )
		  M_Token.AdvancePastWhiteSpace mb, p, bytePos
		  return result
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseObjectEnd(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, settings As Variant) As M_Token.Token
		  #pragma unused settings
		  
		  if context isa ObjectToken then
		    static endBrace as byte = CharToByte( "}" )
		    if p.Byte( bytePos ) = endBrace then
		      bytePos = bytePos + 1
		      M_Token.AdvancePastWhiteSpace mb, p, bytePos
		      return new ObjectEndToken
		    end if
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseObjectStart(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, settings As Variant) As M_Token.Token
		  #pragma unused context
		  #pragma unused settings
		  
		  static brace as byte = CharToByte( "{" )
		  if p.Byte( bytePos ) = brace then
		    bytePos = bytePos + 1
		    M_Token.AdvancePastWhiteSpace mb, p, bytePos
		    return new ObjectToken
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseString(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, settings As Variant) As M_Token.Token
		  #pragma unused context
		  #pragma unused settings
		  
		  static quote as byte = CharToByte( """" )
		  
		  if p.Byte( bytePos ) <> quote then
		    return nil
		  end if
		  
		  var startPos as integer = bytePos
		  bytePos = bytePos + 1
		  
		  var result as string = IdentifyString( mb, p, bytePos )
		  return new ValueToken( startPos, result )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseTrue(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, settings As Variant) As M_Token.Token
		  #pragma unused context
		  #pragma unused settings
		  
		  static t as byte = CharToByte( "t" )
		  static r as byte = CharToByte( "r" )
		  static u as byte = CharToByte( "u" )
		  static e as byte = CharToByte( "e" )
		  
		  const kLen as integer = 4
		  
		  if ( mb.Size - bytePos ) >= kLen and _
		    p.Byte( bytePos + 0 ) = t and _
		    p.Byte( bytePos + 1 ) = r and _
		    p.Byte( bytePos + 2 ) = u and _
		    p.Byte( bytePos + 3 ) = e then
		    var token as new ValueToken( bytePos, true )
		    bytePos = bytePos + kLen
		    M_Token.AdvancePastWhiteSpace mb, p, bytePos
		    return token
		  end if
		  
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
