#tag Class
Protected Class ModuleMethodTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub AdvancePastSpacesAndTabsTest()
		  var bytePos as integer
		  var mb as MemoryBlock
		  
		  mb = new MemoryBlock( 0 )
		  bytePos = 0
		  M_Token.AdvancePastSpacesAndTabs( mb, mb, bytePos )
		  Assert.AreEqual 0, bytePos, "mb.Size = 0"
		  
		  mb = "  34"
		  bytePos = 0
		  M_Token.AdvancePastSpacesAndTabs( mb, mb, bytePos )
		  Assert.AreEqual 2, bytePos, "Leading spaces"
		  
		  mb = " " + &u9 + "34"
		  bytePos = 0
		  M_Token.AdvancePastSpacesAndTabs( mb, mb, bytePos )
		  Assert.AreEqual 2, bytePos, "Leading space and tab"
		  
		  mb = " " + &uD + &uA + "34"
		  bytePos = 0
		  M_Token.AdvancePastSpacesAndTabs( mb, mb, bytePos )
		  Assert.AreEqual 1, bytePos, "Leading space, CR, LF"
		  
		  mb = "12 34"
		  bytePos = 0
		  M_Token.AdvancePastSpacesAndTabs( mb, mb, bytePos )
		  Assert.AreEqual 0, bytePos, "Starting at no whitespace"
		  
		  bytePos = 2
		  M_Token.AdvancePastSpacesAndTabs( mb, mb, bytePos )
		  Assert.AreEqual 3, bytePos, "Second word"
		  
		  bytePos = mb.Size
		  M_Token.AdvancePastSpacesAndTabs( mb, mb, bytePos )
		  Assert.AreEqual mb.Size, bytePos, "Past last word"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AdvancePastWhiteSpaceTest()
		  var bytePos as integer
		  var mb as MemoryBlock
		  
		  mb = new MemoryBlock( 0 )
		  bytePos = 0
		  M_Token.AdvancePastWhiteSpace( mb, mb, bytePos )
		  Assert.AreEqual 0, bytePos, "mb.Size = 0"
		  
		  mb = "  34"
		  bytePos = 0
		  M_Token.AdvancePastWhiteSpace( mb, mb, bytePos )
		  Assert.AreEqual 2, bytePos, "Leading spaces"
		  
		  mb = " " + &u9 + "34"
		  bytePos = 0
		  M_Token.AdvancePastWhiteSpace( mb, mb, bytePos )
		  Assert.AreEqual 2, bytePos, "Leading space and tab"
		  
		  mb = " " + &uD + &uA + "34"
		  bytePos = 0
		  M_Token.AdvancePastWhiteSpace( mb, mb, bytePos )
		  Assert.AreEqual 3, bytePos, "Leading space, CR, LF"
		  
		  mb = "12 34"
		  bytePos = 0
		  M_Token.AdvancePastWhiteSpace( mb, mb, bytePos )
		  Assert.AreEqual 0, bytePos, "Starting at no whitespace"
		  
		  bytePos = 2
		  M_Token.AdvancePastWhiteSpace( mb, mb, bytePos )
		  Assert.AreEqual 3, bytePos, "Second word"
		  
		  bytePos = mb.Size
		  M_Token.AdvancePastWhiteSpace( mb, mb, bytePos )
		  Assert.AreEqual mb.Size, bytePos, "Past last word"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AdvanceToNextLineTest()
		  var bytePos as integer
		  var mb as MemoryBlock
		  
		  mb = new MemoryBlock( 0 )
		  bytePos = 0
		  M_Token.AdvanceToNextLine( mb, mb, bytePos )
		  Assert.AreEqual 0, bytePos, "mb.Size = 0"
		  
		  mb = "1234"
		  bytePos = 1
		  M_Token.AdvanceToNextLine( mb, mb, bytePos )
		  Assert.AreEqual mb.Size, bytePos, "No next line"
		  
		  mb = "1234" + &uA + "  78"
		  for i as integer = 0 to mb.Size
		    bytePos = i
		    var expected as integer = if( i < 5, 5, mb.Size )
		    M_Token.AdvanceToNextLine( mb, mb, bytePos )
		    Assert.AreEqual expected, bytePos, i.ToText
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ExtractNumberTest()
		  var bytePos as integer
		  var mb as MemoryBlock
		  var actual as variant
		  var s as string
		  
		  mb = new MemoryBlock( 0 )
		  bytePos = 0
		  actual = M_Token.ExtractNumber( mb, mb, bytePos )
		  Assert.IsNil actual, "mb.Size = 0"
		  
		  s = "1"
		  mb = s
		  bytePos = 0
		  actual = M_Token.ExtractNumber( mb, mb, bytePos )
		  Assert.AreEqual s.ToInt64, actual.Int64Value, s.ToText
		  Assert.AreEqual Variant.TypeInt64, actual.Type, s.ToText + " type"
		  
		  s = "-21"
		  mb = s
		  bytePos = 0
		  actual = M_Token.ExtractNumber( mb, mb, bytePos )
		  Assert.AreEqual s.ToInt64, actual.Int64Value, s.ToText
		  Assert.AreEqual Variant.TypeInt64, actual.Type, s.ToText + " type"
		  
		  s = "+36"
		  mb = s
		  bytePos = 0
		  actual = M_Token.ExtractNumber( mb, mb, bytePos )
		  Assert.AreEqual s.Middle( 1 ).ToInt64, actual.Int64Value, s.ToText
		  Assert.AreEqual Variant.TypeInt64, actual.Type, s.ToText + " type"
		  
		  s = "1.1"
		  mb = s
		  bytePos = 0
		  actual = M_Token.ExtractNumber( mb, mb, bytePos )
		  Assert.AreEqual s.ToDouble, actual.DoubleValue, s.ToText
		  Assert.AreEqual Variant.TypeDouble, actual.Type, s.ToText + " type"
		  
		  s = "-451.1"
		  mb = s
		  bytePos = 0
		  actual = M_Token.ExtractNumber( mb, mb, bytePos )
		  Assert.AreEqual s.ToDouble, actual.DoubleValue, s.ToText
		  Assert.AreEqual Variant.TypeDouble, actual.Type, s.ToText + " type"
		  
		  s = "+2451.1"
		  mb = s
		  bytePos = 0
		  actual = M_Token.ExtractNumber( mb, mb, bytePos )
		  Assert.AreEqual s.Middle( 1 ).ToDouble, actual.DoubleValue, s.ToText
		  Assert.AreEqual Variant.TypeDouble, actual.Type, s.ToText + " type"
		  
		  s = "86."
		  mb = s
		  bytePos = 0
		  actual = M_Token.ExtractNumber( mb, mb, bytePos )
		  Assert.AreEqual s.ToDouble, actual.DoubleValue, s.ToText
		  Assert.AreEqual Variant.TypeDouble, actual.Type, s.ToText + " type"
		  
		  s = "0.987"
		  mb = s
		  bytePos = 0
		  actual = M_Token.ExtractNumber( mb, mb, bytePos )
		  Assert.AreEqual s.ToDouble, actual.DoubleValue, s.ToText
		  Assert.AreEqual Variant.TypeDouble, actual.Type, s.ToText + " type"
		  
		  s = ".123"
		  mb = s
		  bytePos = 0
		  actual = M_Token.ExtractNumber( mb, mb, bytePos )
		  Assert.AreEqual s.ToDouble, actual.DoubleValue, s.ToText
		  Assert.AreEqual Variant.TypeDouble, actual.Type, s.ToText + " type"
		  
		  s = "3.4e"
		  mb = s
		  bytePos = 0
		  actual = M_Token.ExtractNumber( mb, mb, bytePos )
		  Assert.AreEqual s.Left( 3 ).ToDouble, actual.DoubleValue, s.ToText
		  Assert.AreEqual Variant.TypeDouble, actual.Type, s.ToText + " type"
		  Assert.AreEqual 3, bytePos, s.ToText + " bytePos"
		  
		  s = "3.4e2"
		  mb = s
		  bytePos = 0
		  actual = M_Token.ExtractNumber( mb, mb, bytePos )
		  Assert.AreEqual s.ToDouble, actual.DoubleValue, s.ToText
		  Assert.AreEqual Variant.TypeDouble, actual.Type, s.ToText + " type"
		  Assert.AreEqual mb.Size, bytePos, s.ToText + " bytePos"
		  
		  s = ".98e-2"
		  mb = s
		  bytePos = 0
		  actual = M_Token.ExtractNumber( mb, mb, bytePos )
		  Assert.AreEqual s.ToDouble, actual.DoubleValue, s.ToText
		  Assert.AreEqual Variant.TypeDouble, actual.Type, s.ToText + " type"
		  Assert.AreEqual mb.Size, bytePos, s.ToText + " bytePos"
		  
		  s = "-45.67e+5"
		  mb = s
		  bytePos = 0
		  actual = M_Token.ExtractNumber( mb, mb, bytePos )
		  Assert.AreEqual s.ToDouble, actual.DoubleValue, s.ToText
		  Assert.AreEqual Variant.TypeDouble, actual.Type, s.ToText + " type"
		  Assert.AreEqual mb.Size, bytePos, s.ToText + " bytePos"
		  
		  s = "101 -234 -3.45 5.e-4"
		  var numbers() as string = s.Split( " " )
		  mb = s
		  bytePos = 0
		  for each expected as string in numbers
		    actual = M_Token.ExtractNumber( mb, mb, bytePos )
		    Assert.AreEqual expected.ToDouble, actual.DoubleValue, "Multiple - " + expected.ToText
		    M_Token.AdvancePastWhiteSpace( mb, mb, bytePos )
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NextLineTest()
		  var bytePos as integer
		  var mb as MemoryBlock
		  var s as string
		  var actual as string
		  var expected as string
		  
		  mb = new MemoryBlock( 0 )
		  bytePos = 0
		  expected = ""
		  actual = M_Token.NextLine( mb, mb, bytePos )
		  Assert.AreEqual expected, actual, "mb.Size = 0"
		  Assert.AreEqual 0, bytePos, "bytePos when mb.Size = 0"
		  
		  s = "1234"
		  mb = s
		  expected = s.NthField( &uA, 1 )
		  bytePos = 0
		  actual = M_Token.NextLine( mb, mb, bytePos )
		  Assert.AreEqual expected, actual, expected.ToText
		  Assert.AreEqual mb.Size, bytePos, "No EOL"
		  
		  s = "1234" + &uA + "4567" + &uA + "90"
		  mb = s
		  bytePos = 0
		  var lines() as string = s.Split( &uA )
		  for each expected in lines
		    actual = M_Token.NextLine( mb, mb, bytePos )
		    Assert.AreEqual expected, actual, "Multiple - " + expected.ToText
		  next
		  Assert.AreEqual mb.Size, bytePos, "bytePos after multiple"
		  expected = ""
		  actual = M_Token.NextLine( mb, mb, bytePos )
		  Assert.AreEqual expected, actual, "After multiple"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NextWordTest()
		  var bytePos as integer
		  var mb as MemoryBlock
		  var s as string
		  var actual as string
		  var expected as string
		  
		  mb = new MemoryBlock( 0 )
		  bytePos = 0
		  expected = ""
		  actual = M_Token.NextWord( mb, mb, bytePos )
		  Assert.AreEqual expected, actual, "mb.Size = 0"
		  Assert.AreEqual 0, bytePos, "bytePos when mb.Size = 0"
		  
		  s = "123 4567 90"
		  mb = s
		  bytePos = 0
		  var words() as string = s.Split( " " )
		  for each expected in words
		    actual = M_Token.NextWord( mb, mb, bytePos )
		    Assert.AreEqual expected, actual, "Multiple - " + expected.ToText
		  next
		  Assert.AreEqual mb.Size, bytePos, "bytePos after multiple"
		  expected = ""
		  actual = M_Token.NextWord( mb, mb, bytePos )
		  Assert.AreEqual expected, actual, "After multiple"
		  
		  s = " after_initial_space " + &uA + " after_lf_and_space"
		  mb = s
		  bytePos = 0
		  expected = "after_initial_space"
		  actual = M_Token.NextWord( mb, mb, bytePos )
		  Assert.AreEqual expected, actual
		  expected = "after_lf_and_space"
		  actual = M_Token.NextWord( mb, mb, bytePos )
		  Assert.AreEqual expected, actual
		  
		End Sub
	#tag EndMethod


End Class
#tag EndClass
