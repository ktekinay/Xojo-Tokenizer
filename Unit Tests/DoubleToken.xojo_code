#tag Class
Protected Class DoubleToken
Inherits M_Token.Token
	#tag Event , Description = 476574207468652068756D616E2D7265616461626C65206E616D6520666F72207468697320746F6B656E2C20652E672E2C2022426567696E446F63756D656E74222C202256616C7565222C20222B534551222C20222D534551222E
		Function GetName() As String
		  return "DOUBLE"
		  
		End Function
	#tag EndEvent

	#tag Event , Description = 52657475726E20616E206172726179206F662050617273657244656C65676174652E2054686520706172736572732077696C6C206265207472696564206F6E207468652073747265616D20617420746861742063757272656E7420706F736974696F6E20696E206F7264657220756E74696C206120546F6B656E2069732072657475726E65642C20616E64207468617420746F6B656E2077696C6C2062652061736B656420666F72206974206E65787420746F6B656E20706172736572732E
		Function GetNextToken(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, tokens() As M_Token.Token, settings As Variant) As M_Token.Token
		  #pragma unused context
		  #pragma unused tokens
		  
		  M_Token.AdvancePastWhiteSpace( mb, p, bytePos )
		  
		  var startingPos as integer = bytePos
		  
		  var t as M_Token.Token = ParseDouble( mb, p, bytePos )
		  if t is nil then
		    return nil
		  end if
		  
		  if t.Value.Type = Variant.TypeDouble then
		    return t
		  end if
		  
		  if settings.Type = Variant.TypeBoolean and settings.BooleanValue then
		    return new IntegerToken( startingPos, t.Value.IntegerValue )
		  end if
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Shared Function ParseDouble(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer) As M_Token.Token
		  var startingPos as integer = bytePos
		  var value as variant = M_Token.ExtractNumber( mb, p, bytePos )
		  if value is nil then
		    return nil
		  end if
		  
		  return new DoubleToken( startingPos, value )
		  
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
