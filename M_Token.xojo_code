#tag Module
Protected Module M_Token
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
		Protected Function ExtractNumber(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer) As Variant
		  #if not DebugBuild
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
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
		  
		  if p.Byte( bytePos ) = minus then
		    bytePos = bytePos + 1
		  elseif p.Byte( bytePos ) = plus then
		    bytePos = bytePos + 1
		  end if
		  
		  var mbSize as integer = mb.Size
		  
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
		    bytePos = startingPos
		    return nil
		    
		  elseif not foundDigits and not foundDecimal then
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
		  
		  while position < mbSize 
		    var startingPos as integer = position
		    var previousToken as M_Token.Token = currentToken // Lets us see the value in the debugger
		    currentToken = previousToken.GetNextToken( mb, p, position, context, tokens, tag )
		    
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


End Module
#tag EndModule
