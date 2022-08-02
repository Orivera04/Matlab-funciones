function [m,OK]= InitStore(m,X,y,bd,doRinvCalc);
% xreglinear/INITSTORE initialises model for use by stats and leastsq 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:49:04 $

% clear old store
m.Store= [];
if nargin<5
    doRinvCalc= true;
end
    

if nargin>=3
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

if ~isempty(X)
   FX= x2fx(m,X);
   m.Store.X= FX;
   m.Store.D= X;
   
   % DispOrder==0 implies use model term order
   %  rather than more logical user display order
   m.Store.DispOrder=0;
   t= ~m.TermsOut;
   FX= FX(:,t);
   if doRinvCalc
       [Q,R,OK,df,Ri]= qrdecomp(m,FX);
   else
       [Q,R,OK,df,Ri]= qrdecomp(m,FX);
   end
       
else
	df= 0;
   m.Store.X= [];
   m.Store.D= X;
   m.Store.DispOrder=0;
   Q=[];
   R=[];
   Ri=[];
	OK=0;
end

nObs = size(m.Store.X,1);
m.Store.Q= Q;
m.Store.R= R;
H= zeros(size(BDL,1),1);
if OK & ~all(m.TermsOut)
	H(~BDL)= sum(Q.*Q,2);
end
m.Store.H= H;


if nargin>=3 & OK
   % calculate MSE
   y= m.Store.y(isfinite(y));
   %pad y
   r= y- Q*(Q'*y);
   if df>0
		mse= sum(r.^2)/df;
	else
		mse=0;
	end
	m.Store.mse = mse;
else
	mse=1;
   m.Store.mse= [];
end

if doRinvCalc
    if OK 
        % store variance info
        m= var(m,Ri*sqrt(mse),m.Store.mse,df);
    else
        m= var(m,[],0,Inf);
    end
end