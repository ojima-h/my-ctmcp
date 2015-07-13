declare
fun {NewTicker}
   fun {Loop}
      X={Time.time}
   in
      {Delay 1000}
      X|{Loop}
   end
in
   thread {Loop} end
end
thread for X in {NewTicker} do {Browse X} end end
