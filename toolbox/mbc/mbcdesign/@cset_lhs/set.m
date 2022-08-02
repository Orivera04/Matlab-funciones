function obj=set(obj,param,data)
% SET Set candidate set parameters
%
%   OBJ=SET(OBJ,PARAM,DATA)
%
%   PARAM may be one of:
%
%       Limits  : Cell array of [Min Max] values
%       CostMethod  : String ({'maximin'},'minimax','discrepancy')
%       OptimMethod : String ({'random'})
%       N       : Number of points
%       doRecalc : 0/1
%       doQuickRecalc: recalculates with the number of iterations specified.
%       showGUI: 0/1  shows a waitbar while finding a LHS
%       stratifyLevels:  vector of number of levels to stratify to.  0's imply
%                        no stratification on that factor.  -1 means that
%                        the levels will be taken from the "exactlevels"
%                        property value
%       exactlevels:  cell array of exact level settings for stratified
%                     factors
%       symmetric: 0/1 sets the LHS to have inherrent symmetry
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:01:11 $

% Created 1/11/2000

needcalc=1;
switch lower(param)
case 'limits'
   lims=cat(1,data{:});
   obj.candidateset=limits(obj.candidateset,lims);
   obj.delta= (diff(limits(obj),1,2)')./(obj.N-1);
   needcalc=0;
case 'costmethod'
   obj.alg=data;
   needcalc=1;
case 'optimmethod'
   obj.optimalg=data;
   needcalc=1;
case 'n'
   obj.N=data;
   obj.delta= (diff(limits(obj),1,2)')./(obj.N-1);
   needcalc=1;
case 'dorecalc'
   if data
      data=500;
   end
   obj.doRecalc=data;
   needcalc=1;
case 'doquickrecalc'
   obj.doRecalc=data;
   needcalc=1;
case 'showgui'
   obj.guiflag=data;
   needcalc=0;
case 'stratifylevels'
   obj.stratify=data;
   needcalc=1;
case 'exactlevels'
   obj.stratify_levels=data;
   needcalc=1;
case 'symmetric'
   obj.symmetry=data;
   needcalc=1;
end

if needcalc & obj.doRecalc
   % Recalculate the indices
   
   stratlvls = obj.stratify_levels;
   if any(obj.stratify)
      tpflg = 3;  % require doubles for accuracy
      % convert stratify levels into 1...N domain
      lims = limits(obj);
      for k = find(obj.stratify==-1)
         stratlvls{k} = ((obj.N-1) .* (stratlvls{k}-lims(k,1))./(lims(k,2) - lims(k,1))) + 1;
      end
   else
      if obj.N<=255
         tpflg=0;
      elseif obj.N<=65535
         tpflg=1;
      elseif obj.N<=4294967295
         tpflg=2;
      else
         tpflg=3;
      end
   end
   obj.indices=pr_selectlhs(obj,obj.N, nfactors(obj), tpflg, obj.alg, obj.optimalg,obj.guiflag,obj.doRecalc,...
      obj.stratify,stratlvls,obj.symmetry);
end

return
