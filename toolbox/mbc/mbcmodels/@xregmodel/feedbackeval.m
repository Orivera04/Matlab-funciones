function [y, x] = feedbackeval( m, x, order, delay )
%XREGMODEL/FEEDBACKEVAL   Model evaluation with feedback
%   FEEDBACKEVAL(M,X,ORDER,DELAY) evaluates the model M at the points X and 
%   with the output feedback with the given dynamic ORDER and DELAY. This 
%   differs from DYNEVAL in that the genuine inputs should all have been 
%   expanded and the initial conditions are correctly placed in X and it is 
%   only the output that needs to be fixed up.
%
%   [Y, X] = FEEDBACKEVAL(...) also returns the evaluation matrix X with the 
%   feedback updated with the new model values.
%
%   Note that ORDER and DELAY only apply to the feedback, the dynamic order and 
%   delay of the other inputs shouls already be taken care of inside of X.
%
%   See also XREGMODEL/DYNEVAL.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:51:53 $



md = max( order + delay ); % max delay                    FIX ME!!!
order = order(end);        % output order
delay = delay(end);        % output delay

if nargin <= 2 | order < 1,
    % no feedback, ordinary evaluation will work
    y = eval( m, x );
    return
end

if nargin < 4,
    delay = 1;
elseif delay < 1,
    error( 'DELAY must be greater than 1' );
end

order = floor( order );
delay = floor( delay );
neval = size( x, 1 );

if order + delay > neval,
    error( 'Insufficient points for dynamic evaluation' )
end

y = zeros( neval, 1 );
opdm1 = order + delay - 1; % order plus delay minus one
y(1:opdm1) = x(1:opdm1,end-order+1); % initial conditions
ind = size( x, 2 ) - order + 1:size( x, 2 );
for i = order + delay:neval,
    x(i,ind) = y(i-delay:-1:i-opdm1)';
    y(i) = evalsingle( m, x(i,:) );
end

%   If order = p and delay = q,
%   
%      y(k-q-p+1)    y(1)     -+
%      ...           ...       |  p feedback terms
%      y(k-q)        y(p)     -+
%      ...           ...
%      y(k)          y(p+q)    <-- first output
%      y(k+1)        y(p+q+1)
%      y(k+2)        y(p+q+2)
%
%   Evaluation point matrix
%
%     [ .. x part .. | y(k-q) y(k-q-1) ... y(k-q-p+1) ]
%                      |                            |
%                      +----------------------------+
%                            p feedback terms

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
