function ud= ModelClasses(mdl,crit);
% MODELCLASSES  return list of MBC Toolbox model classes
%
%   ud=MODELCLASSES(mdl,crit)
%
%    crit (optional):  0 => return all
%                      1 => return only linear
%                      2 => return only non-linear
%                      4 => 2nd stage models
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.3 $  $Date: 2004/02/09 07:51:11 $



if nargin<2
   crit=0;
end
isRF=bitand(crit,4);


nf=nfactors(mdl);


% built-in classes
ud.classfuncs=      {'xreglinear','xregrbf','xreghybridrbf','xregmultilin','xregunispline','xregnnet','xregusermod','xregtransient'};
ud.createclassfuncs={@xregcubic,@xregrbf,@xreghybridrbf,@xregmultilin,@xregunispline,@xregnnet,@xregusermod,@xregtransient};
ud.classnames=      {'Linear model','Radial basis function','Hybrid RBF','Multiple linear models',...
        'Free knot spline','Neural network',...
        'User-Defined','Transient'};

if nf~=1
	% remove free knot splines if there is more than one factor
	ind=strmatch('xregunispline',ud.classfuncs,'exact');
	ud.classfuncs(ind)= [];
	ud.createclassfuncs(ind)=[];
	ud.classnames(ind)= [];
end
if ~isRF
	% one stage models
	ud.usermodels= getmodellist(xregusermod,nf);
	% disable userdefined models for now due to coding problems
	if isempty(ud.usermodels)
		ind=strmatch('xregusermod',ud.classfuncs,'exact');
		% remove xregusermod models
		ud.classfuncs(ind)= [];
		ud.createclassfuncs(ind)=[];
		ud.classnames(ind)= [];
	end	
	
	ud.transient= getmodellist(xregtransient,nf);
	% disable userdefined models for now due to coding problems
	if isempty(ud.transient)
		ind=strmatch('xregtransient',ud.classfuncs,'exact');
		% remove xregusermod models
		ud.classfuncs(ind)= [];
		ud.createclassfuncs(ind)=[];
		ud.classnames(ind)= [];
	end	
else
	% response feature models 
	ind= cell(1,4);
	% don't support usermod, transient, nnet or xregarx
	ind{1}=strmatch('xregusermod',ud.classfuncs,'exact');
	ind{2}=strmatch('xregtransient',ud.classfuncs,'exact');
	ind{3}=strmatch('xregnnet',ud.classfuncs,'exact');
	ind{4}=strmatch('xregarx',ud.classfuncs,'exact');
    ind= [ind{:}];
	ud.classfuncs(ind)= [];
	ud.createclassfuncs(ind)=[];
	ud.classnames(ind)= [];
end

% structure defining additional classes from extensions
e = xregtools.extensions;
mdl_ext= e.ModelClasses;

N_extmdl=length(mdl_ext);
% Loop over extensions and add the ones which fit the circumstances
for n=1:N_extmdl
   TAKE_MODEL=0;
   if ((isRF & mdl_ext(n).RFmodel) | (~isRF & mdl_ext(n).onestagemodel))   % Correct model type
      if (mdl_ext(n).minNF==0 & mdl_ext(n).maxNF==0)     % use exactNF
         if any(nf==mdl_ext(n).exactNF)
            TAKE_MODEL=1;
         end
      else
         if (nf>=mdl_ext(n).minNF & nf<=mdl_ext(n).maxNF)
            TAKE_MODEL=1;
         end
      end
   end
   if TAKE_MODEL
      ud.classfuncs=[ud.classfuncs {mdl_ext(n).classfuncs}];
      ud.createclassfuncs=[ud.createclassfuncs {mdl_ext(n).createclassfuncs}];
      ud.classnames=[ud.classnames {mdl_ext(n).classnames}];
   end
end


if bitand(crit,1) | bitand(crit,2)
	% strip out linear (crit==1) or nonlinear (crit==2)
   lin=false(length(ud.classnames),1);
   for n=1:length(lin)
      lin(n)=islinear(feval(ud.createclassfuncs{n}));
   end
   if bitand(crit,2)
      lin=~lin;
   end
   ud.classfuncs=ud.classfuncs(lin);
   ud.createclassfuncs=ud.createclassfuncs(lin);
   ud.classnames=ud.classnames(lin);
end
