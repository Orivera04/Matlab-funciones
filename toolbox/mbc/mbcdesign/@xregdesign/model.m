function m=model(des,varargin);
% MODEL  Get or set the current model 
%   M=MODEL(D) returns the current model from the
%   design object D.
%   D=MODEL(D,M) inserts the model M as the new
%   current model in D. 
%
%   This function is an interface that must be overloaded
%   by design sub-classes.  This function returns empty 
%   when asked for its model and simply alters the number
%   of factors when given a new one.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:07:09 $

if nargin>1
   old_lims=gettarget(des.model);
   des.model=varargin{1};
   des.modelstate=des.modelstate+1;   
   m=nfactors(des,nfactors(varargin{1}));
   if ~isempty(des.constraints)
      m.constraints=factors(des.constraints,get(varargin{1},'symbol'));
   end
   % fix the candidate space settings
   m=fixcandspace(m);
   % New model: should take up new limits from factors
   % This call will also rescale the design and may delete the constraints
   m=expandtomodellimits(m,old_lims);
   % check design class is correct for this model
   desclass=designobj(varargin{1},'classname');
   if ~strcmp(desclass,class(m))
      desclass=designobj(varargin{1});
      % copy current design data into new class
      m=setdesign(desclass,getdesign(m));
   end
else
   m=des.model;
end
return