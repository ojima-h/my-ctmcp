%
% 1 (a)
%
declare
V0 = 2				% 2 ^ 1
V1 = V0 * V0			% 2 ^ 2
V2 = V1 * V1			% 2 ^ 4
V3 = V2 * V2			% 2 ^ 8
V4 = V3 * V3			% 2 ^ 16
V5 = V4 * V4			% 2 ^ 32
V6 = V5 * V5			% 2 ^ 64
V = V6 * V5 * V2		% 2 ^ (64 + 32 + 4) = 2 ^ 100
{Browse V}
% {Browse {Pow 2 100}}		

%
% 1 (b)
%
% 無理

%
% 2 (a)
%
declare
fun {PartFact A B}
   if A < B then
      1
   else
      B * {PartFact A (B + 1)}
   end
end
fun {Comb N K}
   {PartFact N (N - K + 1)} div {PartFact K 1}
end
{Browse {Comb 10 3}}
% {Browse (10 * 9 * 8) div (3 * 2 * 1)

%
% 2 (b)
%
declare
fun {CombFast N K}
   if K < N div 2 then
      {PartFact N (N - K + 1)} div {PartFact K 1}
   else
      {PartFact N (K + 1)} div {PartFact (N - K) 1}
   end
end
{Browse {CombFast 10 3}}

%
% 3
%

% # Base
% {Pascal 1} は正しい答え、すなわち [1] を返す

% # Step
% {Pascal N-1} が正しい答えを返すと仮定する。

% A = 0|{Pascal N-1}
% B = {Pascal N-1}|0
% とおく

% このとき {AddList A B} はリストを返し、そのi番目の要素は A のi番目の要素と B のi番目の要素の和になる。
% (証明略)
% A のi番目の要素は {Pascal N-1} の(i-1)番目の要素に等しく、B のi番目の要素は {Pascal N-1} のi番目の要素に等しい。
% (ただし、A の第1要素と B の第N要素は 0 となる)
% したがって、
% - {AddList A B} のi番目の要素 = {Pascal N-1} の(i-1)番目の要素 + {Pascal N-1} のi番目の要素
% - {AddList A B} の1番目の要素 = {Pascal N-1} の0番目の要素
% - {AddList A B} のN番目の要素 = {Pascal N-1} のN番目の要素
% が成り立つ
% 仮定より、{Pascal N-1} はパスカルの三角形の第(N-1)列を返すので、{AddList A B} はパスカルの三角形の第N列に等しい。

% 以上より、{Pascal N} は正しい答えを返す。

%
% 4
%

% 本文の中では、時間計算量が高次の多項式になるようなプログラムの実用性については特に触れられていない。

% そのようなプログラムは、応答性が重要でないような場面では十分実用的ではないかと思う。

%
% 5
%
declare
fun lazy {Ints N}
   N | {Ints N+1}
end
fun {SumList L}
   case L of X|L1 then X + {SumList L1}
   else 0 end
end
% {Browse {SumList {Ints 0}}} % <- 実行してはいけない。おちる。

declare
fun lazy {Ints N}
   N | {Ints N+1}
end
fun lazy {AddList L1 L2}
   case L1 of X|M1 then
      case L2 of Y|M2 then
	 (X+Y)|{AddList M1 M2}
      else nil end
   else nil end
end
fun lazy {SumList L}
   case L of X|L1 then
      X|{AddList L1 {SumList L}}
   else nil end
end
{Browse {SumList {Ints 0}}.2.2.2.1}

%
% 6 (a) (b)
%
declare
fun {GenericPascal Op N}
   if N == 1 then [1]
   else L in
      L = {GenericPascal Op N-1}
      {OpList Op {ShiftLeft L} {ShiftRight L}}
   end
end
fun {OpList Op L1 L2}
   case L1 of H1|T1 then
      case L2 of H2|T2 then
	 {Op H1 H2} | {OpList Op T1 T2}
      end
   else nil end
end
fun {ShiftLeft L}
   case L of H|T then
      H|{ShiftLeft T}
   else [0] end
end
fun {ShiftRight L} 0|L end
proc {BrowsePascal Op}
   for I in 1..10 do {Browse {GenericPascal Op I}} end
end

{BrowsePascal Number.'+'}
{BrowsePascal Number.'-'}
{BrowsePascal Number.'*'}

declare
fun {Mull X Y} (X+1)*(Y+1) end
{BrowsePascal Mull}


%
% 7
%
local X in
   X = 23
   local X in
      X = 44
   end
   {Browse X}
end
% => 23

local X in
   X = {NewCell 23}
   X := 44
   {Browse @X}
end
% => 44

%
% 8
%
declare
fun {AccumulateWrong N}
   Acc in
   Acc = {NewCell 0}
   Acc := @Acc + N
   @Acc
end
{Browse {AccumulateWrong 5}}
{Browse {AccumulateWrong 100}}
{Browse {AccumulateWrong 45}}

declare Accumulate
local Acc in
   Acc = {NewCell 0}
   fun {Accumulate N}
      Acc := @Acc + N
      @Acc
   end
end
{Browse {Accumulate 5}}
{Browse {Accumulate 100}}
{Browse {Accumulate 45}}

%
% 9 (a)
%
declare
S = {NewStore}
{Put S 0 [22 33]}
{Browse {Get S 0}}
{Browse {Size S}}

%
% 9 (b)
%
declare FasterPascal
local S in
   S = {NewStore}
   fun {FasterPascal N}
      if N < {Size S} then
	 {Get S N}
      else
	 if N == 1 then
	    {Put S 1 [1]}
	 else L in
	    L = {FasterPascal N-1}
	    {Put S N {OpList Number.'+' {ShiftLeft L} {ShiftRight L}}}
	 end
	 {Get S N}
      end
   end
end
fun {OpList Op L1 L2}
   case L1 of H1|T1 then
      case L2 of H2|T2 then
	 {Op H1 H2} | {OpList Op T1 T2}
      end
   else nil end
end
fun {ShiftLeft L}
   case L of H|T then
      H|{ShiftLeft T}
   else [0] end
end
fun {ShiftRight L} 0|L end
{Browse {FasterPascal 10}}

%
% 9 (c)
%
declare
fun {NewStore}
   S = {NewCell nil}

   fun {GetIter K L}
      case L of H|T then
	 case H of N|X then
	    if N == K then X else {GetIter K T} end
	 else {GetIter K T} end
      else nil end
   end
   fun {Get K}
      V = {GetIter K @S} in
      if V == nil then nil else @V end
   end
   proc {Put K X}
      V = {GetIter K @S} in
      if V == nil then
	 S := (K|{NewCell X}) | @S
      else
	 V := X
      end
   end
   fun {Size} {Length @S} end
in
   store(get:Get put:Put size:Size)
end
fun {Get S K} {S.get K} end
proc {Put S K X} {S.put K X} end
fun {Size S} {S.size} end

S = {NewStore}
{Put S 0 [22 33]}
{Browse {Get S 0}}
{Browse {Size S}}
{Put S 0 10}
{Browse {Get S 0}}
{Put S 2 100}
{Browse {Size S}}

declare
fun {NewCounter}
   C Bump Read in
   C = {NewCell 0}
   proc {Bump}
      C:=@C+1
   end
   fun {Read}
      @C
   end
   counter(bump:Bump read:Read)
end
fun {NewStore}
   S C GetIter Get Put Size in
   S = {NewCell nil}
   C = {NewCounter}

   fun {GetIter K L}
      case L of H|T then
	 case H of N|X then
	    if N == K then X else {GetIter K T} end
	 else {GetIter K T} end
      else nil end
   end
   fun {Get K}
      V = {GetIter K @S} in
      if V == nil then nil else @V end
   end
   proc {Put K X}
      V = {GetIter K @S} in
      if V == nil then
	 S := (K|{NewCell X}) | @S
	 {C.bump}
      else
	 V := X
      end
   end
   fun {Size} {C.read} end
   store(get:Get put:Put size:Size)
end
fun {Get S K} {S.get K} end
proc {Put S K X} {S.put K X} end
fun {Size S} {S.size} end

S = {NewStore} in
{Put S 0 [22 33]}
{Browse {Get S 0}}
{Browse {Size S}}
{Put S 0 10}
{Browse {Get S 0}}
{Put S 2 100}
{Browse {Size S}}


%
% 10 (a)(b)
%
declare
C = {NewCell 0}
thread I in
   I = @C
   {Delay 10}
   C := I+1
end
thread J in
   J = @C
   {Delay 10}
   C := J+1
end
{Delay 1000}
{Browse @C}

%
% 10 (c)
%
declare
C = {NewCell 0}
L = {NewLock}
thread
   lock L then I in
      I = @C
      {Delay 10}
      C := I + 1
   end
end
thread
   lock L then J in
      J = @C
      {Delay 200}
      C := J + 1
   end
end
{Delay 100}
{Browse @C}
