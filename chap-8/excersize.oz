declare
fun {NewStack}
   Stack={NewCell nil}
   proc {Push X}
      S in
      {Exchange Stack S X|S}
   end
   fun {Pop}
      X S in
      {Exchange Stack X|S S}
      X
   end
in
   stack(push:Push pop:Pop)
end

local
   S={NewStack}
in
   {S.push 1}
   {S.push 2}
   {Browse {S.pop}}
end


%
% 1
%

% choose(n*k, k) * choose((n-1)*k, k) * ... * choose(k, k)

% = (n*k)!/k!/((n-1)*k)! * ((n-1)*k)!/k!/((n-2)*k)! * ... * k!/k!/0!

% = (n*k)! / (k!)^n

% = (sqrt(2*pi) * (n*k)^(n*k+1/2) * exp(-n*k)) / (sqrt(2*pi) * k^(k+1/2) * exp(-k))^n

% = (sqrt(2*pi) * (n*k)^(n*k+1/2) * exp(-n*k)) / (sqrt(2*pi)^n * k^(n*k+n/2) * exp(-n*k))

% = sqrt(2*pi)^(1-n) * n^(n*k+1/2) * k^(-n/2)

% = n^(n*k+1/2) / C^(n-1) / k^(n/2)

% = O(n^n)


%
% 2
%

local
   C={NewCell 0}
in
   {Browse @C}
   local X in {Exchange C X X+1} end
   {Browse @C}
   local X in {Exchange C X X+1} end
   local X in {Exchange C X X+1} end
   {Browse @C}
end

% X+1 が評価できず Exchange がブロックされる

local
   C={NewCell 0}
in
   {Browse @C}
   local X Y in {Exchange C X Y} Y=X+1 end
   {Browse @C}
   local X Y in {Exchange C X Y} Y=X+1 end
   local X Y in {Exchange C X Y} Y=X+1 end
   {Browse @C}
end

% データフロー変数を持たない言語では使えない

local
   C={NewCell 0}
   L={NewLock}
in
   lock L then C:=@C+1 end
   lock L then C:=@C+1 end
   lock L then C:=@C+1 end
   {Browse @C}
end

%
% 3
%

% ????

%
% 4
%

declare
fun {SlowNet3 Obj D}
   Tokens={NewCell nil}
   L={NewLock}
in
   proc {$ M}
      CurThr={Thread.this}
      Old New
   in
      lock L then
	 C in
	 if {Length {List.filter @Tokens fun {$ K#_} K==CurThr end}}==0
	 then
	    C={NewCell unit}
	    Tokens:=(CurThr#C)|@Tokens
	 else
	    _#C={List.filter @Tokens fun {$ K#_} K==CurThr end}.1
	 end
	 {Exchange C Old New}
      end

      thread
	 {Delay D}
	 {Wait Old}
	 {Obj M}
	 New=unit
      end
   end
end

local
   proc {Obj M} {Browse M} end
   SObj={SlowNet3 Obj 1}
in
   try
      thread
	 {SObj 1} {SObj 2} {SObj 3}
      end
      thread
	 {SObj a} {SObj b} {SObj c}
      end
   catch E then {Browse E} end
end

%
% 5
%
declare
fun {NewQueue}
   X C={NewCell 0 X X}
   proc {Insert X}
      N S E1 N1 in
      {Exchange C q(N S X|E1) q(N1 S E1)}
      N1=N+1
   end
   fun {Delete}
      N S1 E N1 X in
      {Exchange C q(N X|S1 E) q(N1 S1 E)}
      N1=N-1
      X
   end
in
   queue(insert:Insert delete:Delete)
end
		    
fun {NewMVar}
   C={NewCell _}
   Q1={NewQueue}
   Q2={NewQueue}
   proc {Get X}
      L in
      {Q1.insert L}
      {Wait L}
      {Exchange C X _}
      {Q2.delete}=unit
   end
   proc {Put X}
      L in
      {Q2.insert L}
      {Wait L}
      C:=X
      {Q1.delete}=unit
   end
in
   mvar(get:Get put:Put)
end

declare
try
M={NewMVar}
thread {Browse {M.get}} end
thread {Browse {M.get}} end
thread {Browse {M.get}} end
{M.put 1}
catch E then {Browse E} end