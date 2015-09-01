% 7.6

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

declare
fun {CheckConflict B Ss}
   Counts = {NewDictionary}
   DupKeys
in
   for S in Ss do
      for X in S do
	 {Dictionary.put Counts X {Dictionary.condGet Counts X 0}+1}
      end
   end

   DupKeys = {Map
	      {Filter {Dictionary.entries Counts} fun {$ X} K#V=X in V>1 end}
	      fun {$ X} K#V=X in K end}
	      
   {Minus DupKeys B}
end

declare
fun {From BaseClass SuperClasses}
   c(methods:M attrs:A)={Unwrap BaseClass}
   MA={Arity M}

   Ms={Map SuperClasses fun {$ C} c(methods:M attrs:A)={Unwrap C} in M end}
   As={Map SuperClasses fun {$ C} c(methods:M attrs:A)={Unwrap C} in A end}
   MAs={Map SuperClasses fun {$ C} c(methods:M attrs:A)={Unwrap C} in {Arity M} end}

   ConfMeth={CheckConflict MA MAs}
   ConfAttr={CheckConflict A As}
in
   if ConfMeth\=nil then
      raise illegalInheritance(methConf:ConfMeth) end
   end
   if ConfAttr\=nil then
      raise illegalInheritance(attrConf:ConfAttr) end
   end
   {Wrap c(methods:{Adjoin {FoldL Ms Adjoin m()} M}
	   attrs:{Union {FoldL As Union nil} A})}
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
proc {Super ParentClass M State Obj}
   {ParentClass.methods.{Label M} M State Obj}
end

%==============

declare Counter
local
   Attrs = [val]
   MethodTable = m(browse:MyBrowse init:Init inc:Inc)
   proc {Init M S Self}
      {Browse 'counter initialized'}
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

declare ReverseCounter
local
   Attrs = [val]
   MethodTable = m(browse:MyBrowse init:Init dec:Dec)
   proc {Init M S Self}
      {Browse 'reverse_counter initialized'}
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

% class DeCounter from Counter ReverseCounter
%    meth init
%       Counter,init
%    end
% end

declare DeCounter
local
   Attrs = [val]
   MethodTable = m(browse:MyBrowse init:Init)
   proc {Init M S Self}
      {Super Counter M S Self}  %<- {Counter,M M}
   end
   proc {MyBrowse M S Self}
      browse=M
      {Browse @(S.val)}
   end
in
   try
      DeCounter = {From {Wrap c(methods:MethodTable attrs: Attrs)}
		   [Counter ReverseCounter]}
   catch E then {Browse E} end
end

declare
DC = {New DeCounter init(0)}
{DC inc(10)}
{DC dec(5)}
{DC browse}
