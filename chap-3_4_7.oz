% Reverse
declare
fun {Reverse Xs}
   proc {ReverseD Xs ?Y1 Y}
      case Xs
      of nil then Y1 = Y
      [] X|Xr then {ReverseD Xr Y1 X|Y}
      end
   end Y1
in {ReverseD Xs Y1 nil} Y1 end

% 3.4.5

declare
proc {ButLast L ?X ?L1}
   case L
   of [Y] then X = Y L1 = nil
   [] Y|L2 then L3 in
      L1 = Y|L3
      {ButLast L2 X L3}
   end
end

local L = [1 2 3]
   L2 = 0 | L
   X L3 in
   {ButLast L2 X L3}
   {Browse L2}
   {Browse X}
   {Browse L3}
end

%% 償却的一定時間キュー

declare
fun {NewQueue} q(nil nil) end

fun {Check Q}
   case Q of q(nil R) then q({Reverse R} nil) else Q end
end

fun {Insert Q X}
   case Q of q(F R) then {Check q(F X|R)} end
end

fun {Delete Q ?X}
   case Q of q(F R) then F1 in F=X|F1 {Check q(F1 R)} end
end

fun {IsEmpty Q}
   case Q of q(F R) then F == nil end
end

local Q = {Insert {Insert {Insert {NewQueue} 1} 2} 3} in
   {Browse Q}
   local X Q1 = {Delete Q X} in
      {Browse X}
      {Browse Q1}
   end
end

% 最悪時一定時間キュー

declare
fun {NewQueue} X in q(0 X X) end
fun {Insert Q X}
   case Q of q(N S E) then E1 in E=X|E1 q(N+1 S E1) end
end
fun {Delete Q X}
   case Q of q(N S E) then S1 in S = X|S1 q(N-1 S1 E) end
end
fun {IsEmpty Q}
   case Q of q(N S E) then N == 0 end
end
local Q1 Q2 Q3 Q4 Q5 Q6 Q7 in
   Q1={NewQueue}
   Q2={Insert Q1 peter}
   Q3={Insert Q2 paul}
   local X in Q4={Delete Q3 X} {Browse X} end
   local X in Q5={Delete Q4 X} {Browse X} end
   local X in Q6={Delete Q5 X} {Browse X} end
   Q7={Insert Q6 mary}
end


%
% 3.4.6
%

% 木
%
%   <OBTree> ::= leaf
%              | tree(<OValue> <Value> <OBTree> <OBTree>)
declare
fun {Lookup X T}
   case T
   of leaf then notfound
   [] tree(Y V T1 T2) andthen X == Y then found(V)
   [] tree(Y V T1 T2) andthen X < Y then {Lookup X T1}
   [] tree(Y V T1 T2) andthen X > Y then {Lookup X T2}
   end
end

fun {Insert X V T}
   case T
   of leaf then tree(X V leaf leaf)
   [] tree(Y W T1 T2) andthen X==Y then tree(X V T1 T2)
   [] tree(Y W T1 T2) andthen X<Y then tree(Y W {Insert X V T1} T2)
   [] tree(Y W T1 T2) andthen X>Y then tree(Y W T1 {Insert X V T2})
   end
end   

fun {Delete X T}
   case T
   of leaf then none
   [] tree(Y W T1 T2) andthen X==Y then
      case {RemoveSmallest T2}
      of none then T1
      [] Yp#Vp#Tp then tree(Yp Vp T1 Tp)
      end
   [] tree(Y W T1 T2) andthen X<Y then tree(Y W {Delete X T1} T2)
   [] tree(Y W T1 T2) andthen X>Y then tree(Y W T1 {Delete X T2})
   end
end   
fun {RemoveSmallest T}
   case T
   of leaf then none
   [] tree(Y V T1 T2) then
      case {RemoveSmallest T1}
      of none then Y#V#T2
      [] Yp#Vp#Tp then Yp#Vp#tree(Y V Tp T2)
      end
   end
end

local T0 T1 T2 in
   T0=leaf
   T1={Insert c 3 {Insert b 2 {Insert a 1 T0}}}
   {Browse {Lookup b T1}}
   T2={Delete b T1}
   {Browse T2}
end

% 3.4.6.4

declare
proc {DFSAccLoop T ?S1 Sn}
   case T
   of leaf then S1=Sn
   [] tree(Key Val L R) then S2 S3 in
      S1 = Key#Val|S2
      {DFSAccLoop L S2 S3}
      {DFSAccLoop R S3 Sn}
   end
end
fun {DFSAcc T} {DFSAccLoop T $ nil} end

fun {BFSAcc T}
   fun {TreeInsert Q T}
      if T\=leaf then {Insert Q T} else Q end
   end
   proc {BFSQueue Q1 ?S1 Sn}
      if {IsEmpty Q1} then S1=Sn
      else X Q2 Key Val L R S2 in
	 Q2={Delete Q1 X}
	 tree(Key Val L R)=X
	 S1=Key#Val|S2
	 {BFSQueue {TreeInsert {TreeInsert Q2 L} R} S2 Sn}
      end
   end
in
   {BFSQueue {TreeInsert {NewQueue} T} $ nil}
end
	 
fun {DFSAcc2 T}
   fun {TreeInsert S T}
      if T\=leaf then T|S else S end
   end
   proc {DFSStack St ?S1 Sn}
      case St
      of nil then S1=Sn
      [] X|St2 then Key Val L R S2 in
	 tree(Key Val L R)=X
	 S1=Key#Val|S2
	 {DFSStack {TreeInsert {TreeInsert St2 L} R} S2 Sn}
      end
   end
in
   {DFSStack {TreeInsert nil T} $ nil}
end

local T in
   T=tree(a 1 tree(b 2 tree(c 3 leaf leaf) leaf) tree(d 4 leaf leaf))
   {Browse {DFSAcc T}}
   {Browse {BFSAcc T}}
end
