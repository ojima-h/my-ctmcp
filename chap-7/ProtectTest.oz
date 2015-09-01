functor
import
   Browser
   MyClass at 'MyClass.ozf'
export
   a: A
   b: B
define
   Protected = m(test: {NewName})

   local
      Attrs = [obj]
      MethodTable = m(init:Init call:Call)
      proc {Init M S Self}
	 (Attrs.obj):={New B init}
      end

      proc {Call M S Self}
	 {@(Attrs.obj) Protected.test}
      end
   in
      A = {MyClass.wrap c(methods:MethodTable attrs: Attrs)}
   end

   local
      Attrs = nil
      M1=Protected.test
      MethodTable = m(init:Init M1:Test)
      proc {Init M S Self}
	 skip
      end

      proc {Test M S Self}
	 {Browser.browse 'protected method called'}
      end
   in
      B = {MyClass.wrap c(methods:MethodTable attrs: Attrs)}
   end
end