function anss=intmat(m,n,maxx,varargin)
%INTMAT(m,n,maxx) returns an m-by-n matrix of random integers on [0,maxx].
% INTMAT(m,n) returns an m-by-n matrix of random integers on [0,10].
% INTMAT(m) returns an m-by-1 (column) vector of integers on [0,10].

if nargin==1 
   n = m;   maxx = 10;
elseif nargin==2
       maxx = 10;   
elseif nargin>3 
    error('Too many input Arguments.')
end
anss = floor((maxx+1)*rand(m,n));