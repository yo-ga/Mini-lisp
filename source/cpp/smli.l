%{
	#include <string>
	#include <vector>
	#include <iostream>
	using namespace std;
	struct YYST{
		bool bval;
		int ival;
		std::string strval;
		vector<string> contain;
		struct subexp
		{
			int tpe;
			int ival;
			bool bval;
		};
	};
	void yyerror( const char *message);
	#define YYSTYPE YYST
	#include "smli.tab.h"
%}
letter  [a-z]
digit  [0-9]
%%
[ \t\n\r]  {;}
"("  {return (parent_left);}
")"  {return (parent_right);}
"+"  {return (_plus);}
"-"  {return (_minus);}
"*"  {return (_mul);}
"/"  {return (_div);}
"mod"  {return (mod);}
">"  {return (gre);}
"<"  {return (sml);}
"="  {return (equ);}
"and"  {return (_and);}
"or"  {return (_or);}
"not"  {return (_not);}
"define"  {return (_def);}
"fun"  {return (_fun);}
"if"  {return (_if);}
"print-num"  {return (print_num);}
"print-bool"  {return (print_bool);}
[0-9]  {yylval.ival=atoi(yytext); return(number);}
"-"?[1-9][0-9]*  {yylval.ival=atoi(yytext); return(number);}
"#t"  {yylval.bval=true; return(bool_val);}
"#f"  {yylval.bval=false; return(bool_val);}
{letter}({letter}|{digit}|'-')*  {yylval.strval=yytext; return (id);}
.  {yyerror("Syntax error!");}
<<EOF>>  {return(0);}

%%