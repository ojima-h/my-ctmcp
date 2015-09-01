functor
export
   new: New
   wrap: Wrap
define
   % local
   %    Key={NewName}
   % in
   %    fun {Wrap X}
   %       {Chunk.new w(Key:X)}
   %    end
   %    fun {Unwrap W}
   %       try W.Key catch _ then raise error(unwrap(W)) end end
   %    end
   % end
   fun {Wrap X} X end
   fun {Unwrap X} X end

   fun {New WClass InitialMethod}
      State Obj Class={Unwrap WClass}
   in
      State={MakeRecord s Class.attrs}
      {Record.forAll State proc {$ A} {NewCell _ A} end}
      proc {Obj M}
	 {Class.methods.{Label M} M State Obj}
      end
      {Obj InitialMethod}
      Obj
   end
end