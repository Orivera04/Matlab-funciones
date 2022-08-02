function v = portvar(asset,ws) 
%PORTVAR Portfolio variance. 
%   V = PORTVAR(ASSET,WS) returns the variance for a portfolio of assets
%   where ASSET is a matrix of asset data and WS are the corresponding
%   weights of each asset.  ASSET is an MxN matrix of N securities and  
%   WS is a 1xN vector where each column of ASSET is a time series of 
%   historical data for a single security and each column of WS is a 
%   corresponding weight for each security in ASSET.   If WS is a matrix  
%   of size RxN, the portfolio variance, V, is returned as an Rx1 vector 
%   with each row representing a variance calculation for each row of WS.  
% 
%   V = PORTVAR(ASSET) assigns each security an equal weight when 
%   calculating the portfolio variance. 
% 
%   See also FRONTIER, PORTROR, PORTRAND. 
% 
%   Reference: Bodie, Kane, and Marcus, Investments, Chapter 7. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:57:02 $ 
 
[m,n] = size(asset); 
if nargin < 2 
  ws = ones(1,n)/n; 
end 
if nargin < 1 
  error('Missing ASSET.') 
end 
 
[r,c] = size(ws); 
if n ~= c 
  error('Number of assets and weights are not equal.') 
end 
 
covmat = cov(asset);    % Calculate covariance of assets 
va = diag(covmat)';     % Get variance for each column  
ca = tril(covmat,-1);   % Get covariance values of columns 
 
v = zeros(r,1);         % Preallocate matrices 
for n = 1:r             % Weights are not always square matrix, using for loop 
  x = ws(n,:)'*ws(n,:);  
  v(n) = sum(ws(n,:).^2.*va)+2*sum(sum(x.*ca)); % Equation 7.11, pg. 217 
end
