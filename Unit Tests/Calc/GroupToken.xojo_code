#tag Class
Protected Class GroupToken
Inherits M_Token.BeginBlockToken
	#tag Event , Description = 52657475726E20616E206172726179206F662050617273657244656C65676174652E2054686520706172736572732077696C6C206265207472696564206F6E207468652073747265616D20617420746861742063757272656E7420706F736974696F6E20696E206F7264657220756E74696C206120546F6B656E2069732072657475726E65642C20616E64207468617420746F6B656E2077696C6C2062652061736B656420666F72206974206E65787420746F6B656E20706172736572732E
		Function GetNextToken(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, tokens() As M_Token.Token, settings As Variant) As M_Token.Token
		  #pragma unused context
		  #pragma unused tokens
		  #pragma unused settings
		  
		  if tokens.Count = 0 then
		    //
		    // This doubles as the start of the document and will not advance the bytePos
		    //
		    M_Token.AdvancePastWhiteSpace( mb, p, bytePos )
		    return new GroupToken
		  end if
		  
		  static paren as byte = CharToByte( "(" )
		  static closeParen as byte = CharToByte( ")" )
		  
		  select case p.Byte( bytePos )
		  case paren
		    bytePos = bytePos + 1
		    M_Token.AdvancePastWhiteSpace( mb, p, bytePos )
		    return new GroupToken
		    
		  case closeParen
		    bytePos = bytePos + 1 + 1
		    M_Token.AdvancePastWhiteSpace( mb, p, bytePos )
		    return new GroupEndToken
		    
		  case else
		    return ParseNumber( mb, p, bytePos )
		    
		    
		  end select
		End Function
	#tag EndEvent


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
