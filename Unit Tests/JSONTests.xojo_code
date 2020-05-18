#tag Class
Protected Class JSONTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub ArrayTest()
		  var j as string = "[1, 1.2,false , true, null, ""a string""]"
		  var tokens() as M_Token.Token = M_Token.Parse( j, new JSON.StartToken )
		  Assert.AreEqual 8, CType( tokens.Count, integer ), "Unexpected token count"
		  Assert.IsTrue tokens( 0 ) isa JSON.ArrayToken, "Not an ArrayToken"
		  Assert.IsTrue tokens( 1 ) isa JSON.ValueToken, "Not a ValueToken"
		  Assert.IsTrue tokens( 7 ) isa JSON.ArrayEndToken, "Not an ArrayEndToken"
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BadArrayTest()
		  var j as string
		  
		  #pragma BreakOnExceptions false
		  
		  j = ","
		  try
		    call M_Token.Parse( j, new JSON.StartToken )
		    Assert.Fail j.ToText
		  catch err as M_Token.InvalidTokenException
		    Assert.Pass
		  end try
		  
		  j = "[,"
		  try
		    call M_Token.Parse( j, new JSON.StartToken )
		    Assert.Fail j.ToText
		  catch err as M_Token.InvalidTokenException
		    Assert.Pass
		  end try
		  
		  j = "[,]"
		  try
		    call M_Token.Parse( j, new JSON.StartToken )
		    Assert.Fail j.ToText
		  catch err as M_Token.InvalidTokenException
		    Assert.Pass
		  end try
		  
		  j = "[1,]"
		  try
		    call M_Token.Parse( j, new JSON.StartToken )
		    Assert.Fail j.ToText
		  catch err as M_Token.InvalidTokenException
		    Assert.Pass
		  end try
		  
		  j = "[""1]"
		  try
		    call M_Token.Parse( j, new JSON.StartToken )
		    Assert.Fail j.ToText
		  catch err as JSONException
		    Assert.Pass
		  end try
		  
		  j = "[1 2]"
		  try
		    call M_Token.Parse( j, new JSON.StartToken )
		    Assert.Fail j.ToText
		  catch err as M_Token.InvalidTokenException
		    Assert.Pass
		  end try
		  
		  #pragma BreakOnExceptions default
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BadObjectTest()
		  var j as string
		  
		  #pragma BreakOnExceptions false
		  
		  j = "{,"
		  try
		    call M_Token.Parse( j, new JSON.StartToken )
		    Assert.Fail j.ToText
		  catch err as M_Token.InvalidTokenException
		    Assert.Pass
		  end try
		  
		  j = "{,}"
		  try
		    call M_Token.Parse( j, new JSON.StartToken )
		    Assert.Fail j.ToText
		  catch err as M_Token.InvalidTokenException
		    Assert.Pass
		  end try
		  
		  j = "{null}"
		  try
		    call M_Token.Parse( j, new JSON.StartToken )
		    Assert.Fail j.ToText
		  catch err as M_Token.InvalidTokenException
		    Assert.Pass
		  end try
		  
		  j = "{1,2}"
		  try
		    call M_Token.Parse( j, new JSON.StartToken )
		    Assert.Fail j.ToText
		  catch err as M_Token.InvalidTokenException
		    Assert.Pass
		  end try
		  
		  j = "{1 : 2}"
		  try
		    call M_Token.Parse( j, new JSON.StartToken )
		    Assert.Fail j.ToText
		  catch err as M_Token.InvalidTokenException
		    Assert.Pass
		  end try
		  
		  j = "{""k1"":}"
		  try
		    call M_Token.Parse( j, new JSON.StartToken )
		    Assert.Fail j.ToText
		  catch err as M_Token.InvalidTokenException
		    Assert.Pass
		  end try
		  
		  #pragma BreakOnExceptions default
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CompareJSON(j1 As Variant, j2 As Variant) As Boolean
		  if j1.Type <> j2.Type then
		    return false
		  end if
		  
		  if j1 isa Dictionary then
		    var d1 as Dictionary = j1
		    var d2 as Dictionary = j2
		    
		    if d1.KeyCount <> d2.KeyCount then
		      return false
		    end if
		    
		    for each key as variant in d1.Keys
		      var v1 as variant = d1.Value( key )
		      var v2 as variant
		      try
		        v2 = d2.Value( key )
		      catch err as KeyNotFoundException
		        return false
		      end try
		      
		      if not CompareValues( v1, v2 ) then
		        return false
		      end if
		    next
		    
		  else // Array
		    var arr1() as variant = j1
		    var arr2() as variant = j2
		    
		    if arr1.Count <> arr2.Count then
		      return false
		    end if
		    
		    for i as integer = 0 to arr1.LastRowIndex
		      var v1 as variant = arr1( i )
		      var v2 as variant = arr2( i )
		      if not CompareValues( v1, v2 ) then
		        return false
		      end if
		    next
		    
		  end if
		  
		  return true
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CompareValues(v1 As Variant, v2 As Variant) As Boolean
		  var type1 as integer = v1.Type
		  var type2 as integer = v2.Type
		  
		  if ( type1 = Variant.TypeInt32 and type2 = Variant.TypeInt64 ) or _
		    ( type1 = Variant.TypeInt64 and type2 = Variant.TypeInt32 ) then
		    type1 = Variant.TypeInt64
		    type2 = type1
		    v1 = v1.Int64Value
		    v2 = v2.Int64Value
		  end if
		  
		  if type1 <> type2 then
		    return false
		    
		  elseif v1.IsArray then
		    if not v2.IsArray then
		      return false
		    end if
		    if not CompareJSON( v1, v2 ) then
		      return false
		    end if
		    
		  elseif v1 isa Dictionary then
		    if not ( v2 isa Dictionary ) then
		      return false
		    end if
		    if not CompareJSON( v1, v2 ) then
		      return false
		    end if
		    
		  elseif v1.Type = Variant.TypeString and StrComp( v1.StringValue, v2.StringValue, 0 ) <> 0 then
		    return false
		    
		  elseif v1 <> v2 then
		    return false
		    
		  end if
		  
		  return true
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InterpreterTest()
		  var interpreter as JSON.Interpreter
		  var j as string
		  var value as variant
		  var arr() as variant
		  var dict as Dictionary
		  
		  j = "[1, null, false]"
		  interpreter = new JSON.Interpreter
		  call M_Token.Parse( j, new JSON.StartToken, nil, interpreter )
		  value = interpreter.Value
		  Assert.IsTrue value.IsArray
		  arr = value
		  Assert.AreEqual 3, CType( arr.Count, integer ), "Unexpected array count"
		  
		  j = "{ ""k1"" : 1, ""k2"":true, ""k3"": null, ""k4"" : ""string""}"
		  interpreter = new JSON.Interpreter
		  call M_Token.Parse( j, new JSON.StartToken, nil, interpreter )
		  value = interpreter.Value
		  Assert.IsTrue value isa Dictionary
		  dict = value
		  Assert.AreEqual 4, CType( dict.Count, integer ), "Unexpected Dictionary count"
		  
		  var tests() As string = array( kExampleGlossary, kExampleMenu, kExampleMenu2, kExampleWebApp, kExampleWidget )
		  for i as integer = 0 to tests.LastRowIndex
		    j = tests( i )
		    interpreter = new JSON.Interpreter
		    call M_Token.Parse( j, new JSON.StartToken, nil, interpreter )
		    var v1 as variant = interpreter.Value
		    var v2 as variant = ParseJSON( j )
		    Assert.IsTrue CompareJSON( v1, v2 ), "Test " + i.ToText
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ObjectTest()
		  var j as string = "{""k1"":null, ""k2"" : true ,""k3"": 1.2}"
		  
		  var tokens() as M_Token.Token = M_Token.Parse( j, new JSON.StartToken )
		  Assert.AreEqual 8, CType( tokens.Count, integer ), "Unexpected token count"
		  Assert.IsTrue tokens( 0 ) isa JSON.ObjectToken, "Not an ObjectToken"
		  Assert.IsTrue tokens( 1 ) isa JSON.KeyToken, "Not a KeyToken"
		  Assert.IsTrue tokens( 2 ) isa JSON.ValueToken, "Not a ValueToken"
		  Assert.IsTrue tokens( 7 ) isa JSON.ObjectEndToken, "Not an ObjectEndToken"
		  
		  
		End Sub
	#tag EndMethod


	#tag Constant, Name = kExampleGlossary, Type = String, Dynamic = False, Default = \"{\n    \"glossary\": {\n        \"title\": \"example glossary\"\x2C\n\t\t\"GlossDiv\": {\n            \"title\": \"S\"\x2C\n\t\t\t\"GlossList\": {\n                \"GlossEntry\": {\n                    \"ID\": \"SGML\"\x2C\n\t\t\t\t\t\"SortAs\": \"SGML\"\x2C\n\t\t\t\t\t\"GlossTerm\": \"Standard Generalized Markup Language\"\x2C\n\t\t\t\t\t\"Acronym\": \"SGML\"\x2C\n\t\t\t\t\t\"Abbrev\": \"ISO 8879:1986\"\x2C\n\t\t\t\t\t\"GlossDef\": {\n                        \"para\": \"A meta-markup language\x2C used to create markup languages such as DocBook.\"\x2C\n\t\t\t\t\t\t\"GlossSeeAlso\": [\"GML\"\x2C \"XML\"]\n                    }\x2C\n\t\t\t\t\t\"GlossSee\": \"markup\"\n                }\n            }\n        }\n    }\n}", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExampleMenu, Type = String, Dynamic = False, Default = \"{\"menu\": {\n  \"id\": \"file\"\x2C\n  \"value\": \"File\"\x2C\n  \"popup\": {\n    \"menuitem\": [\n      {\"value\": \"New\"\x2C \"onclick\": \"CreateNewDoc()\"}\x2C\n      {\"value\": \"Open\"\x2C \"onclick\": \"OpenDoc()\"}\x2C\n      {\"value\": \"Close\"\x2C \"onclick\": \"CloseDoc()\"}\n    ]\n  }\n}}", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExampleMenu2, Type = String, Dynamic = False, Default = \"{\"menu\": {\n    \"header\": \"SVG Viewer\"\x2C\n    \"items\": [\n        {\"id\": \"Open\"}\x2C\n        {\"id\": \"OpenNew\"\x2C \"label\": \"Open New\"}\x2C\n        null\x2C\n        {\"id\": \"ZoomIn\"\x2C \"label\": \"Zoom In\"}\x2C\n        {\"id\": \"ZoomOut\"\x2C \"label\": \"Zoom Out\"}\x2C\n        {\"id\": \"OriginalView\"\x2C \"label\": \"Original View\"}\x2C\n        null\x2C\n        {\"id\": \"Quality\"}\x2C\n        {\"id\": \"Pause\"}\x2C\n        {\"id\": \"Mute\"}\x2C\n        null\x2C\n        {\"id\": \"Find\"\x2C \"label\": \"Find...\"}\x2C\n        {\"id\": \"FindAgain\"\x2C \"label\": \"Find Again\"}\x2C\n        {\"id\": \"Copy\"}\x2C\n        {\"id\": \"CopyAgain\"\x2C \"label\": \"Copy Again\"}\x2C\n        {\"id\": \"CopySVG\"\x2C \"label\": \"Copy SVG\"}\x2C\n        {\"id\": \"ViewSVG\"\x2C \"label\": \"View SVG\"}\x2C\n        {\"id\": \"ViewSource\"\x2C \"label\": \"View Source\"}\x2C\n        {\"id\": \"SaveAs\"\x2C \"label\": \"Save As\"}\x2C\n        null\x2C\n        {\"id\": \"Help\"}\x2C\n        {\"id\": \"About\"\x2C \"label\": \"About Adobe CVG Viewer...\"}\n    ]\n}}", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExampleWebApp, Type = String, Dynamic = False, Default = \"{\n\"web-app\": {\n  \"servlet\": [   \n    {\n      \"servlet-name\": \"cofaxCDS\"\x2C\n      \"servlet-class\": \"org.cofax.cds.CDSServlet\"\x2C\n      \"init-param\": {\n        \"configGlossary:installationAt\": \"Philadelphia\x2C PA\"\x2C\n        \"configGlossary:adminEmail\": \"ksm@pobox.com\"\x2C\n        \"configGlossary:poweredBy\": \"Cofax\"\x2C\n        \"configGlossary:poweredByIcon\": \"/images/cofax.gif\"\x2C\n        \"configGlossary:staticPath\": \"/content/static\"\x2C\n        \"templateProcessorClass\": \"org.cofax.WysiwygTemplate\"\x2C\n        \"templateLoaderClass\": \"org.cofax.FilesTemplateLoader\"\x2C\n        \"templatePath\": \"templates\"\x2C\n        \"templateOverridePath\": \"\"\x2C\n        \"defaultListTemplate\": \"listTemplate.htm\"\x2C\n        \"defaultFileTemplate\": \"articleTemplate.htm\"\x2C\n        \"useJSP\": false\x2C\n        \"jspListTemplate\": \"listTemplate.jsp\"\x2C\n        \"jspFileTemplate\": \"articleTemplate.jsp\"\x2C\n        \"cachePackageTagsTrack\": 200\x2C\n        \"cachePackageTagsStore\": 200\x2C\n        \"cachePackageTagsRefresh\": 60\x2C\n        \"cacheTemplatesTrack\": 100\x2C\n        \"cacheTemplatesStore\": 50\x2C\n        \"cacheTemplatesRefresh\": 15\x2C\n        \"cachePagesTrack\": 200\x2C\n        \"cachePagesStore\": 100\x2C\n        \"cachePagesRefresh\": 10\x2C\n        \"cachePagesDirtyRead\": 10\x2C\n        \"searchEngineListTemplate\": \"forSearchEnginesList.htm\"\x2C\n        \"searchEngineFileTemplate\": \"forSearchEngines.htm\"\x2C\n        \"searchEngineRobotsDb\": \"WEB-INF/robots.db\"\x2C\n        \"useDataStore\": true\x2C\n        \"dataStoreClass\": \"org.cofax.SqlDataStore\"\x2C\n        \"redirectionClass\": \"org.cofax.SqlRedirection\"\x2C\n        \"dataStoreName\": \"cofax\"\x2C\n        \"dataStoreDriver\": \"com.microsoft.jdbc.sqlserver.SQLServerDriver\"\x2C\n        \"dataStoreUrl\": \"jdbc:microsoft:sqlserver://LOCALHOST:1433;DatabaseName\x3Dgoon\"\x2C\n        \"dataStoreUser\": \"sa\"\x2C\n        \"dataStorePassword\": \"dataStoreTestQuery\"\x2C\n        \"dataStoreTestQuery\": \"SET NOCOUNT ON;select test\x3D\'test\';\"\x2C\n        \"dataStoreLogFile\": \"/usr/local/tomcat/logs/datastore.log\"\x2C\n        \"dataStoreInitConns\": 10\x2C\n        \"dataStoreMaxConns\": 100\x2C\n        \"dataStoreConnUsageLimit\": 100\x2C\n        \"dataStoreLogLevel\": \"debug\"\x2C\n        \"maxUrlLength\": 500}}\x2C\n    {\n      \"servlet-name\": \"cofaxEmail\"\x2C\n      \"servlet-class\": \"org.cofax.cds.EmailServlet\"\x2C\n      \"init-param\": {\n      \"mailHost\": \"mail1\"\x2C\n      \"mailHostOverride\": \"mail2\"}}\x2C\n    {\n      \"servlet-name\": \"cofaxAdmin\"\x2C\n      \"servlet-class\": \"org.cofax.cds.AdminServlet\"}\x2C\n \n    {\n      \"servlet-name\": \"fileServlet\"\x2C\n      \"servlet-class\": \"org.cofax.cds.FileServlet\"}\x2C\n    {\n      \"servlet-name\": \"cofaxTools\"\x2C\n      \"servlet-class\": \"org.cofax.cms.CofaxToolsServlet\"\x2C\n      \"init-param\": {\n        \"templatePath\": \"toolstemplates/\"\x2C\n        \"log\": 1\x2C\n        \"logLocation\": \"/usr/local/tomcat/logs/CofaxTools.log\"\x2C\n        \"logMaxSize\": \"\"\x2C\n        \"dataLog\": 1\x2C\n        \"dataLogLocation\": \"/usr/local/tomcat/logs/dataLog.log\"\x2C\n        \"dataLogMaxSize\": \"\"\x2C\n        \"removePageCache\": \"/content/admin/remove\?cache\x3Dpages&id\x3D\"\x2C\n        \"removeTemplateCache\": \"/content/admin/remove\?cache\x3Dtemplates&id\x3D\"\x2C\n        \"fileTransferFolder\": \"/usr/local/tomcat/webapps/content/fileTransferFolder\"\x2C\n        \"lookInContext\": 1\x2C\n        \"adminGroupID\": 4\x2C\n        \"betaServer\": true}}]\x2C\n  \"servlet-mapping\": {\n    \"cofaxCDS\": \"/\"\x2C\n    \"cofaxEmail\": \"/cofaxutil/aemail/*\"\x2C\n    \"cofaxAdmin\": \"/admin/*\"\x2C\n    \"fileServlet\": \"/static/*\"\x2C\n    \"cofaxTools\": \"/tools/*\"}\x2C\n \n  \"taglib\": {\n    \"taglib-uri\": \"cofax.tld\"\x2C\n    \"taglib-location\": \"/WEB-INF/tlds/cofax.tld\"}}\n}", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExampleWidget, Type = String, Dynamic = False, Default = \"{\"widget\": {\n    \"debug\": \"on\"\x2C\n    \"window\": {\n        \"title\": \"Sample Konfabulator Widget\"\x2C\n        \"name\": \"main_window\"\x2C\n        \"width\": 500\x2C\n        \"height\": 500\n    }\x2C\n    \"image\": { \n        \"src\": \"Images/Sun.png\"\x2C\n        \"name\": \"sun1\"\x2C\n        \"hOffset\": 250\x2C\n        \"vOffset\": 250\x2C\n        \"alignment\": \"center\"\n    }\x2C\n    \"text\": {\n        \"data\": \"Click Here\"\x2C\n        \"size\": 36\x2C\n        \"style\": \"bold\"\x2C\n        \"name\": \"text1\"\x2C\n        \"hOffset\": 250\x2C\n        \"vOffset\": 100\x2C\n        \"alignment\": \"center\"\x2C\n        \"onMouseUp\": \"sun1.opacity \x3D (sun1.opacity / 100) * 90;\"\n    }\n}}", Scope = Private
	#tag EndConstant


End Class
#tag EndClass
