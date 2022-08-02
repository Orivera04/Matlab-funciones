function [m,mlist]= MakeEXM(T,Types);
%MAKEEXM make exportmodel for command-line or CAGE
% 
%  Models= MakeEXM(mdev);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  $Revision: 1.1.6.1 $  $Date: 2004/04/04 03:31:30 $


[m,mlist]= pveceval(children(T),'MakeEXM',Types);
mlist= [mlist{:}];