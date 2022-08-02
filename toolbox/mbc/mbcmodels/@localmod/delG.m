function dg= delG(L)
% LOCALMOD/DELG delG/delp for localmod
% 
% Use this only if delG is constant (i.e. response features are linear)
% Use localmod/evaldelg to update delG
%
% See also EvalDelG

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:53 $

dg= L.delG;