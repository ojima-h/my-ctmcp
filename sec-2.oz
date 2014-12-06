%
% 第2章
%

% 1.
% ====

declare P

proc {P X}
   if X>0 then {P X-1} end
end
{P 10}

% 核言語に翻訳すると

declare P

P = proc {$ X}
       local T in
	  T = X > 0
	  if T then
	     local V in
		V = X - 1
		{P V}
	     end
	  end
       end
    end

% 識別子Pの2番めの出現は自由である。
% 文 `P = proc {$ X} ... end` において P は宣言されていないからである. (p.65)


% 2.
% ====

local MulByN in
   local N in
      N = 3
      proc {MulByN X ?Y}
	 Y = N * X
      end
   end

   local A B in
      A = 10
      {MulByN A B}
      {Browse B}
   end
end

% MulByN には `(proc {$ X ?Y} <body> end, {N -> 3})` が束縛される。
% `<body>` 実行時に `N -> 3` が存在しないと、`N * X` を評価することができずエラーになる。

% 3
% ====

declare F
fun {F X}
   if X > 0 then
      plus
   end
end

{Browse 10}

declare X Y
try
   X = {F 10}
   Y = {F -1}
   {Browse X}
   {Browse Y}
catch
   X then {Browse X}
end
   
% 例外が発生しない...
% 仕様が変わったのかも
%  
% 手続きの場合は、値を返すわけではないので、else節がなくても問題にならない。

% 4.
% ====

if <x> then <s1> else <s2> end

%=>

case <x>
of true then <s1>
else <s2>
end

% 5.
% ====

declare Test
proc {Test X}
   case X
   of a|Z then {Browse 'case'(1)}
   [] f(a) then {Browse 'case'(2)}
   [] Y|Z andthen Y == Z then {Browse 'case'(3)}
   [] Y|Z then {Browse 'case'(4)}
   [] f(Y) then {Browse 'case'(5)}
   else {Browse 'case'(6)}
   end
end

{Test [b c a]}  % => case(4)
{Test f(b(3))}  % => case(2) -> 5
{Test f(a)}     % => case(2)				      
{Test f(a(3))}  % => case(5)
{Test f(d)}     % => case(5)
{Test [a b c]}  % => case(1)
{Test [c a d]}  % => case(4)
{Test a|a}      % => case(3) -> 1
{Test '|'(a b c)} % -> 6

% 6.
% ====

declare Test
proc {Test X}
   case X of f(a Y c) then {Browse 'case'(1)}
   else {Browse 'case'(2)} end
end

/* 1 */
declare X Y {Test f(X b Y)} % => case(2) -> block

% X は未束縛で a と等しいかどうかわからないため、ブロックされる
% 引数に与えている Y と case文中の Y は別物

/* 2 */
declare X Y {Test f(a Y d)} % => case(2)

% Y は未束縛であるが、case 文中の対応する部分には未宣言の変数が来ているので、マッチしてブロックされない

/* 3 */
declare X Y {Test f(X Y d)} % => case(2) -> block

% 1. と同様の理由でブロックされる
% 3番目の値 ( d \= c ) だけを見て Reject 可能ではあるが、1番目の値が比較可能な状態にないので、ブロックされる

declare X Y
if f(X Y d) == f(a Y c) then {Browse 'case'(1)}
else {Browse 'case'(2)} end

% ブロックされない
% 3番目の値をみて、内含しないことが判断できるから


% ### Pattern Matching の semantics
%  
% [https://mozart.github.io/mozart-v1/doc-1.4.0/tutorial/node5.html]
%  
% > Let us assume that expression E is evaluated to V. Executing the case statement will sequentially try to match V against the patterns Pattern_1, Pattern_2, ...,Pattern_n in this order. Matching V against Pattern_i is done in **left-to-right depth-first manner**.
% >  
% > - If V matches Pattern_i without binding any variable occuring in V, the corresponding Si statement is executed.
% >  
% > - If V matches Pattern_i but binds some variables occuring in V, the thread suspends
% >  
% > - If the matching of V and Pattern_i fails, V is tried against the next pattern Pattern_i+1, otherwise the else statement S is executed.



% ### Equality test の semantics

% [https://mozart.github.io/mozart-v1/doc-1.4.0/tutorial/node4.html]

% The basic procedure {Value.'==' X Y R} tries to test whether X and Y are equal or not, and returns the result in R.
% 
% - It returns the Boolean value true if the graphs starting from the nodes of X and Y have the same structure, with each pair-wise corresponding nodes having identical Oz values or are the same node.
% 
% - It returns the Boolean value false if the graphs have different structure, or some pair-wise corresponding nodes have different values.
% 
% - It suspends when it arrives at pair-wise corresponding nodes that are different, but at least one of them is unbound.
% 



% 7
% ====

declare Max3 Max5
proc {SpecialMax Value ?SMax}
   fun {SMax X}
      if X>Value then X else Value end
   end
end
{SpecialMax 3 Max3}
{SpecialMax 5 Max5}

{Browse [{Max3 4} {Max5 4}]}

%=> [4 5]

% 8
% ====

% ### (a)

declare AndThen
fun {AndThen BP1 BP2}
   if {BP1} then {BP2} else false end
end

{Browse
 {AndThen
  fun {$} {Browse a} false end
  fun {$} {Browse b} true end
 }
}

% ### (b)

declare OrElse
fun {OrElse BP1 BP2}
   if {BP1} then true else {BP2} end
end

{Browse
 {OrElse
  fun {$} {Browse a} false end
  fun {$} {Browse b} true end
 }
}

% 9
% ====

declare Sum1 Sum2
fun {Sum1 N}
   if N == 0 then 0 else N + {Sum1 N-1} end
end
fun {Sum2 N S}
   if N == 0 then S else {Sum2 N-1 N+S} end
end

% ### (a)

declare Sum1
Sum1 = proc {$ N ?R}
	  if N == 0 then
	     R = 0
	  else
	     local S in
		{Sum1 N-1 S}
		R = N + S
	     end
	  end
       end

declare Sum2
Sum2 = proc {$ N S ?R}
	  if N == 0 then
	     R = S
	  else
	     {Sum2 N-1 N+S R}
	  end
       end

% ### (b)

% #### Sum1

% <s> := if N == 0 then R = 0 else local S in {Sum1 N-1 S} R = N + S end end
%  
% ----
%  
% ({Sum1 10}, [])
%  
% (<s>, [N -> n1, R -> r])
% { n1 = 10, r }
%  
% ({Sum1 N-1 S}, [N -> n1, R -> r, S -> s1]), (R=N+S, [N -> n1, R -> r, S -> s1])
% { n1 = 10, r, s1 }
%  
% (<s>, [N -> n2, R -> s1]), (R = N + S, [N -> n1, R -> r, S -> s1])
% { n1 = 10, n2 = 9, r, s1 }
%  
% ({Sum N-1 S}, [N->n2, R->s1, S->s2]), (R=N+S, [N->n2, R->s1, S->s2]), (R=N+S, [N -> n1, R -> r, S -> s1])
% { n1 = 10, n2 = 9, r, s1, s2 }
%  
% (<s>, [N->n3, R->s2]), (R=N+S, [N->n2, R->s1, S->s2]), (R=N+S, [N -> n1, R -> r, S -> s1])
% { n1 = 10, n2 = 9, n3 = 8, r, s1, s2 }
%  
% ...
%  
% (<s>, [N->n11, R->s10]), (R=N+S, [N->n10, R->s9, S->s10]), ..., (R=N+S, [N->n1, R->r, S->s1])
% { n1=10, n2=9, ..., n11=0, r, s1, ..., s10 }
%  
% (R=0, [N->n11, R->s10]), (R=N+S, [N->n10, R->s9, S->s10]), ..., (R=N+S, [N->n1, R->r, S->s1])
% { n1=10, n2=9, ..., n11=0, r, s1, ..., s10 }
%  
% (R=N+S, [N->n10, R->s9, S->s10]), ..., (R=N+S, [N->n1, R->r, S->s1])
% { n1=10, n2=9, ..., n11=0, r, s1, ..., s10=0 }
%  
% (R=N+S, [N->n9, R->s8, S->s9]), ..., (R=N+S, [N->n1, R->r, S->s1])
% { n1=10, n2=9, ..., n11=0, r, s1, ..., s9=1, s10=0 }
%  
% (R=N+S, [N->n8, R->s7, S->s8]), ..., (R=N+S, [N->n1, R->r, S->s1])
% { n1=10, n2=9, ..., n11=0, r, s1, ..., s8=2+1, s9=1, s10=0 }
%  
% ...
%  
% (R=N+S, [N->n1, R->r, S->s1])
% { n1=10, n2=9, ..., n11=0, r, s1=(9+..+1), ..., s8=2+1, s9=1, s10=0 }
%  
% ()
% { n1=10, n2=9, ..., n11=0, r=(10+9+..+1), s1=(9+..+1), ..., s8=2+1, s9=1, s10=0 }
%  
%  
% max stack size: 12
% max store size: 21

% #### Max2

% fun {$ N S ?R}
%    if N == 0 then R = S else {Sum2 N-1 N+S R} end % =: <s>
% end
%  
% ({Sum2 10 0 R}, [R -> r])
% { r }
%  
% (<s>, [N->n0, S->s0, R->r])
% { r, n0=10, s0=0 }
%  
% ({Sum2 N-1 N+S R}, [N->n0, S->s0, R->r])
% { r, n0=10, s0=0 }
%  
% (<s>, [N->n1, S->s1, R->r])
% { r, n0=10, s0=0, n1=9, s1=n0+s0=10 }
%  
% ({Sum2 N-1 N+S R}, [N->n1, S->s1, R->r])
% { r, n0=10, s0=0, n1=9, s1=n0+s0=10 }
%  
% (<s>, [N->n2, S->s2, R->r])
% { r, n0=10, s0=0, n1=9, s1=n0+s0=10, n2=8, s2=n1+s1=19 }
%  
% ...
%  
% (<s>, [N->n10, S->s10, R->r])
% { r, n0=10, s0=0, n1=9, s1=n0+s0=10, ..., n10=0, s10=n9+s9=10+..+1 }
%  
% (R = S, [N->n10, S->s10, R->r])
% { r, n0=10, s0=0, n1=9, s1=n0+s0=10, ..., n10=0, s10=n9+s9=10+..+1 }
%  
% ()
% { r=10+..+1, n0=10, s0=0, n1=9, s1=n0+s0=10, ..., n10=0, s10=n9+s9=10+..+1 }
%  
% max stack size = 1
% max store size = 3 (Stack から参照がないものは除外した)

% ## (c)

declare Sum1 Sum2
fun {Sum1 N}
   if N == 0 then 0 else N + {Sum1 N-1} end
end
fun {Sum2 N S}
   if N == 0 then S else {Sum2 N-1 N+S} end
end

{Browse {Sum1 100000000}}
{Browse {Sum2 100000000 0}}


% 10
% ====

declare SMerge
fun {SMerge Xs Ys}
   case Xs#Ys
   of nil#Ys then Ys
   [] Xs#nil then Xs
   [] (X|Xr)#(Y|Yr) then
      if X =< Y then X|{SMerge Xr Ys}
      else Y|{SMerge Xs Yr} end
   end
end

{Browse {SMerge [1 3 9 10] [2 4 5 7 8]}}

% ----

declare SMerge
SMerge = proc {$ Xs Ys ?R}
	    case Xs of nil then Ys
	    else
	       case Ys of nil then Xs
	       else
		  case Xs of (X|Xr) then
		     case Ys of (Y|Yr) then
			local B in
			   B = X =< Y
			   if B then
			      local S in
				 R = X|S
				 {SMerge Xr Ys S}
			      end
			   else
			      local S in
				 R = Y|S
				 {SMerge Xs Yr S}
			      end
			   end
			end
		     end
		  end
	       end
	    end
	 end

% 11. 相互再帰
% ====

% declare IsEvent IsOdd
% fun {IsEven X} 
%    if X == 0 then true else {IsOdd X-1} end
% end
% fun {IsOdd X}
%    if X == 0 then false else {IsEvent X-1} end
% end
%  
% ({IsEven n}, [])
% {}
%  
% (if X == 0 then true else {IsOdd X-1} end, [X->n])
% {}
%  
% ({IsOdd X-1}, [X->n])
% {}
%  
% (if X == 0 then false else {IsEven X-1} end, [X->n-1])
% {}
%  
% ({IsEven X-1}, [X->n-1])
% {}
%  
% {IsEven n-2} の呼び出しに必要なスタックのサイズがM以下であるとすると、{IsEvent n} の呼び出しに必要なスタックのサイズもM以下であることが分かる。
%  
% したがって、{IsEven n} は一定のスタックの大きさで実行できることが分かる。

% 12. finally 節を持つ例外
% ====

try <s1> finally <s2> end

% =>

local B E in
   try
      B = false
      <s1>
   catch X then
      B = true
      E = X
   end
   <s2>
   if B then raise E end end
end

% 13. 単一化.
% ====

X = [a Z]
% [Z->z, X->x] | {z, x=[a z]} 
Y = [W b]
% [Z->z, X->x, W->w, Y->y] | {z, x=['a' z], w, y=[w 'b']} 
X = Y
% [Z->z, X->x, W->w, Y->y] | {z='b', x=['a' z='b'], w='a', y=[w='a' 'b']} 

% ----

X = [a Z]
% [Z->z, X->x] | {z, x = ['a' z]} 
X = Y
% [Z->z, X->x, Y->y] | {z, x=['a' z], y=x=['a' z]} 
Y = [W b]
% [Z->z, X->x, W->w, Y->y] | {z='b', x=['a' z='b'], y=x=[w='a' z='b']}

% ----

% 略

% X = [a Z] and Y = [W b] and X = Y
%  
% <=>
%  
% X = [a b] and Y = [a b] and W = a and Z = b
