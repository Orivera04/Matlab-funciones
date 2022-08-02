function ExpCovariance = corr2cov(ExpSigma, ExpCorrC)
%CORR2COV Converts standard deviation and correlation to covariance.
%   Transforms the volatilities of N random processes and the degrees
%   of correlation between the processes into an N by N covariance matrix.
%
%   ExpCovariance = corr2cov(ExpSigma, ExpCorrC)
%
%   Inputs
%     ExpSigma : Vector of length N with the standard deviations of each process
%
%     ExpCorrC : N by N correlation coefficient matrix.  If ExpCorrC is not 
%     specified, the processes are assumed to be uncorrelated and the 
%     identity matrix is used.
%
%   Output
%     ExpCovariance  : N by N covariance matrix.  The (i,j) entry is
%     the expectation of the i'th fluctuation from the mean times the
%     j'th fluctuation from the mean.
% 
%   ExpCov(i,j) = ExpCorrC(i,j)*( ExpSigma(i)*ExpSigma(j) )
% 
%   See also EWSTATS, COV, CORRCOEF, STD, COV2CORR.

%   Author: J. Akao 11/17/97
%   Copyright 1995-2002 The MathWorks, Inc.  
%   $Revision: 1.7 $   $ Date: 1998/03/24 $

%-----------------------------------------------------------------
% Argument checking
% ExpSigma  [1 by N] standard deviations
% ExpCorrC  [N by N] correlation coefficients
% N         [scalar] number of processes
%-----------------------------------------------------------------
if nargin<1,
  error('Enter at least a vector of standard deviations')
else
  % Make ExpSigma a row vector
  ExpSigma = ExpSigma(:)';
  N = length(ExpSigma);
end

if nargin<2,
  ExpCorrC = eye(N);
end
if any( size(ExpCorrC)~=N ),
  error('Length of ExpSigma and size of ExpCorrC are mismatched')
end

%-----------------------------------------------------------------
% Scale the rows and columns of the correlation by the covariance
%-----------------------------------------------------------------
ExpCovariance = ExpCorrC.*(ExpSigma'*ExpSigma);

%-----------------------------------------------------------------
% end of function CORR2COV
%-----------------------------------------------------------------

