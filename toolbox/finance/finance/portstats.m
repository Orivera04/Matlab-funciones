function [PortRisk, PortReturn] = portstats(ExpReturn, ExpCovariance, Wts)
%PORTSTATS  Portfolio expected return and risk.
%   [PortRisk, PortReturn] = portstats (ExpReturn, ExpCovariance, Wts) returns
%   the expected rate of return and risk for a portfolio of assets.
%
%   Inputs: 
%     ExpReturn is a 1xNASSETS vector specifying the expected (mean) 
%     return of each asset.
%
%     ExpCovariance is an NASSETSxNASSETS matrix specifying the covariance 
%     of the asset returns.
%
%     Wts is an NPORTSxNASSETS matrix of weights allocated to each asset.
%     Each row represents a different weighting combination of the assets
%     in the portfolio. If Wts is not entered, weights of 1/NASSETS are
%     assigned to each security.
% 
%   Outputs:             
%     PortRisk is an NPORTSx1 vector of the standard deviation of return 
%     for each portfolio. 
%
%     PortReturn is an NPORTSx1 vector of the expected return of each 
%     portfolio.
%
%
%   See also EWSTATS, FRONTCON, PORTOPT, PORTALLOC.
%
%   Reference Bodie, Kane, and Marcus, Investments, Chapter 7.

%    Author(s): M. Reyes-Kattar, 03/07/98
%    Copyright 1995-2002 The MathWorks, Inc. 
%    $Revision: 1.9 $   $ Date: 1998/01/30 13:45:34 $

% Check for input errors

NASSETS = length(ExpReturn);

if (nargin < 3)
   Wts = ones(1,NASSETS)/NASSETS;
end

if nargin < 2 
  error('You must enter ExpReturn and ExpCovariance.');
end 

% Make sure that the number of returns entered matches the number of  
% rows/columns in the covariance matrix (which represents the number of assets)
% and the number of columns in the weights matrix.
   
[covRows, covCols] = size(ExpCovariance);
[wtsRows, wtsCols] = size(Wts); 

if(covRows ~= covCols)
    error('The covariance matrix must be NxN, where N = number of assets');
end
   

if size(ExpCovariance, 1) ~= NASSETS
		error('The number of expected returns does not equal the number of assets.');
end

EC = eig(ExpCovariance);   
if(min(min(EC)) < (-1E-14 * max(max(abs(EC)))))
    warning('Covariance matrix must be positive semi-definite.');
end
clear EC;


if size(Wts, 2) ~= NASSETS
		error('Wts should be an MxN matrix, where N = number of assets');
end
 
% Function body

PortReturn = Wts*ExpReturn';

PortRisk = zeros(wtsRows,1);
for i = 1:wtsRows
   port = Wts(i,:);
   PortRisk(i) = sqrt(port*ExpCovariance*port');
end
