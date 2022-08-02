function [ExpSigma, ExpCorrC] = cov2corr(ExpCovariance)
%COV2CORR Converts covariance to standard deviation and correlation coefficient.
%   Computes the volatilities of N random processes and the degree of
%   correlation between the processes.  
%
%   [ExpSigma, ExpCorrC] = cov2corr(ExpCovariance)
%
%   Input:
%     ExpCovariance: N by N covariance matrix, e.g. from COV or EWSTATS
%
%   Outputs:
%     ExpSigma     : 1 by N vector with the standard deviations of each process
%
%     ExpCorrC     : N by N matrix of correlation coefficients.  The
%     entries of ExpCorrC range from 1 (completely correlated) to -1
%     (completely anti-correlated).  A value of 0 in the (i,j) entry
%     indicates that the i'th and j'th processes are uncorrelated.
% 
%   ExpSigma(i) = sqrt( ExpCovariance(i,i) );
%   ExpCorrC(i,j) = ExpCovariance(i,j)/( ExpSigma(i)*ExpSigma(j) );
% 
%   See also EWSTATS, COV, CORRCOEF, STD, CORR2COV.

%    Author J. Akao 11/17/97
%    Copyright 1995-2002 The MathWorks, Inc.  
%    $Revision: 1.7 $   $ Date: 1998/03/24 $

%-----------------------------------------------------------------
% Argument checking
% ExpCovariance   [N by N]  with diag(ExpCovariance)>=0
% N      [scalar]
%-----------------------------------------------------------------
if nargin<1,
  error('Enter a covariance matrix')
end

if size(ExpCovariance,1)~=size(ExpCovariance,2)
  error('Covariance matrix must be square')
else
  N = size(ExpCovariance,1);
end

if any( diag(ExpCovariance)<0 )
  error('Covariance matrix must be symmetric with non-negative diagonal')
end

%-----------------------------------------------------------------
% Simple correlation is ExpCovariance./( ExpSigma'*ExpSigma )
% ExpSigma [1 by N]
% ExpCorrC [N by N]
%-----------------------------------------------------------------
ExpSigma = sqrt(diag(ExpCovariance))'; 

% start with default correlation of identity for degenerate processes
ExpCorrC = eye(N);

% find processes which are not degenerate
IndPos = ExpSigma>0;

% Compute correlation only for non-degenerate processes
ExpCorrC(IndPos,IndPos) = ExpCovariance(IndPos,IndPos) ./ ... 
    (ExpSigma(IndPos)'*ExpSigma(IndPos));

%-----------------------------------------------------------------
% end of function COV2CORR
%-----------------------------------------------------------------
