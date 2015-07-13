declare [File] = {Module.link ['/Users/hikaru.ojima/Workspace/ctmcp/sec-3-9/File.ozf']}

declare
L = {File.readList "/Users/hikaru.ojima/Workspace/ctmcp/sec-1.oz"}
{Browse L}
{Browse File}

declare
L = {File.readList "http://google.com"}
{Browse L}

declare
{File.writeOpen '/Users/hikaru.ojima/Workspace/ctmcp/foo.txt'}
{File.write 'This comes in the file.\n'}
{File.write 'Thre result of 43*43 is'#43*43#'.\n'}
{File.write "Strings are ok too.\n"}
{File.writeClose}

declare [QTK] = {Module.link ['x-oz://system/wp/QTK.ozf']}

declare
D = td(button(text:"Press me"
	      action: proc {$} {Browse ouch} end))
W = {QTK.build D}
{W show}

% 連打すると固まるww

declare In Out
A1 = proc {$} X in {In get(X)} {Out set(X)} end
A2 = proc {$} {W close} end

D = td(title:"Simple text I/O interface"
       lr(label(text:"Intput:")
	  text(handle:In tdscrollbar:true glue:nswe)
	  glue:nswe)
       lr(label(text:"Output")
	  text(handle:Out tdscrollbar:true glue:nswe)
	  glue:nswe)
       lr(button(text:"Do It" action:A1 glue:nswe)
	  button(text:"Quit" action:A2 glue:nswe)
	  glue:we))
W = {QTK.build D}
{W show}

declare
fun {Fact N}
   if N == 0 then 1 else N * {Fact N-1} end
end
F10 = {Fact 10}
F10Gen1 = fun {$} F10 end
F10Gen2 = fun {$} {Fact 10} end
FNGen1 = fun {$ N} F={Fact N} in fun {$} F end end
FNGen2 = fun {$ N} fun {$} {Fact N} end end

{Pickle.save [F10Gen1 F10Gen2 FNGen1 FNGen2] '/Users/hikaru.ojima/Workspace/ctmcp/sec-3-9/factfile'}

declare F1 F2 F3 F4 in
{Browse {F1}}
{Browse {F2}}
{Browse {{F3 10}}}
{Browse {{F4 10}}}
[F1 F2 F3 F4] = {Pickle.load '/Users/hikaru.ojima/Workspace/ctmcp/sec-3-9/factfile'}

declare X
{Pickle.save 1 '/Users/hikaru.ojima/Workspace/ctmcp/test.ozp'}
declare {Pickle.load '/Users/hikaru.ojima/Workspace/ctmcp/test.ozp' X} in
{Browse X}

% https://github.com/mozart/mozart2/issues/91
% Pickle 壊れてる？