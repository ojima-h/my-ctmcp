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
fun {