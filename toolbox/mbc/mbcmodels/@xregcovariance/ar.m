function [w,bnds,A,b,nl]= ar(c,yhat,X,varargin);
% COVMODEL/AR Auto-regressive model 
% 
% [w,bnds]= ar(c,yhat,X,varargin);
%    Inputs 
%      c     covmodel object
%      yhat  length(yhat) defines how big to make the covariance matrix
%            other inputs ignored
%    Outputs
%       w    covariance matrix
%  This file forms the covariance matrix using the yule-walker equations

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:00 $


% object fields c.cparams = [A1 A2 .. AN]

if nargin==1
   w= 1;
   bnds=[];
   A=[];b=[];
   nl=[];
   switch length(c.cparam)
   case 1
      % simple bounds for ar1
      bnds=[-1 1];
   case 2
      % use linear constraints for ar2
      % these come from discrete Routh Hurwitz conditions
      bnds=zeros(0,2);
      A= [-1 -1;0 1;1 -1];
      b= [1 1 1]'-0.001;
   otherwise
      % use nonlinear constrants based on roots
      nl= abs(roots([1 c.cparam(:)']))-1;
   end
else
   nr= length(c.cparam);
   % we want to find correlations r
   % where toeplitz([1 r])*a = r
   
   
   % [1      0   0   ...     ]
   % [-A1    1   0           ]
   % [-A2  -A1   1   0       ]
   % [                       ]
   % [                  1  0 ]
   % [-An-1 -An-2 .... -A1 1 ]
	if nr==1
		T=1;
	else
        ws= warning('off','MATLAB:toeplitz:DiagonalConflict');
		T= toeplitz([1 -c.cparam(1:end-1)],zeros(1,nr));
        warning(ws.state,'MATLAB:toeplitz:DiagonalConflict');
	end
   
   if nr>1
      % [A2 A3 ...    An 0 ]
      % [A3 A4     An  0 0 ]
      % [A4    An   0      ]
      % [   An  0          ] 
      % [An  0             ]
      % [ 0  0  0  ...     ] 
      T =  T - hankel([c.cparam(2:end) 0]);
   end 
   ny= length(yhat);
   nx = round((X(end,1)-X(1,1))/c.Ts)+1;
   
   if nx>=nr
      r= zeros(nx,1);
      % solve Tr = a to obtain correlations
      r(1:nr)= T\c.cparam(:);
      for i=nr+1:nx
         % recurse to get the rest of the parameters
         r(i)= c.cparam*r(i-nr:i-1);
      end
   else
      % don't need all the correlations
      r= T\c.cparam(:);
      r= r(1:nr);
   end
   
   % now calculate the covariance matrix 
   w= toeplitz([1;r(1:end-1)]);
   
   if nx~=ny
      % get rid of missing points
      xind= round((X(:,1)-X(1,1))/c.Ts + 1);
      ok= intersect(1:nx,xind);
      w= w(ok,ok);
   end
end
