#tag Class
Private Class Interpreter
Inherits M_Token.Interpreter
	#tag Event , Description = 496E746572707265742074686520676976656E20746F6B656E732E20496620616E20496E74657270726574657220697320676976656E206173206120706172616D6574657220746F2050617273652C207468697320697320726169736564207768656E20697420656E636F756E7465727320616E20456E64426C6F636B546F6B656E20616E642061742074686520656E64206F662074686520646F63756D656E742E
		Sub Interpret(tokens() As M_Token.Token, beginBlockIndex As Integer, tag As Variant)
		  #pragma unused tag
		  
		  //
		  // Sanity check
		  //
		  if tokens.Count = 0 then
		    Value = 0.0
		    return
		  elseif tokens.Count = 1 and tokens( 0 ) isa NumberToken then
		    Value = tokens( 0 ).Value
		    return
		  end if
		  
		  //
		  // If we get here and the beginBlockIndex = -1 (end of equation)
		  // then something went wrong
		  //
		  if beginBlockIndex = -1 then
		    raise new M_Token.TokenizerException( "Something went wrong" )
		  end if
		  
		  var startIndex as integer = beginBlockIndex
		  var endIndex as integer = tokens.LastRowIndex
		  
		  //
		  // See what's in the group
		  //
		  var itemCount as integer = endIndex - startIndex - 1
		  if itemCount = 1 then
		    tokens.RemoveRowAt endIndex
		    tokens.RemoveRowAt startIndex
		    return
		  end if
		  
		  //
		  // Start at the first and last operators
		  //
		  startIndex = startIndex + 2
		  endIndex = endIndex - 2
		  
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
		  static operators() as string = kOperators.Trim.ReplaceLineEndings( &uA ).Split( &uA ) // In order of priority
		  for each operator as string in operators
		    for i as integer = endIndex downto startIndex step 2
		      var op as string
		      var opToken as OperatorToken
		      var prevNumToken as NumberToken
		      var nextNumToken as NumberToken
		      
		      try
		        opToken = OperatorToken( tokens( i ) )
		        prevNumToken = NumberToken( tokens( i - 1 ) )
		        nextNumToken = NumberToken( tokens( i + 1 ) )
		      catch err as IllegalCastException
		        raise new M_Token.TokenizerException( "Illegal value somewhere after " + tokens( beginBlockIndex ).BytePosition.ToString )
		      end try
		      
		      op = tokens( i ).Value
		      if op = operator then
		        var previousNumber as double = prevNumToken.Value
		        var nextNumber as double = nextNumToken.Value
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
		  
		  //
		  // Remove the GroupTokens
		  //
		  Value = tokens( startIndex - 1 ).Value
		  
		  tokens.RemoveRowAt beginBlockIndex + 2
		  tokens.RemoveRowAt beginBlockIndex
		  
		  
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
