function y=mmrgb(x,d)
%MMRGB Color Specification Conversion and Substitution. (MM)
% MMRGB(S) where S is a single character colorspec or the complete
% name of a standard color, returns its numerical RGB equivalent.
% If S is not one of the standard colors given below [] is returned.
%
% MMRGB(RGB) where RGB is a 1-by-3 numerical colorspec, returns
% RGB if it is a valid colorspec, otherwise [] is returned.
%
% MMRGB(S,DEFRGB) or MMRGB(RGB,DEFRGB) returns the numerical colorspec
% DEFRGB if S or RGB is invalid. If DEFRGB is invalid [] is returned.
%
% red       r   [1 0 0]
% green     g   [0 1 0]
% blue      b   [0 0 1]
% cyan      c   [0 1 1]
% magenta   m   [1 0 1]
% yellow    y   [1 1 0]
% black     k   [0 0 0]
% white     w   [1 1 1]

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 5/21/96, v5: 1/14/97, 5/20/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

s='rgbcmykw';
rgb=   [1 0 0;  0 1 0;  0 0 1;  0 1 1;   1 0 1;   1 1 0;   0 0 0;  1 1 1];
str=char('red','green', 'blue', 'cyan','magenta','yellow','black', 'white');

if nargin==2
   d=mmrgb(d);    % Check default for validity
elseif nargin==1
   d=[];
end
if isempty(x)  % Empty input case
   y=d;
elseif ischar(x)  % MMRGB(S) or MMRGB(S,DEFRGB)
   x=deblank(lower(x(isletter(x))));
   if length(x)==1
      i=find(lower(x)==s);
      if isempty(i), y=d;
      else           y=rgb(i,:);
      end
   elseif length(x)>2 % MMRGB(S) full string        
      i=strmatch(x(1:3),lower(str));
      if isempty(i), y=d;
      else           y=rgb(i(1),:);
      end
   else
      error('S Must Contain at Least 3 Characters.')
   end
else  % MMRGB(RGB) or MMRGB(RGB,DEFRGB)
   
   xsiz=size(x);
   if xsiz(2)==3 & all(x(1,:)>=0) & all(x(1,:)<=1)
      y=x(1,:);
   else
      y=d;
   end
end
