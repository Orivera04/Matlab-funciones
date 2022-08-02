function ud= ModelClasses(L,nf)
%LOCALMOD/MODELCLASSES list of available classes
%
% ud= ModelClasses(L,nf)
% L localmod
% nf number of input factors
% 
% Output Structure
%   ud.classfunc   class constructor string (or function handle) + extra arguments to pass to feval
%   ud.modeltps    Display String for Model
%   ud.lmgroups    



%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 07:38:42 $





if nargin<2
   nf= nfactors(L);
end

if nf==1
	% builtin classes for one input factor
   ud.classfuncs={@localpoly,@localpspline,@localtruncps,@localbspline}';
   ud.modeltps= {'Polynomial','Polynomial spline','Truncated power series','Free knot spline'}';
   
   ud.lmgroups= ud.classfuncs;
else
   ud.classfuncs= {};
   ud.modeltps= {};
   ud.lmgroups = {};
end

if nf==1
	% Growth Models
	ud.classfuncs= [ud.classfuncs;{{@localusermod,'logistic'}}];
	ud.modeltps     = [ud.modeltps;{'Growth models'}];
	ud.lmgroups   = [ud.lmgroups;{'Growth'}];
end

% General Models
ud.classfuncs= [ud.classfuncs;{{@localsurface,xregcubic('nfactors',nf)};{@localavfit,'nfactors',nf};{@localmulti,'nfactors',nf}}];
ud.modeltps     = [ud.modeltps;{'Linear models';'Average Fit';'Multiple Models'}];
ud.lmgroups   = [ud.lmgroups;{'localsurface';'localavfit';'localmulti'}];

% user-defined models
cfglist=getmodellist(xregusermod,nf);
if ~isempty(cfglist)
   ud.classfuncs= [ud.classfuncs;{{@localusermod,cfglist{1}}}];
   ud.modeltps     = [ud.modeltps;{'User defined'}];
   ud.lmgroups   = [ud.lmgroups;{'xregusermod'}];
end
% dynamic models
cfglist=getmodellist(xregtransient,nf);
if ~isempty(cfglist)
	tmod= xregtransient('name',cfglist{1});
   ud.classfuncs= [ud.classfuncs;{{@localusermod,tmod}}];
   ud.modeltps     = [ud.modeltps;{'Transient models'}];
   ud.lmgroups   = [ud.lmgroups;{'xregtransient'}];
end


% structure defining additional classes from extensions
e = xregtools.extensions;
mdl_ext= e.LocalModelClasses;

N_extmdl=length(mdl_ext);
% Loop over extensions and add the ones which fit the circumstances
for n=1:N_extmdl
   TAKE_MODEL=0;
   if (mdl_ext(n).minNF==0 & mdl_ext(n).maxNF==0)     % use exactNF
      if any(nf==mdl_ext(n).exactNF)
         TAKE_MODEL=1;
      end
   else
      if (nf>=mdl_ext(n).minNF & nf<=mdl_ext(n).maxNF)
         TAKE_MODEL=1;
      end
   end
   if TAKE_MODEL
      cfunc= mdl_ext(n).classfuncs;
      if ~iscell(cfunc)
         cfunc= {cfunc};
      end
      mnew= feval(cfunc{:});
      if nfactors(mnew)~=nf
         cfunc= [cfunc(1),{'nfactors',nf}];
      end
      ud.classfuncs=[ud.classfuncs; {cfunc}];
      ud.modeltps=[ud.modeltps; {mdl_ext(n).modeltps}];
      ud.lmgroups=[ud.lmgroups; {mdl_ext(n).lmgroups}];
   end
end



if DatumType(L)
    % make list of permisble models for datumtypes
    SelectedModels= true(size(ud.modeltps));
    for i=1:length(ud.modeltps);
        % construct a model
        if iscell(ud.classfuncs{i})
            mi= feval(ud.classfuncs{i}{:});
        else
            mi= feval(ud.classfuncs{i});
        end
        SelectedModels(i)= permitsDatum(mi);
    end
    ud.modeltps= ud.modeltps(SelectedModels);
    ud.lmgroups= ud.lmgroups(SelectedModels);
    ud.classfuncs= ud.classfuncs(SelectedModels);
end