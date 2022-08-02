function h= specialPlots(m,plotname,axhand,X,Y)
% function pH= specialPlots(m,plotname,ax)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:48:25 $

% would like h= specialPlots(m,X,Y,plotname,axhand)


% Loop over the number of plots

switch lower(plotname)
case 'predicted/observed'					
	% Predicted vs. Observed
	% move this option to diagnostic plots ?
   p= get(MBrowser,'CurrentNode');
	h= i_predobs(m,p,axhand);
case 'normal plot'
	h= i_normal(m,X,Y,axhand);
end

% ------------------------------------------------------------------------------
% function predobs			PREDICTED VS OBSERVED.
% ------------------------------------------------------------------------------
function h= i_predobs(m,p,axhand)
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

Opts= [bdf,trf,cif];

[X,Y,DataOk]= FitData(p.info);

% call the model/plot routine
h= plot(m,X,Y,DataOk,Opts,axhand);


% ------------------------------------------------------------------------------
% function normal 				NORMAL.
% ------------------------------------------------------------------------------
function h= i_normal(m,X,Y,axhand)

dstats= stats(m,'diagnostics');
[cookd,...
		leverage,...
		residuals,...
		response,...
		Xv,...
		studres,...
		yhat,...
		ci_hi,ci_lo]= deal(dstats{:});

h=mv_normplot(studres,axhand);
set(h,'parent',axhand,'hittest','off');
set(h(1),'tag','main line',...
   'hittest','on',...
   'buttondownfcn','diagnosticPlots(modeldev,''click'',gcbo)');
h= h(1);

xH=get(axhand,'xlabel');
set(xH,'string','Probability',...
   'fontweight','bold');
yH=get(axhand,'ylabel');
set(yH,'string','Data',...
   'fontweight','bold');
% tH=get(axhand,'title');
% set(tH,'string','Normal Probability Plot','fontweight','bold');

