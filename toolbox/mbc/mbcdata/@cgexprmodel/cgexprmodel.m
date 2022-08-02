function S = cgexprmodel(e,i)
% CGEXPRMODEL A subclass of xregexportmodel that snapshots a cgexpr
%
% M = CGEXPRMODEL( EXPR )
% M = CGEXPRMODEL( PTR_EXPR )
% M = CGEXPRMODEL( PTR_EXPR, INFO )
%
%		INFO is a structure with the following fields:
%        User - User who created model.
%        Date - Date created.
%        Version - Version of CAGE used.
%        Parent - Name of parent CAGE file.
%        Variables - Model variables.
%        new - any other information (Structure with at least one field)
% This information is read-only after creation

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.4 $  $Date: 2004/02/09 06:49:35 $

S = struct('modObj',[],...
	'valPtrs',[],...
	'allPtrs',[],...
	'store',[],...
    'version',2);
   m = xregexportmodel;
   S = class(S , 'cgexprmodel' , m);
if nargin > 0
   if isa(e,'xregpointer')
      e = e.info;
   end
   if isa(e,'cgfeature')
      % extract the equation only
      e = get(e,'equation');
      if isa(e,'xregpointer') & isvalid(e)
         e = e.info;
      end
   end
   if nargin < 2
      i.User = [];
      i.Date = datestr(now);
      i.mvver = [];
      i.Parent = [];
      i.Variables = [];
      i.New = [];
   end
   % copy the object and all it's children - ie take a snapshot of this subfeature
   % Don't replicate any values - leave them pointing where they were
   if ~isempty(e)
      [p,createdPtrs,valIndex,oldValPtrs] = cgexprcopy(e,0);
	  valPtrs = createdPtrs(valIndex);
      if length(valPtrs) > 0
         for ind = 1:length(valPtrs)
            symbols{ind} = valPtrs(ind).getname;
         end
      end
      % try to deduce ranges
      R = zeros(2,length(oldValPtrs));
      for ind=1:length(oldValPtrs)
          V = oldValPtrs(ind).eval;
          if length(V) == 1
              V = [V/2;V*2];
          end
          R(:,ind) = [min(V);max(V)];

      end     
      R(1,find(isnan(R(1,:)))) = -inf;
      R(2,find(isnan(R(2,:)))) = inf;
      S.xregexportmodel = xregexportmodel(getname(p),i,symbols,[],R);
      S.valPtrs = valIndex;
      S.allPtrs = createdPtrs;
      S.modObj = p;
  end
end



