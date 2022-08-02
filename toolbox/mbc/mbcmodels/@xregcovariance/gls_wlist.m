function out= gls_wlist(c,n)
% COVMODEL/GLS_WLIST list of weighting functions available

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:46:19 $



wmodels= {'','power','exp','mixed'};

if nargin==1
   n= strmatch(c.wfunc,wmodels);
   if isempty(c.wfunc) | isempty(n)
      n=1;
   end
   out= n;
else
   c.wfunc= wmodels{n};
   
   % default function values
   if ~isempty(c.wfunc)
      c.wparam= feval(c.wfunc,c);
   else
      c.wparam= [];
   end
   out= c;
end