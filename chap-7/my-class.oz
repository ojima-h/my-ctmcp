% 7.6

declare
class Counter
   attr val
   meth init(Value)
      val:=Value
   end
   meth inc(Value)
      val:=@val+Value
   end
   meth browse
      {Browse @val}
   end
end

declare
C={New Counter init(1)}
{C inc(3)}
{C browse}

%%%

declare Wrap Unwrap
% local
%    Key={NewName}
% in
%    fun {Wrap X}
%       {Chunk.new w(Key:X)}
%    end
%    fun {Unwrap W}
%       try W.Key catch _ then raise error(unwrap(W)) end end
%    end
% end
fun {Wrap X} X end
fun {Unwrap X} X end

declare Counter
local
   Attrs = [val]
   MethodTable = m(browse:MyBrowse init:Init inc:Inc)
   proc {Init M S Self}
      init(Value)=M
   in
      (S.val):=Value
   end
   proc {Inc M S Self}
      X
      inc(Value)=M
   in
      X=@(S.val) (S.val):=X+Value
   end
   proc {MyBrowse M S Self}
      browse=M
      {Browse @(S.val)}
   end
in
   Counter = {Wrap c(methods:MethodTable attrs: Attrs)}
end

declare
fun {New WClass InitialMethod}
   State Obj Class={Unwrap WClass}
in
   State={MakeRecord s Class.attrs}
   {Record.forAll State proc {$ A} {NewCell _ A} end}
   proc {Obj M}
      {Class.methods.{Label M} M State Obj}
   end
   {Obj InitialMethod}
   Obj
end

declare
C={New Counter init(1)}
{C inc(3)}
{C browse}

% 7.6.4

declare
fun {Union S1 S2}
   R1={MakeRecord s S1}
   R2={MakeRecord s S2}
in
   {Arity {Adjoin R1 R2}}
end

declare
fun {Minus S1 S2}
   R={MakeRecord s S1}
in
   {Arity {Record.subtractList R S2}}
end

declare
fun {Inter S1 S2}
   {Minus {Union S1 S2}
    {Union {Minus S1 S2} {Minus S2 S1}}}
end

{Browse {Inter [a b c] [c b f]}}

declare
fun {From C1 C2 C3}
   c(methods:M1 attrs:A1)={Unwrap C1}
   c(methods:M2 attrs:A2)={Unwrap C2}
   c(methods:M3 attrs:A3)={Unwrap C3}
   MA1={Arity M1}
   MA2={Arity M2}
   MA3={Arity M3}
   ConfMeth={Minus {Inter MA2 MA3} MA1}
   ConfAttr={Minus {Inter A2 A3} A1}
in
   if ConfMeth\=nil then
      raise illegalInheritance(methConf:ConfMeth) end
   end
   if ConfAttr\=nil then
      raise illegalInheritance(attrConf:ConfAttr) end
   end
   {Wrap c(methods:{Adjoin {Adjoin M2 M3} M1}
	   attrs:{Union {Union A2 A3} A1})}
end

declare ReverseCounter
local
   Attrs = [val]
   MethodTable = m(browse:MyBrowse init:Init dec:Dec)
   proc {Init M S Self}
      init(Value)=M
   in
      (S.val):=Value
   end
   proc {Dec M S Self}
      X
      dec(Value)=M
   in
      X=@(S.val) (S.val):=X-Value
   end
   proc {MyBrowse M S Self}
      browse=M
      {Browse @(S.val)}
   end
in
   ReverseCounter = {Wrap c(methods:MethodTable attrs: Attrs)}
end

declare DeCounter
local
   Attrs = [val]
   MethodTable = m(browse:MyBrowse init:Init)
   proc {Init M S Self}
      init(Value)=M
   in
      (S.val):=Value
   end
   proc {MyBrowse M S Self}
      browse=M
      {Browse @(S.val)}
   end
in
   DeCounter = {From
		{Wrap c(methods:MethodTable attrs: Attrs)}
		Counter ReverseCounter}
end

declare
DC = {New DeCounter init(0)}
{DC inc(10)}
{DC dec(5)}
{DC browse}
