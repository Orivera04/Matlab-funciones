function [om,OK]= trialwidths(m)
%TRIALWIDTHS
%
%  [om,OK]= TRIALWIDTHS(m) returns an optimisation manager for
%  i_trialwidths,  an algorithm to test several widths by educated search

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.4.4 $  $Date: 2004/04/04 03:30:32 $

[omNest,OK] = iterateridge(m);

om= contextimplementation(xregoptmgr,m,@i_trialwidths,[],'TrialWidths',@trialwidths);

AllOpts= {@trialwidths, @widperdim, @fit_treeregression};
if false
    AllOpts= [AllOpts {@uGA,@uGA2,@ccGA,@widthsearch,@iterateridge,@iteraterols,@stepitrols}];
end

om = setAltMgrs(om,AllOpts);

om = AddOption(om,'NestedFitAlgorithm',omNest,'xregoptmgr', 'Lambda selection algorithm',2);

% fit parameters
om= AddOption(om,'NTrials',10,{'int',[2 100]}, 'Number of trial widths in each zoom');
om= AddOption(om,'NZooms',5,{'int',[1 100]}, 'Number of zooms');% number of zooms
om= AddOption(om,'LoWidth',0.01,{'numeric',[eps 1000]}, 'Initial lower bound on width');% lower bound on width
om= AddOption(om,'HiWidth',20,{'numeric',[eps 100]}, 'Initial upper bound on width');% upper bound on width
om= AddOption(om,'PlotFlag',0,'boolean', 'Display');% 1 for plotting
om= AddOption(om,'cost',Inf,{'numeric',[-Inf,Inf]},[],false);% field to store cost (GCV)



function [m,cost,OK,varargout] = i_trialwidths(m,om,x0,x,y,varargin)

ntrials= get(om,'NTrials');
nzooms = get(om,'nZooms');
lobound = get(om,'LoWidth');
hibound = get(om,'HiWidth');

alg = get(om,'NestedFitAlgorithm');

cheapflag  = get(alg,'CheapMode'); % must have a cheapmode!!
centalg = getCentalg(m);
try
    plotflag = get(om,'PlotFlag');
catch
    plotflag = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% offer the option to stop if too many plots will be produced
try
    plotflagalg = get(alg,'PlotFlag');
catch
    plotflagalg = 0;
end
if plotflagalg == 1
    ask = questdlg('This will produce an excessive number of plots. Continue?','Warning','Yes','No','No');
    if strcmp(ask,'No')
        cost = Inf;
        OK = 1;
        return
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


width = m.width;%width of the radial basis function
if length(width)>1 || width<0
    [m,OK] = defaultwidth(m,x); % set the default width
end

DLGTITLE = 'TrialWidths - Fitting RBF Model';
waitH = xregGui.waitdlg('title',DLGTITLE,'message','');
waitH.waitbar.min = 0;
waitH.waitbar.max = nzooms*ntrials + 1;

[m,junk,OK]=run(centalg,m,[],x,y);
for j =1:nzooms
    widths = linspace(lobound,hibound,ntrials)';
    bestlog10GCV = Inf;
    log10GCV = zeros(1, ntrials);
    for i = 1: ntrials
        waitH.message = sprintf('Computing width for zoom number %d', j);
        m.width = widths(i);
        [m,log10GCV(i),OK] = run(alg,m,[],x,y);
        if  bestlog10GCV  > log10GCV(i) % if things improve save settings
            bestlog10GCV=log10GCV(i);
            bestcenters = m.centers;
            bestlambda = get(m,'lambda');
            bestwidth = m.width;
            bestweights= double(m);
        end
        waitH.waitbar.value = (j-1)*ntrials + i;
    end
    [cost, index]= min(log10GCV);
    lenbound= hibound -lobound; % current length of width interval
    lobound = max((widths(index) -lenbound/5),eps);%
    hibound = widths(index) +lenbound/5;%narrow the bounds
    % want to ensure the best width so far is trialled in the next round
    newlenbound = hibound - lobound;
    newspacing = newlenbound/(ntrials-1);
    disttoopt = widths(index)-lobound;% how far the optimal width is along the new interval
    numbefore = max(floor(disttoopt/newspacing),0);
    numafter = ntrials -numbefore-1;
    lobound = widths(index) - numbefore*newspacing;
    hibound = widths(index) + numafter*newspacing;
    %%%%%%%%%%%%%%%%%%%%%%

    m.width = widths(index); % save the best width
    set(m,'lambda',bestlambda); % save the best lambda
    m.centers = bestcenters; % save the best centers
    m= update(m,bestweights);
    if plotflag ==1
        plothand =figure('menubar','none',...
            'toolbar','none',...
            'doublebuffer','on',...
            'numbertitle','off',...
            'name','Results of TrialWidths',...
            'color',get(0,'defaultuicontrolbackgroundcolor'));
        a = axes('parent',plothand,'ButtonDownFcn', 'mv_zoom');
        for i = 1:length(widths)
            line('parent',a,'XData',widths(i),'YData',log10GCV(i),'Color','r','Marker','o','LineStyle','none');
            line('parent',a,'XData',[widths(i) widths(i)],'YData',[0 log10GCV(i)]);
            line('parent',a,'XData',m.width,'YData',cost,'Color','g','Marker','*','LineStyle','none');
        end
        mbctitle(a,['TrialWidths, zoom number ' num2str(j)]);
        mbcxlabel(a,'width');
        mbcylabel(a,'log10(GCV)');
    end
    %match center selection to the new lambda and width
    [m,junk,OK]=run(centalg,m,[],x,y);

    % try running the fit again to see if the new centers helped
    alg = set(alg,'CheapMode',true);%no center reselection
    [m,newcost,OK] = run(alg,m,[],x,y);
    alg = set(alg,'CheapMode',cheapflag); % restore the setting
    % if it didn't help, then revert
    if newcost > bestlog10GCV
        m.centers = bestcenters;
        set(m,'lambda',bestlambda);
        m.width = bestwidth;
        m= update(m,bestweights);
    end
end
alg = set(alg,'CheapMode',true);
[m,cost,OK] = run(alg,m,[],x,y);%run the lambda iteration (no center reselection)
alg = set(alg,'CheapMode',cheapflag); % restore the setting

waitH.waitbar.value = nzooms*ntrials + 1;
delete(waitH);
