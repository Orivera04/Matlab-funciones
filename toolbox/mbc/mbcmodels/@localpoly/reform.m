function [L,OK]= reform(L,y)
% POLYNOM/REFORM reform localmod from response features (and datum if applicable)
% 
% [L,OK]= reform(L,y)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:40:43 $

OK=1;
y= y(:);
Nf= numfeats(L);

if L.DatumType
   % define datum
   L=datum(L,y(1:end-Nf)');
   % might need to remove datum if it is not used as response feature
end
y= y(end-Nf+1:end);

% 
beta= L.delG\y; 
L=update(L,beta,[]);
