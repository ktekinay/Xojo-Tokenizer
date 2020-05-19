#tag Class
Protected Class CalcTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub BasicTest()
		  Assert.AreEqual 3.0, Calc.Evaluate( "1 + 2" )
		  Assert.AreEqual 50.0, Calc.Evaluate( "10 * 5.0" )
		  Assert.AreEqual 6.0, Calc.Evaluate( "18.0 / 3" )
		  Assert.AreEqual -1.0, Calc.Evaluate( "1 - 2" )
		  Assert.AreEqual 2.0, Calc.Evaluate( "1 + 8/2 * 4" )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GroupTest()
		  Assert.AreEqual -25.0, Calc.Evaluate( "(  10.0 * -5 ) / ( 1 + 1 )" )
		  Assert.AreEqual -50.0, Calc.Evaluate( "(  10.0 * -5 ) / ( .5 * ( 1 + 1 ) )" )
		  Assert.AreEqual 6.0, Calc.Evaluate( "(5+( 1.0))" )
		  Assert.AreEqual 1.0, Calc.Evaluate( "((1))" )
		  Assert.AreEqual 5.0, Calc.Evaluate( "10.0 / ( 1 + 1 )" )
		  
		End Sub
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
End Class
#tag EndClass
