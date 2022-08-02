function p = cglookuptwo(name,varargin);
%CGLOOKUPTWO

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:11:27 $

% Constructor for 2-D Look up Table class
%	l=cglookuptwo
%		returns an empty cglookuptwo class
%	l=cglookuptwo(name,M,X,Y,v)
%		returns a xregpointer to a cglookuptwo object
%		Input arguments
%			M - lookup table values - [m n] doubles
%				 giving a LUT based on the integer grid (0:m-1) x (0:n-1)
%			X - x input 		- cgexpr
%			Y - y input 		- cgexpr
%			v - clip points  	- [cliplow,cliphigh] doubles 

% Fields are:
%             Values - The values from which we interpolate.
%             Clips - Clipping values.
%             VLocks - Values Lock field.
%             Xexpr - Expression for x argument.  
%             Yexpr - Expreesion for y argument.   
%             Memory - Structure storing history.
%             SFlist - List of sub features.
%             Weights - Weight vector.

LT = struct('Values',[],...
   'Xexpr',[],...
   'Yexpr',[],...
   'Clips',[-Inf,Inf],...
   'VLocks',[],...
   'Memory',[],...
   'SFlist',[],...
   'Weights',[],...
   'Description',[],...
   'Input',[],...
   'Precision',cgprecfloat('double'),...
   'Range',[], ...
   'version',2);

e = cglookup;

if nargin == 0;
   p = class(LT,'cglookuptwo',e);
   return
end
if ischar(name)
   e = setname(e,name);
else
   error('cglookuptwo: Name must be a string');
end
if isempty(varargin)
   % Parse data values
   LT = class(LT,'cglookuptwo',e);
   M{1}.Information = 'Created'; M{1}.Values = []; M{1}.Date = datestr(now,0);
   LT.Memory = M;
   p = xregpointer(LT);
else
   
   data = varargin{1};
   LT.Values = data;
   LT.VLocks = zeros(size(data));
   LT.Memory{1}.Values = data;
   LT.Memory{1}.Information = 'Initial configuration';
   LT.Memory{1}.Date = datestr(now,0);
   
   % Create object class and assign xregpointer
   LT = class(LT,'cglookuptwo',e);
   p = xregpointer(LT);
   
   k = length(varargin);
   % Parse remaining inputs
   if length(varargin)>1
      if isa(varargin{2},'xregpointer')
         if isa(varargin{2}.info,'cgexpr')
            p.info  = p.setX(p,varargin{2});
         else
            error('cglookuptwo: Xexpr must be a xregpointer to an expression');
         end
      else
         error('cglookuptwo: Xexpr must be a xregpointer to an expression');
      end
      if length(varargin)>2
         if isa(varargin{3},'xregpointer')
            if isa(varargin{3}.info,'cgexpr')
               p.info =  p.setY(p,varargin{3});
            else
               error('cglookuptwo: Yexpr must be a xregpointer to an expression');
            end
         else
            error('cglookuptwo: Yexpr must be a xregpointer to an expression');
         end
         if length(varargin)>3
            p.info = p.set('clips',varargin{4});
         end
      end
   end
end
