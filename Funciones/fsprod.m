function pn=fsprod(varargin)
%FSPROD Fourier Series Time Product. (MM)
% FSPROD(Fn,Kn,...) returns the Fourier Series of the product
% of time functions having Fourier Series Fn, Kn,...
% The resulting Fourier Series is truncated to be as large
% as the largest input Fourier Series.
%
% See also FSHELP

% Calls: fssize fsresize

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 4/2/96, v5: 1/14/97, 10/26/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<2
   error('Two or More Inputs are Required.')
end
[N,errmsg]=fssize(varargin{1});
error(errmsg)
N=(max(cellfun('length',varargin))-1)/2;
pn=varargin{1};
for i=2:nargin
   kn=varargin{i};
   [n,errmsg]=fssize(kn);
   error(errmsg)
   pn=fsresize(conv(pn,kn),N);
end