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
		Protected Function Parse(mb As MemoryBlock, ByRef position As Integer, startDocumentToken As M_Token.Token, settings As Variant = Nil, interpreter As M_Token.InterpreterInterface = Nil) As M_Token.Token()
		  //**********************************************************/
		  //*                                                        */
		  //*             This is the main parse method              */
		  //*                                                        */
		  //**********************************************************/
		  
		  
		  var tokens() as M_Token.Token
		  
		  var mbSize as integer = mb.Size
		  var p as Ptr = mb
		  
		  if position < 0 then
		    position = 0
		  end if
		  
		  const kStartingBlockStackLastRow as integer = 99
		  
		  var currentToken as M_Token.Token = startDocumentToken
		  var blockTokenStack( kStartingBlockStackLastRow ) as M_Token.BeginBlockToken
		  var blockTokenStackIndex as integer = -1
		  var context as M_Token.BeginBlockToken
		  var beginBlockIndexes( kStartingBlockStackLastRow ) as integer
		  
		  while position < mbSize 
		    var startingPos as integer = position
		    var parsers() as M_Token.ParserDelegate = currentToken.GetNextTokenParsers( settings )
		    
		    for each parser as M_Token.ParserDelegate in parsers
		      currentToken = parser.Invoke( mb, p, position, context, settings )
		      if currentToken isa object then
		        if not ( currentToken isa M_Token.IgnoreThisToken ) then
		          tokens.AddRow currentToken
		        end if
		        exit for parser
		      end if
		      position = startingPos // The next parser must start at the same place
		    next
		    
		    if currentToken is nil then
		      raise new InvalidTokenException( startingPos )
		    end if
		    
		    if currentToken isa M_Token.EndBlockToken then
		      if blockTokenStackIndex = -1 then
		        raise new InvalidTokenException( startingPos )
		      end if
		      
		      if interpreter isa object then
		        interpreter.Interpret( tokens, beginBlockIndexes( blockTokenStackIndex ), mb, position )
		      end if
		      
		      blockTokenStackIndex = blockTokenStackIndex - 1
		      if blockTokenStackIndex = -1 then
		        context = nil
		      else
		        context = blockTokenStack( blockTokenStackIndex )
		      end if
		      
		    elseif currentToken isa M_Token.BeginBlockToken then
		      blockTokenStackIndex = blockTokenStackIndex + 1
		      if blockTokenStackIndex >= blockTokenStack.LastRowIndex then
		        blockTokenStack.ResizeTo blockTokenStack.Count * 2
		        beginBlockIndexes.ResizeTo blockTokenStack.LastRowIndex
		      end if
		      
		      blockTokenStack( blockTokenStackIndex ) = M_Token.BeginBlockToken( currentToken )
		      beginBlockIndexes( blockTokenStackIndex ) = tokens.LastRowIndex
		      context = M_Token.BeginBlockToken( currentToken )
		      
		    end if
		  wend
		  
		  if interpreter isa object and tokens.Count <> 0 then
		    interpreter.Interpret tokens, -1, mb, position
		  end if
		  
		  return tokens
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Parse(mb As MemoryBlock, startDocumentToken As M_Token.Token, settings As Variant = Nil, interpreter As M_Token.InterpreterInterface = Nil) As M_Token.Token()
		  var position as integer
		  return Parse( mb, position, startDocumentToken, settings, interpreter )
		End Function
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h1
		Protected Delegate Function ParserDelegate(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, settings As Variant) As M_Token.Token
	#tag EndDelegateDeclaration


End Module
#tag EndModule
