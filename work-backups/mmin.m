function [m,i]=mmin(varargin)
%MMIN Array Minimum Value. (MM)
% MMIN(A) returns the minimum value in the array A.
% [M,I]=MMIN(A)in addition returns indices of ALL minimum
% values in I. That is, A(I) contains the minimum values.
%
% MMIN(A,B,C,...) finds element by element minimums across all
% input arguments, returning an array the same size as the input
% arguments. Scalar expansion is performed on all scalar inputs.
%
% See also MAX, MMAX, MIN

% D.C. Hanselman, University of Maine, Orono ME 04469
% 1/4/95, revised 5/20/96, v5: 1/13/97, 11/2/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1
   a=varargin{1}(:);
   m=min(a);
   if nargout>1	%return indices
      i=find(m==a);
   end
else
   try
      m=varargin{1};
      for i=2:nargin
         m=min(m,varargin{i});
      end
   catch
      error(lasterr)
   end
end
