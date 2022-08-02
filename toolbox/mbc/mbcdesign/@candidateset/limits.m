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


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:56:01 $

% Created 1/11/2000


get=0;
if nargin==1
   ind=1:nfactors(obj);
   get=1;
elseif nargin==2
   ind=varargin{1};
   if size(ind,2)==2 | isempty(ind);
      if isempty(ind)
         obj.lims=zeros(0,2);
      else
         obj.lims=ind;
      end
      out=obj;
      return
   else
      get=1;
   end   
elseif nargin==3
   lims=varargin{1};
   ind=varargin{2};
end

if get
   out=obj.lims(ind,:);
else
   % set
   obj.lims(ind,:)=lims;
   out=obj;
end
return