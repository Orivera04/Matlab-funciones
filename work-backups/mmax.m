function [m,i]=mmax(varargin)
%MMAX Array Maximum Value. (MM)
% MMAX(A) returns the maximum value in the array A.
% [M,I]=MMAX(A)in addition returns indices of ALL maximum
% values in I. That is, A(I) contains the maximum values.
%
% MMAX(A,B,C,...) finds element by element maximums across all
% input arguments, returning an array the same size as the input
% arguments. Scalar expansion is performed on all scalar inputs.
%
% See also MAX, MMIN, MIN

% D.C. Hanselman, University of Maine, Orono ME 04469
% 1/4/95, revised 5/20/96, v5: 1/13/97, 11/2/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1
   a=varargin{1}(:);
   m=max(a);
   if nargout>1	%return indices
      i=find(m==a);
   end
else
   try
      m=varargin{1};
      for i=2:nargin
         m=max(m,varargin{i});
      end
   catch
      error(lasterr)
   end
end
