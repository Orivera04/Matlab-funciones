function PSI = garchma(AR , MA , NumLags)
%GARCHMA Convert finite-order ARMA models to infinite-order MA models.
%   Given the coefficients of a univariate, stationary/invertible finite-order 
%   ARMA(R,M) model, compute the coefficients of the equivalent infinite-order 
%   moving average model. The infinite-order MA coefficients are truncated to 
%   accommodate a user-specified number of lagged MA coefficients. This function
%   is particularly useful for calculating the standard errors of minimum mean
%   square error forecasts of univariate ARMA models. 
%
%   InfiniteMA = garchma(AR , MA)
%   InfiniteMA = garchma(AR , MA , NumLags)
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
%   NumLags - Number of lagged MA coefficients included in the approximation 
%     of the infinite-order MA representation. NumLags is an integer scalar 
%     and determines the length of the infinite-order MA output vector. If
%     empty or missing, the default is NumLags = 10.
%
% Outputs:
%   InfiniteMA - Vector of coefficients of the infinite-order MA representation 
%     associated with the finite-order ARMA model specified by the AR and MA 
%     input vectors. InfiniteMA is a vector of length NumLags. The j-th element
%     of InfiniteMA is the coefficient of the j-th lag of the innovations noise
%     sequence in an infinite-order MA representation.
%
% Example: 
%   Let {y(t)} be the return series of interest and {e(t)} the innovations noise 
%   process. The input coefficient vectors AR and MA are specified exactly as
%   they would be read from the ARMA(R,M) model equation when solved for y(t): 
%
%       y(t) = AR(1)y(t-1) + ... + AR(R)y(t-R) + e(t) + 
%              MA(1)e(t-1) + ... + MA(M)e(t-M)
%
%   Note that the coefficients of y(t) and e(t) are assumed to be 1. For the 
%   following ARMA(2,2) model,
%
%       y(t) = 0.5y(t-1) - 0.8y(t-2) + e(t) - 0.6e(t-1) + 0.08e(t-2)
%
%   AR = [0.5 -0.8] and MA = [-0.6 0.08]. Suppose a forecast horizon of 10 
%   periods is desired. To obtain probability limits for these forecasts, the
%   first 10 - 1 = 9 weights of the infinite order MA approximation, PSI(j), 
%   are needed and found as follows:
%
%       PSI = garchma([0.5 -0.8] , [-0.6 0.08] , 9);
%
%   In theory, y(t) can now be approximated as an pure MA process:
%
%       y(t) = e(t) + PSI(1)e(t-1) + PSI(2)e(t-2) + ... + PSI(9)e(t-9)
%
% See also GARCHAR, GARCHPRED.

%   Copyright 1999-2003 The MathWorks, Inc.   
%   $Revision: 1.9.4.1 $   $Date: 2003/05/08 21:45:27 $


% Reference:
%   Box, G.E.P., Jenkins, G.M., Reinsel, G.C., "Time Series Analysis: 
%     Forecasting and Control", 3rd edition, Prentice Hall, 1994
%
% Since the current-time-index coefficients of y(t) and e(t) are defined 
% to be 1, they are NOT included in the AR and MA input 'vectors'. This is 
% done simply to save time & effort when specifying parameters via the
% GARCHSET/GARCHGET user interface. 
%
% The j-th elements of the AR and MA input 'vectors' are the coefficients of
% the j-th lag of the return series and innovations processes y(t-j) and 
% e(t-j), respectively. To maintain consistency, the j-th element of the 
% truncated infinite-order moving-average output vector, PSI(j), is the 
% coefficient of the j-th lag of the innovations process, e(t-j), in the 
% infinite order representation of the input ARMA(R,M) process. See BJR, 
% Section 5.2.2, pages 139-141. Note that BJR refer to the infinite-order 
% MA coefficients as the 'PSI weights'.
%
% Given the above discussion, the AR & MA input 'vectors' differ from the
% corresponding AR & MA 'polynomials' formally presented in BJR time series 
% reference. The conversion from GARCH Toolbox 'vectors' to the corresponding
% GARCH Toolbox 'polynomials' is as follows:
%
%       AR polynomial tested for stationarity  = [1 ; -AR]
%       MA polynomial tested for invertibility = [1 ;  MA]
%

if nargin < 2
   error('GARCH:garchma:UnspecifiedInput' , ' Insufficient number of inputs.');
end

rowAR  =  logical(0);

if ~isempty(AR)
   if prod(size(AR)) == length(AR)         % Check for a vector.
      rowAR  =  (size(AR,1) == 1) & (prod(size(AR)) > 1);
   else
      error('GARCH:garchma:NonVectorAR' , ' Auto-regressive coefficients ''AR'' must be a vector.');
   end

   AR          =  AR(:);
   eigenValues =  roots([1 ; -AR]);

   if any(abs(eigenValues) >= 1) 
      error('GARCH:garchma:NonStationary' , ' ''AR'' polynomial must be stationary.');
   end
end

if ~isempty(MA)
   if prod(size(MA)) ~= length(MA)         % Check for a vector.
      error('GARCH:garchma:NonVectorMA' , ' Moving-average coefficients ''MA'' must be a vector.');
   end

   MA          =  MA(:);
   eigenValues =  roots([1 ; MA]);

   if any(abs(eigenValues) >= 1) 
      error('GARCH:garchma:NonInvertible' , ' ''MA'' polynomial must be invertible.');
   end
end

if (nargin >= 3) & ~isempty(NumLags)
   if prod(size(NumLags)) > 1
      error('GARCH:garchma:NonScalar' , ' ''NumLags'' must be a scalar.');
   end
   if (round(NumLags) ~= NumLags) | (NumLags <= 0)
      error('GARCH:garchma:NonPositiveInteger' , ' ''NumLags'' must be a positive integer.');
   end
else
   NumLags  =  10;   % Set default
end

%
% Compute infinite-order MA coefficients by deconvolution (i.e., 
% polynomial division) of the AR & MA vectors.
%
% As a sanity check, once the infinite-order MA weights are computed, the
% original finite-order MA coefficients can be recovered via the MATLAB 
% CONV function in the following manner:
%
%    THETA = conv([1 ; -AR(:)] , [1 ; PSI(:)]); 
%    THETA = THETA(1:M+1);
% 
% Then , THETA should equal [1 ; MA(:)].
%

M    =  length(MA);    % MA order.
R    =  length(AR);    % MA order.
PSI  =  deconv([1 ; MA ; zeros(NumLags+R+M,1)] , [1 ; -AR]);
PSI  =  PSI(2:NumLags+1);

%
% Re-format output for compatibility with the AR input. 
%

if rowAR
   PSI  =  PSI(:).';
end
