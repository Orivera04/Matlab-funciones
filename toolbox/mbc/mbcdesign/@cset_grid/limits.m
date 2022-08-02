function out=limits(obj,varargin)
% LIMITS  Get/Set limits for CandidateSet object
%
%  LIMS=LIMITS(OBJ)
%  LIMS=LIMITS(OBJ,IND)
%
%  OBJ=LIMITS(OBJ,LIMS)
%  OBJ=LIMITS(OBJ,LIMS,IND)
%
%  LIMS is a (nf -by- 2) matrix of lower and upper limits
%  IND is an (optional) index matrix indicating which factors
%  to apply to or get.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:26:35 $

% Created 1/11/2000


if nargin==1
   out=limits(obj.candidateset);
   
elseif nargin==2
   ind=varargin{1};
   if size(ind,2)==2;
      % scale levels to match limits
      lims=ind;
      ind=1:size(lims,1);
      obj=i_setlims(obj,lims,ind);
      obj.candidateset=limits(obj.candidateset,lims,ind);
      out=obj;
      
   else
      out=limits(obj.candidateset, ind);      
   end   
   
elseif nargin==3
   ind=varargin{2};
   lims=limits(obj.candidateset);
   lims(ind,:)=varargin{1};
   obj=i_setlims(obj,lims,ind);
   obj.candidateset=limits(obj.candidateset,lims,ind);
   out=obj;
   
end


function obj=i_setlims(obj,lims,ind)

if size(lims,1)~= length(obj.levels)
   error('Mismatch in number of limits and factors!');
end

% scale the levels to match new limits
oldlims=limits(obj.candidateset);
for i=ind
   obj.levels{i}=lims(i,1)+(obj.levels{i}-oldlims(i,1)).*(lims(i,2)-lims(i,1))./(oldlims(i,2)-oldlims(i,1));
end
return