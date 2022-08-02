function specialPlots(m,plotname,axhand,xdata,ydata)
% function pH= specialPlots(m,plotname,ax)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:00:34 $

% checkdata?
%[xdata,ydata,dataOK]= checkdata(m,xdata,ydata);
% the statistics
dstats= stats(m.mv3xspline,'diagnostics');
[cookd,...
      leverage,...
      residuals,...
      response,...
      Xv,...
      studres,...
      yhat,...
      ci_hi,ci_lo]= deal(dstats{:});

% Plot indexes.
s_plt=[response yhat ci_hi ci_lo];
obs=1:length(response);

% Loop over the number of plots
switch lower(plotname)
case 'predicted/observed'					
   i_resppred(m,axhand);
case 'normal plot'
   i_normal(axhand,studres);
end

% ------------------------------------------------------------------------------
% function i_resppred
% ------------------------------------------------------------------------------
function i_resppred(m,axhand)
% Get the options from the context menu
ux= get(axhand,'uicontextmenu');
kids= get(ux,'children');
% Get the options from the context menu
ubd= findobj(kids,'tag','showBD1');
bdf= strcmp(get(ubd,'check'),'on');
uci= findobj(kids,'tag','confidence interval');
cif= strcmp(get(uci,'check'),'on');
utr= findobj(kids,'tag','ytrans_units');
trf= strcmp(get(utr,'check'),'on');
set([ubd,uci,utr],'enable','on');


p= get(MBrowser,'CurrentNode');
[X,Y,DataOK]= FitData(p.info);

plot(m,X,Y,DataOK,[bdf,trf,cif],axhand);


% ------------------------------------------------------------------------------
% function normal 				NORMAL.
% ------------------------------------------------------------------------------
function i_normal(axhand,studres)

p=mv_normplot(studres,axhand);
set(p,'parent',axhand,'hittest','off');
set(p(1),'tag','main line',...
   'hittest','on',...
   'buttondownfcn','diagnosticPlots(modeldev,''click'',gcbo)');

xH=get(axhand,'xlabel');
set(xH,'string','Probability','interpreter','none');
yH=get(axhand,'ylabel');
set(yH,'string','Data','interpreter','none');
% tH=get(axhand,'title');
% set(tH,'string','Normal Probability Plot','interpreter','none');