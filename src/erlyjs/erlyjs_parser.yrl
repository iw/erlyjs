%%%-------------------------------------------------------------------
%%% File:      erlyjs_parser.xrl
%%% @author    Roberto Saccon <rsaccon@gmail.com> [http://rsaccon.com]
%%% @copyright 2007 Roberto Saccon
%%% @doc  
%%% ErlyJS Parser
%%% @end  
%%%
%%% The MIT License
%%%
%%% Copyright (c) 2007 Roberto Saccon
%%%
%%% Permission is hereby granted, free of charge, to any person obtaining a copy
%%% of this software and associated documentation files (the "Software"), to deal
%%% in the Software without restriction, including without limitation the rights
%%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%%% copies of the Software, and to permit persons to whom the Software is
%%% furnished to do so, subject to the following conditions:
%%%
%%% The above copyright notice and this permission notice shall be included in
%%% all copies or substantial portions of the Software.
%%%
%%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
%%% THE SOFTWARE.
%%%
%%% Acknowledgements
%%% ================
%%% special thanks to Denis Loutrein for initial code contribution
%%%
%%% @since 2007-12-23 by Roberto Saccon
%%%-------------------------------------------------------------------


Nonterminals 
    Program
    MultiplicativeExpression
    UnaryExpression
    AdditiveExpression
    PostfixExpression
    LeftSideExpression
    CallExpression
    PrimaryExpression
    MemberOperator
    Arguments
    FullNewExpression
    FullNewSubexpression
    ShortNewSubexpression
    ShortNewExpression
    Expression
    ArgumentList
    AssignmentExpression
    SimpleExpression
    ObjectLiteral
    RegularExpression
    ParenthesizedExpression
    FunctionExpression
    ArrayLiteral
    AnonymousFunction
    NamedFunction
    FieldList
    LiteralField
    ElementList
    LiteralElement
    OptionalExpression
    Number
    ConditionalExpression
    CompoundAssignment
    FormalParametersAndBody
    FormalParameters
    FunctionDefinition
    Statement
    OptionalSemicolon
    EmptyStatement
    TopStatement
    TopStatements
    ExpressionStatement
    VariableDefinition
    VariableDeclarationList
    VariableDeclaration
    VariableInitializer
    ShiftExpression
    RelationalExpression
    EqualityExpression
    BitwiseAndExpression
    BitwiseXorExpression
    LogicalOrExpression
    BitwiseOrExpression
    LogicalAndExpression
    Block
    LabeledStatement
    IfStatement
    SwitchStatement
    DoStatement
    WhileStatement
    ForStatement
    WithStatement
    ContinueStatement
    BreakStatement
    ReturnStatement
    ThrowStatement
    TryStatement
    BlockStatements
    CaseGroups
    CaseGroup
    CaseGuards
    CaseGuard
    ForInitializer
    ForInBinding
    LastCaseGroup
    OptionalLabel
    CatchClauses
    FinallyClause
    CatchClause
    .


Terminals 
    float integer string new this null true false delete void typeof try throw with break return 
    identifier regexp function var instanceof in if else switch do while for case default
    continue finally catch
    '+' '-' '*' '/' ':' '~' '!' '*=' '/=' '%=' '+=' '-=' '<<=' '>>=' '>>>='
    '&=' '^=' '|=' '=' ';' '?' '<<' '>>' '>>>' '<<<' '<' '>' 
    '(' ')' '[' ']' '.' ',' '++' '--' '&&' '===' '==' '<=' '>=' '!=' '!==' 
    '{' '}' '&' '^' '||' '|'
    .


Left 100 FunctionExpression.
Left 100 LiteralField.
Left 100 PostfixExpression.


Rootsymbol Program.


%% Number
Number -> float : '$1'.
Number -> integer : '$1'.

%% Primary Expressions 
PrimaryExpression -> SimpleExpression : '$1'.
PrimaryExpression -> FunctionExpression : '$1'.
PrimaryExpression -> ObjectLiteral : '$1'.
SimpleExpression -> this : '$1'.
SimpleExpression -> null : '$1'.
SimpleExpression -> true : '$1'.
SimpleExpression -> false : '$1'.
SimpleExpression -> Number : '$1'.
SimpleExpression -> string : '$1'.
SimpleExpression -> identifier  : '$1'.
SimpleExpression -> regexp : '$1'.
SimpleExpression -> ParenthesizedExpression : '$1'.
SimpleExpression -> ArrayLiteral : '$1'.
ParenthesizedExpression -> '(' Expression ')' : '$1'.

%% Function Expressions 
FunctionExpression -> AnonymousFunction : '$1'.
FunctionExpression -> NamedFunction : '$1'.

%% Object Literals TODO
ObjectLiteral -> '{' '}' : '$1'. 
ObjectLiteral -> '{' FieldList '}'  : '$1'. 
FieldList -> LiteralField : ['$1'].
FieldList -> FieldList ',' LiteralField : '$1' ++ ['$3'].
LiteralField -> identifier ':' AssignmentExpression : '$1'.

%% Array Literals TODO
ArrayLiteral -> '[' ']' : '$1'. 
ArrayLiteral -> '[' ElementList ']' : '$1'.
ElementList -> LiteralElement : ['$1'].
ElementList -> ElementList ',' LiteralElement : '$1' ++ ['$3'].
LiteralElement -> AssignmentExpression : '$1'.

%% Left-Side Expressions 
LeftSideExpression -> CallExpression : '$1'.
LeftSideExpression -> ShortNewExpression : '$1'.
CallExpression -> PrimaryExpression : '$1'.
CallExpression -> FullNewExpression : '$1'.
CallExpression -> CallExpression MemberOperator : '$1'.
CallExpression -> CallExpression Arguments : '$1'.
FullNewExpression -> new FullNewSubexpression Arguments : '$1'.
ShortNewExpression -> new ShortNewSubexpression : '$1'.
FullNewSubexpression -> PrimaryExpression : '$1'.
FullNewSubexpression -> FullNewExpression : '$1'.
FullNewSubexpression -> FullNewSubexpression MemberOperator : '$1'.
ShortNewSubexpression -> FullNewSubexpression : '$1'.
ShortNewSubexpression -> ShortNewExpression : '$1'.
MemberOperator -> '[' Expression ']' : '$1'.
MemberOperator -> '.' identifier : '$1'.
Arguments -> '(' ')' : '$1'.
Arguments -> '(' ArgumentList ')' : {'$2'}. 
ArgumentList -> AssignmentExpression : ['$1'].  
ArgumentList -> ArgumentList ',' AssignmentExpression : '$1' ++ ['$3'].


%% Postfix Operators 
PostfixExpression -> LeftSideExpression : '$1'.
PostfixExpression -> LeftSideExpression '++' : '$1'. 
PostfixExpression -> LeftSideExpression '--' : '$1'.

%% Unary Operators
UnaryExpression -> PostfixExpression : '$1'.
UnaryExpression -> delete LeftSideExpression : '$1'.
UnaryExpression -> void UnaryExpression : '$1'.
UnaryExpression -> typeof UnaryExpression : '$1'.
UnaryExpression -> '++' LeftSideExpression : '$1'.
UnaryExpression -> '--' LeftSideExpression : '$1'.
UnaryExpression -> '+' UnaryExpression : '$1'.
UnaryExpression -> '-' UnaryExpression : {op, '-', '$2'}.
UnaryExpression -> '~' UnaryExpression : {op, 'bnot', '$2'}.
UnaryExpression -> '!' UnaryExpression : '$1'.


%% Multiplicative Operators
MultiplicativeExpression -> UnaryExpression : '$1'.
MultiplicativeExpression -> MultiplicativeExpression '*' UnaryExpression : {op, '*', '$1', '$3'}.
MultiplicativeExpression -> MultiplicativeExpression '/' UnaryExpression : {op, '/', '$1', '$3'}.


%% Additive Operators
AdditiveExpression -> MultiplicativeExpression : '$1'.
AdditiveExpression -> AdditiveExpression '+' MultiplicativeExpression : {op, '+', '$1', '$3'}.
AdditiveExpression -> AdditiveExpression '-' MultiplicativeExpression : {op, '-', '$1', '$3'}.

%% Bitwise Shift Operators
ShiftExpression -> AdditiveExpression : '$1'.
ShiftExpression -> ShiftExpression '<<' AdditiveExpression : {op, 'bsl', '$1', '$3'}.
ShiftExpression -> ShiftExpression '>>' AdditiveExpression : {op, 'bsr', '$1', '$3'}.
ShiftExpression -> ShiftExpression '>>>' AdditiveExpression : '$1'.

%% Relational Operators TODO
RelationalExpression -> ShiftExpression : '$1'.
RelationalExpression -> RelationalExpression '<' ShiftExpression : '$1'.
RelationalExpression -> RelationalExpression '>' ShiftExpression : '$1'.
RelationalExpression -> RelationalExpression '<=' ShiftExpression : '$1'.
RelationalExpression -> RelationalExpression '>=' ShiftExpression  : '$1'.
RelationalExpression -> RelationalExpression instanceof ShiftExpression : '$1'.
RelationalExpression -> RelationalExpression in ShiftExpression  : '$1'. 

%% Equality Operators TODO
EqualityExpression -> RelationalExpression : '$1'.
EqualityExpression -> EqualityExpression '==' RelationalExpression : '$1'.
EqualityExpression -> EqualityExpression '!=' RelationalExpression : '$1'.
EqualityExpression -> EqualityExpression '===' RelationalExpression  : '$1'.
EqualityExpression -> EqualityExpression '!==' RelationalExpression : '$1'.

%% Binary Bitwise Operators  TODO (is currently wrong)
BitwiseAndExpression -> EqualityExpression : '$1'.
BitwiseAndExpression -> BitwiseAndExpression '&' EqualityExpression : {op, 'band', '$1', '$3'}.
BitwiseXorExpression -> BitwiseAndExpression : '$1'.
BitwiseXorExpression -> BitwiseXorExpression '^' BitwiseAndExpression : {op, 'bxor', '$1', '$3'}.
BitwiseOrExpression -> BitwiseXorExpression : '$1'.
BitwiseOrExpression -> BitwiseOrExpression '|' BitwiseXorExpression : {op, 'bor', '$1', '$3'}.

%% Binary Logical Operators  TODO (is currently wrong)
LogicalAndExpression -> BitwiseOrExpression : '$1'.
LogicalAndExpression -> LogicalAndExpression '&&' BitwiseOrExpression : {op, 'and', '$1', '$3'}.
LogicalOrExpression -> LogicalAndExpression : '$1'.
LogicalOrExpression -> LogicalOrExpression '||' LogicalAndExpression : {op, 'or', '$1', '$3'}.

%% Conditional Operator  TODO
ConditionalExpression -> LogicalOrExpression : '$1'.
ConditionalExpression -> LogicalOrExpression '?' AssignmentExpression ':' AssignmentExpression : '$1'. 

%% Assignment Operators 
AssignmentExpression -> ConditionalExpression : '$1'. 
AssignmentExpression -> LeftSideExpression '=' AssignmentExpression : {'$2', '$1', '$3'}.
AssignmentExpression -> LeftSideExpression CompoundAssignment AssignmentExpression  : {'$2', '$1', '$3'}.
CompoundAssignment -> '*=' : '$1'.
CompoundAssignment -> '/=' : '$1'. 
CompoundAssignment -> '%=' : '$1'. 
CompoundAssignment -> '+=' : '$1'. 
CompoundAssignment -> '-=' : '$1'. 
CompoundAssignment -> '<<=' : '$1'. 
CompoundAssignment -> '>>=' : '$1'. 
CompoundAssignment -> '>>>=' : '$1'. 
CompoundAssignment -> '&=' : '$1'. 
CompoundAssignment -> '^=' : '$1'. 
CompoundAssignment -> '|=' : '$1'. 

%% Expressions 
Expression -> AssignmentExpression : '$1'.
Expression -> Expression ',' AssignmentExpression : ['$1', '$3']. 
OptionalExpression -> Expression : '$1'.
OptionalExpression -> '$empty' : [].

%% Statements
Statement -> EmptyStatement :  '$1'.
Statement -> ExpressionStatement OptionalSemicolon : '$1'.
Statement -> VariableDefinition OptionalSemicolon : '$1'.
Statement -> Block : '$1'.
Statement -> LabeledStatement : '$1'.
Statement -> IfStatement : '$1'.
Statement -> SwitchStatement : '$1'.
Statement -> DoStatement OptionalSemicolon : '$1'.
Statement -> WhileStatement : '$1'.
Statement -> ForStatement : '$1'.
Statement -> WithStatement : '$1'.
Statement -> ContinueStatement OptionalSemicolon : '$1'.
Statement -> BreakStatement OptionalSemicolon  : '$1'.
Statement -> ReturnStatement OptionalSemicolon  : '$1'.
Statement -> ThrowStatement OptionalSemicolon : '$1'.
Statement -> TryStatement : '$1'.
OptionalSemicolon -> ';' : '$1'. 
OptionalSemicolon -> '$empty' : [].

%% Empty Statement 
EmptyStatement -> ';'. 

%% Expression Statement 
ExpressionStatement -> Expression : '$1'.

%% Variable Definition
VariableDefinition -> var VariableDeclarationList : {'$1', '$2'}.
VariableDeclarationList -> VariableDeclaration : ['$1'].
VariableDeclarationList -> VariableDeclarationList ',' VariableDeclaration : '$1' ++ ['$3'].
VariableDeclaration -> identifier VariableInitializer : {'$1', '$2'}.
VariableInitializer -> '$empty' : [].
VariableInitializer -> '=' AssignmentExpression : '$2'.

%% Block 
Block -> '{' BlockStatements '}' : '$1'. 
BlockStatements -> '$empty' : [].
BlockStatements ->  BlockStatements Statement : '$1' ++ ['$2'].

%% Labeled Statements 
LabeledStatement -> identifier ':' Statement : {'$1', '$3'}. 

%% If Statement
IfStatement -> if ParenthesizedExpression Statement  : {'$1', '$2', '$3'}.
IfStatement -> if ParenthesizedExpression Statement else Statement : {'$1', '$2', '$3', '$4', '$5'}.

%% Switch Statement  TODO
SwitchStatement -> switch ParenthesizedExpression '{' '}' : '$1'.
%% SwitchStatement -> switch ParenthesizedExpression '{' CaseGroups LastCaseGroup '}' : '$1'.
%% CaseGroups -> '$empty' : [].
%% CaseGroups -> CaseGroups CaseGroup : '$1'.
%% CaseGroup -> CaseGuards BlockStatementsPrefix : '$1'.
%% LastCaseGroup  -> CaseGuards BlockStatements : '$1'.
%% CaseGuards -> CaseGuard : '$1'.
%% CaseGuards -> CaseGuards CaseGuard  : '$1'.
%% CaseGuard -> case Expression ':' : '$1'.
%% CaseGuard -> default ':' : '$1'.
     
%% Do-While Statement  TODO
DoStatement -> do Statement while ParenthesizedExpression : '$1'.

%% While Statement
WhileStatement -> while ParenthesizedExpression Statement : '$1'.

%% For Statements  TODO
ForStatement -> for '(' ForInitializer ';' OptionalExpression ';' OptionalExpression ')' Statement : '$1'.
ForStatement -> for '(' ForInBinding in Expression ')' Statement : '$1'.
ForInitializer -> '$empty' : [].
ForInitializer -> Expression : '$1'.
ForInitializer -> var VariableDeclarationList : '$1'.  %% TODO
ForInBinding -> LeftSideExpression : '$1'.
ForInBinding -> var VariableDeclaration : '$1'.  %% TODO

%% With Statement TODO
WithStatement -> with ParenthesizedExpression Statement : '$1'.

%% Continue and Break Statements 
ContinueStatement -> continue OptionalLabel : '$1'.
BreakStatement  -> break OptionalLabel : '$1'.
OptionalLabel -> '$empty' : [].
OptionalLabel -> identifier : '$1'.

%% Return Statement TODO
ReturnStatement -> return OptionalExpression : {'$1', '$2'}. 

%% Throw Statement TODO
ThrowStatement -> throw Expression : '$1'.

%% Try Statement 
TryStatement -> try Block CatchClauses : '$1'.
TryStatement -> try Block FinallyClause : '$1'.
TryStatement -> try Block CatchClauses FinallyClause : '$1'.
CatchClauses -> CatchClause : '$1'.
CatchClauses -> CatchClauses CatchClause : '$1'.
CatchClause -> catch '(' identifier ')' Block : '$1'.
FinallyClause -> finally Block : '$1'.

%% Function Definition 
FunctionDefinition -> NamedFunction : '$1'.
AnonymousFunction -> function FormalParametersAndBody : {'$1'}.
NamedFunction -> function identifier FormalParametersAndBody : { '$1', '$2', '$3'}.
FormalParametersAndBody -> '(' FormalParameters ')' '{' TopStatements '}' : { params, '$2', body, '$5'}.
FormalParameters -> '$empty' : [].
FormalParameters -> identifier : ['$1'].
FormalParameters -> FormalParameters ',' identifier : '$1' ++ ['$3'].

%% Programs 
Program -> TopStatements : '$1'.
TopStatements -> '$empty' : [].
TopStatements -> TopStatements TopStatement : '$1' ++ ['$2'].
TopStatement -> Statement : '$1'.
TopStatement -> FunctionDefinition  : '$1'.


Erlang code.