function [om,OK]= widperdim(m);
% use fminsearch to find the optimal widths

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.3 $  $Date: 2004/02/09 07:57:35 $
[omNest,OK] = iterateridge(m); 

om= contextimplementation(xregoptmgr,m,@i_widperdim,[],'WidPerDim',@widperdim);
om = AddOption(om,'NestedFitAlgorithm',omNest,'xregoptmgr', 'Lambda selection algorithm',2);
om = AddOption(om,'DisplayFlag',0,'boolean','Display');
om = AddOption(om,'MaxFunEvals',100*nfactors(m),{'int',[1 1000000]},'Maximum number of test widths');
om= AddOption(om,'cost',0,{'numeric',[-Inf,Inf]},[],false);
OK = 1;

function [m,cost,OK]=i_widperdim(m,om,x0,x,y,varargin)

alg = get(om,'NestedFitAlgorithm'); 

maxfunevals = get(om,'MaxFunEvals');
displayflag = get(om,'DisplayFlag');
if displayflag
    display = 'iter';
else
    display = '';
end    
% optimise the width parameter
fopts= optimset(optimset('fminsearch'),'display',display,'MaxFunEvals',maxfunevals);

%%%%%%%%%%%%%%%%%%%%time estimation
cheapflag  = get(alg,'CheapMode'); % must have a cheapmode!!
centalg = getCentalg(m);
% print a warning if things are going to be time-consuming
nObs = size(x,1); % number of data points
maxCStr= get(centalg,'MaxNCenters');
maxncenters = calcMaxNCenters(m,maxCStr,nObs);

% This is a problem as it assumes that the center selection algorithm has a 
% percentcandidates field. Need to fix this when we look at the time estimation/waitbar problem
try
   PcCandStr = get(centalg,'PercentCandidates');
catch
   PcCandStr =100;
end

PercentCandidates = calcPercentCand(m,PcCandStr,nObs);
ncand = (PercentCandidates/100)*nObs;%   

TimeEstimation = round((nObs/100)*sqrt((maxncenters/ncand)*nObs*(ncand))*(2-cheapflag));
str= '';
if TimeEstimation < 100 &  TimeEstimation > 10
    str = ['This may take a few minutes. Time estimation is ' num2str(TimeEstimation) ' units.'];
elseif  TimeEstimation > 100
    str = ['This may take more than a couple of minutes. Time estimation is ' num2str(TimeEstimation) ...
            ' units. Reduce MaxFunEvals to reduce the computation time. '];
end 
if ~isempty(str)
    mv_busy(str);
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


wid0= m.width;%initial width
if wid0 <0 
   [m,OK] = defaultwidth(m,x); % set the default width
   wid0 = m.width;
end 

if numel(wid0) ==1 
    wid0 = ones(1,nfactors(m))*wid0; % expand
end    
wid= fminsearch(@i_widperdimcostfn,wid0,fopts,m,x,y,alg);

m.width= wid;

alg = set(alg,'CheapMode',true);%will reselect the centers
[m,cost,OK] = run(alg,m,[],x,y);

mv_busy('delete');% delete the wait


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cost=i_widperdimcostfn(wid,m,x,y,alg)

m.width = wid;
alg = set(alg,'CheapMode',false);%will reselect the centers
[m,cost,OK]= run(alg,m,[],x,y);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
