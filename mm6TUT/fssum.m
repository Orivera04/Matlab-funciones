function pn=fssum(varargin)
%FSSUM Fourier Series Addition. (MM)
% FSSUM(Fn,Kn,...) returns the Fourier Series of the sum
% of time functions having Fourier Series Fn, Kn,...
% The resulting Fourier Series is as large as the largest
% input Fourier Series.
%
% FSSUM(Fn,dc) adds the DC term dc to Fn.
%
% See also FSHELP.

% Calls: fssize fsresize

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 4/9/96, v5: 1/14/97, 10/26/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<2
   error('Two or More Inputs are Required.')
end
[tmp,errmsg]=fssize(varargin{1});
error(errmsg)
pn=varargin{1};
for i=2:nargin
   kn=varargin{i};
   [nkn,errmsg]=fssize(kn);
   error(errmsg)
   d=fssize(pn)-nkn;
   pn=[zeros(1,-d) pn zeros(1,-d)]+[zeros(1,d) kn zeros(1,d)];
end