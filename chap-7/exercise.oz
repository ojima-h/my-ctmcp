%
% 1
%

declare
class Counter 
   attr val
   meth browse 
      {Browse @val}
   end 
   meth inc(Value)
      val := @val + Value
   end 
   meth init(Value)
      val := Value
   end 
end

declare
fun {New2 Class}
   TInit={NewName}
   class WrapClass from Class
      meth !TInit skip end
   end
in
   {New WrapClass TInit}
end

declare
C = {New2 Counter}
{C init(10)}
{C inc(3)}
{C browse}


%
% 2
%

declare
fun {TraceNew3 Class Init}
   class Tracer
      attr obj
      meth initTracer(Class Init)
	 obj:={New Class Init}
      end
      meth otherwise(M)
	 {Browse entering({Label M})}
	 {@obj M}
	 {Browse exiting({Label M})}
      end
   end
in {New Tracer initTracer(Class Init)}
end

declare
TC={TraceNew3 Counter init(0)}
{TC inc(10)}
{TC browse}

%
% 3
%

declare [ProtectedTest] = {Module.link ['ProtectedTest.ozf']}
declare [MyClass] = {Module.link ['MyClass.ozf']}

declare
A={MyClass.new ProtectedTest.a init}
B={MyClass.new ProtectedTest.b init}
{Browse ProtectedTest.a}
{A call}
