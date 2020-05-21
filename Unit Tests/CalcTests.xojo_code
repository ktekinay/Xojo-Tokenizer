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

	#tag Method, Flags = &h0
		Sub MalformedStringTest()
		  var s as string
		  
		  #pragma BreakOnExceptions false
		  
		  try
		    s = "1+"
		    call Calc.Evaluate( s )
		    Assert.Fail s.ToText
		  catch err as M_Token.TokenizerException
		    Assert.Pass
		  end try
		  
		  try
		    s = "(1"
		    call Calc.Evaluate( s )
		    Assert.Fail s.ToText
		  catch err as M_Token.TokenizerException
		    Assert.Pass
		  end try
		  
		  try
		    s = "1 + 1e"
		    call Calc.Evaluate( s )
		    Assert.Fail s.ToText
		  catch err as M_Token.TokenizerException
		    Assert.Pass
		  end try
		  
		  try
		    s = "1 + 1e4e"
		    call Calc.Evaluate( s )
		    Assert.Fail s.ToText
		  catch err as M_Token.TokenizerException
		    Assert.Pass
		  end try
		  
		  try
		    s = "1 + 1.1e4.2"
		    call Calc.Evaluate( s )
		    Assert.Fail s.ToText
		  catch err as M_Token.TokenizerException
		    Assert.Pass
		  end try
		  
		  try
		    s = "1 + 1 )"
		    call Calc.Evaluate( s )
		    Assert.Fail s.ToText
		  catch err as M_Token.TokenizerException
		    Assert.Pass
		  end try
		  
		  try
		    s = "((1 + 1 )"
		    call Calc.Evaluate( s )
		    Assert.Fail s.ToText
		  catch err as M_Token.TokenizerException
		    Assert.Pass
		  end try
		  
		  #pragma BreakOnExceptions default 
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsRunning"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NotImplementedCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
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
