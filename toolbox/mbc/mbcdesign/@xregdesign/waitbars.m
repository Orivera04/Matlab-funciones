function flg=waitbars(des,val)
% WAITBARS  Returns/sets waitbar usage flag
%
%  FLG=WAITBARS(D) returns 1 if the design D is set
%  to use graphical waitbars, 0 otherwise.
%  D=WAITBARS(D,FLG) sets the design D to use/not use
%  waitbars.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:55 $

% Created 20/9/2000

if nargin==1
   flg=des.guiflags.waitbars;   
else
   des.guiflags.waitbars=val;
   flg=des;
end
return