% 3.

declare Solve
fun {Solve F A B GoodEnough}
   fun {SolveIter X Y}
      Z = (X + Y) / 2. % Improve
      V = {F Z}
   in
      if V == 0. then
	 Z
      elseif V > 0. then
	 {Check X Z}
      elseif V < 0. then
	 {Check Z Y}
      end
   end
   fun {Check X Y}
      if Y - X < GoodEnough then
	 (X + Y) / 2.
      else
	 {SolveIter X Y}
      end
   end
in
   if {F A} =< 0. andthen {F B} >= 0. then
      {SolveIter A B}
   elseif {F A} >= 0. andthen {F B} =< 0. then
      {SolveIter B A}
   else
      raise argumentError end
   end
end

declare F
fun {F X} {Pow X 2.} - 1. end
{Browse {Solve F ~2. 0. 0.001}}
{Browse {Solve F 0. 1.5 0.01}}

% 4

declare Fact Fact2
proc {Fact N ?R}
   if N == 0 then R = 1
   elseif N > 0 then N1 R1 in
      N1 = N - 1
      {Fact N1 R1}
      R = N * N * R1
   else raise domainError end
   end
end
proc {Fact2 N ?R}
   proc {FactIter N A}
      if N == 0 then R = A
      elseif N > 0 then N1 A1 in
	 N1 = N - 1
	 A1 = N * A
	 {FactIter N1 A1}
      end
   end
in
   {FactIter N 1}
end

local R in
   {Fact2 5 R}
   {Browse R}
end


% 5

declare SumList
fun {SumList Xs}
   case Xs
   of nil then 0
   [] X|Xr then X + {SumList Xr}
   end
end

%
% 状態 ((X1 + ... + Xr), [X(r+1), .., Xn]) の列として考える
%
declare SumListIter
fun {SumListIter S Ys}
   case Ys
   of nil then S
   [] Y|Yr then {SumListIter S+Y Yr}
   end
end
{Browse {SumListIter 0 [3 1 4]}}


% 6

% S = (Rs, Ys)
% P((Rs, Ys)) = [[ Xs = reverse(Rs) . Ys ]]

% 7

declare Append
fun {Append Ls Ms}
   case Ms
   of nil then Ls
   [] X|Mr then {Append {Append Ls [X]} Mr}
   end
end

% 終了しない
% {Append Ls [X]} の呼び出しがループしてしまう

% 8

declare Reverse Append
fun {Reverse Xs}
   fun {IterReverse Rs Ys}
      case Ys
      of nil then Rs
      [] Y|Yr then {IterReverse Y|Rs Yr}
      end
   end
in
   {IterReverse nil Xs}
end
fun {Append Xs Ys}
   fun {ReverseAppend Xs Ys}
      case Xs
      of nil then Ys
      [] X|Xr then {ReverseAppend Xr X|Ys}
      end
   end
in
   {ReverseAppend {Reverse Xs} Ys}
end

{Browse {Append [1 2 3] [4 5 6]}}

% 9

% 上に示した Append がデータフロー変数を使わない反復的Appendではないのか？



fun {Merge Xs Ys}
   case Xs # Ys then Ys
      