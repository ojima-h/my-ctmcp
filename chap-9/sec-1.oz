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

declare
fun {Soft} choice beige [] coral end end
fun {Hard} choice mauve [] ochre end end
proc {Contrast C1 C2}
   choice C1={Soft} C2={Hard} [] C1={Hard} C2={Soft} end
end
fun {Suit}
   Shirt Pants Socks
in
   {Contrast Shirt Pants}
   {Contrast Pants Socks}
   if Shirt==Socks then fail end
   suit(Shirt Pants Socks)
end
{Browse {SolveOne Hard}}
