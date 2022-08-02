function [errmsg,tf]=mmspchk(pp,varargin)
%MMSPCHK Check Spline Piecewise Polynomial. (MM)
% [ERRMSG,TF]=MMSPCHK(PP,'Prop1','Val1','Prop2','Val2',...)
% checks the Spline Piecewise Polynomial PP to see if it has the
% properties specified by the property Name/Value pairs,
% 'Prop1','Val1','Prop2','Val2',...
% If PP has all the specified property values, ERRMSG='' and TF=LOGICAL(1)
% If PP is not a Spline Piecewise Polynomial or violates
% any of the specified property values, ERRMSG is a string appropriate
% for use with the ERROR function, e.g., ERROR(MMSPCHK(PP,...))
%
% If no property Name/Value pairs are given, PP is only checked to see
% if it is a Spline Piecewise Polynomial.
%
% Valid Property Name/Value Pairs are:
% Property    Values         Description
% 'order'     integer        spline order (polynomial order + 1)
% 'dim'       integer        spline dimension

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 8/20/99, 6/18/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

tf=1;
errmsg='';
if isfield(pp,'form')&~strcmp(pp.form,'pp')
   errmsg=[inputname(1) ' Input is Not a Valid Piecewise Polynomial.'];
   tf=0;
elseif isnumeric(pp)&(pp(1)~=10)
   errmsg=[inputname(1) ' Input is Not a Valid Piecewise Polynomial.'];
   tf=0;
end
if tf & (nargin>1)
   [brk,coef,npoly,order,dim]=unmkpp(pp);
   if rem(nargin-1,2)~=0
      error('Property Names/Values Must be in Pairs')
   end
   for i=1:2:nargin-1
      p=varargin{i};
      if ~ischar(p)
         error('Property Names Must be Strings.')
      end
      switch lower(p(1))
      case 'o'
         v=varargin{i+1};
         if ~isnumeric(v)
            error('Order Property Accepts only Numeric Values.')
         end
         tf=isequal(v(1),order);
         if ~tf
            errmsg=sprintf('Expected Spline Order is %d',order);
         end
      case 'd'
         v=varargin{i+1};
         if ~isnumeric(v)
            error('Dimension Property Accepts only Numeric Values.')
         end
         tf=isequal(v(1),dim);
         if ~tf
            errmsg=sprintf('Expected Spline Dimension is %d',dim);
         end
      otherwise
         error('Unknown Property Name Provided.')
      end
   end
end
