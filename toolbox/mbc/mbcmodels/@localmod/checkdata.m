function [Xf,Yf,OK,badIndex]= checkdata(L,X,Y,Lreal);
% LOCALMOD/CHECKDATA check X and Y data for fitting

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.7.4.3 $  $Date: 2004/02/09 07:38:49 $



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

Yf=  Y(~badIndex,:);
Xf=  X(~badIndex,:);

% see if whole sweeps removed by this check
% list of sweeps
OK= ismember(tn,testnum( Yf ));

