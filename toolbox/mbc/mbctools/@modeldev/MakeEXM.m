function [m,mlist]= MakeEXM(mdev,varargin)
%MAKEEXM make exportmodel for command-line or CAGE
% 
%  Models= MakeEXM(mdev);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $  $Date: 2004/04/04 03:31:44 $

m= [];
mlist={};

if strcmp(guid(mdev),'twostage')
    p= mdev.BestModel;
    if p~=0
        % get models from local nodes
        [m,mlist]= MakeEXM(p.info,varargin{:});
    end
elseif hasBest(mdev);
    m = model(mdev);
    pResp= address(mdev);
    conModel= BoundaryModel(mdevtestplan(mdev),m);
    ModelInfo= exportinfo(info(project(mdev)),pResp,{m});
    m = xregstatsmodel(m,varname(m),ModelInfo,conModel);
end
