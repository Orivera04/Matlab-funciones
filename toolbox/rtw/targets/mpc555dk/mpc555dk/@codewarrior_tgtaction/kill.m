% File : kill(obj)
%
% Abstract : kill the current code warrior session

% Copyright 2002-2004 The MathWorks, Inc.
%
% $Revision: 1.1.4.3 $  
% $Date: 2004/04/19 01:26:14 $
%
% function status = KillCW
%
function kill(obj)
cw = actxserver('CodeWarrior.CodeWarriorApp');

% By closing all the debugger documents before
% quiting CodeWarrior we avoid the annoying
% popup asking if we wish to kill the current
% session.
documents = cw.Documents;
for i = 0:(documents.Count-1)
   item = documents.Item(i);
   item.Close(0);
end
cw.Quit(0);
