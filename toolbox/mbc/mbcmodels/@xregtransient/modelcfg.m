function modelcfg(U,Action)
% xregusermod/MODELCFG add model to configuration file

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:30:36 $

if nargin==1
   Action= 'add';
end

switch lower(Action)
case 'add'
   i_AddModel(U)
case 'delete'
   i_Delete(U)
end
   
   
   

function i_AddModel(U)


fname= name(U);


% add to configuration file
cfg= getpref(mbcprefs('mbc'),'dynamic');

f= find(strcmp(fname,cfg.models));
if ~isempty(f);
   % update model
   cfg.models{f} = fname;
	cfg.sim  = U.simName;
	cfg.mchecksum(f)= -1;
	cfg.simchecksum(f)= -1;
else
	
	
   cfg.models = [cfg.models {fname}];
   cfg.sim= [cfg.sim {U.simName}];
   
	cfg.mchecksum = [cfg.mchecksum -1];
	cfg.simchecksum= [cfg.simchecksum -1];
   
end

setpref(mbcprefs('mbc'),'dynamic',cfg);

function i_Delete(U)

fname= U.simName;

% file info
finfo= dir( which([fname,'(U)'] ) );

% add to configuration file
cfg= getpref(mbcprefs('mbc'),'dynamic');

f= find(strcmp(fname,cfg.models));

if ~isempty(f);
   cfg.models(f)= [];
   cfg.sim(f) = [];
	
   cfg.mchecksum(f)= [];
   cfg.simchecksum(f)= [];
	
	setpref(mbcprefs('mbc'),'dynamic',cfg);
else
	%% should say nothing deleted??
	%% but can be called from failed mvcheckin - this requires different message??
	
	%disp(['No ', fname, ' model was checked in. Nothing to delete.']);
end




