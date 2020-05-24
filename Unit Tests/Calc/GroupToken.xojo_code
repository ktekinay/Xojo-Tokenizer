#tag Class
Private Class GroupToken
Inherits M_Token.BeginBlockToken
	#tag Event , Description = 52657475726E20616E20696E7374616E6365206F6620746865204D5F546F6B656E2E456E64426C6F636B546F6B656E207468617420636F72726573706F6E647320746F207468697320426567696E426C6F636B546F6B656E2E0A526571756972656420696620796F7520737570706C79206120426567696E426C6F636B546F6B656E20617320746865207374617274446F63756D656E74546F6B656E20706172616D6574657220746F2050617273652E20546869732077696C6C20616C6C6F772074686520456E64546F6B656E20746F206265206175746F6D6F61746963616C6C7920617070656E64656420746F2074686520656E64206F66207468652073747265616D2E
		Function CorrespondingEndBlockToken() As M_Token.EndBlockToken
		  return new GroupEndToken
		End Function
	#tag EndEvent

	#tag Event , Description = 52657475726E20616E206172726179206F662050617273657244656C65676174652E2054686520706172736572732077696C6C206265207472696564206F6E207468652073747265616D20617420746861742063757272656E7420706F736974696F6E20696E206F7264657220756E74696C206120546F6B656E2069732072657475726E65642C20616E64207468617420746F6B656E2077696C6C2062652061736B656420666F72206974206E65787420746F6B656E20706172736572732E
		Function GetNextToken(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, tokens() As M_Token.Token, tag As Variant) As M_Token.Token
		  #pragma unused context
		  #pragma unused tokens
		  #pragma unused tag
		  
		  static paren as byte = CharToByte( "(" )
		  
		  select case p.Byte( bytePos )
		  case paren
		    bytePos = bytePos + 1
		    M_Token.AdvancePastWhiteSpace( mb, p, bytePos )
		    return new GroupToken
		    
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
