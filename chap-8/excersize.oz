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
   X C={NewCell q(0 X X)}
   L={NewLock}
   proc {Insert X}
      N S E1 in
      lock L then
	 q(N S X|E1)=@C
	 C:=q(N+1 S E1)
      end
   end
   fun {Delete}
      N S1 E in
      lock L then
	 q(N X|S1 E)=@C
	 C:=q(N-1 S1 E)
      end
      X
   end
   fun {Size}
      lock L then @C.1 end
   end
   fun {DeleteAll}
      lock L then
	 X q(_ S E)=@C in
	 C:=q(0 X X)
	 E=nil S
      end
   end
   fun {DeleteNonBlock}
      lock L then
	 if {Size}>0 then [{Delete}] else nil end
      end
   end
in
   queue(insert:Insert delete:Delete size:Size
	deleteAll:DeleteAll deleteNonBlock:DeleteNonBlock)
end
fun {NewGRLock}
   Token1={NewCell unit}
   Token2={NewCell unit}
   CurThr={NewCell unit}

   proc {GetLock}
      if {Thread.this}\=@CurThr then Old New in
	 {Exchange Token1 Old New}
	 {Wait Old}
	 Token2:=New
	 CurThr:={Thread.this}
      end
   end
   proc {ReleaseLock}
      CurThr:=unit
      unit=@Token2
   end
in
   'lock'(get:GetLock release:ReleaseLock)
end
fun {NewMonitor}
   Q={NewQueue}
   L={NewGRLock}

   proc {LockM P}
      {L.get} try {P} finally {L.release} end
   end

   proc {WaitM}
      X in
      {Q.insert X} {L.release} {Wait X} {L.get}
   end

   proc {NotifyM}
      U={Q.deleteNonBlock} in
      case U of [X] then X=unit else skip end
   end

   proc {NotifyAllM}
      L={Q.deleteAll} in
      for X in L do X=unit end
   end
in
   monitor('lock':LockM wait:WaitM notify:NotifyM
	   notifyAll:NotifyAllM)
end

declare
fun {NewMVar}
   C={NewCell _}
   M={NewMonitor}
   E={NewCell true}
   proc {Get X}
      {M.'lock' proc {$}
		   if @E then {M.wait} {Get X}
		   else
		      X=@C
		      E:=true
		      {M.notifyAll}
		   end
		end}
   end
   proc {Put X}
      {M.'lock' proc {$}
		   if {Not @E} then {M.wait} {Put X}
		   else
		      C:=X
		      E:=true
		      {M.notifyAll}
		   end
		end}
   end
in
   mvar(get:Get put:Put)
end

declare
M={NewMVar}

try
thread {Browse {M.get}} end
thread {Browse {M.get}} end
thread {Browse {M.get}} end
{M.put 1}
{Browse {M.get}}
catch E then {Browse E} end

{Browse 1}