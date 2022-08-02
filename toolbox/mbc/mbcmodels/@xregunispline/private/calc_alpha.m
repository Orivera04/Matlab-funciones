function alpha=calc_alpha(knot_values,a,b,p)
%CALC_ALPHA

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:00:28 $

% A function to calculate the scaling parameter for the penalty function
%
% knot_values	vector of knots
% a 				is the lower bound for the covariate interval
% b 				is the upper bound for the covariate interval
% p				multiplier at knot_values

k=[a; knot_values(:); b];	  % augmented knot sequence with lower and upper bound
h=diff(k)/(b-a);					% calculate Jupp style parameters


div= sum(log((length(knot_values)+1)*h));
if div < -0.01
   % calculate penalty
   alpha= (1-p)/div;	
else
   alpha= (1-p)/0.01;
end
