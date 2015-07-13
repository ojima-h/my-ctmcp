declare
fun {Generate N Limit}
   if N < Limit then
      N|{Generate N+1 Limit}
   else nil end
end

fun {Sum Xs A}
   case Xs
   of X|Xr then {Sum Xr A+X}
   [] nil then A
   end
end

local Xs S in
   thread S={Sum Xs 0} end
   thread Xs={Generate 0 15000} end
   {Browse S}
end      

local Xs S1 S2 in
   thread Xs={Generate 0 15000} end
   thread S1={Sum Xs 0} end
   thread S2={FoldL Xs fun {$ X Y} X+Y end 0} end
   {Browse S1}
   {Browse S2}
end

local Xs Ys S in
   thread Xs={Generate 0 15000} end
   thread Ys={Filter Xs IsOdd} end
   thread S={Sum Ys 0} end
   {Browse S}
end

declare
fun {Sieve Xs}
   case Xs
   of nil then nil
   [] X|Xr then Ys in
      thread Ys={Filter Xr fun {$ Y} Y mod X \= 0 end} end
      X|{Sieve Ys}
   end
end
local Xs Ys in
   thread Xs={Generate 2 10000} end
   thread Ys={Sieve Xs} end
   {Browse Ys}
end

declare
fun {Sieve Xs M}
   case Xs
   of nil then nil
   [] X|Xr then Ys in
      if X=<M then
	 thread Ys={Filter Xr fun {$ Y} Y mod X \= 0 end} end
      else Ys=Xr end
      X|{Sieve Ys M}
   end
end
local Xs Ys in
   thread Xs={Generate 2 10000} end
   thread Ys={Sieve Xs 316} end
   {Browse Ys}
end

%%%%%

declare
proc {DGenerate N Xs}
   case Xs of X|Xr then
      X=N
      {DGenerate N+1 Xr}
   end
end   

fun {DSum ?Xs A Limit}
   if Limit>0 then
      X|Xr=Xs
   in
      {DSum Xr A+X Limit-1}
   else A end
end

local Xs S in
   thread {DGenerate 0 Xs} end
   thread S={DSum Xs 0 150000} end
   {Browse S}
end

declare
proc {Buffer N ?Xs ?Ys}
   fun {Startup N ?Xs}
      if N==0 then Xs
      else Xr in Xs=_|Xr {Startup N-1 Xr} end
   end

   proc {AskLoop Ys ?Xs ?End}
      case Ys of Y|Yr then Xr End2 in
	 Xs=Y|Xr
	 End=_|End2
	 {AskLoop Yr Xr End2}
      end
   end
   End={Startup N Xs}
in
   {AskLoop Ys Xs End}
end
proc {DGenerateSlow N Xs}
   case Xs of X|Xr then
      {Delay 1000}
      X=N
      {DGenerateSlow N+1 Xr}
   end
end   
fun {DSumSlow ?Xs A Limit}
   if Limit>0 then
      X|Xr=Xs
   in
      {Delay 1000}
      {DSumSlow Xr A+X Limit-1}
   else A end
end
local Xs Ys S in
   {Browse Xs} {Browse Ys}
   {Browse S}
   thread {DGenerateSlow 0 Xs} end
   thread {Buffer 4 Xs Ys} end
   {Delay 4000}
   thread S={DSumSlow Ys 0 15} end
end

{Property.put priorities p(high:10 medium:10)}
local Xs S in
   thread
      {Thread.setThisPriority low}
      Xs={Generate 0 150000}
   end
   thread
      {Thread.setThisPriority high}
      S={Sum Xs 0}
   end
   {Browse S}
end

%%%%%

declare
proc {StreamObject S1 X1 ?T1}
   case S1
   of M|S2 then N X2 T2 in
      {NextState M X1 N X2}
      T1=N|T2
      {StreamObject S2 X2 T2}
   [] nil then T1=nil end
end

declare
local
   fun {NotLoop Xs}
      case Xs of X|Xr then (1-X)|{NotLoop Xr} end
   end
in
   fun {NotG Xs}
      thread {NotLoop Xs} end
   end
end

fun {GateMaker F}
   fun {$ Xs Ys}
      fun {GateLoop Xs Ys}
	 case Xs#Ys of (X|Xr)#(Y|Yr) then
	    {F X Y}|{GateLoop Xr Yr}
	 end
      end
   in
      thread {GateLoop Xs Ys} end
   end
end
AndG = {GateMaker fun {$ X Y} X*Y end}
OrG = {GateMaker fun {$ X Y} X+Y-X*Y end}
NandG = {GateMaker fun {$ X Y} 1-X*Y end}
NorG = {GateMaker fun {$ X Y} 1-X-Y+X*Y end}
XorG = {GateMaker fun {$ X Y} X+Y-2*X*Y end}

proc {FullAdder X Y Z ?C ?S}
   K L M
in
   K={AndG X Y}
   L={AndG Y Z}
   M={AndG X Z}
   C={OrG K {OrG L M}}
   S={XorG Z {XorG X Y}}
end

local
   X=1|1|0|_
   Y=0|1|0|_
   Z=1|1|1|_ C S in
   {FullAdder X Y Z C S}
   {Browse inp(X Y Z)#sum(C S)}
end

declare
fun {DelayG Xs}
   0|Xs
end

declare
fun {Latch C DI}
   DO X Y Z F
in
   F={DelayG DO}
   X={AndG F C}
   Z={NotG C}
   Y={AndG Z DI}
   DO={OrG X Y}
   DO
end
local
   DI=1|1|1|1|0|0|0|0|_
   %C=1|1|0|1|1|1|0|1|_
   C=0|0|0|0|0|1|0|1|_
   DO={Latch C DI}
in
   {Browse r('in':DI c:C 'out':DO)}
end


fun {Clock}
   fun {Loop B}
      if Limit > 0
	 {Delay 1000} B|{Loop B}
      end
   end
in
   thread {Loop 1} end
end
