function [Xf,Yf,OK,badIndex]= checkdata(L,X,Y,Lreal);
% LOCALMOD/CHECKDATA check X and Y data for fitting

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:37:34 $

if nargin>3
   % 'overloaded' checkdata call
   L= Lreal;
end

% Set zeros and negative numbers to be bad data
% transform data
Yd= ytrans(L,double(Y));
% now do ytrans
Y(:,1)= Yd;

% Yd= double(Y);
Xd= code(L,double(X));
X(:,1:end)= Xd;


badIndex= ~all(isfinite(Xd),2) | ~isfinite(Yd);

% remove any complex data
if ~isreal(Xd)
   badIndex= badIndex | any(abs(imag(Xd)) > 1e-8,2);
   Xd= real(Xd);
end
if ~isreal(Yd)
   badIndex= badIndex | abs(imag(Yd)) > 1e-8;
   Yd= real(Yd);
end
   
% see if whole sweeps removed by this check
tn= testnum(Y);
Yb=  Y(~badIndex,:);
Xb=  X(~badIndex,:);

% check that there are enough points for fitting each sweep
OK= tsizes(Yb) >= 1;
ptsOK=  find(OK);
if length(ptsOK)<size(Yb,3)
   ptsBD=  find(~OK);

   % need to update badIndex
   bds= RecPos(Yb,ptsBD);
   tmp= badIndex(~badIndex);
   tmp(bds)= logical(1);
   badIndex(~badIndex)= tmp;
   
   % remove these sweeps
   Yf= Yb(:,:,ptsOK);
   Xf= Xb(:,:,ptsOK);
else
   Yf= Yb;
   Xf= Xb;
end   

% list of sweeps
OK= ismember(tn,testnum( Yf ));

