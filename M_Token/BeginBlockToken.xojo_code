#tag Class
Protected Class BeginBlockToken
Inherits M_Token.Token
	#tag Method, Flags = &h0
		Function GetCorrespondingEndBlockToken() As M_Token.EndBlockToken
		  return RaiseEvent CorrespondingEndBlockToken
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0, Description = 52657475726E20616E20696E7374616E6365206F6620746865204D5F546F6B656E2E456E64426C6F636B546F6B656E207468617420636F72726573706F6E647320746F207468697320426567696E426C6F636B546F6B656E2E0A496620796F7520737570706C79206120426567696E426C6F636B546F6B656E20617320746865207374617274446F63756D656E74546F6B656E20746F2050617273652C20746869732077696C6C206175746F6D61746963616C6C7920626520617070656E64656420746F2074686520656E64206F662074686520746F6B656E2073747265616D2E
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
