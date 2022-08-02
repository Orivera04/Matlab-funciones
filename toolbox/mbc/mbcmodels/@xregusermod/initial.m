function [p0,OK]= initial(U,varargin);
% xregusermod/INITIAL
% 
% [p0,OK]= initial(U)
% [p0,OK]= initial(U,x,y);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:16 $

[p0,OK]= feval(U.funcName,U,'initial',varargin{:});

if isempty(p0)
   np= numParams(U);
   % user upper and lower bounds to find an initial guess
   [LB,UB]= constraints(U);
   LB(~isfinite(LB))=0;
   UB(~isfinite(UB))=0;
   if isempty(LB) 
      if isempty(UB)
         p0= zeros(np,1);
      else
         ub2= UB;
         ub2(ub2==0)= 1;
         p0= UB - rand(np,1).*abs(ub2);
      end
   elseif isempty(UB)
      if isempty(LB)
         p0= zeros(np,1);
      else
         lb2= LB;
         lb2(lb2==0)= 1;
         p0= LB + rand(np,1).*abs(lb2);
      end
   else
      % use randon starting point between LB and UB
      p0= LB + rand(np,1).*(UB-LB);
   end
end

p0(~isfinite(p0))= 0;
