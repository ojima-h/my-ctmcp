%
% 10
%
local
   fun lazy {Three} {Delay 3000} 3 end
in
   {Browse {Three}+0}
   {Browse {Three}+0}
   {Browse {Three}+0}
end

%=>

local
   proc {Three ?X}
      thread {Delay 3000} X=3 end
   end
in
   {Browse {Three $}+0}
   {Browse {Three $}+0}
   {Browse {Three $}+0}
end


%
% 11
%
declare
fun lazy {MakeX} {Browse x} {Delay 3000} 1 end
fun lazy {MakeY} {Browse y} {Delay 6000} 2 end
fun lazy {MakeZ} {Browse z} {Delay 9000} 3 end

X={MakeX}
Y={MakeY}
Z={MakeZ}

{Browse (X+Y)+Z}
%{Browse thread X+Y end + Z}
%{Browse Z + thread X+Y end}


%
% 12
%
declare
proc {Generate N Xs}
   case Xs of X|Xr then
      {Delay 1000}
      X=N
      {Generate N+1 Xr}
   end
end

fun {Sum ?Xs A Limit}
   if Limit>0 then
      X|Xr=Xs
   in
      {Sum Xr A+X Limit-1}
   else A end
end

local Xs S in
   thread {Generate 0 Xs} end
   thread S={Sum Xs 0 15} end
   {Browse Xs}
   {Browse S}
end

%---

declare
fun lazy {Generate N}
   {Delay 1000}
   N|{Generate N+1}
end
fun {Sum Xs A Limit}
   if Limit>0 then
      case Xs of X|Xr then
	 {Sum Xr A+X Limit-1}
      end
   else A end
end

local Xs S in
   Xs={Generate 0}
   S={Sum Xs 0 15}
   {Browse Xs}
   {Browse S}
end

%
% 13
%
declare
fun lazy {Reverse1 S}
   fun {Rev S R}
      case S of nil then R
      [] X|S2 then {Rev S2 X|R} end
   end
in {Rev S nil} end

fun lazy {Reverse2 S}
   fun lazy {Rev S R}
      case S of nil then R
      [] X|S2 then {Rev S2 X|R} end
   end
in {Rev S nil} end

fun {Generate N Limit}
   if Limit>0 then
      {Delay 1000}
      N|{Generate N+1 Limit-1}
   else nil end      
end

local X R1 Y R2 in
   {Browse X}
   {Browse R1}
   X={Generate 0 10}
   R1={Reverse X}
   
   {Browse Y}
   {Browse R2}
   Y={Generate 0 10}
   R2={Reverse Y}
end


%
% 14
%
fun lazy {Append As Bs}
   case As
   of nil then Bs
   [] A|Ar then X|{Append Ar Bs}
   end
end

%
% 16
%
local X in
   thread X={ByNeed fun {$} {Delay 3000} {Browse x} 3 end} end
   {Browse thread X+2 end}
   {Browse done}
end

%
% 17
%
declare
fun lazy {Times N H}
   case H of X|H2 then N*X|{Times N H2} end
end

fun lazy {Merge Xs Ys}
   case Xs#Ys of (X|Xr)#(Y|Yr) then
      if X<Y then X|{Merge Xr Ys}
      elseif X>Y then Y|{Merge Xs Yr}
      else X|{Merge Xr Yr}
      end
   end
end

proc {Touch N H}
   if N>0 then {Touch N-1 H.2} else skip end
end

%H=1|{Merge {Times 2 H}
%     {Merge {Times 3 H}
%      {Times 5 H}}}
%{Browse H}
%{Touch 10 H}

fun {Hamming Ps H}
   case Ps
   of P|Pr then
      case Pr
      of nil then {Times P H}
      else {Merge {Times P H} {Hamming Pr H}}
      end
   end
end

{Browse H2}
H2=1|{Hamming [2 3 5 7] H2}
{Touch 20 H2}
