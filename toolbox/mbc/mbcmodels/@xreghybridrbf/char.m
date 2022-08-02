function str=char(m,hg);
% CHAR  Char function for xreghybridrbf

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:48:02 $

% Created 1/3/2001
% gives details of model
coeffs = double(m);
m = update(m,coeffs); % this will ensure the submodel coeffs are updated also


lmstr = char(m.linearmodpart);
bridge = ['plus '];
rbfstr = char(m.rbfpart);
cell = [{lmstr};{bridge};{rbfstr}];
str = char(cell);
   
return