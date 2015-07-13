functor
export
   append:Append
define
   fun {Append L1 L2}
      case L1
      of nil then L2
      [] X|Xr then X|{Append Xr L2}
      end
   end
end
