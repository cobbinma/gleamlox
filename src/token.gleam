import snag.{Result}
import gleam/list
import gleam/io

pub type TokenType {
  // Single-character tokens
  LeftParenToken
  RightParenToken
  LeftBraceToken
  RightBraceToken
  CommaToken
  DotToken
  MinusToken
  PlusToken
  SemicolonToken
  SlashToken
  StarToken

  // One or two character tokens
  BangToken
  BangEqualToken
  EqualToken
  EqualEqualToken
  GreaterToken
  GreaterEqualToken
  LessToken
  LessEqualToken

  // Literals
  IdentifierToken(String)
  StringToken(String)
  NumberToken(String)

  //Keywords
  AndToken
  ClassToken
  ElseToken
  FalseToken
  FunToken
  ForToken
  IfToken
  NilToken
  OrToken
  PrintToken
  ReturnToken
  SuperToken
  ThisToken
  TrueToken
  VarToken
  WhileToken

  EofToken
}

pub type Token {
  Token(token_type: TokenType, line: Int)
}

pub fn print_tokens(tokens: List(Token)) -> Result(Nil) {
  tokens
  |> list.each(print_token)

  Ok(Nil)
}

pub fn to_string(token: Token) -> String {
  token_type_to_string(token.token_type)
}

fn token_type_to_string(token_type: TokenType) -> String {
  case token_type {
    LeftParenToken -> "("
    RightParenToken -> ")"
    LeftBraceToken -> "{"
    RightBraceToken -> "}"
    CommaToken -> ","
    DotToken -> "."
    MinusToken -> "-"
    PlusToken -> "+"
    SemicolonToken -> ";"
    SlashToken -> "/"
    StarToken -> "*"
    BangToken -> "!"
    BangEqualToken -> "!="
    EqualToken -> "="
    EqualEqualToken -> "=="
    GreaterToken -> ">"
    GreaterEqualToken -> ">="
    LessToken -> "<"
    LessEqualToken -> "<="
    IdentifierToken(value) -> value
    StringToken(value) -> value
    NumberToken(value) -> value
    AndToken -> "and"
    ClassToken -> "class"
    ElseToken -> "else"
    FalseToken -> "false"
    FunToken -> "fun"
    ForToken -> "for"
    IfToken -> "if"
    NilToken -> "nil"
    OrToken -> "or"
    PrintToken -> "print"
    ReturnToken -> "return"
    SuperToken -> "super"
    ThisToken -> "this"
    TrueToken -> "true"
    VarToken -> "var"
    WhileToken -> "while"
    EofToken -> "eof"
  }
}

fn print_token(token: Token) -> Nil {
  io.println(to_string(token))
}
