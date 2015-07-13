declare S P in
{NewPort S P}
{Browse S}
{Send P a}
{Send P b}
{Send P c}

declare
fun {NewPortObject Init Fun}
   Sin Sout in
   thread {FoldL Sin Fun Init Sout} end
   {NewPort Sin}
end
fun {NewPortObject2 Proc}
   Sin in
   thread for Msg in Sin do {Proc Msg} end end
   {NewPort Sin}
end

fun {Player Others}
   {NewPortObject2
    proc {$ Msg}
       case Msg of ball then
	  Ran={OS.rand} mod {Width Others} + 1
       in
	  {Send Others.Ran ball}
       end
    end}
end
