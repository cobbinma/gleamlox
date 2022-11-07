import token.{
  AndToken, BangEqualToken, BangToken, ClassToken, CommaToken, DotToken,
  ElseToken, EofToken, EqualEqualToken, EqualToken, FalseToken, ForToken,
  FunToken, GreaterEqualToken, GreaterToken, IdentifierToken, IfToken,
  LeftBraceToken, LeftParenToken, LessEqualToken, LessToken, Literal, MinusToken,
  NilToken, Null, NumberLiteral, NumberToken, OrToken, PlusToken, PrintToken,
  ReturnToken, RightBraceToken, RightParenToken, SemicolonToken, SlashToken,
  StarToken, StringLiteral, StringToken, SuperToken, ThisToken, Token, TokenType,
  TrueToken, VarToken, WhileToken,
}
import snag.{Snag}
import gleam/string
import gleam/list
import gleam/result
import gleam/int
import gleam/io
import gleam/order
import gleam/map

pub opaque type Scanner {
  Scanner(
    source: List(String),
    start: Int,
    current: Int,
    line: Int,
    tokens: List(Token),
    has_error: Bool,
  )
}

pub fn new(source: String) -> Scanner {
  Scanner(
    source: string.to_graphemes(source),
    start: 0,
    current: 0,
    line: 1,
    tokens: [],
    has_error: False,
  )
}

pub fn scan(scanner: Scanner) -> Result(List(Token), Snag) {
  let scanner = scan_tokens(scanner)

  let scanner =
    scanner
    |> add_token(EofToken, Null, "", scanner.line)

  case scanner.has_error {
    False -> Ok(scanner.tokens)
    True -> snag.error("scanning found error")
  }
}

fn advance(scanner: Scanner) -> Scanner {
  Scanner(..scanner, current: scanner.current + 1)
}

fn next_line(scanner: Scanner) -> Scanner {
  Scanner(..scanner, line: scanner.line + 1)
}

fn has_error(scanner: Scanner, has_error: Bool) -> Scanner {
  Scanner(..scanner, has_error: has_error)
}

fn add_token(
  scanner: Scanner,
  token_type: TokenType,
  literal: Literal,
  lexeme: String,
  line: Int,
) -> Scanner {
  let token = Token(token_type, lexeme, literal, line)

  Scanner(
    ..scanner,
    tokens: scanner.tokens
    |> list.append([token]),
  )
}

fn scan_tokens(scanner: Scanner) -> Scanner {
  let scanner = Scanner(..scanner, start: scanner.current)

  let scanner = advance(scanner)

  let c = list.at(scanner.source, scanner.start)

  case c {
    Ok("(") ->
      add_token(
        scanner,
        LeftParenToken,
        Null,
        lexeme(scanner.source, scanner.start, scanner.current, ""),
        scanner.line,
      )
      |> scan_tokens
    Ok(")") ->
      add_token(
        scanner,
        RightParenToken,
        Null,
        lexeme(scanner.source, scanner.start, scanner.current, ""),
        scanner.line,
      )
      |> scan_tokens
    Ok("{") ->
      add_token(
        scanner,
        LeftBraceToken,
        Null,
        lexeme(scanner.source, scanner.start, scanner.current, ""),
        scanner.line,
      )
      |> scan_tokens
    Ok("}") ->
      add_token(
        scanner,
        RightBraceToken,
        Null,
        lexeme(scanner.source, scanner.start, scanner.current, ""),
        scanner.line,
      )
      |> scan_tokens
    Ok(",") ->
      add_token(
        scanner,
        CommaToken,
        Null,
        lexeme(scanner.source, scanner.start, scanner.current, ""),
        scanner.line,
      )
      |> scan_tokens
    Ok(".") ->
      add_token(
        scanner,
        DotToken,
        Null,
        lexeme(scanner.source, scanner.start, scanner.current, ""),
        scanner.line,
      )
      |> scan_tokens
    Ok("-") ->
      add_token(
        scanner,
        MinusToken,
        Null,
        lexeme(scanner.source, scanner.start, scanner.current, ""),
        scanner.line,
      )
      |> scan_tokens
    Ok("+") ->
      add_token(
        scanner,
        PlusToken,
        Null,
        lexeme(scanner.source, scanner.start, scanner.current, ""),
        scanner.line,
      )
      |> scan_tokens
    Ok(";") ->
      add_token(
        scanner,
        SemicolonToken,
        Null,
        lexeme(scanner.source, scanner.start, scanner.current, ""),
        scanner.line,
      )
      |> scan_tokens
    Ok("*") ->
      add_token(
        scanner,
        StarToken,
        Null,
        lexeme(scanner.source, scanner.start, scanner.current, ""),
        scanner.line,
      )
      |> scan_tokens
    Ok("!") ->
      case match(list.at(scanner.source, scanner.start + 1), "=") {
        True ->
          scanner
          |> add_token(
            BangEqualToken,
            Null,
            lexeme(scanner.source, scanner.start, scanner.current + 1, ""),
            scanner.line,
          )
          |> advance
          |> scan_tokens
        False ->
          scanner
          |> add_token(
            BangToken,
            Null,
            lexeme(scanner.source, scanner.start, scanner.current, ""),
            scanner.line,
          )
          |> scan_tokens
      }
    Ok("=") ->
      case match(list.at(scanner.source, scanner.start + 1), "=") {
        True ->
          scanner
          |> add_token(
            EqualEqualToken,
            Null,
            lexeme(scanner.source, scanner.start, scanner.current + 1, ""),
            scanner.line,
          )
          |> advance
          |> scan_tokens
        False ->
          scanner
          |> add_token(
            EqualToken,
            Null,
            lexeme(scanner.source, scanner.start, scanner.current, ""),
            scanner.line,
          )
          |> scan_tokens
      }
    Ok("<") ->
      case match(list.at(scanner.source, scanner.start + 1), "=") {
        True ->
          scanner
          |> add_token(
            LessEqualToken,
            Null,
            lexeme(scanner.source, scanner.start, scanner.current + 1, ""),
            scanner.line,
          )
          |> advance
          |> scan_tokens
        False ->
          scanner
          |> add_token(
            LessToken,
            Null,
            lexeme(scanner.source, scanner.start, scanner.current, ""),
            scanner.line,
          )
          |> scan_tokens
      }
    Ok(">") ->
      case
        match(
          scanner
          |> peek,
          "=",
        )
      {
        True ->
          scanner
          |> add_token(
            GreaterEqualToken,
            Null,
            lexeme(scanner.source, scanner.start, scanner.current + 1, ""),
            scanner.line,
          )
          |> advance
          |> scan_tokens
        False ->
          scanner
          |> add_token(
            GreaterToken,
            Null,
            lexeme(scanner.source, scanner.start, scanner.current, ""),
            scanner.line,
          )
          |> scan_tokens
      }
    Ok("/") ->
      case match(list.at(scanner.source, scanner.start + 1), "/") {
        True ->
          scanner
          |> comment
          |> scan_tokens
        False ->
          scanner
          |> add_token(
            SlashToken,
            Null,
            lexeme(scanner.source, scanner.start, scanner.current, ""),
            scanner.line,
          )
          |> scan_tokens
      }
    Ok("o") ->
      case match(peek(scanner), "r") {
        True ->
          scanner
          |> add_token(
            OrToken,
            Null,
            lexeme(scanner.source, scanner.start, scanner.current + 1, ""),
            scanner.line,
          )
          |> advance
          |> scan_tokens
        False ->
          scanner
          |> scan_tokens
      }
    Ok(" ") | Ok("\r") | Ok("\t") ->
      scanner
      |> scan_tokens
    Ok("\n") ->
      scanner
      |> next_line
      |> scan_tokens
    Ok("\"") ->
      scanner
      |> string
      |> advance
      |> scan_tokens
    Ok(c) ->
      case #(is_digit(c), is_alpha(c)) {
        #(True, _) ->
          scanner
          |> number
          |> scan_tokens
        #(False, True) ->
          scanner
          |> identifier
          |> scan_tokens
        #(False, False) -> {
          report(scanner.line, "Unexpected character.")
          scanner
          |> has_error(True)
          |> scan_tokens
        }
      }
    Error(_) -> scanner
  }
}

fn lexeme(
  source: List(String),
  start: Int,
  current: Int,
  init: String,
) -> String {
  let char =
    source
    |> list.at(start)
    |> result.unwrap("")

  let init = init <> char
  let start = start + 1

  case start >= current {
    True -> init
    False -> lexeme(source, start, current, init)
  }
}

fn report(line: Int, message: String) {
  io.println("[line " <> int.to_string(line) <> "] Error: " <> message)
}

fn peek(scanner: Scanner) -> Result(String, Nil) {
  scanner.source
  |> list.at(scanner.start + 1)
}

fn match(current: Result(String, Nil), expected: String) -> Bool {
  case current {
    Ok(current) ->
      case current != expected {
        True -> False
        False -> True
      }
    Error(_) -> False
  }
}

fn comment(scanner: Scanner) -> Scanner {
  case
    scanner.source
    |> list.at(scanner.current)
  {
    Ok(char) ->
      case char {
        "\n" -> scanner
        _ ->
          scanner
          |> advance
          |> comment
      }
    Error(_) ->
      scanner
      |> advance
  }
}

fn string(scanner: Scanner) -> Scanner {
  let scanner =
    scanner
    |> advance
  case
    scanner.source
    |> list.at(scanner.current)
  {
    Ok(char) ->
      case char {
        "\"" ->
          scanner
          |> add_token(
            StringToken,
            StringLiteral,
            lexeme(scanner.source, scanner.start, scanner.current + 1, ""),
            scanner.line,
          )
        "\n" ->
          scanner
          |> next_line
          |> string
        _ ->
          scanner
          |> string
      }
    Error(_) -> {
      report(scanner.line, "Unterminated string.")
      scanner
      |> has_error(True)
    }
  }
}

fn is_digit(char: String) -> Bool {
  case
    char
    |> int.parse
  {
    Ok(_) -> True
    Error(_) -> False
  }
}

fn is_alpha(c: String) -> Bool {
  let lowercase =
    { string.compare(c, "a") == order.Eq || string.compare(c, "a") == order.Gt } && {
      string.compare(c, "z") == order.Eq || string.compare(c, "z") == order.Lt
    }
  let uppercase =
    { string.compare(c, "A") == order.Eq || string.compare(c, "A") == order.Gt } && {
      string.compare(c, "Z") == order.Eq || string.compare(c, "Z") == order.Lt
    }

  lowercase || uppercase || c == "_"
}

fn number(scanner: Scanner) -> Scanner {
  case
    scanner.source
    |> list.at(scanner.current)
  {
    Ok(char) ->
      case #(char, is_digit(char)) {
        #(_, True) ->
          scanner
          |> advance
          |> number
        #(".", False) ->
          case list.at(scanner.source, scanner.current + 1) {
            Ok(c) ->
              case
                c
                |> is_digit
              {
                True ->
                  scanner
                  |> advance
                  |> number
                False ->
                  scanner
                  |> add_token(
                    NumberToken,
                    NumberLiteral,
                    lexeme(scanner.source, scanner.start, scanner.current, ""),
                    scanner.line,
                  )
              }
            Error(_) ->
              scanner
              |> advance
          }
        _ ->
          scanner
          |> add_token(
            NumberToken,
            NumberLiteral,
            lexeme(scanner.source, scanner.start, scanner.current, ""),
            scanner.line,
          )
          |> advance
      }
    Error(_) ->
      scanner
      |> advance
  }
}

fn identifier(scanner: Scanner) -> Scanner {
  case
    scanner.source
    |> list.at(scanner.current)
  {
    Ok(char) ->
      case
        char
        |> is_alpha
      {
        True ->
          scanner
          |> advance
          |> identifier
        False -> {
          let text = lexeme(scanner.source, scanner.start, scanner.current, "")
          let token_type =
            text
            |> keyword
            |> result.unwrap(IdentifierToken)
          scanner
          |> add_token(token_type, Null, text, scanner.line)
          |> advance
        }
      }
    Error(_) ->
      scanner
      |> advance
  }
}

fn keyword(identifier: String) -> Result(token.TokenType, Nil) {
  map.from_list([
    #("and", AndToken),
    #("class", ClassToken),
    #("else", ElseToken),
    #("false", FalseToken),
    #("for", ForToken),
    #("fun", FunToken),
    #("if", IfToken),
    #("nil", NilToken),
    #("or", OrToken),
    #("print", PrintToken),
    #("return", ReturnToken),
    #("super", SuperToken),
    #("this", ThisToken),
    #("true", TrueToken),
    #("var", VarToken),
    #("while", WhileToken),
  ])
  |> map.get(identifier)
}
