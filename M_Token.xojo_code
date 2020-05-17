#tag Module
Protected Module M_Token
	#tag Method, Flags = &h1
		Protected Sub AdvancePastWhiteSpace(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer)
		  //
		  // A convenience method to advance past all white space
		  //
		  
		  const kReturn as byte = &hD
		  const kLinefeed as byte = &hA
		  const kTab as byte = &h9
		  const kSpace as byte = &h20
		  
		  while bytePos <  mb.Size
		    select case p.Byte( bytePos )
		    case kReturn
		    case kLinefeed
		    case kTab
		    case kSpace
		    case else
		      return
		    end select
		    
		    bytePos = bytePos + 1
		  wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Parse(mb As MemoryBlock, ByRef position As Integer, startDocumentToken As M_Token.Token) As M_Token.Token()
		  var tokens() as M_Token.Token
		  
		  var mbSize as integer = mb.Size
		  var p as Ptr = mb
		  
		  if position < 0 then
		    position = 0
		  end if
		  
		  var currentToken as M_Token.Token = startDocumentToken
		  
		  while position < mbSize 
		    var startingPos as integer = position
		    var parsers() as M_Token.ParserDelegate = currentToken.GetNextTokenParsers
		    
		    for each parser as M_Token.ParserDelegate in parsers
		      currentToken = parser.Invoke( mb, p, position )
		      if currentToken isa object then
		        tokens.AddRow currentToken
		        exit for parser
		      end if
		      position = startingPos // The next parser must start at the same place
		    next
		    
		    if currentToken is nil then
		      raise new InvalidTokenException( position )
		    end if
		  wend
		  
		  return tokens
		  
		End Function
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h1
		Protected Delegate Function ParserDelegate(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer) As M_Token.Token
	#tag EndDelegateDeclaration


End Module
#tag EndModule
