function ugarchplot(u , h)
%UGARCHPLOT Plots univariate GARCH(P,Q) time series processes.
%
%   ugarchplot(U , H)
%
%   Inputs:
%     U: Single column vector of innovations, representing a mean-zero,
%        discrete-time stochastic process. The innovations time series U is 
%        assumed to follow a GARCH(P,Q) process (see Notes below). 
%
%     H: Single column vector of the conditional variance corresponding 
%        to the innovations vector U. Note that U and H are the same length, and 
%        form a 'matching' pair of vectors. To model the GARCH(P,Q) process, the 
%        conditional variance time series, H(t), must be constructed (see Notes 
%        below). Thus, H(t) represents the time series inferred from the 
%        innovations time series vector U(t). 
%
%   Output:
%      UGARCHPLOT plots the innovations time series column vector U, and the
%      square root of the corresponding conditional variance column vector H.
%      Since the purpose of this function is to allow visual comparison of the
%      innovations time series U and the corresponding conditional standard 
%      deviation, U and H must be column vectors of the same length.
%
%      The plot is 2-tiered: the top plot is the innovations time series U; the
%      bottom plot is the corresponding conditional standard deviation, which is
%      just the square root of H. Note that although the conditional variance H 
%      is the input, the square root of H is what appears in the bottom plot. 
%      Accepting the conditional variance H as an input, rather than the standard 
%      deviation of H, is just to maintain consistency with the output arguments 
%      of the univariate simulation function UGARCHSIM.
%
%   Notes:
%     The time-conditional variance, H(t), of a GARCH(P,Q) process is modeled 
%     as follows:
%
%       H(t) = Kappa + Alpha(1)*H(t-1) + Alpha(2)*H(t-2) +...+ Alpha(P)*H(t-P)
%                    + Beta(1)*U^2(t-1)+ Beta(2)*U^2(t-2)+...+ Beta(Q)*U^2(t-Q)
%
%     Note that U is vector of innovations representing a mean-zero, discrete-time
%     stochastic process. Although H is generated via the equation above, U and H
%     are related as follows:
%    
%       U(t) = sqrt(H(t))*v(t), where {v(t)} is an i.i.d. sequence.
%
%   See also UGARCHPRED, UGARCHSIM, UGARCH.

% Author(s): R.A. Baker, 04/29/98
% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.7 $   $Date: 2002/04/14 21:42:23 $

%
% Ensure we have single, univariate time series COLUMN vectors of matching size.
% And ensure that all elements of H are positive.
%

if nargin ~= 2
   error(' Not enough input arguments.') , return
end

if size(u,2) > 1
   error(' Innovations time series U must be a single column vector.') , return
elseif isempty(u)
   error(' Innovations time series U is empty.') , return
end

if size(h,2) > 1
   error(' Conditional variance time series H must be a single column vector.') , return
elseif any(h < 0)
   error(' All samples of the conditional variance time series H must be positive.') , return
elseif isempty(h)
   error(' Conditional variance time series H is empty.') , return
end

if length(u) ~= length(h)
   error(' U and H must be column vectors of the same length.') , return
end


subplot(2 , 1 , 1) , plot(u , 'red-') , grid
xlabel ('Sample Index')
ylabel ('Innovations')
title  ('Simulated Innovations Time Series')

subplot(2 , 1 , 2) , plot(sqrt(h) , 'blue-') , grid
xlabel ('Sample Index')
ylabel ('Standard Deviation')
title  ('Conditional Standard Deviation of the Innovations Time Series')

