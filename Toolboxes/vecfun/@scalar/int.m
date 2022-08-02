function I=int(S,varargin)
%INT  Integrates a scalar function.
%   I = INT(S,DIM) where S is the scalar function to
%   integrate and DIM a vector containing any of the numbers
%   1, 2 and 3.
%   I = INT(S,DIM1,DIM2,...) where DIM is either 1, 2 or 3 or
%   a string containing the variable name of which to
%   integrate along.

% Copyright (c) 2001-08-26, B. Rasmus Anthin.

I=S;
name=inputname(1);
[x y z]=vars(S);
if isempty(name)
   name=S.f;
   if ~isempty(S.xval)
      name=strrepx(name,x,S.xval,'pdiff');
   end
   if ~isempty(S.yval)
      name=strrepx(name,y,S.yval,'pdiff');
   end
   if ~isempty(S.zval)
      name=strrepx(name,z,S.zval,'pdiff');
   end
end
[h1,h2,h3]=coeffs(S);
if nargin==2 & isnumeric(varargin{1})
   dvar=varargin{1};
else
   dvar=[];
   for i=1:nargin-1
      switch(varargin{i})
      case {1,x}, dvar=[dvar 1];
      case {2,y}, dvar=[dvar 2];
      case {3,z}, dvar=[dvar 3];
      otherwise, error('Wrong type of index.')
      end
   end
end
%if length(dvar)>3 | ~length(dvar)
%   error('There must be 1 to 3 integration variables.')
%end
iax='[]';iay='[]';iaz='[]';
intch=repmat('§',1,length(dvar));
dxs='';
h='';
for i=1:length(dvar)
   switch(dvar(i))
   case 1
      I=I*h1;
      dx=x;
      if ~strcmp(expr(h1),'1')
         h=[h '*' strrep(expr(h1),'.','')];
      end
      iax=['linspace(' num2str(S.x(1)) ',' num2str(S.x(2)) ',' num2str(S.x(3)) ')'];
   case 2
      I=I*h2;
      dx=y;
      if ~strcmp(expr(h2),'1')
         h=[h '*' strrep(expr(h2),'.','')];
      end
      iay=['linspace(' num2str(S.y(1)) ',' num2str(S.y(2)) ',' num2str(S.y(3)) ')'];
   case 3
      I=I*h3;
      dx=z;
      if ~strcmp(expr(h3),'1')
         h=[h '*' strrep(expr(h3),'.','')];
      end
      iaz=['linspace(' num2str(S.z(1)) ',' num2str(S.z(2)) ',' num2str(S.z(3)) ')'];
   end
   dxs=[dxs '*d' dx];
end
I.f=[intch '(' name ')' h dxs];
expfact='';
if isconst(S), expfact=['*ones(size(' x '))'];end
I.F=['integral(' S.F expfact ',' iax ',' iay ',' iaz ')'];