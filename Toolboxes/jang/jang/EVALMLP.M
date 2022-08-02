function [X2, X1] = evalmlp(input, W1, W2)
% EVALMLP Evaluation an MLP with hyperbolic tangent activation.
%	output = evalmlp(input, W1, W2)
%
%	See also MLPDM1 and MLPDM2.

% Roger Jang, Feb 7, 1999

X1 = tanh([X0 ones(size(X0,1),1)]*W1);	% Output of layer 1 (hidden layer)
X2 = tanh([X1 ones(size(X1,1),1)]*W2);	% Output of layer 2 (output layer)
