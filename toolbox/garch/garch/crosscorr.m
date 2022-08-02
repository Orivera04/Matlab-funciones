function varargout = crosscorr(Series1 , Series2 , nLags , nSTDs)
%CROSSCORR Compute or plot sample cross-correlation function.
%   Compute or plot the sample cross-correlation function (XCF) between
%   univariate, stochastic time series. When called with no output arguments, 
%   CROSSCORR displays the XCF sequence with confidence bounds.
%
%   [XCF, Lags, Bounds] = crosscorr(Series1 , Series2)
%   [XCF, Lags, Bounds] = crosscorr(Series1 , Series2 , nLags , nSTDs)
%
%   Optional Inputs: nLags , nSTDs
%
% Inputs:
%   Series1 - Vector of observations of the first univariate time series for 
%     which the sample XCF is computed or plotted. The last row of Series1 
%     contains the most recent observation.
%
%   Series2 - Vector of observations of the second univariate time series for 
%     which the sample XCF is computed or plotted. The last row of Series2 
%     contains the most recent observation.
%
% Optional Inputs:
%   nLags - Positive, scalar integer indicating the number of lags of the XCF 
%     to compute. If empty or missing, the default is to compute the XCF at 
%     lags 0, +/-1, +/-2,...,+/-T, where T is the smaller of 20 or one less 
%     than the length of the shortest series.
%
%   nSTDs - Positive scalar indicating the number of standard deviations of the 
%     sample XCF estimation error to compute assuming Series1/Series2 are 
%     uncorrelated. If empty or missing, default is nSTDs = 2 (i.e., approximate
%     95% confidence interval).
%
% Outputs:
%   XCF - Sample cross correlation function between Series1 and Series2. XCF 
%     is a vector of length 2*nLags + 1 corresponding to lags 0, +/-1, +/-2,
%     ... +/-nLags. The center element of XCF contains the zeroth lag cross
%     correlation. XCF will be a row (column) vector if Series1 is a row 
%     (column) vector.
%
%   Lags - Vector of lags corresponding to XCF (-nLags to +nLags).
%
%   Bounds - Two element vector indicating the approximate upper and lower
%     confidence bounds assuming the input series are completely uncorrelated.
%
% Example:
%   Create a random sequence of 100 Gaussian deviates, and a delayed version 
%   lagged by 4 samples. Then see the XCF peak at the 4th lag:
%
%     randn('state',100)               % Start from a known state.
%     x           = randn(100,1);      % 100 Gaussian deviates ~ N(0,1).
%     y           = lagmatrix(x , 4);  % Delay it by 4 samples.
%     y(isnan(y)) = 0;                 % Replace NaN's with zeros.
%     crosscorr(x,y)                   % It should peak at the 4th lag.
%
% See also AUTOCORR, PARCORR, FILTER.

%   Copyright 1999-2003 The MathWorks, Inc.   
%   $Revision: 1.6.2.1 $  $Date: 2003/05/08 21:45:16 $

if nargin < 2
   error('GARCH:crosscorr:UnspecifiedInput' , ' ''Series1'' and ''Series2'' are both required.');
end

%
% Ensure the sample data are VECTORS.
%

[rows , columns]  =  size(Series1);

if ((rows ~= 1) & (columns ~= 1)) | (rows*columns < 2)
   error('GARCH:crosscorr:NonVectorSeries1' , ' Input ''Series1'' must be a vector.');
end

[rows , columns]  =  size(Series2);

if ((rows ~= 1) & (columns ~= 1)) | (rows*columns < 2)
   error('GARCH:crosscorr:NonVectorSeries2' , ' Input ''Series2'' must be a vector.');
else

end

rowSeries   =  size(Series1,1) == 1;

Series1     =  Series1(:);                              % Ensure a column vector
Series2     =  Series2(:);                              % Ensure a column vector

n           =  min(length(Series1) , length(Series2));  % Sample size.
defaultLags =  20;                                      % BJR recommend about 20 lags.

%
% Ensure the number of lags, nLags, is a positive 
% integer scalar and set default if necessary.
%

if (nargin >= 3) & ~isempty(nLags)
   if prod(size(nLags)) > 1
      error('GARCH:crosscorr:NonScalarLags' , ' Number of lags ''nLags'' must be a scalar.');
   end
   if (round(nLags) ~= nLags) | (nLags <= 0)
      error('GARCH:crosscorr:NonPositiveInteger' , ' Number of lags ''nLags'' must be a positive integer.');
   end
   if nLags > (n - 1)
      error('GARCH:crosscorr:InputTooLarge' , ' Number of lags ''nLags'' must not exceed ''Series'' length - 1.');
   end
else
   nLags  =  min(defaultLags , n - 1);
end

%
% Ensure the number of standard deviations, nSTDs, is a positive 
% scalar and set default if necessary.
%

if (nargin >= 4) & ~isempty(nSTDs)
   if prod(size(nSTDs)) > 1
      error('GARCH:crosscorr:NonScalarSTDs' , ' Number of standard deviations ''nSTDs'' must be a scalar.');
   end
   if nSTDs < 0
      error('GARCH:crosscorr:NegativeSTDs' , ' Number of standard deviations ''nSTDs'' must be non-negative.');
   end
else
   nSTDs =  2;     % Default is 2 standard errors (95% condfidence interval).
end

%
% The FILTER command could be used to compute the XCF, but FFT-based 
% computation is significantly faster for large data sets.
%

Series1 =  Series1 - mean(Series1);
Series2 =  Series2 - mean(Series2);
L1      =  length(Series1);
L2      =  length(Series2);

if L1 > L2
   Series2(L1)  =  0;
elseif L1 < L2
   Series1(L2)  =  0;
end

nFFT   =  2^(nextpow2(max([L1 L2])) + 1);
F      =  fft([Series1(:) Series2(:)] , nFFT); 

ACF1   =  ifft(F(:,1) .* conj(F(:,1)));
ACF2   =  ifft(F(:,2) .* conj(F(:,2)));

XCF    =  ifft(F(:,1) .* conj(F(:,2)));
XCF    =  XCF([(nLags+1:-1:1)  (nFFT:-1:(nFFT-nLags+1))]);
XCF    =  real(XCF) / (sqrt(ACF1(1)) * sqrt(ACF2(1)));

Lags   =  [-nLags:nLags]';
bounds =  [nSTDs ; -nSTDs] / sqrt(n);


if nargout == 0                     % Make plot if requested.

%
%  Plot the sample XCF.
%
   lineHandles  =  stem(Lags , XCF , 'filled' , 'r-o');
   set   (lineHandles(1) , 'MarkerSize' , 4)
   grid  ('on')
   xlabel('Lag')
   ylabel('Sample Cross Correlation')
   title ('Sample Cross Correlation Function (XCF)')
   hold  ('on')
%
%  Plot the confidence bounds under the hypothesis 
%  that the underlying series are uncorrelated.
%
   a  =  axis;

   plot([a(1) a(1) ; a(2) a(2)] , [bounds([1 1]) bounds([2 2])] , '-b');

   plot([a(1) a(2)] , [0 0] , '-k');
   hold('off')

else

%
%  Re-format outputs for compatibility with the SERIES1 input. When SERIES1 is
%  input as a row vector, then pass the outputs as a row vectors; when SERIES1
%  is a column vector, then pass the outputs as a column vectors.
%
   if rowSeries
      XCF     =  XCF.';
      Lags    =  Lags.';
      bounds  =  bounds.';
   end

   varargout  =  {XCF , Lags , bounds};

end
