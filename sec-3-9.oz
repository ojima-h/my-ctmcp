declare 
functor F
import
   Browser
export
   test: Test
define
   proc {Test} {Browser.browse hoge} end
end


declare [MyList] = {Module.link ['/Users/hikaru.ojima/Workspace/ctmcp/sec-3-9/MyList.ozf']}
{Browse {MyList.append [1 2 3] [4 5 6]}}


