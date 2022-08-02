function p = cgnormaliser(name,varargin);
%CGNORMALISER
%
%  Constructor for the cgnormaliser class.
%	n=CGNORMALISER returns an empty lookUpOne object.
%	n=CGNORMALISER(name,M,X,v) returns a xregpointer to a cgnormaliser
%	object.
%		M - lookup table values 			- [n 2] array of doubles
%		X - input argument of the table 	- xregpointer to expression
%		v - clip points  						- [cliplow,cliphigh] doubles 
%  The breakpoints field will be the first column of M and the values field
%  will be the second column of M. 
%  Method flist will be called when another LUT has one of its argument
%  fields filled with a xregpointer to this table.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:45 $



N = struct('Breakpoints',[],...
   'Values',[],...
   'Xexpr',[],...
   'BPLocks',[],...
   'VLocks',[],...
   'Memory',[],...
   'Flist',[],...
   'SFlist',[],...
   'Weights',[],...
   'Description',[],...
   'Input',[],...
   'Precision',[cgprecfloat('double')],...
   'Range',[],...
   'Extrapolate',0);

e = cglookup;

if nargin ==0;
   p = class(N,'cgnormaliser',e);
   return
end

if ischar(name)
   e = setname(e,name);
else
   error('LookUpOne: Name must be a string');
end

if ~isempty(varargin)
   % Parse data values
   data = varargin{1};
   N.Breakpoints = data(:,1);
   N.Values = data(:,2);
   N.BPLocks = zeros(size(data(:,1)));
   N.VLocks = zeros(size(data(:,2)));
   N.Memory{1}.Breakpoints = N.Breakpoints;
   N.Memory{1}.Values = N.Values;
   N.Memory{1}.Information = 'Initial configuration';
   N.Memory{1}.Date = datestr(now,0);
   % Parse 
   if length(varargin)==2
      if isa(varargin{2},'xregpointer')
         if isa(varargin{2}.info,'cgexpr')
            N.Xexpr = varargin{2};
         else
            error('cgnormaliser: Xexpr must be an xregpointer to an expression');
         end
      else
         error('cgnormaliser: Xexpr must be an xregpointer to an expression');
      end
   end
else
   N.Memory{1}.Breakpoints = [];
   N.Memory{1}.Values = [];
   N.Memory{1}.Information = 'Created';
   N.Memory{1}.Date = datestr(now,0);
end
% Create object class and assign xregpointer
N = class(N,'cgnormaliser',e);
p = xregpointer(N);