function [T,OK,NumDatasets]= InitData(T)
% MDEVTESTPLAN/INITDATA

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:07:16 $

HM= HSModel(T.DesignDev);

mp= project(T);
dp= mp.dataptrs;


nf= nfactors(HM);

Valid= false(size(dp));
for i=1:length(dp)
    Valid(i)= dp(i).size(2) > nf;
end
% must have more than nf variables
dp   = dp(Valid);
NumDatasets= sum(Valid);

NStages= length(designdev(T));
nf= nfactors(HM);

if isempty(dp)
	OK=false;
	return;
end


OK=true;
Dp= dp(1);

S= Dp.sweepset;

T.DataLink= dp(1); % xregpointer( dp(1).info );

dtree= T.DesignDev(end).DesignTree;
if length(dtree.designs)==1 
	OldHM= HM;
	HM = ChannelMatch(HM,S);
	T.DesignDev=  UpdateModels( T.DesignDev, HM );
	% make a data design
	T= DataDesign(T);
	% restore old model 
	T.DesignDev=  UpdateModels( T.DesignDev, OldHM );
end

pointer(T);
