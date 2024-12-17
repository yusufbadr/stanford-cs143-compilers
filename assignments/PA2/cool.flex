/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;
int string_len;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */

%}

/*
 * Define names for regular expressions here.
 */


DARROW                "=>"
DIGIT                 [0-9]
ASSIGN                "<-"    

%x STRING
%x COMMENT
%x INLINE_COMMENT

%%

 /*
  *  Nested comments
  */
"(*" {
  BEGIN(COMMENT);
}

<COMMENT><<EOF>> {
  cool_yylval.error_msg = "EOF in comment";
  BEGIN(INITIAL);
  return ERROR;
}

<COMMENT>\n { curr_lineno++; }

<COMMENT>"*)" {
  BEGIN(INITIAL);
}

"*)" {
  cool_yylval.error_msg = "Unmatched *)";
  BEGIN(INITIAL);
  return ERROR;
}

<COMMENT>[^*\n]+ {}

<COMMENT>. {}

 /*
  * INLINE COMMENT
  */

"--" {
  BEGIN(INLINE_COMMENT);
}

<INLINE_COMMENT><<EOF>> {
  BEGIN(INITIAL);
}

<INLINE_COMMENT>\n {
  curr_lineno++;
}

<INLINE_COMMENT>. {}

(?i:class)        { return CLASS; }
(?i:else)         { return ELSE; }
(?i:fi)           { return FI; }
(?i:if)           { return IF; }
(?i:in)           { return IN; }
(?i:inherits)     { return INHERITS; }
(?i:let)          { return LET; }
(?i:loop)         { return LOOP; }
(?i:pool)         { return POOL; }
(?i:then)         { return THEN; }
(?i:while)        { return WHILE; }
(?i:case)         { return CASE; }
(?i:esac)         { return ESAC; }
(?i:of)           { return OF; }
(?i:new)          { return NEW; }
(?i:isvoid)       { return ISVOID; }
(?i:not)          { return NOT; }


{DIGIT}+ {
  cool_yylval.symbol = inttable.add_string(yytext);
  return (INT_CONST);
}

{DARROW}		{ return (DARROW); }
{ASSIGN}    { return (ASSIGN); }

"<=" {return (LE);}

[ \f\r\t\v]+ { }

t[rR][uU][eE]   {
  cool_yylval.boolean = true;
  return BOOL_CONST; 
}

f[aA][lL][sS][eE] %{ 
  cool_yylval.boolean = false;
  return BOOL_CONST; 
%}


[A-Z][a-zA-Z0-9_]* {
  cool_yylval.symbol = idtable.add_string(yytext);
  return (TYPEID); 
}

[a-z][a-zA-Z0-9_]* {
  cool_yylval.symbol = idtable.add_string(yytext);
  return (OBJECTID);
}



 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */
\" {
  BEGIN(STRING);
  string_buf_ptr = string_buf;
  string_len = 0;
}

<STRING>\" {
  *string_buf_ptr = '\0';
  cool_yylval.symbol = stringtable.add_string(string_buf);
  BEGIN(INITIAL);
  return STR_CONST;
}

<STRING>[^\\\"\n] {
  /* match regular character that are not \, ", or \n */

  if (string_len >= MAX_STR_CONST - 1) {
      cool_yylval.error_msg = "String constant too long";
      BEGIN(INITIAL);
      return ERROR; 
  }

  string_len++;
  *string_buf_ptr++ = yytext[0];
}


<STRING>\n {
  cool_yylval.error_msg = "Unterminated string constant"; 
  BEGIN(INITIAL);
  return ERROR;
}



<STRING>\\\n { 
  /* match escape char followed by newline which is allowed*/
  if (string_len >= MAX_STR_CONST - 1) {
      cool_yylval.error_msg = "String constant too long";
      BEGIN(INITIAL);
      return ERROR; 
  }
  string_len++;
  *string_buf_ptr++ = '\\';

  string_len++;
  *string_buf_ptr++ = '\n';
}

<STRING><<EOF>> {
  cool_yylval.error_msg = "EOF in string constant";
  BEGIN(INITIAL);
  return ERROR; 
}


<STRING>\\0 {
  cool_yylval.error_msg = "String contains null character";
  BEGIN(INITIAL);
  return ERROR; 
}

<STRING>\\\" {
  if (string_len >= MAX_STR_CONST - 1) {
      cool_yylval.error_msg = "String constant too long";
      BEGIN(INITIAL);
      return ERROR; 
  }
  string_len++;
  *string_buf_ptr++ = '\"';
}


<STRING>\\\\ {
  if (string_len >= MAX_STR_CONST - 1) {
    cool_yylval.error_msg = "String constant too long";
    BEGIN(INITIAL);
    return ERROR; 
  }
  string_len++;
  *string_buf_ptr++ = '\\';
}


<STRING>\\b {
  if (string_len >= MAX_STR_CONST - 1) {
    cool_yylval.error_msg = "String constant too long";
    BEGIN(INITIAL);
    return ERROR; 
  }
  string_len++;
  *string_buf_ptr++ = '\b';
}

<STRING>\\t {
  if (string_len >= MAX_STR_CONST - 1) {
    cool_yylval.error_msg = "String constant too long";
    BEGIN(INITIAL);
    return ERROR; 
  }
  string_len++;
  *string_buf_ptr++ = '\t';
}

<STRING>\\n {
  if (string_len >= MAX_STR_CONST - 1) {
    cool_yylval.error_msg = "String constant too long";
    BEGIN(INITIAL);
    return ERROR; 
  }
  string_len++;
  *string_buf_ptr++ = '\n';
}


<STRING>\\f {
  if (string_len >= MAX_STR_CONST - 1) {
    cool_yylval.error_msg = "String constant too long";
    BEGIN(INITIAL);
    return ERROR; 
  }
  string_len++;
  *string_buf_ptr++ = '\f';
}


\n { curr_lineno++; }


"+"    { return '+'; }
"/"    { return '/'; }
"-"    { return '-'; }
"*"    { return '*'; }
"="    { return '='; }
"<"    { return '<'; }
"."    { return '.'; }
"~"    { return '~'; }
","    { return ','; }
";"    { return ';'; }
":"    { return ':'; }
"("    { return '('; }
")"    { return ')'; }
"@"    { return '@'; }
"{"    { return '{'; }
"}"    { return '}'; }


. {
  cool_yylval.error_msg = yytext;
  return ERROR;
}


%%
