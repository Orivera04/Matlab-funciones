function x= getCrossSection(T,m);
%GETCROSSSECTION Get setting for cross-section viewer
%
%  x= GETCROSSSECTION(T,m);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.3 $  $Date: 2004/02/09 08:07:47 $

if isempty(T.PlotSetup)
    T= DefaultPlotSetup(T);
end

finputModel= factorNames(m);

% find which model to use
RespType=0;
mlist= getModel(T.DesignDev,':');
stInd= 1;
for i=1:length(mlist)
    fi= factorNames(mlist{i});
    if isequal(fi,finputModel)
        % Use Stage Model i
        RespType= 1;
        break
    elseif isequal(fi,finputModel(1:min(length(fi),end)))
        % response model i
        RespType= 2;
        break
    end
    stInd= stInd+ nfactors(mlist{i});
end

if RespType==0
    [RespType,i,stInd]= i_OldModels(m,mlist);    
end

switch RespType
    case 1
        % stage model
        nf= nfactors(mlist{i});
        x= T.PlotSetup.CrossSection(stInd:stInd+nf-1,:);
    case 2
        % response model
        x= T.PlotSetup.CrossSection(stInd:end,:);
end

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
