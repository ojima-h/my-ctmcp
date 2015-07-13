declare
fun {NewExtensibleArray L H Init}
   A={NewCell {NewArray L H Init}}
   proc {CheckOverflow I}
      Arr=@A
      Low={Array.low Arr}
      High={Array.high Arr}
   in
      if I>High then
	 High2=Low+{Max I 2*(High-Low)}
	 Arr2={NewArray Low High2 Init}
      in
	 for K in Low..High do Arr2.K:=Arr.K end
	 A:=Arr2
      end
   end
   proc {Put I X}
      {CheckOverflow I}
      @A.I:=X
   end
   fun {Get I}
      {CheckOverflow I}
      @A.I
   end
in extArray(get:Get put:Put)
end

Arr = {NewExtensibleArray 3 5 10}
{Browse {Arr.get 4}}
{Arr.put 4 20}
{Browse {Arr.get 4}}
{Browse {Arr.get 7}}
{Arr.put 7 30}
{Browse {Arr.get 7}}


% Q.7

% proc {Revocable Obj ?R ?RObj}
%    C={NewCell Obj}
% in
%    proc {R}
%       C:=proc {$ M} raise revokedError end end
%    end
%    proc {RObj M}
%       {@C M}
%    end
% end

declare
fun {Revocable Obj}
   C={NewCell Obj}
   proc {R Mr}
      C:=proc {$ M} raise revokedError end end
   end
   proc {RObj M}
      {@C M}
   end
in
   revocable(obj:RObj revoke:R)
end

fun {NewCollector}
   Lst={NewCell nil}
in
   proc {$ M}
      case M
      of add(X) then T in {Exchange Lst T X|T}
      [] get(L) then L={Reverse @Lst}
      end
   end
end
declare C R in
C = {Revocable {NewCollector}}
{C.obj add(1)}
{C.obj add(2)}
{C.obj add(2)}
{Browse {C.obj get($)}}
{C.revoke revoke}
{Browse {C.revoke get}}
RR = {Revocable C.revoke}

% Q.8

declare
proc {Collect C X}
   H T in
   {Exchange C H|(X|T) H|T}
end
fun {NewCollector}
   T in
   {NewCell T|T}
end
fun {EndCollect C}
   H|nil = @C in
   H
end
local C = {NewCollector} in
   {Collect C 1}
   {Collect C 2}
   {Collect C 3}
   {Browse {EndCollect C}}
end

%%%%%

declare
proc {Collect C X}
   T in
   {Exchange C.2 X|T T}
end
fun {NewCollector}
   T in
   T|{NewCell T}
end
fun {EndCollect C}
   @(C.2)=nil
   C.1
end
local C = {NewCollector} in
   {Collect C 1}
   {Collect C 2}
   {Collect C 3}
   {Browse {EndCollect C}}
end


% 一番目の実装の方が瞬間的により多くのメモリを消費する(5 vs 2)
% しかし、Collector が占めるメモリ量はどちらの実装でも同じである
% したがって、一番目の実装のほうがより多くのメモリの確保と開放を繰り返すため、
% GCへの負担が大きいと考えられる