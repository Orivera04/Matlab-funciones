function ret=ytranscmp(m1,m2)
% YTRANSCMP  Compare ytrans settings
%
%   OK=YTRANSCMP(M1,M2) returns 1 if the two models have the
%   same ytrans settings (ytrans AND tbs are the same), 0 
%   otherwise.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:53:33 $

% Created 4/4/2000

if ~isa(m1,'model') | ~isa(m2,'model')
   ret=0;
   return
end

if strcmp(char(get(m1,'ytrans')),char(get(m2,'ytrans'))) & (get(m1,'tbs')==get(m2,'tbs'))
   ret=1;
else
   ret=0;
end
