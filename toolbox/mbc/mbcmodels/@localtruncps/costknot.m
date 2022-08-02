function [res,B,J,YHAT,PS]= costknot(knots,ts,DATA,Wc,c0)
% localpspline/COSTB
% 
% [res,B,J,YHAT,PS]= costknot(knots,ps,DATA,Wc)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.4 $  $Date: 2004/02/09 07:42:53 $



if nargin<5
   c0=1;
end
Ns= size(DATA,3);
if nargout>1
   B= zeros(size(ts,1),Ns);
   J= cell(1,Ns);
   PS= J;
   YHAT= cell(1,Ns);
end

nk= length(ts.knots);
knots= reshape(knots,nk,Ns);

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
   ts.knots= knots(:,i);
   % possibly expand data
   
   [ts,OK]= leastsq(ts,x,y,Wc{i});
   if ~OK
      % this occurs because there is no data above the knots
      X= x2fx(ts,x);
      X= X(:,Terms(ts));
      
      stat= getstatus(ts);
      
      all0= all(X(:,ts.order+1:end)==0); 
      ts= setstatus(ts,find(all0)+ts.order+1,0);
      [ts,OK]= leastsq(ts,x,y,Wc{i});
      ts.xreglinear= set(ts.xreglinear,'status',stat);
      
   end      
      
   yhat= eval(ts,x);
   
   % do we have to weight the conditional problem ?
   wci=[];
   if ~isempty(Wc{i}) 
      wci= Wc{i}; 
   end
   
   r = y-yhat;
   
   % weighting
   if ~isempty(wci) 
      r= wci*r;
   end
   
   % should be in a sweepset
   res{i}= r;

   if nargout > 1
      % Model object setup
      
      % set up polynomial objects in x-k
      
      Ji= jacobian(ts,x);
      if ~isempty(wci) 
         Ji= wci*Ji;
      end
         
      % what length should these be ? ni
      YHAT{i}= yhat;
      
      PS{i}= ts;
      
      % parameter matrix
      B(:,i)= double(ts);
      J{i}= Ji;
   end
end   

if nargout==1
   res= double(res)/c0;
end
