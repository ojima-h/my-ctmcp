% Prepare
%%%%%%%%%
declare
fun {Solve Script}
   {SolStep {Space.new Script} nil}
end
fun {SolStep S Rest}
   case {Space.ask S}
   of failed then Rest
   [] succeeded then {Space.merge S}|Rest
   [] alternatives(N) then 
      {SolLoop S 1 N Rest}
   end
end
fun lazy {SolLoop S I N Rest}
   if I>N then Rest
   elseif I==N then
      {Space.commit S I}
      {SolStep S Rest}
   else Right C in
      Right={SolLoop S I+1 N Rest}
      C={Space.clone S}
      {Space.commit C I}
      {SolStep C Right}
   end
end

declare
fun {SolveOne F}
   L={Solve F}
in
   if L==nil then nil else [L.1] end
end
fun {SolveAll F}
   L={Solve F}
   proc {TouchAll L}
      if L==nil then skip else {TouchAll L.2} end
   end
in
   {TouchAll L}
   L
end

% 12.1
%%%%%%

%
% 12.1.2
%
declare X Y in
X::90#110
Y::48#53

declare A in
A::0#10000
A=:X*Y
{Browse A>:4000}
{Browse A}

X-2*Y=:11

{Browse X}
{Browse Y}

%
% 12.1.3
%
declare X Y in
X::1#9
Y::1#9
{Browse X}
{Browse Y}
{Browse X=<:Y}

X*Y=:24
X+Y=:10
X=<:Y

% case 1
X=:4

% case 2
X\=:4

%
% 12.1.4
%
declare
proc {Rectangle ?Sol}
   sol(X Y)=Sol
in
   X::1#9 Y::1#9
   X*Y=:24 X+Y=:10 X=<:Y
   {FD.distribute naive Sol}
end
{Browse {SolveAll Rectangle}}

% 12.2
%%%%%%

%
% 12.2.1
%
declare
proc {SendMoreMoney ?Sol}
   S E N D M O R Y
in
   Sol=sol(s:S e:E n:N d:D m:M o:O r:R y:Y)
   Sol:::0#9
   {FD.distinct Sol}
   S\=:0
   M\=:0
   1000*S + 100*E + 10*N + D
   + 1000*M + 100*O + 10*R + E
   =: 10000*M + 1000*O + 100*N + 10*E + Y
   {FD.distribute ff Sol}
end
{Browse {SolveAll SendMoreMoney}}

%
% 12.2.2
%
declare
proc {Palindrome ?A}
   B C X Y Z
in
   A::0#9999 B::0#99 C::0#99
   A=:B*C
   X::1#9 Y::0#9
   A=:X*1000+Y*100+Y*10+X
   {FD.distribute ff [X Y B C]}
end
{Browse {SolveAll Palindrome}}

declare
proc {Palindrome2 ?Sol}
   sol(A)=Sol
   B C X Y Z
in
   A::0#90909 B::0#90 C::0#999
   A=:B*C
   X::1#9 Y::0#9 Z::0#9
   A=:X*9091+Y*910+Z*100
   {FD.distribute ff [X Y B C]}
end
{Browse {SolveAll Palindrome2}}

% 12.4
%%%%%%

%
% 12.4.1
%
declare
fun {DFE S}
   case {Ask S}
   of failed then nil
   [] succeeded then [S]
   [] alternatives(2) then C={Clone S} in
      {Commit S 1}
      case {DFE S} of nil then {Commit C 2} {DFE C}
      [] [T] then [T]
      end
   end
end

fun {DFS Script}
   case {DFE {NewSpace Script}} of nil then nil
   [] [S] then [{Merge S}]
   end
end

% 12.6
%%%%%%

% 1

declare
fun {AbsTriangle N}
   S=(N+1)*N div 2

   fun {Edge J}
      if J==0 then nil
      else X in
	 X::1#S
	 X|{Edge J-1}
      end
   end

   proc {Constraint E1 E2}
      case E1#E2
      of (X|R1)#(Y|Z|R2) then
	 {FD.distance X Y '=:' Z}
	 {Constraint R1 Z|R2}
      else skip
      end
   end

   fun {Triangle I}
      if I==1 then
	 [{Edge 1}]
      else
	 T={Triangle I-1}
	 E={Edge I}
      in
	 {Constraint T.1 E}
	 E|T
      end
   end
in
   proc {$ ?Sol}
      Sol={Triangle N}
      {FD.distinct {List.flatten Sol}}
      {FD.distribute ff {List.flatten Sol}}
   end
end

{Browse {SolveAll {AbsTriangle 4}}}

% 8 1 10 6
%  7 9  4
%   2 5
%    3
% ---
% 9 10 3 8
%  1  7 5
%   6  2
%    4

{Browse {SolveAll {AbsTriangle 5}}}

% 6 14 15  3 13
%  8  1 12 10
%   7 11  2
%    4  9
%     5

{Browse {SolveAll {AbsTriangle 6}}}

% nil

{Browse {SolveAll {AbsTriangle 7}}}

% nil

%
% 2
%

% http://doc.uh.cz/Mozart-oz/print/tutorial/FiniteDomainProgramming.pdf

declare
proc {GroceryPuzzle ?Sol}
   A#B#C#D=Sol
   S=711
in
   Sol:::0#S

   % (A/100)+(B/100)+(C/100)+(D/100)=S/100
   A+B+C+D=:S

   % (A/100)*(B/100)*(C/100)*(D/100)=S/100
   A*B*C*D=:S*100*100*100

   A=<:B B=<:C C=<:D

   {FD.distribute ff Sol}
end
{Browse {SolveAll GroceryPuzzle}}


%
% 3
%

% The green house comes after the white one.

declare
proc {ZebraPuzzle ?Sol}
   Persons=persons(english:_ spaniard:_ japanese:_ italian:_ norwegian:_)
   Colors=colors(red:_ green:_ white:_ yellow:_ blue:_)
   Drinks=drinks(tea:_ coffee:_ milk:_ juice:_ water:_)
   Jobs=jobs(painter:_ diplomat:_ sculptor:_ violinist:_ doctor:_)
   Animals=animals(dog:_ snail:_ fox:_ horse:_ zebra:_)

   proc {NextDoor X Y}
      {FD.distance X Y '=:' 1}
   end
in
   Sol=[Persons Colors Drinks Jobs Animals]

   for X in Sol do
      X:::1#5
      {FD.distinct X}
   end
   
   Persons.english =: Colors.red % a
   Persons.spaniard =: Animals.dog % b
   Persons.japanese =: Jobs.painter % c
   Persons.italian =: Drinks.tea % d
   Persons.norwegian =: 1 % e
   Colors.green =: Drinks.coffee % f
   Colors.green >: Colors.white % g
   Jobs.sculptor =: Animals.snail % h
   Jobs.diplomat =: Colors.yellow % i
   Drinks.milk =: 3 % j
   {NextDoor Persons.norwegian Colors.blue} % k
   Jobs.violinist =: Drinks.juice % l
   {NextDoor Animals.fox Jobs.doctor} % m
   {NextDoor Animals.horse Jobs.diplomat} % n
   Animals.zebra =: Colors.white %o

   {FD.distribute ff
    {List.flatten {Map Sol fun {$ X} {Record.toList X} end}}}
end

{Browse {SolveAll ZebraPuzzle}}

%
% 4
%
declare
fun {ExchangeMoney Coins CoinsNum Payment}
   proc {$ ?Sol}
      Sol={Map CoinsNum proc {$ X ?Y} Y::0#X end}
      {FD.sumC Coins Sol '=:' Payment}
      {FD.distribute naive Sol}
   end
end
{Browse {SolveAll {ExchangeMoney [100 25 10 5 1] [6 8 10 1 5] 142}}}
