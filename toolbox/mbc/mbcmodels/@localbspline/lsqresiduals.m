function [res,B,YHAT]= costknot(knots,bs,DATA,Wc,c0,alpha,JTgt)
% localpspline/COSTB
% 
% [res,B,YHAT]= costknot(knots,ps,DATA,Wc)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.3 $  $Date: 2004/02/09 07:38:18 $




Ns= size(DATA,3);
if nargin<5 | isempty(c0)
   c0=1;
end
if nargin<6 | isempty(alpha)
   alpha= zeros(Ns,1);
end
   
if nargout>1
   B= zeros(size(bs,1),Ns);
   YHAT= cell(1,Ns);
end

nk= get(bs.xreg3xspline,'numknots');
knots= reshape(knots,nk,Ns);

if nargin<4 | isempty(Wc)
   Wc=cell(1,Ns);
end

res= DATA(:,1);

Tgt=gettarget(bs,1);
for i= 1:Ns
   % extract data for current sweep
   d= DATA{i};
   x= d(:,1:end-1);
   y= d(:,end);
   
   ny = length(y);
   
   % Residual Calculation
   k= invjupp(bs.xreg3xspline,knots(:,i),JTgt(i,:));
   
   bs.xreg3xspline= set(bs.xreg3xspline,'knots',k);
   % possibly expand data
   
   [bs.xreg3xspline,OK]= leastsq(bs.xreg3xspline,x,y,Wc{i});
   
	if OK
		yhat= eval(bs,x);
		r = y-yhat;
	else
      
		r= NaN*y;
      yhat= r;
	end
   
   % do we have to weight the conditional problem ?
   wci=[];
   if ~isempty(Wc{i}) 
      wci= Wc{i}; 
      r= wci*r;
   end
   
   % penalty function
   h=diff([JTgt(i,1);k(:);JTgt(i,2)])/(JTgt(i,2)-JTgt(i,1)) ;
   h(h<sqrt(eps))=sqrt(eps);
   penalty= 1-alpha(i)*sum(log((nk+1)*h));
   
   % should be in a sweepset
   res{i}= r*sqrt(abs(penalty));

   if nargout > 1
      % Model object setup
      
      YHAT{i}= yhat;
      
      % parameter matrix
      B(:,i)= double(bs);
   end
end   


if nargout==1
   res= double(res)/sqrt(c0);
   
   % deal with nonfinite residuals
   ir= isfinite(res);
   if ~all(ir)
      res(~ir)= 10/sqrt(length(res));
   end
end