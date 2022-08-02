function out= gls_clist(c,n,Ts)
% COVMODEL/GLS_CLIST list of correlation functions available

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:18 $

cmodels= {'','ma','ar','ar'};

if nargin==1
   n= strmatch(c.cfunc,cmodels);
   if isempty(c.cfunc) | isempty(n)
      n=1;
   elseif length(n)>1 & strcmp(c.cfunc,'ar')
      n= 2+length(c.cparam);
   end
   out= n(1);
else
   c.cfunc= cmodels{n};
   
   % default function values
   cparams= {[],0,0,[0 0]};
   c.cparam= cparams{n};
   if ~isempty(c.cfunc)
      if nargin>2 
         c.Ts= Ts;
      else
         c.Ts=1;
      end
   else
      c.Ts=0;
   end
   out= c;
end