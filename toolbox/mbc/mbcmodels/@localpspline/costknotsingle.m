function res= costknotsingle(knots,ps,d,Wc)
% localpspline/COSTKNOTSINGLE
% 
% [res,B,J,YHAT,PS]= costknot(knots,ps,DATA,Wc)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:41:03 $




if nargin<4 
   Wc=[];
end
wci= Wc;

x= d(:,1:end-1);
y= d(:,end);
   
   ny = length(y);
   
   % Residual Calculation
   ps.knot= knots;
   % possibly expand data
   [x,y]= symmetric(ps,x,y);
   %Ji= jacobian(ps,x,1);
   %Xs= Ji(:,2:end); % note that Ji(:,1)= delF/delKnot
   Xs= x2fxlin(ps,x); %   
   % do we have to weight the conditional problem ?
   if ~isempty(wci) 
      if size(wci,1)~=length(y)
         p= Xs\y;
         yhat= Xs*p;
         wci= choltinv(covmodel(ps),yhat);
      end
      p= (wci*Xs)\(wci*y);
   else
      p= Xs\y;
   end
  
   yhat= Xs*p;
   
%   if TBS
%      yhat= ytrans(ps,yhat);
%   end

   r = y-yhat;
   
   % weighting
   if ~isempty(wci) 
      r= wci*r;
   end
   r = r(1:ny);
   
   % should be in a sweepset
   % res(:,:,i) = r;
   res= r;



if nargout==1
   res= double(res)/sqrt(size(d,1));
end