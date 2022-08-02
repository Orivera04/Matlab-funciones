function h=specialPlots(md,plotname,ax,X,Y);
%SPECIALPLOTS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 08:05:50 $




switch lower(plotname)
case 'predicted/observed'					
	% Predicted vs. Observed
	% move this option to diagnostic plots ?
	h= i_predobs(md,ax);
case 'normal plot'
	h= i_normal(md,X,Y,ax);
end




% ------------------------------------------------------------------------------
% function predobs			PREDICTED VS OBSERVED.
% ------------------------------------------------------------------------------
function h= i_predobs(md,axhand)

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

[X,Y,DataOk]= FitData(md);

% call the model/plot routine
h= plot(model(md),X,Y,DataOk,Opts,axhand);

set(h,'color',[0.5 0 0.5],'markerfacecolor',[0.5 0 0.5])


% ------------------------------------------------------------------------------
% function normal 				NORMAL.
% ------------------------------------------------------------------------------
function h= i_normal(md,X,Y,axhand)

h=mv_normplot(md.DiagStats.SResiduals,axhand);
set(h,'parent',axhand,'hittest','off');
set(h(1),'tag','main line',...
   'hittest','on',...
   'buttondownfcn','diagnosticPlots(modeldev,''click'',gcbo)');
h= h(1);
set(h,'color',[0.5 0 0.5],'markerfacecolor',[0.5 0 0.5])

xH=get(axhand,'xlabel');
set(xH,'string','Probability',...
   'fontweight','bold');
yH=get(axhand,'ylabel');
set(yH,'string','Data',...
   'fontweight','bold');
% tH=get(axhand,'title');
% set(tH,'string','Normal Probability Plot','fontweight','bold');
