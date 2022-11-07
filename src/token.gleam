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
  IdentifierToken
  StringToken
  NumberToken

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

pub type Literal {
  NumberLiteral
  StringLiteral
  Null
}

fn literal_to_string(literal: Literal) -> String {
  case literal {
    NumberLiteral -> "Number"
    StringLiteral -> "String"
    Null -> "Null"
  }
}

pub type Token {
  Token(token_type: TokenType, lexeme: String, literal: Literal, line: Int)
}

pub fn print_tokens(tokens: List(Token)) -> Result(Nil) {
  tokens
  |> list.each(print_token)

  Ok(Nil)
}

pub fn to_string(token: Token) -> String {
  token_type_to_string(token.token_type) <> " " <> token.lexeme <> " " <> literal_to_string(
    token.literal,
  )
}

fn token_type_to_string(token_type: TokenType) -> String {
  case token_type {
    LeftParenToken -> "LeftParen"
    RightParenToken -> "RightParen"
    LeftBraceToken -> "LeftBrace"
    RightBraceToken -> "RightBrace"
    CommaToken -> "Comma"
    DotToken -> "Dot"
    MinusToken -> "Minus"
    PlusToken -> "Plus"
    SemicolonToken -> "Semicolon"
    SlashToken -> "Slash"
    StarToken -> "Star"
    BangToken -> "Bang"
    BangEqualToken -> "BangEqual"
    EqualToken -> "Equal"
    EqualEqualToken -> "EqualEqual"
    GreaterToken -> "Greater"
    GreaterEqualToken -> "GreaterEqual"
    LessToken -> "Less"
    LessEqualToken -> "LessEqual"
    IdentifierToken -> "Identifier"
    StringToken -> "String"
    NumberToken -> "Number"
    AndToken -> "And"
    ClassToken -> "Class"
    ElseToken -> "Else"
    FalseToken -> "False"
    FunToken -> "Fun"
    ForToken -> "For"
    IfToken -> "If"
    NilToken -> "Nil"
    OrToken -> "Or"
    PrintToken -> "Print"
    ReturnToken -> "Return"
    SuperToken -> "Super"
    ThisToken -> "This"
    TrueToken -> "True"
    VarToken -> "Var"
    WhileToken -> "While"
    EofToken -> "Eof"
  }
}

fn print_token(token: Token) -> Nil {
  io.println(to_string(token))
}
