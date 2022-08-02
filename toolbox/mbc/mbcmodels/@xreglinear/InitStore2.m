function [m,OK]= InitStore2(m,X,y,bd);
% xreglinear/INITSTORE2 initialises model useing display order deined in TERMORDER

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:49:05 $

if nargin>=3 & length(y)==size(X,1)
   m.Store.y= ytrans(m,y);
   if nargin > 3	
      if ~islogical(bd)   
         BDL= false(size(X,1),1);
         BDL(bd)= true;
      else
         BDL= bd;
      end
   else
      BDL= ~isfinite(m.Store.y);
   end	
   X(BDL,:)= [];
else
   BDL= false(size(X,1),1);
end

m.Store.D= X;
if ~isempty(X)
   FX= x2fx(m,X);
   
   t= ~m.TermsOut;
   
   % use TERMORDER to reorder coefficients for display
   ord= termorder(m);
   FX= FX(:,ord);
   m.Store.X= FX;
   m.Store.DispOrder= 1;
   
   t= t(ord);
   FX= FX(:,t);
   [Q,R,OK,df,Ri]= qrdecomp(m,FX);
else
   FX=[];
   m.Store.X= FX;
   m.Store.DispOrder= 1;
   Q=[];
   R=[];
   Ri=[];
	df=0;
   OK=0;
end


nObs = size(m.Store.X,1);
m.Store.Q= Q;
m.Store.R= R;
% leverage is 0 for bad data
H= zeros(size(BDL,1),1);
if OK & ~all(m.TermsOut)
	H(~BDL)= sum(Q.*Q,2);
end
m.Store.H= H;

if nargin>=3
   % calculate mse
   y= m.Store.y(isfinite(y));
   %pad y
	if df>0
		r= y - Q*(Q'*y);
		m.Store.mse = sum(r.^2)/df;
	else
		m.Store.mse = 0;
	end
		
else
   m.Store.mse= [];
end

if OK 
	if ~isempty(m.Store.mse)
		% store variance info
		m= var(m,Ri*sqrt(m.Store.mse),m.Store.mse,df);
	else
		m= var(m,Ri,m.Store.mse,df);
	end
end
