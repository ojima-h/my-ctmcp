proc {Hoge X Y R ?C}
   case X#R
   of (Xl|Xr)#(Yl|Yr) then 1
   [] nil#(Yl|Yr) then 2
   [] (Xl|Xr)|nil then 3
   else 4
   end
end

      