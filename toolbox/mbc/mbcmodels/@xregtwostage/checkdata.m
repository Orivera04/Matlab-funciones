function [Xgc,Yrf,W,varargout] = checkdata(TS,Xg,Yrf,Sigma,varargin);
%CHECKDATA

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:59:21 $

% code global variables variable
Xgc    = gcode(TS,Xg);
% Global Models 
Models = TS.Global;

Ns= size(Yrf,1);  % Number of sweeps
Nf= size(Yrf,2);  % Number of Response features



% Delete responses only if all features are bad 
% or the variance is non-finite
bdSig=  squeeze(any(any(~isfinite(Sigma),1),2));
if all(bdSig)
   Sigma(:)=0;
   bdSig= false(Ns,1);
end
% turn SIGMA into sparse matrix
W= spblkdiag(Sigma);

% this is the setting for the old predict mode
AllBad= all(isnan(Yrf),2) | bdSig;

BadTrans= false(Ns,1);

G0= zeros(Nf);

lossdf= 0;
for i= 1:Nf
   
   m= Models{i}; 
   
   % if bad data and not all response features are bad for that point 
   % replace data estimate with model from univariate model
   bdy= isnan(Yrf(:,i)) & ~AllBad;
   
   % natural units  ytrans gets done later
   Yrf(bdy,i) = m(Xgc(bdy,:));
	lossdf= lossdf+sum(bdy);
   
   f= get(m,'ytrans');
   if ~isempty(f)
      % Box Cox Transformation f(y)
      % sym and inline objects to calculate f'(y)
      gv= ydiff(m,Yrf(:,i));
      % deal with any non-finite results from transform
      BadTrans(~isfinite(gv))= true;
      if ~isreal(gv)
         % deal with any complex results
         BadTrans(imag(gv)~=0)= true;
			gv= real(gv);
      end
      % 
      
      G= speye( size(W) );
      % Index to diagonal Sigma elements
      Sind=i:Nf:size(W,1);
      Gind= Sind+ (Sind-1)*size(W,1);
      G(Gind)=gv;
      % Sigma = f'(y)*(dg(y)/dq)/(J'J)*(dg(y)/dq)'*f'(y)'
      W=G*W*G;
      Yrf(:,i)= ytrans(m,Yrf(:,i));
      if ~isreal(Yrf(:,i))
         % deal with any complex results
         BadTrans(imag(Yrf(:,i))~=0)= true;
      end
   end
end


% Find Bad Data
bd= any(~isfinite(Yrf),2) | BadTrans | bdSig ;
% Bad data for Z and W
bdW= ((bd(:,ones(Nf,1))')~=0);


Yrf(bd,:)=[];
Xgc(bd,:)=[];
W= W(~bdW(:),~bdW(:));



OK= ~bd;
if length(varargin)>0
   varargout= [varargin,{OK,lossdf}];
else
   varargout= {OK,lossdf};
end
