function knots= invjupp(m,sigma,Tgt)
% xreg3xspline/INVJUPP inverse jupp transformation
% 
% This function will undo Jupp's transformation.
% The routine is:
% 
% p(i) = e^sigma(i)
% Z = 1 + p(1) + p(1)p(2) + ... +p(1)p(2)..p(N)
% h(1) = (b-a)/Z
% h(i+1)=p(i)h(i)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:28 $


%-------------------------------------------------------------------------------
% undo Jupp's transformation scheme
%-------------------------------------------------------------------------------
sz= size(sigma);
Z=ones(sz(1),1);

if nargin<3
	Tgt=gettarget(m,m.splinevar);
end

a=Tgt(1);
b=Tgt(2);;

knots=zeros(sz);

cp= (cumprod(sigma));
Z =  sum(cp)+1;

h=(b-a)./Z;

knots(1) =h+a;
knots(2:end)= knots(1) + cumsum(cp(1:end-1)*h);

