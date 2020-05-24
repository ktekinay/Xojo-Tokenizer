#tag Class
Protected Class BeginBlockToken
Inherits M_Token.Token
Implements M_Token.PrivateBeginBlockTokenInterface
	#tag Method, Flags = &h21
		Private Function GetCorrespondingEndBlockToken() As M_Token.EndBlockToken
		  return RaiseEvent CorrespondingEndBlockToken
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0, Description = 52657475726E20616E20696E7374616E6365206F6620746865204D5F546F6B656E2E456E64426C6F636B546F6B656E207468617420636F72726573706F6E647320746F207468697320426567696E426C6F636B546F6B656E2E0A526571756972656420696620796F7520737570706C79206120426567696E426C6F636B546F6B656E20617320746865207374617274446F63756D656E74546F6B656E20706172616D6574657220746F2050617273652E20546869732077696C6C20616C6C6F772074686520456E64546F6B656E20746F206265206175746F6D6F61746963616C6C7920617070656E64656420746F2074686520656E64206F66207468652073747265616D2E
		Event CorrespondingEndBlockToken() As M_Token.EndBlockToken
	#tag EndHook


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
