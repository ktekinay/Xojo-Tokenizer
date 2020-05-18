#tag Class
Protected Class Token
	#tag Method, Flags = &h0
		Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(bytePos As Integer, value As Variant)
		  self.BytePosition = bytePos
		  self.Value = value
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetNextTokenParsers(context As M_Token.BeginBlockToken, settings As Variant) As M_Token.ParserDelegate()
		  var parsers() as M_Token.ParserDelegate
		  RaiseEvent GetNextTokenParsers( parsers, context, settings )
		  return parsers
		  
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0, Description = 476574207468652068756D616E2D7265616461626C65206E616D6520666F72207468697320746F6B656E2C20652E672E2C2022426567696E446F63756D656E74222C202256616C7565222C20222B534551222C20222D534551222E
		Event GetName() As String
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 52657475726E20616E206172726179206F662050617273657244656C65676174652E2054686520706172736572732077696C6C206265207472696564206F6E207468652073747265616D20617420746861742063757272656E7420706F736974696F6E20696E206F7264657220756E74696C206120546F6B656E2069732072657475726E65642C20616E64207468617420746F6B656E2077696C6C2062652061736B656420666F72206974206E65787420746F6B656E20706172736572732E
		Event GetNextTokenParsers(parsers() As M_Token.ParserDelegate, context As M_Token.BeginBlockToken, settings As Variant)
	#tag EndHook


	#tag Property, Flags = &h0
		BytePosition As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mName As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if mName = "" then
			    mName = RaiseEvent GetName
			    
			    if mName = "" then
			      //
			      // Return a name based on the class name
			      //
			      mName = Introspection.GetType( self ).Name
			      
			      //
			      // Strip the "token" suffix if present, but
			      // only if that's not the entire name
			      //
			      if mName <> "token" and mName.EndsWith( "token" ) then
			        mName = mName.Left( mName.Length - 5 )
			      end if
			    end if
			  end if
			  
			  return mName
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mName = value
			End Set
		#tag EndSetter
		Name As String
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Value As Variant
	#tag EndProperty


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
			Name="Name"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
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
		#tag ViewProperty
			Name="mName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
