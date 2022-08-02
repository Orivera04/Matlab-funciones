function [varargout]= getRespSurf(T,m);
%MDEVTESTPLAN/GETRESPSURF get setting for response surface viewer
%
% [x,DispType,Order]= getRespSurf(T,m);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.3 $  $Date: 2004/02/09 08:07:50 $


if isempty(T.PlotSetup)
    T= DefaultPlotSetup(T);
end

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
    case 0
        x= {[],1};    
    case 1
        x= T.PlotSetup.RespSurf(i).Stage;
    case 2
        x= T.PlotSetup.RespSurf(i).Response;
end
if length(x)<3
    % default order 
    x{3} = find( cellfun('prodofsize',x{1})>1 );
end
varargout= cell(1,nargout);
varargout(1:length(x))= x;

function [RespType,Stage]= i_OldModels(m,mlist)

if isa(m,'localmod') && nfactors(m)== nfactors(mlist{1}) 
    RespType= 1;
    Stage   = 1 ;
elseif isa(m,'xregtwostage')&& nfactors(m)== nfactors(mlist{1})+  nfactors(mlist{2})
    RespType= 2;
    Stage= 1;
elseif length(mlist)==2 && nfactors(m)== nfactors(mlist{2})
    RespType=1;
    Stage= 2;
else
    RespType=0;
    Stage   =1;
end


