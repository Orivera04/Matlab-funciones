
function T= setCrossSection(T,m,x);
%MDEVTESTPLAN/SETCrossSection set setting for cross-section viewer
%
% T= setCrossSection(T,m,x);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.3 $  $Date: 2004/02/09 08:08:16 $

finputModel= factorNames(m);

% find which model to use
RespType=0;
mlist= getModel(T.DesignDev,':');
stInd= 1;
for i=1:length(mlist)
    fi= factorNames(mlist{i});
    nf =nfactors(mlist{i});
    if isequal(fi,finputModel)
        % Use Stage Model i
        RespType= 1;
        break
    elseif isequal(fi,finputModel(1:min(end,length(fi))))
        % response model i
        RespType= 2;
        break
    end
    stInd= stInd+ nf;
end


if RespType==0
    [RespType,i,stInd]= i_OldModels(m,mlist);    
end
switch RespType
    case 1
        T.PlotSetup.CrossSection(stInd:stInd+nf-1,:) = x;
    case 2
        T.PlotSetup.CrossSection(stInd:end,:) = x;
end

xregpointer(T);


function [RespType,Stage,stInd]= i_OldModels(m,mlist)

stInd=1;
if isa(m,'localmodel') 
    RespType= 1;
    Stage   = 1 ;
elseif isa(m,'xregtwostage')
    RespType= 2;
    Stage= 1;
elseif length(mlist)==2
    stInd= nfactors(mlist{1})+1;
    RespType=1;
    Stage= 2;
else
    RespType=2;
    Stage   =1;
end
