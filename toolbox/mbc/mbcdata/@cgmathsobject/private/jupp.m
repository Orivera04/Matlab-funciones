function sigma = jupp(X,a,b)
% JUPP
%  
% This function will apply Jupp's transformation to 
% a knot sequence.
%
% Jupp's transformation is defined by:
%
%                ( (knots(i+1) - knots(i))  )
% sigma(i) = log (  ----------------------  )
%                ( (knots(i) - knots(i-1))  )
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:50:10 $

ext= ones(1,size(X,2));

knots=[a*ext ; X; b*ext];

h = diff(knots);

hi= h(1:end-1,:);
hiplus1=h(2:end,:);

sigma = ((hiplus1./hi));