function [m,OK]= InitModel(m,x,y,Wc,IsCoded,doRinvCalc);
% xreglinear/INITSTORE initialises model for use by stats and leastsq 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:49:03 $

% clear old store
m.Store= [];

if nargin<6
    doRinvCalc= true;
end

if nargin>4 & ~IsCoded
	% raw data used
   [x,y,DataOK]= checkdata(m,x,y);
else
   DataOK= isfinite(y);
end

% calculate full x2fx matrix (for stepwise)
FX= x2fx(m,x);
if nargin>=4 & ~isempty(Wc)
   y= Wc*y;
   FX= Wc*FX;
end
% calculate Jacobian 
J= FX(:,~m.TermsOut);

if doRinvCalc
    % fit algorithm dependent qr decomposition (may need model for lambda)
    [Q,R,OK,df,Ri]= qrdecomp(m,J);
else
    [Q,R,OK,df]= qrdecomp(m,J);
end
    
nObs = size(x,1);
H= zeros(size(y,1),1);
if OK & ~all(m.TermsOut)
	% leverage values
    H = sum(Q.*Q,2);
    % residuals
    r= y- Q*(Q'*y);
else
    r = y;
end    
    
    
% calculate MSE
if df>0 & OK
   mse = sum(r.^2)/df;
else
   mse= 0;
end
if doRinvCalc
    if OK
        % store variance info
        m= var(m,Ri*sqrt(mse),mse,df);
    else
        m= var(m,[],0,Inf);
    end
end

% store data in structure
m.Store= struct('y',y,...
   'X',FX,...
   'D',x,...
   'Q',Q,...
   'R',R,...
   'H',H,...
   'DispOrder',0,...
   'mse',mse);


