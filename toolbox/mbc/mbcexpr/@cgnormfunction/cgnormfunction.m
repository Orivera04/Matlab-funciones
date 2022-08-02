function p = cgnormfunction(name,varargin);
%CGNORMFUNCTION Constructor for the cgnormfunction class.
%	N = CGNORMFUNCTION returns an empty lookUpOne object.
%	N = CGNORMFUNCTION(name,M,X,v) returns a xregpointer to a cgnormfunction
%	object.
%		M - lookup table values 			- [n 2] array of doubles
%		X - input argument of the table 	- xregpointer to expression
%		v - clip points  						- [cliplow,cliphigh] doubles 
%  The breakpoints field will be the first column of M and the values field
%  will be the second column of M. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:14:34 $

% Fields are: 
%             Breakpoints - The points on the x-axis we interpolate between.
%             Xexpr - x arguement expression. 
%             Values - The values of the LUT at the breakpoints.
%             VLocks - Values Lock field.
%             Memory - History of previous Breakpoint/values  
%             Clips - Clip values
%             SFlist - List of sub features.
%             Weights - Weight vector.


LT = struct('Breakpoints',[],...
   'Values',[],...
   'Xexpr',[],...
   'VLocks',[],...
   'Memory',[],...
   'Clips',[-Inf,Inf],...
   'SFlist',[],...
   'Weights',[],...
   'Description',[],...
   'Input',[],...
   'Precision',cgprecfloat('double'),...
   'Range',[], ...
   'version',2);

e = cglookup;

if nargin == 0
   p = class(LT,'cgnormfunction',e);
   return
end

if ischar(name)
   e = setname(e,name);
else
   error('cgnormfunction: Name must be a string');
end

if isempty(varargin)
   LT = class(LT,'cgnormfunction',e);
   LT.Memory{1}.Breakpoints = [];
   LT.Memory{1}.Values = [];
   LT.Memory{1}.Information = 'Created';
   LT.Memory{1}.Date = datestr(now,0);
   p= xregpointer(LT);
else
   % Parse data values
   data = varargin{1};
   N = size(data);
   LT.Breakpoints = [0:N(1)-1]';
   LT.Values = data;
   LT.VLocks = zeros(size(data));
   LT.Memory{1}.Breakpoints = LT.Breakpoints;
   LT.Memory{1}.Values = LT.Values;
   LT.Memory{1}.Information = 'Initial configuration';
   LT.Memory{1}.Date = datestr(now,0);
   % Create object class and assign xregpointer
   LT = class(LT,'cgnormfunction',e);
   p= xregpointer(LT);
   
   % Parse remaining inputs
   if length(varargin)>1
      if isa(varargin{2},'xregpointer')
         if isa(varargin{2}.info,'cgexpr')
            p.info = p.setX(p,varargin{2});
         else
            error('cgnormfunction: Xexpr must be a xregpointer to an expression');
         end
         if length(varargin)>2
            p.info = p.set('clips',varargin{3});
         end
      end
   end
end
