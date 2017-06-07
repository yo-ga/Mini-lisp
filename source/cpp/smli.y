%{
	#include<iostream>
	#include<cstdlib>
	#include<sstream>
	#include<string>
	#include<map>
	#include<vector>
	using namespace std;
	void yyerror( const char *message);
	int yylex();
	map<string, string> mapping;
	map<string, string> local;
	struct YYST{
		bool bval;
		int ival;
		string strval;
		vector<string> contn;
		struct subexp
		{
			int tpe;
			int ival;
			bool bval;
		};
	};
	#define YYSTYPE YYST
%}
%token _mul _minus _plus mod _div
%token sml gre equ
%token _or _and _not
%token _def _fun _if
%token bool_val number id
%token print_num print_bool
%token parent_left parent_right

%type <strval> id VARIABLE
%type <ival> number INT_EXP
%type <bval> bool_val BOOL_EXP
%type <contn> INT_EXPs BOOL_EXPs
%%
PROGRAM : STMTs  {;}
		;
STMTs	: STMT STMTs  {;}
		| STMT  {;}
		;
STMT	: BOOL_EXP  {;}
		| INT_EXP  {;}
		| VARIABLE {;}
		| PRINT-STMT  {;}
		| DEF-STMT  {;}
		;
PRINT-STMT : parent_left print_num INT_EXP parent_right
		{
			cout<<$<ival>3<<endl;
		}
		| parent_left print_bool BOOL_EXP parent_right
		{
			if($<bval>3)
				cout<<"#t"<<endl;
			else
				cout<<"#f"<<endl;
		}
		;
INT_EXP	: number  {$<ival>$ = $<ival>1;}
		| id
		{
			$<ival>$ = atoi(mapping[$<strval>1].c_str());
		}
		| parent_left _plus INT_EXP INT_EXPs parent_right
		{
			int ans = $<ival>3 ;
			for(int i = 0;i< $<contn>4.size();i++)
			{
				ans += atoi($<contn>4[i].c_str());
			}
			$<ival>$ = ans;
		}
		| parent_left _minus INT_EXP INT_EXP parent_right
		{
			$<ival>$ = $<ival>3 - $<ival>4 ;
		}
		| parent_left _mul INT_EXP INT_EXPs parent_right
		{
			int ans = $<ival>3 ;
			for(int i = 0;i< $<contn>4.size();i++)
			{
				ans *= atoi($<contn>4[i].c_str());
			}
			$<ival>$ = ans;
		}
		| parent_left _div INT_EXP INT_EXP parent_right
		{
			$<ival>$ = $<ival>3 / $<ival>4 ;
		}
		| parent_left mod INT_EXP INT_EXP parent_right
		{
			$<ival>$ = $<ival>3 % $<ival>4 ;
		}
		;
INT_EXPs: INT_EXP
		{
			$<contn>$ = vector<string>();
			stringstream out;
			out << $<ival>1;
			string s = out.str();
			$<contn>$.push_back(s);
		}
		| INT_EXP INT_EXPs
		{
			$<contn>$ = vector<string>();
			stringstream out;
			out << $<ival>1;
			string s = out.str();
			$<contn>$.push_back(s);
			for(int i=0;i< $<contn>2.size() ;i++)
			{
				$<contn>$.push_back($<contn>2[i]);
			}
		}
		;
BOOL_EXP: bool_val  {$<bval>$ = $<bval>1;}
		| id
		{
			if(mapping[$<strval>1] == "#t")
				$<bval>$ = true;
			else if(mapping[$<strval>1]=="#f")
				$<bval>$ = false;
			else
				YYABORT;
		}
		| parent_left gre INT_EXP INT_EXP parent_right
		{
			$<bval>$ = $<bval>3 > $<bval>4 ;
		}
		| parent_left sml INT_EXP INT_EXP parent_right
		{
			$<bval>$ = $<bval>3 < $<bval>4 ;
		}
		| parent_left equ INT_EXP INT_EXPs parent_right
		{
			bool ans = true ;
			for(int i = 0;i< $<contn>4.size();i++)
			{
				if($<ival>3 != atoi($<contn>4[i].c_str()))
					ans = false;
			}
			$<bval>$ = ans;
		}
		| parent_left _and BOOL_EXP BOOL_EXPs parent_right
		{
			bool ans = $<bval>3 ;
			for(int i = 0;i< $<contn>4.size();i++)
			{
				if("true" == $<contn>4[i])
					ans = ans && true ;
				else
					ans = ans && false ;
			}
			$<bval>$ = ans;
		}
		| parent_left _or BOOL_EXP BOOL_EXPs parent_right
		{
			bool ans = $<bval>3 ;
			for(int i = 0;i< $<contn>4.size();i++)
			{
				if("true" == $<contn>4[i])
					ans = ans || true ;
				else
					ans = ans || false ;
			}
			$<bval>$ = ans;
		}
		| parent_left _not BOOL_EXP parent_right
		{
			$<bval>$ = ! $<bval>3;
		}
		;
BOOL_EXPs: BOOL_EXP BOOL_EXPs
		{
			$<contn>$ = vector<string>();
			if($<bval>1)
				$<contn>$.push_back("true");
			else
				$<contn>$.push_back("false");
			for(int i = 0;i<$<contn>2.size();i++)
			{
				$<contn>$.push_back($<contn>2[i]);
			}
		}
		| BOOL_EXP
		{
			$<contn>$ = vector<string>();
			if($<bval>1)
				$<contn>$.push_back("true");
			else
				$<contn>$.push_back("false");
		}
		;
VARIABLE: id  {$<strval>$ = $<strval>1;}
		;
DEF-STMT: parent_left _def id INT_EXP parent_right
		{
			stringstream out;
			out << $<ival>4;
			string s = out.str();
			mapping[$<strval>3] = s;
		}
		| parent_left _def id BOOL_EXP parent_right
		{
			if($<bval>4)
				mapping[$<strval>3] = "#t";
			else
				mapping[$<strval>3] = "#f";
		}
		;
%%
void yyerror (const char* message)
{
	cout<<message<<endl;
}
int main()
{
	yyparse();
	return 0;
}