function p = cglookupone(name,varargin);
%CGLOOKUPONE Constructor for 1-D look up table class
%
%  lt = CGLOOKUPONE returns an empty cglookupone object
%  lt = CGLOOKUPONE('name',M,X,v) returns a xregpointer to a cglookupone
%  object.
%		M - lookup table values 			- [n 2] array of doubles
%		X - input argument of the table 	- xregpointer to expression
%		v - clip points  						- [cliplow,cliphigh] doubles 
%  The breakpoints field will be the first column of M and the values field
%  will be the second column of M. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:12:15 $
 
if nargin==0;
   e = cgnormfunction;
   %version 1 created 31/5/2001
   LT.Version = 1;
   p = class(LT,'cglookupone',e);
   return
end


if ischar(name)
   if nargin ==1
      e = cgnormfunction;
      e = setname(e,name);
      LT.Version = 1;
      Memory{1}.Breakpoints = [];
      Memory{1}.Values = [];
      Memory{1}.Information = 'Created';
      Memory{1}.Date = datestr(now,0);
      e = set(e,'memory',Memory);    
      p = class(LT,'cglookupone',e);
   end  
else
   error('cglookupone: Name must be a string');
end

if ~isempty(varargin)
   % Parse data values
   data = varargin{1};
   
   if nargin == 2
     % create a dummy normaliser 
     Norm = cgnormaliser(['Axis_' name],[data(:,1) [0:size(data,1)-1]']);
   end
   
   if nargin > 2
      X= varargin{2};
      Norm = cgnormaliser(['Axis_' name],[data(:,1) [0:size(data,1)-1]'], X);
   end
   
   if nargin > 3
      v = varargin{3};
      Norm = cgnormaliser(['Axis_' name],[data(:,1) [0:size(data,1)-1]'], X, v);
   else
      v = [];
   end   
      
   % create a cgnormfunction with this normaliser
   if ~isempty(v)
      pE = cgnormfunction(name, data(:,2) , Norm, v);
   else
      pE = cgnormfunction(name, data(:,2) , Norm);
   end     
   e = pE.info;
   freeptr(pE);
   
   LT.Version = 1;
end

% Create object class and assign xregpointer
LT = class(LT,'cglookupone',e);
p = xregpointer(LT);

if nargin ==1
   % create a dummy normaliser
   Norm = cgnormaliser(['Axis_' name]);
   LT.cgnormfunction = setX(LT.cgnormfunction, p, Norm);
   p.info = LT;
end
