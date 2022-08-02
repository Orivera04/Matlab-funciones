function L_mdev= mdev_local(varargin);
% MDEV_LOCAL model development class for local regression
% 
%  L_mdev= mdev_local(Name,{m,X,Y,3});
%
%  mdev_local is a child of modeldev.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:04:44 $




loadstr=0;
ver=2;
if nargin==0
   loadstr=1;
end
if nargin==1 
   if isa(varargin{1},'struct')
      L_mdev= varargin{1};
		[L_mdev,mdev]= i_UpdateOld(L_mdev);
		loadstr=1;
	elseif isa(varargin{1},'mdev_local')
      L_mdev= varargin{1};
      L_mdev.version=ver;
      return
   end
else   
   L_mdev= struct(...
         'ResponseFeatures',[],...
         'TwoStage',[],...
         'TSstatistics',[],...
         'MLE',[],...
         'version',3,...
         'AllModels',[],...    % all local models, so we don't have to refit every view
         'FitOK',[],...        % logical array indicating fit for each sweep
         'GLSWeights',[],...   % weights for GLS fit, if any 
         'Notes',{{}},...      % Dean's sweep notes
         'IsLinearised',0,....  % indicates whether linearised approach is to be used
			'RFData',xregpointer... % pointer to RF data
      );
   mdev= modeldev(varargin{:});
end

% class definition
L_mdev= class(L_mdev,'mdev_local',mdev);


if ~loadstr
   % store object in dynamic memory
   p_mdev= pointer(L_mdev);
   
   % must get a copy of the dynamic object (contains the pointer to self)
   L_mdev= p_mdev.info;
   
   % Set local models to be 1st stage modelling
   L_mdev=modelstage(L_mdev,1);
end   



function [L_mdev,mdev]= i_UpdateOld(L_mdev);

mdev= L_mdev.modeldev;
L_mdev= rmfield(L_mdev,'modeldev');
while L_mdev.version<3
	switch L_mdev.version
	case {0,1}
		%  
		% new fields for version 2
		L_mdev.version = 2;
		% all local models, so we don't have to refit every view
		L_mdev.AllModels=[];  
		% logical array indicating fit for each sweep
		L_mdev.FitOK=[];      
		% weights for GLS fit, if any 
		L_mdev.GLSWeights=[];
		% Dean's sweep notes
		if isfield(L_mdev.MLE,'Sigma')
			Ns= size(L_mdev.MLE.Sigma,3);
			L_mdev.Notes=cell(Ns,1);
			[L_mdev.Notes{:}]=deal('');
		else
			L_mdev.Notes= {};
		end
		L_mdev.IsLinearised=0;     
	case 2
		L_mdev.version = 3;
		L_mdev.RFData = xregpointer;
	otherwise
		error('Unknown MDEV_LOCAL Version')
	end
end
mdev= modeldev(mdev);
