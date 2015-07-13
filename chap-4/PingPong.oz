functor
import
   Browser(browse:Browse)
define
   proc {Ping N}
      if N==0 then {Browse 'ping terminated'}
      else {Delay 500} {Browse ping} {Ping N-1} end
   end
   proc {Pong N}
      {For 1 N 1
       proc {$ I} {Delay 600} {Browse pong} end}
      {Browse 'pong terminated'}
   end
in
   {Browse 'game started'}
   thread {Ping 50} end
   thread {Pong 50} end
end

%%%%%%

declare
proc {Ping N}
   if N==0 then {Browse 'ping terminated'}
   else {Delay 500} {Browse ping} {Ping N-1} end
end
proc {Pong N}
   {For 1 N 1
    proc {$ I} {Delay 600} {Browse pong} end}
   {Browse 'pong terminated'}
end

{Browse 'game started'}
thread {Ping 50} end
thread {Pong 50} end

{Browse test}
