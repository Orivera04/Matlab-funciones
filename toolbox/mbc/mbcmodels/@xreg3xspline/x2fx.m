function FX= x2fx(m,X)
% xreg3xspline/X2FX Regression matrix for xreg3xspline object
%
% FX= x2fx(m,X)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:44:26 $




% Check size of X matrix
if size(X,2)~=length(m.reorder)
   error(sprintf('An Nx%d matrix is required for evaluating',length(m.reorder)));
end

% reorder x variable so spline is first
reorder= [m.splinevar find(1:size(X,2) ~= m.splinevar)];
X= X(:,reorder);

% Calculate PHI functions for first variable
Tgt=gettarget(m,m.splinevar);
onek= ones(m.poly_order+1,1);
k= [Tgt(1,onek),m.knots(:)',Tgt(1,2*onek)];

PHI = phi_calc(k,m.poly_order,X(:,1));

Ns = size(PHI,2);
N  = order(m.cubic);

% call X2FX for xregcubic
if size(X,2)>1
   FX3= x2fx(m.cubic,X(:,2:end));
else
   FX3= zeros(size(X,1),0);
end
Nfx= size(m,1);

FX= zeros(size(FX3,1),Nfx);

pos=1;  % index to xregcubic FX3
% PHI Terms
FX(:,1:Ns) = PHI;
fxpos= Ns+1;
for i=1:N(1)
   % 1st order terms
   pos=pos + 1;
   if m.interact>=1
      % PHI * Xi terms
      for k= 1:Ns;
         FX(:,fxpos+k-1)= PHI(:,k).*FX3(:,pos);
      end
      fxpos= fxpos+Ns;
   else
      % Xi * [1 X1 X1^2] terms 
      FX(:,fxpos)= FX3(:,pos); 
      FX(:,fxpos+1)= X(:,1).*FX3(:,pos); 
      FX(:,fxpos+2)= X(:,1).^2.*FX3(:,pos); 
      fxpos= fxpos+3;
   end
   for j=i:N(2)
      % 2nd order terms
      pos=pos + 1;
      if m.interact>=2
         % Xi * Xj * PHI terms
         for k= 1:Ns;
            FX(:,fxpos+k-1)= PHI(:,k).*FX3(:,pos);
         end
         fxpos= fxpos+Ns;
      else
         % Xi * Xj * [1 X1] terms 
         FX(:,fxpos)= FX3(:,pos); 
         FX(:,fxpos+1)= X(:,1).*FX3(:,pos); 
         fxpos= fxpos+2;
      end
      for k=j:N(3)
         % Xi * Xj * Xk  terms 
         pos=pos+1;
         FX(:,fxpos)= FX3(:,pos); 
         fxpos= fxpos+1;
      end
   end
end
