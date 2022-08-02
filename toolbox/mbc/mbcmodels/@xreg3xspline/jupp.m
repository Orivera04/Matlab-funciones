function sigma = jupp(m,knots,Tgt)
% xreg3xspline/JUPP transform knot sequence into jupp parameters
%
%
% This function will apply Jupp's transformation to 
% a knot sequence.
%
% Jupp's transformation is defined by:
%
%                ( (knots(i+1) - knots(i))  )
% sigma(i) = log (  ----------------------  )
%                ( (knots(i) - knots(i-1))  )

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:29 $


if nargin==1;
   knots= m.knots(:);
end

if nargin<3
	Tgt=gettarget(m,m.splinevar);
end

a=Tgt(1);
b=Tgt(2);

ext= ones(1,size(knots,2));

knots=[a*ext ; knots; b*ext];

h = diff(knots);

hi= h(1:end-1,:);
hiplus1=h(2:end,:);

sigma = ((hiplus1./hi));