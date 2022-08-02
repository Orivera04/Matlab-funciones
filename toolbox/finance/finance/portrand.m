function [risk,ror,weights] = portrand(asset,ret,pts) 
%PORTRAND Randomized portfolio risks, returns, and weights. 
%   [RISK,ROR,WEIGHTS]=PORTRAND(ASSET,RET,PTS) returns the risk, rate of 
%   return, and weight vectors of random portfolio configurations.  ASSET is  
%   an MxN matrix where each column represents the time series data of a 
%   single security.  RET is a 1xN vector where each column represents the
%   rate of return for a corresponding security in ASSET.  PTS is a scalar 
%   value that specifies how many random points should be generated. 
%   RISK is a PTSx1 vector of standard deviations, ROR is a PTSx1 vector
%   of expected rates of return, and WEIGHTS is a PTSxN matrix of asset 
%   weights.  Each row of WEIGHTS is a different portfolio configuration.
%   By default, PTS equals 1000 and RET will be computed by taking the
%   average value of each column of ASSET.     
% 
%   PORTRAND(ASSET,RET,PTS) plots the points representing each
%   portfolio configuration.
%       
%   This function is used in the MATLAB Financial Expo and illustrates
%   how multiple weighting combinations of the same portfolio will
%   generate the same expected rate of return.
%
%   See also FRONTIER, PORTVAR, PORTROR. 
%       
%   Reference: Bodie, Kane, and Marcus, Investments, Chapter 7.
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.7 $   $Date: 2002/04/14 21:53:02 $ 
 
if nargin < 1 
  error(sprintf('Missing ASSET.')) 
end 
if nargin < 2 
  ret = mean(asset); 
end 
if nargin < 3 
  pts = 1000; 
end 
 
[r,c] = size(asset); 
[m,n] = size(ret); 
if c ~= n 
  error(sprintf('ASSET and RET must have equal number of columns.')) 
end 
if m ~= 1 
  error(sprintf('RET must be a 1x%1.0f vector.',c)) 
end 
if length(pts) ~= 1 | pts < 1 
  error(sprintf('PTS must be a scalar value > 0.')) 
end 
 
% Generate random weighting combinations 
randmat = rand(pts,c); 
randsum = sum(randmat')'; 
randexp = randsum(:,ones(c,1)); 
ws = randmat./randexp; 
 
y = sqrt(portvar(asset,ws));  % Standard deviations for each weight vector 
z = portror(ret,ws);         % Rate of return for each weight vector 
[z,in] = sort(z);             % Sort output for plotting 
y = y(in);                    % Standard deviations in same order as returns 
 
if nargout == 0 
  plot(y,z,'c.','linewidth',3.5) 
else 
  risk = y; 
  ror = z'; 
  weights = ws; 
end
