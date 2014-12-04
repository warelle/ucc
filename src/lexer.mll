{
  open Parser

  exception Error of string
}

let digit = ['0'-'9']
let space = ' ' | '\t'
let alpha = ['a'-'z' 'A'-'Z' '_' ]
let ident = alpha (alpha | digit)*

rule token = parse
| space
    { token lexbuf }
| ['\r' '\n']
    { Lexing.new_line lexbuf; token lexbuf }
| ';'
    { SEMICOLON }
| ','
    { COMMA}
| "int"
    { TINT }
| "if"
    { IF }
| "else"
    { ELSE }
| "while"
    { WHILE }
| "do"
    { DO }
| "for"
    { FOR }
| "return"
    { RETURN }
| "continue"
    { CONTINUE }
| "break"
    { BREAK }
| '+'
    { PLUS }
| "++"
    { INC }
| '-'
    { MINUS }
| '!'
    { NOT }
| '?'
    { COND }
| ':'
    { COLON }
| "--"
    { DEC }
| '*'
    { STAR }
| '/'
    { SLASH }
| '%'
    { MOD }
| "<<"
    { LSHIFT }
| ">>"
    { RSHIFT }
| '&'
    { AMP }
| '^'
    { HAT }
| '|'
    { BAR }
| '~'
    { TILDE }
| "=="
    { EQ}
| "!="
    { NEQ}
| "="
    { SUBST }
| "+="
    { PLUSSUBST }
| "-="
    { MINUSSUBST }
| "*="
    { STARSUBST }
| "/="
    { SLASHSUBST }
| "%="
    { MODSUBST }
| "<<="
    { LSHIFTSUBST }
| ">>="
    { RSHIFTSUBST }
| "&="
    { AMPSUBST }
| "^="
    { HATSUBST }
| "|="
    { BARSUBST }
| "<"
    { LT }
| ">"
    { GT }
| "<="
    { LE }
| ">="
    { GE }
| '('
    { LPAREN }
| ')'
    { RPAREN }
| '{'
    { LBRACE }
| '}'
    { RBRACE }
| '['
    { LBRACKET }
| ']'
    { RBRACKET }
| "//"
    { commentbis lexbuf }
| "#"
    { commentbis lexbuf }
| "/*"
    { comment lexbuf }
| digit+ as i
    { INT (int_of_string i) }
| ident  as n
    { ID n }
| eof
    { EOF }
| _
    { raise (Error
               (Printf.sprintf "At offset %d: unexpected character.\n"
                               (Lexing.lexeme_start lexbuf)))
    }

and comment = parse
| "*/"
    { token lexbuf }
| _
    { comment lexbuf }
| eof
    { raise (Error "Error: unclosed comment\n") }

and commentbis = parse
| '\n'
    { Lexing.new_line lexbuf; token lexbuf }
| _
    { commentbis lexbuf }
| eof
    { EOF }
