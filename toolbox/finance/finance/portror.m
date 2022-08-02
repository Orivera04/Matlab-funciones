function r = portror(rs,ws) 
%PORTROR Portfolio expected rate of return. 
%   R = PORTROR(RS,WS) calculates the expected rate of return for a  
%   portfolio of assets given the expected rate of return and weight of   
%   each asset.  RS is an 1xN matrix of rates of return and WS is an MxN
%   matrix of weights.  Each column of RS represents the rate of return
%   for a single security.  Each row of WS represents a different weighting
%   combination of the assets in the portfolio.  R, the expected rate of  
%   return, is a 1xM vector. 
% 
%   For example, a portfolio is made up of two assets ABC and XYZ having  
%   expected rates of return of 10% and 14%, respectively.  40% percent  
%   of the portfolio's funds are allocated to asset ABC and the remaining 
%   funds are allocated to asset XYZ.  The portfolio's expected rate of 
%   return is r = portror([.1 .14],[.4 .6]) or r = 0.124. 
% 
%   See also FRONTIER, PORTVAR, PORTRAND. 
%       
%   Reference Bodie, Kane, and Marcus, Investments, Chapter 7.
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:56:44 $ 
 
if nargin < 2 
  error('Missing one of RS and WS.') 
end 
[m,n] = size(ws); 
[ro,co] = size(rs); 
if n ~= co 
  error('Equal number of rates and weights must be entered.') 
end 
 
r = rs*ws';
