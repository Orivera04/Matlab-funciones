function fx = feedbackx2fx( m, x, order, delay )
%XREGLINEAR/FEEDBACKX2FX   Regression matrix with feedback
%   FEEDBACKX2FX(M,X,ORDER,DELAY) is the regression matrix for the model M at 
%   the points X and with the output feedback with the given dynamic ORDER and 
%   DELAY. This differs from DYNX2FX in that the genuine inputs should all have 
%   been expanded and the initial conditions are correctly placed in X and it 
%   is only the output that needs to be fixed up.
%
%   Note that ORDER and DELAY only apply to the feedback, the dynamic order and 
%   delay of the other inputs shouls already be taken care of inside of X.
%
%   Need the whole ORDER and DELAY vectors to determine the maximum delay and 
%   hence the first response that can be predicted by the model.
%
%   See also XREGLINEAR/X2FX, XREGLINEAR/DYNX2FX, XREGMODEL/FEEDBACKEVAL.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.1 $  $Date: 2004/02/09 07:49:29 $

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

if isa(x,'sweepset')
   Ns= size(x,3);
   FX= cell(Ns,1);
   for i=1:Ns
      FX{i}= i_feedbackx2fx( m, x{i}, order, delay );
   end
   fx= cat(1,FX{:});
else
   fx = i_feedbackx2fx( m, x, order, delay );
end


function fx = i_feedbackx2fx( m, x, order, delay )


if nargin <= 2 | order(end) < 1,
    % no feedback, ordinary evaluation will work
    fx = x2fx( m, x );
    return
end
if nargin < 4,
    delay = ones( size( order ) );
elseif delay(end) < 1,
    error( [ 'Feedback delay, i.e., DELAY(end), must be greater than or ' ...
            'equal to 1' ] );
end

neval = size( x, 1 );           % number of evaluation points
md = max( order + delay  ) - 1; % max delay
order = order(end);             % output order
delay = delay(end);             % output delay
opdm1 = order + delay - 1;      % o(rder) p(lus) d(elay) m(inus) (one)

if order + delay > neval,
    error( 'Insufficient points for dynamic evaluation' )
end

y = zeros( neval, 1 );
y(1:md) = x(1:md,end-order+1); % initial conditions

fx = x2fx( m, x(1:md,:) );
fx = [ fx; zeros( neval - md, size( fx, 2 ) ) ];

beta = double( m );

ind = size( x, 2 ) - order + 1:size( x, 2 );
for i = order + delay:neval,
    x(i,ind) = y(i-delay:-1:i-opdm1)';

    fx(i,:) = x2fx( m, x(i,:) );
    
    % need to evaluate the model to get the feedback terms
    %% y(i) = evalsingle( m, x(i,:) );
    y(i) = fx(i,:) * beta;
end

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
