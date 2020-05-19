#tag Class
Protected Class Interpreter
Inherits M_Token.Interpreter
	#tag Event , Description = 496E746572707265742074686520676976656E20746F6B656E732E20496620616E20496E74657270726574657220697320676976656E206173206120706172616D6574657220746F2050617273652C207468697320697320726169736564207768656E20697420656E636F756E7465727320616E20456E64426C6F636B546F6B656E20616E642061742074686520656E64206F662074686520646F63756D656E742E
		Sub Interpret(tokens() As M_Token.Token, beginBlockIndex As Integer, mb As MemoryBlock, currentBytePos As Integer)
		  #pragma unused mb
		  #pragma unused currentBytePos
		  
		  //
		  // Will consolidate the tokens in the current block
		  //
		  
		  if tokens.Count = 0 then
		    return
		  end if
		  
		  if beginBlockIndex = -1 then // We should be all done, so check it
		    if tokens.Count <> 1 or _
		      not ( tokens( 0 ) isa JSON.ValueToken ) or _
		      not (tokens( 0 ).Value.Type = Variant.TypeObject or tokens( 0 ).Value.IsArray ) then
		      raise new JSONException( "Unexpected end of data" )
		    end if
		    
		    Value = tokens( 0 ).Value
		    
		  else
		    //
		    // We are in a block, so consolidate the tokens
		    //
		    var beginBlockToken as M_Token.Token = tokens( beginBlockIndex )
		    var useValue as variant
		    var startIndex as integer = beginBlockIndex + 1
		    var endIndex as integer = tokens.LastRowIndex - 1
		    
		    select case beginBlockToken
		    case isa JSON.ArrayToken
		      var arr() as variant
		      for i as integer = startIndex to endIndex
		        arr.Append tokens( i ).Value
		      next
		      useValue = arr
		      
		    case isa JSON.ObjectToken
		      var dict as Dictionary = ParseJSON( "{}" ) // This is cheating to get a case-sensitive Dictionary
		      
		      for i as integer = startIndex to endIndex step 2
		        var key as string = tokens( i ).Value
		        var value as variant = tokens( i + 1 ).Value
		        
		        if dict.HasKey( key ) then
		          raise new JSONException( "Duplicate key: " + key )
		        end if
		        
		        dict.Value( key ) = value
		      next
		      useValue = dict
		      
		    case else
		      raise new JSONException( "Unknown token type: " + Introspection.GetType( beginBlockToken ).Name )
		    end select
		    
		    var valueToken as new JSON.ValueToken( beginBlockToken.BytePosition, useValue )
		    
		    tokens.ResizeTo beginBlockIndex
		    tokens( beginBlockIndex ) = valueToken
		  end if
		  
		End Sub
	#tag EndEvent


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
	#tag EndViewBehavior
End Class
#tag EndClass
