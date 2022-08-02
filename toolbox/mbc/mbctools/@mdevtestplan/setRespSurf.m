function T= setRespSurf(T,m,varargin);
%MDEVTESTPLAN/SETRESPSURF set setting for response surface viewer
%
% T= setRespSurf(T,m,x);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.3 $  $Date: 2004/02/09 08:08:18 $

finputModel= factorNames(m);

% find which model to use
RespType=0;
mlist= getModel(T.DesignDev,':');
for i=1:length(mlist)
    fi= factorNames(mlist{i});
    if isequal(fi,finputModel)
        % Use Stage Model i
        RespType= 1;
        break
    elseif isequal(fi,finputModel(1:min(end,length(fi))))
        % response model i
        RespType= 2;
        break
    end
end
if RespType==0
    [RespType,i]= i_OldModels(m,mlist);    
end
switch RespType
    case 1
        T.PlotSetup.RespSurf(i).Stage = varargin;
    case 2
        T.PlotSetup.RespSurf(i).Response= varargin;
end

xregpointer(T);


function [RespType,Stage]= i_OldModels(m,mlist)

if isa(m,'localmodel') 
    RespType= 1;
    Stage   = 1 ;
elseif isa(m,'xregtwostage')
    RespType= 2;
    Stage= 1;
elseif length(mlist)==2
    RespType=1;
    Stage= 2;
else
    RespType=2;
    Stage   =1;
end
