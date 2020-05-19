#tag Module
Protected Module Calc
	#tag Method, Flags = &h21
		Private Function CharToByte(char As String) As Integer
		  return char.AscByte
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Evaluate(s As String) As Double
		  s = s.ConvertEncoding( Encodings.UTF8 ).Trim
		  
		  var interpreter as new Calc.Interpreter
		  call M_Token.Parse( s, new GroupToken, nil, interpreter )
		  return interpreter.Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseNumber(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer) As NumberToken
		  var value as variant = M_Token.ExtractNumber( mb, p, bytePos )
		  if not value.IsNull then
		    var t as new NumberToken
		    t.Value = value
		    M_Token.AdvancePastWhiteSpace( mb, p, bytePos )
		    return t
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseOperator(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer) As OperatorToken
		  var operator as string = String.ChrByte( p.Byte( bytePos ) )
		  
		  select case operator
		  case "+", "-", "*", "/"
		    var t as new OperatorToken( bytePos, operator )
		    bytePos = bytePos + 1
		    M_Token.AdvancePastWhiteSpace( mb, p, bytePos )
		    return t
		  end select
		  
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
	#tag EndViewBehavior
End Module
#tag EndModule
