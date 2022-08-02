function PI = garchar(AR , MA , NumLags)
%GARCHAR Convert finite-order ARMA models to infinite-order AR models.
%   Given the coefficients of a univariate, stationary/invertible, finite-order
%   ARMA(R,M) model, compute the coefficients of the equivalent infinite-order 
%   AR model. The infinite-order AR coefficients are truncated to accommodate 
%   a user-specified number of lagged AR coefficients.
%
%   InfiniteAR  = garchar(AR , MA)
%   InfiniteAR  = garchar(AR , MA , NumLags)
%
%   Optional Inputs: NumLags
%
% Inputs:
%   AR - R-element vector of auto-regressive coefficients associated with the
%     lagged observations of a univariate return series modeled as a finite 
%     order, stationary, invertible ARMA(R,M) model.
%
%   MA - M-element vector of moving-average coefficients associated with the 
%     lagged innovations of a finite-order, stationary, invertible univariate 
%     ARMA(R,M) model.
%
% Optional Input:
%   NumLags - Number of lagged AR coefficients included in the approximation 
%     of the infinite-order AR representation. NumLags is an integer scalar 
%     and determines the length of the infinite-order AR output vector. If
%     empty or missing, the default is NumLags = 10.
%
% Outputs:
%   InfiniteAR - Vector of coefficients of the infinite-order AR representation 
%     associated with the finite-order ARMA model specified by the AR and MA 
%     input vectors. InfiniteAR is a vector of length NumLags. The j-th element
%     of InfiniteAR is the coefficient of the j-th lag of the input series in 
%     an infinite-order AR representation.
%
% Example: 
%   Let {y(t)} be the return series of interest and {e(t)} the innovations noise 
%   process. The input coefficient vectors AR and MA are specified exactly as
%   they would be read from the ARMA(R,M) model equation when solved for y(t): 
%
%       y(t) = AR(1)y(t-1) + ... + AR(R)y(t-R) + e(t) + 
%              MA(1)e(t-1) + ... + MA(M)e(t-M)
%
%   Note that the coefficients of y(t) and e(t) are assumed to be 1 and are NOT
%   part of the AR/MA input vectors. For the following ARMA(2,2) model,
%
%       y(t) = 0.5y(t-1) - 0.8y(t-2) + e(t) - 0.6e(t-1) + 0.08e(t-2)
%
%   AR = [0.5 -0.8] and MA = [-0.6 0.08]. The first 20 weights of the infinite
%   order AR approximation may be found as follows:
%
%       PI = garchar([0.5 -0.8] , [-0.6 0.08] , 20);
%
%   In theory, y(t) may now be approximated as an pure AR process:
%
%       y(t) = PI(1)y(t-1) + PI(2)y(t-2) + ... + PI(20)y(t-20) + e(t)
%
% See also GARCHMA, GARCHPRED, GARCHFIT.

%   Copyright 1999-2003 The MathWorks, Inc.   
%   $Revision: 1.9.4.1 $   $Date: 2003/05/08 21:45:19 $


% Reference:
%   Box, G.E.P., Jenkins, G.M., Reinsel, G.C., "Time Series Analysis: 
%     Forecasting and Control", 3rd edition, Prentice Hall, 1994
%
% Since the current-time-index coefficients of y(t) and e(t) are defined 
% to be 1, they are NOT included in the AR and MA input 'vectors'. This is 
% done simply to save time & effort when specifying parameters via the
% GARCHSET/GARCHGET user interface. 
%
% The j-th elements of the AR and MA input 'vectors' are the coefficients 
% of the j-th lag of the return series and innovations processes y(t-j) and 
% e(t-j), respectively. To maintain consistency, the j-th element of the 
% truncated infinite-order auto-regressive output vector, PI(j), is the 
% coefficient of the j-th lag of the observed return series, y(t-j), in the 
% infinite order representation of the input ARMA(R,M) process. See BJR, 
% Section 4.2.3, pages 106-109. Note that BJR refer to the infinite-order 
% AR coefficients as the 'PI weights'.
%
% Given the above discussion, the AR & MA input 'vectors' differ from the
% corresponding AR & MA 'polynomials' formally presented in time series 
% references such as BJR. The conversion from GARCH Toolbox 'vectors' to 
% the corresponding GARCH Toolbox 'polynomials' is as follows:
%
%       AR polynomial tested for stationarity  = [1 ; -AR]
%       MA polynomial tested for invertibility = [1 ;  MA]
%

if nargin < 2
   error('GARCH:garchar:UnspecifiedInput' , ' Insufficient number of inputs.');
end

rowAR  =  logical(0);

if ~isempty(AR)
   if prod(size(AR)) == length(AR)         % Check for a vector.
      rowAR  =  (size(AR,1) == 1) & (prod(size(AR)) > 1);
   else
      error('GARCH:garchar:NonVectorAR' , ' Auto-regressive coefficients ''AR'' must be a vector.');
   end

   AR          =  AR(:);
   eigenValues =  roots([1 ; -AR]);

   if any(abs(eigenValues) >= 1) 
      error('GARCH:garchar:NonStationary' , ' ''AR'' polynomial must be stationary.');
   end
end

if ~isempty(MA)
   if prod(size(MA)) ~= length(MA)        % Check for a vector.
      error('GARCH:garchar:NonVectorMA' , ' Moving-average coefficients ''MA'' must be a vector.');
   end

   MA          =  MA(:);
   eigenValues =  roots([1 ; MA]);

   if any(abs(eigenValues) >= 1) 
      error('GARCH:garchar:NonInvertible' , ' ''MA'' polynomial must be invertible.');
   end
end

if (nargin >= 3) & ~isempty(NumLags)
   if prod(size(NumLags)) > 1
      error('GARCH:garchar:NonScalar' , ' ''NumLags'' must be a scalar.');
   end
   if (round(NumLags) ~= NumLags) | (NumLags <= 0)
      error('GARCH:garchar:NonPositiveInteger' , ' ''NumLags'' must be a positive integer.');
   end
else
   NumLags  =  10;   % Set default
end

%
% Compute infinite-order AR coefficients by deconvolution of the AR & MA 
% vectors. Equivalently, perform a polynomial division to determine the 
% impulse response of the linear ARMA filter.
%
% As a sanity check, once the infinite-order AR weights are computed, the
% original finite-order AR coefficients can be recovered via the MATLAB 
% CONV function in the following manner:
%
%    PHI = conv([1 ; -PI(:)] , [1 ; MA]); 
%    PHI = PHI(1:R+1);
%
% Then , PHI should equal [1 ; -AR(:)].
%

R   =  length(AR);     % AR order.
M   =  length(MA);     % AR order.
PI  =  deconv([1 ; -AR ; zeros(NumLags+R+M,1)] , [1 ; MA]);
PI  = -PI(2:NumLags+1);

%
% Re-format output for compatibility with the AR input. 
%

if rowAR
   PI  =  PI(:).';
end
