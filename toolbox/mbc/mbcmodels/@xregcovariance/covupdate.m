function c= covupdate(c,D)
% COVMODEL/COVUPDATE update unstructured covariance 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:46:10 $


% do some scaling
sd= diag(D);
sd(sd<=0)= 1;
sd= sqrt(sd);
s= diag(1./sd);
D1= s*D*s;
[ch,p]= chol(D1);
if p
   % rank problems - just use the diagional
   ch= diag(sd);
else
   ch=ch*diag(sd);
end
c.cparam = ch( triu(ones(size(D)))~=0 );

