function varargout=mmdeal(x,n)
%MMDEAL Deal Data Into Individual Arguments. (MM)
% [a,b,c,...]=MMDEAL(A) when A is a array returns a=A(1), b=A(2), ...
% [a,b,c,...]=MMDEAL(A,1) when A is a matrix returns a=A(1,:), b=A(2,:), ...
% [a,b,c,...]=MMDEAL(A,2) when A is a matrix returns a=A(:,1), b=A(:,2), ...
% [a,b,c,...]=MMDEAL(A,'dup') duplicates A, returning a=A, b=A, ...
% [a,b,c,...]=MMDEAL(A) when A is a string matrix having at least two rows
%             and columns, returns individual deblanked strings.
% [a,b,c,...]=MMDEAL(A) when A is a Cell Array returns a=A{1}, b=A{2}, ...
% [a,b,c,...]=MMDEAL(A) when A is a Cell Array of strings returns
%             a=deblank(A{1}), b=deblank(A{2}), ...
%
% See also DEAL. 

% D.C. Hanselman, University of Maine, Orono, ME  04469-5708
% 5/2/96, modified 8/28/96, 9/8/96, 10/28/96, 11/7/96
% v5: 1/14/97, 1/22/97, 1/26/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if isempty(x), error('Input Must Not be Empty.'), end
if ndims(x)~=2, error('Input Must be 2D.'), end
[rx,cx]=size(x);

if iscell(x)  % input is a cell array
   if iscellstr(x)                       % cell array of strings
      for i=1:min(nargout,rx*cx)
         varargout{i}=deblank(x{i});
      end
   else                                  % numerical cell array
      for i=1:min(nargout,rx*cx)
         varargout{i}=x{i};
      end
   end
elseif nargin==1 & ischar(x) & cx>1 &rx>1 % string matrix
   for i=1:min(nargout,rx);
      varargout{i}=deblank(x(i,:));
   end
   
elseif nargin==1                          % vector input
   for i=1:min(nargout,rx*cx);
      varargout{i}=x(i);
   end
   
elseif ischar(n) & (n(1)=='d')            % duplicate input
   for i=1:nargout
      varargout{i}=x;
   end
   
elseif n==1                               % return rows
   for i=1:min(nargout,rx)
      varargout{i}=x(i,:);
   end
   
elseif n==2                               % return columns
   for i=1:min(nargout,cx);
      varargout{i}=x(:,i);
   end
else
   error('Calling Syntax Unknown.')
end
