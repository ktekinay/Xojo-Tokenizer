#tag Class
Protected Class ValueToken
Inherits M_Token.Token
	#tag Event , Description = 52657475726E20616E206172726179206F662050617273657244656C65676174652E2054686520706172736572732077696C6C206265207472696564206F6E207468652073747265616D20617420746861742063757272656E7420706F736974696F6E20696E206F7264657220756E74696C206120546F6B656E2069732072657475726E65642C20616E64207468617420746F6B656E2077696C6C2062652061736B656420666F72206974206E65787420746F6B656E20706172736572732E
		Function GetNextToken(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, context As M_Token.BeginBlockToken, tokens() As M_Token.Token, tag As Variant) As M_Token.Token
		  #pragma unused tokens
		  #pragma unused tag
		  
		  static comma as byte = CharToByte( "," )
		  static braceClose as byte = CharToByte( "}" )
		  static bracketClose as byte = CharToByte( "]" )
		  
		  select case p.Byte( bytePos )
		  case comma
		    return ParseComma( mb, p, bytePos )
		  case braceClose
		    return ParseObjectEnd( mb, p, bytePos, context ) // Might have another object trailing it, the parser will deal with it if it's out of context
		  case bracketClose
		    return ParseArrayEnd( mb, p, bytePos, context ) // Ditto
		  end select
		End Function
	#tag EndEvent


End Class
#tag EndClass
