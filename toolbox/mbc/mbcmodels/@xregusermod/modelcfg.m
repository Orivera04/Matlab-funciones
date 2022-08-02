function modelcfg(U,Action)
% xregusermod/MODELCFG add model to configuration file

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:28 $

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
cfg= getpref(mbcprefs('mbc'),'usermodels');

f= find(strcmp(fname,cfg.models));
if ~isempty(f);
   cfg.models{f}= fname;
	cfg.checksum(f)= -1;
else
   cfg.models = [cfg.models {fname}];
	cfg.checksum= [cfg.checksum -1];
end

setpref(mbcprefs('mbc'),'usermodels',cfg);


function i_Delete(U)

fname= name(U);


% add to configuration file
cfg= getpref(mbcprefs('mbc'),'usermodels');

f= find(strcmp(fname,cfg.models));

if ~isempty(f);
   cfg.models(f)= [];
   cfg.checksum(f)= [];
	setpref(mbcprefs('mbc'),'usermodels',cfg);
end

