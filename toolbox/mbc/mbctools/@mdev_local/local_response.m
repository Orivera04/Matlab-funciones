function OK=local_response(mdev,hFig,View);
% MDEV_LOCAL/LOCAL_RESPONSE page 1 of local view

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:04:38 $

%L= model(mdev);
SNo= View.SweepPos;

[X,Y]= getdata(mdev);
Ns= size(X,3);
X=X(:,:,SNo);
Y=Y(:,:,SNo);

[m,OK]= LocalModel(mdev,SNo);

if OK
    i_setstring(View,m)
    
    DATUM= datum(m);
    
    % summary stats
    Pooled_RMSE= sqrt(mdev.MLE.Pooled_MSE);
    
    % update the Graph2d object
    
    diagnosticPlots(mdev,'updateview',hFig,View,m,X,Y);
    
    
    local_regstats('DisplayStats',View.Reg,SNo,address(mdev),m,X,Y);
    
    % update view model
    hModView= findobj(get(0,'child'),'flat','tag','mvModelView');
    if ~isempty(hModView)
        view(m,fullname(mdev),testnum(X),Pooled_RMSE);
    end
    
else
    hModView= findobj(get(0,'child'),'flat','tag','mvModelView');
    diagnosticPlots(mdev,'updateview',hFig,View,m,X,Y);
    if ~isempty(hModView)
        delete(get(get(hModView,'CurrentAxes'),'child'))
    end
    local_regstats('DisplayStats',View.Reg,SNo,address(mdev),m,X,Y);
    %  local_regstats('NoFit',View.Reg);
end 
if ~isa(mdev.Notes,'cell') | length(mdev.Notes)~=Ns 
    % make some empty notes
    mdev.Notes = cell(Ns,2);
    col= zeros(size(mdev.Notes,1),3);
    
    [mdev.Notes{:,1}]= deal('');
    mdev.Notes(:,2) = num2cell(col,2);
    
    pointer(mdev);
elseif size(mdev.Notes,2)~=2
    col= zeros(length(mdev.Notes),3);
    ci= ~cellfun('isempty',mdev.Notes);
    col(ci,:)= repmat([1 0.5 0],sum(ci),1);
    
    mdev.Notes = [mdev.Notes num2cell(col,2)];
    pointer(mdev);
end

note=mdev.Notes{SNo,1};
col=mdev.Notes{SNo,2};
set(View.Notes,'string','');
set(View.Color,'backgroundcolor',col);

set(View.Notes,'string',note);


function i_setstring(View,m)

set(View.mdlString,'string',['{\bfModel type:} \fontsize{10}', str_func(m,1)],...
	'shortstring',['{\bfModel Type:} \fontsize{10}',name(m)],...
	'verticalalignment','bottom',...
	'fontname',get(0,'defaultuicontrolfontname'),...
	'fontsize',get(0,'defaultuicontrolfontsize'));
Ytr = char(get(m,'ytrans'));
if ~isempty(Ytr)
    set(View.transString,'string',['Transform = ', Ytr],'shortstring',['y = ', Ytr]);
    set(View.allModelText,'colsizes',[-1,120]);
else
    set(View.transString,'string','');
    set(View.allModelText,'colsizes',[-1,1]);
end
return
