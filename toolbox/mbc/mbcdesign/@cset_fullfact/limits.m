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


%   $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:26:33 $

% Created 3/1/2001


if nargin==1
   out=limits(obj.candidateset);
   
elseif nargin==2
   ind=varargin{1};
   if size(ind,2)==2;
      % scale levels to match limits
      lims=ind;
      ind=1:size(lims,1);
      obj.candidateset=limits(obj.candidateset,lims,ind);
      obj.grid=limits(obj.grid,lims,ind);
      out=obj;
      
   else
      out=limits(obj.candidateset, ind);      
   end   
   
elseif nargin==3
   ind=varargin{2};
   lims=limits(obj.candidateset);
   lims(ind,:)=varargin{1};
   obj.candidateset=limits(obj.candidateset,lims,ind);
   obj.grid=limits(obj.grid,lims,ind);
   out=obj;
   
end