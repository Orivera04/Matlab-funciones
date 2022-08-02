function is= ismle(TS);
% TWOSTAGE/ISMLE indicates mle has been run on algorithm

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:59:46 $

alg= get(TS,'fitalg');
if ischar(alg)
   is= strcmp(lower(alg(1:3)),'mle');
else
   n=getname(alg);
   is= 1; % strcmp(lower(n(1:3)),'gls');
end