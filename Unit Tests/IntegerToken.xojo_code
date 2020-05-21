#tag Class
Protected Class IntegerToken
Inherits M_Token.Token
	#tag Event , Description = 476574207468652068756D616E2D7265616461626C65206E616D6520666F72207468697320746F6B656E2C20652E672E2C2022426567696E446F63756D656E74222C202256616C7565222C20222B534551222C20222D534551222E
		Function GetName() As String
		  return "INTEGER"
		  
		End Function
	#tag EndEvent

	#tag Event , Description = 52657475726E20616E206172726179206F662050617273657244656C65676174652E2054686520706172736572732077696C6C206265207472696564206F6E207468652073747265616D20617420746861742063757272656E7420706F736974696F6E20696E206F7264657220756E74696C206120546F6B656E2069732072657475726E65642C20616E64207468617420746F6B656E2077696C6C2062652061736B656420666F72206974206E65787420746F6B656E20706172736572732E
		Function GetNextToken(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, tokens() As M_Token.Token, tag As Variant) As M_Token.Token
		  #pragma unused context
		  #pragma unused tokens
		  
		  //
		  // If it's any number, must check for a double first
		  //
		  
		  M_Token.AdvancePastWhiteSpace( mb, p, bytePos )
		  
		  var result as M_Token.Token
		  
		  if tag.Type = Variant.TypeBoolean and tag.BooleanValue then
		    result = DoubleToken.ParseDouble( mb, p, bytePos )
		  end if
		  
		  if result is nil then
		    result = ParseInteger( mb, p, bytePos )
		  end if
		  
		  return result
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Shared Function ParseInteger(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer) As M_Token.Token
		  const kZero as byte = 48
		  const kNine as byte = 57
		  const kHyphen as byte = 45
		  
		  if bytePos >= mb.Size then
		    return nil
		  end if
		  
		  var startingPos as integer = bytePos
		  
		  if p.Byte( bytePos ) = kHyphen and bytePos < ( mb.Size - 1 ) then
		    bytePos = bytePos + 1
		  end if
		  
		  while bytePos < mb.Size and p.Byte( bytePos ) >= kZero and p.Byte( bytePos ) <= kNine
		    bytePos = bytePos + 1
		  wend
		  
		  if bytePos = startingPos then
		    return nil
		  else
		    return new IntegerToken( startingPos, mb.StringValue( startingPos, bytePos - startingPos ).ToInt64 )
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
		#tag ViewProperty
			Name="BytePosition"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
