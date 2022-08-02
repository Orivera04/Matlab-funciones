function p= getptrs(T);
% TREE/GETPTRS ist of internal pointers for 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:47:49 $

p= [T.node T.Parent T.Children];