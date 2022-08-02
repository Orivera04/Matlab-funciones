function OK=print(md,h)
%MODELDEV\PRINT Generic print function for modeldev objects

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:05:02 $

%

OK=1;
View= h.GetViewData;
hFig= double(h.Figure);

CurTab = get(View.ChildTab,'currentcard');
% Will I have to delete the ModelView window I create
DELETE_MV = 0;

mvH = mvf('mvModelView');

if isempty(mvH)
    if CurTab==3
		 mbest= BestModel(md);
       if ~isempty(mbest) & mle_isrun(md)
          %% we have some MLE plots
          mvH= view(mbest);
       else %% don't do anything
          return
       end
    else
        [L,OK]= LocalModel(md,View.SweepPos);
        X= getdata(md,'X');
        X= X(:,:,View.SweepPos);
        if OK
            % summary stats
            ms= mle_stats(md);
            Pooled_RMSE= sqrt(ms.Pooled_MSE);
            mvH = view(L,fullname(md),testnum(X),Pooled_RMSE);
        end     
    end
    set(mvH,'visible','off');
    DELETE_MV = 1;
end

tH = findobj(mvH,'type','axes');

switch CurTab
case 1	
    aH = diagnosticPlots(md,'getcurrentaxes',hFig);
    %% returns all axes of the outleir line = diagnostic plots AND current monitor plots
    %% only want to print the axes visible in current view.
    aH = aH(strcmp(get(aH,'vis'),'on'));
case 2
    aH = mv_MonitorPlots('getgridlayout',hFig);
    if isempty(aH) %% there may be no monitor plots displayed
        aH=xregborderlayout(hFig);
    end
case 3 
    if isempty(findobj(hFig,'type','axes','visible','on'))
        %% when come on this tab we may have graphs
        %% but gca might be invisible (on a different card!)
        return
    else
        aH = View.MLEObj.regLyt;
    end
end

printlayout1(aH,tH,fullname(md));

if DELETE_MV
	close(mvH);
end
