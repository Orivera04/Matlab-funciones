function TS= loadobj(TS);
% TWOSTAGE/LOADOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:48 $


if isa(TS,'struct')
   if TS.version==0
      c= get(TS.xregmodel,'code');
      Ng= nfactors(TS.Global{1});
      if length(c)==Ng
         c= [c(1) c];
         c(1).min=-1;
         c(1).max=1;
         c(1).g='';
         c(1).mid=0;   
         TS.xregmodel= set(TS.xregmodel,'code',c);
      end
      TS.version=1;
   end
   TS= xregtwostage(TS);
end


