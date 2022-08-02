function [res,B,J,YHAT,PS]= costknot(knots,ps,DATA,Wc)
% localpspline/COSTB
% 
% [res,B,J,YHAT,PS]= costknot(knots,ps,DATA,Wc)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:41:02 $



Ns= size(DATA,3);
if nargout>1
   B= zeros(size(ps,1),Ns);
   J= cell(1,Ns);
   PS= J;
   YHAT= cell(1,Ns);
end

if nargin<4 | isempty(Wc)
   Wc=cell(1,Ns);
end

res= DATA(:,1);
for i= 1:Ns
   % extract data for current sweep
   d= DATA{i};
   x= d(:,1:end-1);
   y= d(:,end);
   
   ny = length(y);
   
   % Residual Calculation
   ps.knot= knots(i);
   % possibly expand data
   [x,y]= symmetric(ps,x,y);
   %Ji= jacobian(ps,x,1);
   %Xs= Ji(:,2:end); % note that Ji(:,1)= delF/delKnot
   Xs= x2fxlin(ps,x); %   
   % do we have to weight the conditional problem ?
   wci=[];
   if ~isempty(Wc{i}) 
      wci= Wc{i};
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
   res{i}= r;

   if nargout > 1
      % Model object setup
      
      % set up polynomial objects in x-k
      
      ps= update(ps,[ps.knot;p]);
      
      % do we still want this
      
      Ji= jacobian(ps,x);
      if ~isempty(wci) 
         if size(wci,1)~=size(Ji,1)
            yhat= Xs*p;
            wci= choltinv(covmodel(ps),yhat,x);
         end
         Ji= wci*Ji;
      end
      ps.Store.Jacob = Ji;
         
      % what length should these be ? ni
      YHAT{i}= yhat;
      
      PS{i}= ps;
      
      % parameter matrix
      B(:,i)= double(ps);
      J{i}= Ji;
   end
end   

if nargout==1
   res= double(res)/sqrt(size(DATA,1));
end