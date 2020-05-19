#tag Class
Private Class Interpreter
Inherits M_Token.Interpreter
	#tag Event , Description = 496E746572707265742074686520676976656E20746F6B656E732E20496620616E20496E74657270726574657220697320676976656E206173206120706172616D6574657220746F2050617273652C207468697320697320726169736564207768656E20697420656E636F756E7465727320616E20456E64426C6F636B546F6B656E20616E642061742074686520656E64206F662074686520646F63756D656E742E
		Sub Interpret(tokens() As M_Token.Token, beginBlockIndex As Integer, mb As MemoryBlock, currentBytePos As Integer)
		  #pragma unused mb
		  #pragma unused currentBytePos
		  
		  //
		  // Sanity check
		  //
		  if tokens.Count = 0 then
		    Value = 0.0
		    return
		  end if
		  
		  var startIndex as integer
		  var endIndex as integer = tokens.LastRowIndex
		  
		  if beginBlockIndex = -1 then
		    //
		    // All done
		    //
		    startIndex = 2 // Skip the opening GroupToken and first number
		    if tokens( endIndex ) isa GroupEndToken then
		      endIndex = endIndex - 2
		    else
		      endIndex = endIndex - 1 // Before the last number
		    end if
		  else
		    startIndex = beginBlockIndex + 2 // Skip the GroupToken and first number
		    endIndex = endIndex - 2 // The last one will be a GroupEndToken
		  end if
		  
		  if tokens( startIndex ) isa OperatorToken and tokens( endIndex ) isa OperatorToken then
		    //
		    // Fine
		    //
		  else
		    //
		    // Something went wrong
		    //
		    raise new M_Token.TokenizerException( "Unexpected end of string" )
		  end if
		  
		  //
		  // Cycle through the tokens in this group and convert it to a value
		  //
		  var operators() as string = array( "*", "/", "+", "-" ) // In order of priority
		  for each operator as string in operators
		    for i as integer = endIndex downto startIndex step 2
		      var op as string = tokens( i ).Value
		      if op = operator then
		        var previousNumber as double = tokens( i - 1 ).Value
		        var nextNumber as double = tokens( i + 1 ).Value
		        var thisValue as double
		        select case operator
		        case "*"
		          thisValue = previousNumber * nextNumber
		        case "/"
		          thisValue = previousNumber / nextNumber
		        case "+"
		          thisValue = previousNumber + nextNumber
		        case "-"
		          thisValue = previousNumber - nextNumber
		        end select
		        
		        //
		        // Remove the operator and next number
		        //
		        tokens.RemoveRowAt i + 1
		        tokens.RemoveRowAt i
		        //
		        // And change the value of the number
		        //
		        tokens( i - 1 ).Value = thisValue
		        
		        endIndex = endIndex - 2
		      end if
		    next
		  next
		  
		  Value = tokens( startIndex - 1 ).Value
		  
		End Sub
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
	#tag EndViewBehavior
End Class
#tag EndClass
