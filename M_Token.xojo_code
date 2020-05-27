#tag Module
Protected Module M_Token
	#tag Method, Flags = &h1
		Protected Sub AdvancePastBytes(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, skipBytes() As Integer)
		  //
		  // A convenience method to skip past specific bytes
		  //
		  
		  #if not DebugBuild
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  if bytePos >= mb.Size or skipBytes.Count = 0 then
		    return
		  end if
		  
		  while bytePos < mb.Size and skipBytes.IndexOf( p.Byte( bytePos ) ) <> -1
		    bytePos = bytePos + 1
		  wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub AdvancePastSpacesAndTabs(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer)
		  //
		  // A convenience method to advance past spaces and tabs
		  //
		  
		  #if not DebugBuild
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  while bytePos <  mb.Size
		    select case p.Byte( bytePos )
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
		Protected Sub AdvancePastWhiteSpace(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer)
		  //
		  // A convenience method to advance past all white space
		  //
		  
		  #if not DebugBuild
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
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
		Protected Sub AdvanceToNextLine(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer)
		  //
		  // A convenience method to advance to the next line as defined by
		  // an EOL character
		  //
		  // Will leave the bytePos at the next position after the EOL
		  //
		  
		  #if not DebugBuild
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  //
		  // Get to the EOL
		  //
		  while bytePos < mb.Size
		    select case p.Byte( bytePos )
		    case kLinefeed, kLinefeed
		      bytePos = bytePos + 1
		      exit while
		      
		    case else
		      bytePos = bytePos + 1
		      
		    end select
		  wend
		  
		  //
		  // Get past the EOL
		  //
		  while bytePos < mb.Size
		    select case p.Byte( bytePos )
		    case kLinefeed, kReturn
		      bytePos = bytePos + 1
		      
		    case else
		      return
		      
		    end select
		  wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ExtractNumber(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer) As Variant
		  #if not DebugBuild
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  var mbSize as integer = mb.Size
		  
		  if bytePos >= mbSize then
		    return nil
		  end if
		  
		  const zero as byte = 48
		  const nine as byte = 57
		  const dot as byte = 46
		  const minus as byte = 45
		  const plus as byte = 43
		  const e as byte = 101
		  const eCap as byte = 69
		  
		  var startingPos as integer = bytePos
		  
		  var foundDigits as boolean
		  var foundDot as boolean
		  var foundDecimal as boolean
		  var foundE as boolean
		  var foundSN as boolean
		  var ePos as integer 
		  
		  if p.Byte( bytePos ) = minus then
		    bytePos = bytePos + 1
		  elseif p.Byte( bytePos ) = plus then
		    bytePos = bytePos + 1
		    startingPos = bytePos
		  end if
		  
		  
		  //
		  // Look for integer portion
		  //
		  while bytePos < mbSize and p.Byte( bytePos ) >= zero and p.Byte( bytePos ) <= nine
		    foundDigits = true
		    bytePos = bytePos + 1
		  wend
		  
		  //
		  // See if there is a decimal
		  //
		  if bytePos < mbSize and p.Byte( bytePos ) = dot then
		    foundDot = true
		    bytePos = bytePos + 1
		    
		    while bytePos < mbSize and p.Byte( bytePos ) >= zero and p.Byte( bytePos ) <= nine 
		      foundDecimal = true
		      bytePos = bytePos + 1
		    wend
		  end if
		  
		  //
		  // See if it's scientific notation
		  //
		  if bytePos < mbSize and _
		    ( foundDigits or foundDecimal ) and _
		    ( p.Byte( bytePos ) = e or p.Byte( bytePos ) = eCap ) then
		    foundE = true
		    ePos = bytePos
		    bytePos = bytePos + 1
		    
		    if bytePos < mbSize and ( p.Byte( bytePos ) = minus or p.Byte( bytePos ) = plus ) then
		      bytePos = bytePos + 1
		    end if
		    
		    while bytePos < mbSize and p.Byte( bytePos ) >= zero and p.Byte( bytePos ) <= nine 
		      foundSN = true
		      bytePos = bytePos + 1
		    wend
		  end if
		  
		  //
		  // See if we have a value here
		  //
		  if foundE and not foundSN then
		    //
		    // Improper scientific notation
		    //
		    bytePos = ePos
		    foundE = false
		  end if
		  
		  if not foundDigits and not foundDecimal then
		    //
		    // Didn't identify a proper number
		    //
		    bytePos = startingPos
		    return nil
		  end if
		  
		  //
		  // Let's grab the value and return it
		  //
		  var length as integer = bytePos - startingPos
		  var s as string = mb.StringValue( startingPos, length )
		  var result as variant
		  
		  if foundDot then
		    var d as double = s.ToDouble
		    result = d
		  else
		    var i as integer = s.ToInteger
		    result = i
		  end if
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function NextLine(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, enc As TextEncoding = Nil) As String
		  //
		  // Reads the upcoming line from the current bytePos
		  // and leaves bytePos at the start of the next line
		  //
		  //
		  
		  #if not DebugBuild
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  if bytePos >= mb.Size then
		    return ""
		  end if
		  
		  if enc is nil then
		    enc = Encodings.UTF8
		  end if
		  
		  //
		  // Make sure we are at the start of the line
		  //
		  if p.Byte( bytePos ) = kReturn or p.Byte( bytePos ) = kLinefeed then
		    AdvanceToNextLine( mb, p, bytePos )
		  end if
		  
		  var result as string
		  
		  var startingPos as integer = bytePos
		  var endingPos as integer = startingPos
		  
		  while bytePos < mb.Size
		    select case p.Byte( bytePos )
		    case kReturn, kLinefeed
		      endingPos = bytePos
		      AdvanceToNextLine( mb, p, bytePos )
		      exit while
		      
		    case else
		      bytePos = bytePos + 1
		      endingPos = bytePos // In case we run out of bytes before the EOL
		      
		    end select
		  wend
		  
		  var length as integer = endingPos - startingPos
		  if length <> 0 then
		    result = mb.StringValue( startingPos, length, enc )
		  end if
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function NextWord(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, enc As TextEncoding = Nil) As String
		  //
		  // Convenience function to return the next series of bytes as a string
		  // leaving bytePos pointing at the next white space
		  //
		  
		  #if not DebugBuild
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  if enc = nil then
		    enc = Encodings.UTF8
		  end if
		  
		  //
		  // If this is already whitespace, get past it
		  //
		  AdvancePastWhiteSpace( mb, p, bytePos )
		  
		  var startingPos as integer = bytePos
		  
		  while bytePos <  mb.Size
		    select case p.Byte( bytePos )
		    case kReturn
		    case kLinefeed
		    case kTab
		    case kSpace
		    case else
		      bytePos = bytePos + 1
		      continue while
		    end select
		    
		    //
		    // We found whitespace
		    //
		    exit while
		  wend
		  
		  var length as integer = bytePos - startingPos
		  var s as string
		  
		  if length <> 0 then
		    s = mb.StringValue( startingPos, length, enc )
		  end if
		  
		  return s
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Parse(mb As MemoryBlock, ByRef position As Integer, startDocumentToken As M_Token.Token, tag As Variant = Nil, interpreter As M_Token.InterpreterInterface = Nil) As M_Token.Token()
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
		  
		  #if not DebugBuild
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  const kStartingBlockStackLastRow as integer = 99
		  
		  var currentToken as M_Token.Token = startDocumentToken
		  var blockTokenStack( kStartingBlockStackLastRow ) as M_Token.BeginBlockToken
		  var blockTokenStackIndex as integer = -1
		  var context as M_Token.BeginBlockToken
		  var beginBlockIndexes( kStartingBlockStackLastRow ) as integer
		  
		  //
		  // If the startDocumentToken is a BeginBlockToken, add it to the start of the stream too
		  //
		  if startDocumentToken isa M_Token.BeginBlockToken then
		    tokens.AddRow startDocumentToken
		    
		    context = M_Token.BeginBlockToken( startDocumentToken )
		    blockTokenStackIndex = 0
		    blockTokenStack( blockTokenStackIndex ) = context
		    beginBlockIndexes( blockTokenStackIndex ) = 0
		  end if
		  
		  while position < mbSize 
		    var startingPos as integer = position
		    var previousToken as M_Token.Token = currentToken // Lets us see the value in the debugger
		    currentToken = PrivateTokenInterface( previousToken ).GetNextToken( mb, p, position, context, tokens, tag )
		    
		    if currentToken is nil then
		      //
		      // We couldn't find a token to match
		      //
		      raise new InvalidTokenException( startingPos )
		    end if
		    
		    if not ( currentToken isa M_Token.IgnoreThisToken ) then
		      tokens.AddRow currentToken
		    end if
		    
		    if currentToken.BytePosition = -1 then
		      //
		      // The parser didn't fill this out, so let's do it for them
		      //
		      currentToken.BytePosition = startingPos
		    end if
		    
		    if currentToken isa M_Token.EndBlockToken then
		      EndBlockToken( currentToken ).Match = context // Store the matching BeginBlockToken
		      
		      if blockTokenStackIndex = -1 then
		        raise new InvalidTokenException( startingPos )
		      end if
		      
		      if interpreter isa object then
		        interpreter.Interpret tokens, beginBlockIndexes( blockTokenStackIndex ), tag
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
		  
		  //
		  // Append the EndBlockToken, if we can
		  //
		  if startDocumentToken isa M_Token.BeginBlockToken then
		    var bbt as M_Token.BeginBlockToken = M_Token.BeginBlockToken( startDocumentToken )
		    var endToken as M_Token.EndBlockToken = PrivateBeginBlockTokenInterface( bbt ).GetCorrespondingEndBlockToken
		    if endToken isa object then
		      //
		      // Make sure this makes sense
		      //
		      if blockTokenStackIndex <> 0 then
		        raise new TokenizerException( "Unmatched begin and end tokens" )
		      end if
		      
		      endToken.BytePosition = position
		      tokens.AddRow endToken
		      
		      //
		      // Call the interpreter
		      //
		      if interpreter isa object then
		        interpreter.Interpret tokens, 0, tag
		      end if
		      
		      blockTokenStackIndex = blockTokenStackIndex - 1
		    end if
		  end if
		  
		  if interpreter isa object and tokens.Count <> 0 then
		    //
		    // Final wrap up call
		    //
		    interpreter.Interpret tokens, -1, tag
		  end if
		  
		  return tokens
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Parse(mb As MemoryBlock, startDocumentToken As M_Token.Token, tag As Variant = Nil, interpreter As M_Token.InterpreterInterface = Nil) As M_Token.Token()
		  var position as integer
		  return Parse( mb, position, startDocumentToken, tag, interpreter )
		End Function
	#tag EndMethod


	#tag Constant, Name = kLinefeed, Type = Double, Dynamic = False, Default = \"&hA", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kReturn, Type = Double, Dynamic = False, Default = \"&hD", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kSpace, Type = Double, Dynamic = False, Default = \"&h20", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kTab, Type = Double, Dynamic = False, Default = \"&h9", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"1.0", Scope = Protected
	#tag EndConstant


End Module
#tag EndModule
