function A=ddeconv(arg,arg2,arg3)
% DDECONV  A dde conversation plugin for PPLOT. (Excel etc.)
% ----------------------------------------------------------
%                                   `-==-´ Joachim Johansson
% ----------------------------------------------------------

% ----------------------------------------------------------
% (c) 1997 `-==-´   Joachim Johansson.  All rights reserved.
%
% No part of this software  may be reproduced or transmitted
% in  any  form  or by any means,  electronic or mechanical,
% for any purpose  without  prior  written  consent  of  the
% author.
% 
% While  the software  is assumed to be accurate, the author
% assume no  responsibility  for  any  errors  or omissions.
% In  no  event  shall the author of this software be liable
% for special,  direct,  indirect,  or consequential damage,
% losses,  costs,  charges,  claims, demands, claim for lost
% profits, fees, or expences of any nature or kind. 
% ----------------------------------------------------------
if nargin==0
  global ddeuifig ddefig ddechannel ddeapp ddefile dderng ddevar ddedir ddeadvis ddecmd
  ddefig=gcf;
  ddeuifig=figure;
  ddechannel=0;
  clf;
  set(ddeuifig,'NumberTitle','off','Name','DDE PowerGraf Plugin','color', [1 1 1], 'Resize', 'off','MenuBar','none','Position', [130 150 300 250]);
  set(gca,'units','normal','pos',[0 0 1 1]);
  sparfill=fill([0 300 300 0 0],[0 0 80 80 0],[0.99 0.99 0.94],[0 300 300 0 0],[155 155 250 250 155],[0.99 0.99 0.94]);
  set(sparfill,'edgecolor',[1 1 1]);
  axis([0 300 0 250]);
  axis('off');
  text(0,0,'Application or Service:','FontSize',10,'color',[0.4 0.3 0],'units','pixels','pos',[5 235]);
  ddeapp=uicontrol('style','popupmenu','string',['excel';'none '],'units','pixels','pos',[235 225 60 20], 'BackgroundColor', [1 1 0.9]);
  text(0,0,'Filename or Topic (must be open):','FontSize',10,'color',[0.4 0.3 0],'units','pixels','pos',[5 215]);
  ddefile=uicontrol('style','edit','string','test.xls','units','pixels','pos',[5 185 225 20],'backgroundcolor', [0.9 0.9 0.83]);
  uicontrol('string','Browse...','Position', [235 185 60 20],'CallBack',...
            'global ddefile;[pgname,pgpath]=uigetfile(''*.xls'',''Load File'');if pgname,eval([''cd '' pgpath '';'']);set(ddefile,''string'',lower(pgname));clear pgname pgpath;end');
  text(0,0,'Data flow:','FontSize',10,'color',[0.4 0.3 0],'units','pixels','pos',[5 165]);
  ddedir=uicontrol('style','popupmenu','string',['import';'export'],'units','pixels','pos',[70 160 85 20], 'BackgroundColor', [1 1 0.9]);
  ddeadvis=uicontrol('style','check','value',0,'string','AUTO Dynamic Link','pos',[160 160 135 20],'foregroundcolor',[0.4 0.3 0],'backgroundcolor', [0.99 0.99 0.94],'callback',...
                   'global ddechannel ddefile ddeadvis;if (ddechannel&~get(ddeadvis,''value'')), ddeunadv(ddechannel,get(ddefile,''string''));end');

  text(0,0,'Enter Range (r=row,c=col) and Variable:','FontSize',10,'color','red','units','pixels','pos',[5 130]);
  text(0,0,'Range:','FontSize',10,'color','red','units','pixels','pos',[5 105]);
  dderng=uicontrol('style','edit','string','r1c1:r100c2','units','pixels','pos',[60 95 105 20],'backgroundcolor', [0.9 0.9 0.83]);
  text(0,0,'Variable:','FontSize',10,'color','red','units','pixels','pos',[170 105]);
  ddevar=uicontrol('style','edit','string','A','units','pixels','pos',[235 95 60 20],'backgroundcolor', [0.9 0.9 0.83]);

  text(0,0,'Enter command to execute (optional):','FontSize',10,'color',[0.4 0.3 0],'units','pixels','pos',[5 60]);
  ddecmd=uicontrol('style','edit','string','pplot(A(:,1),A(:,2))','units','pixels','pos',[5 30 225 20],'backgroundcolor', [0.9 0.9 0.83]);
  uicontrol('string','Apply','Position', [235 30 60 20],'CallBack',...
            'global ddeuifig ddefig ddechannel ddeapp ddefile dderng ddevar ddedir ddeadvis ddecmd;if ddechannel, ddeterm(ddechannel);end;eval([''global '' get(ddevar,''string'') '';ddechannel=ddeinit('''''' deblank(pplot(''element'',get(ddeapp,''value''),get(ddeapp,''string''))) '''''','''''' get(ddefile,''string'') '''''');'']);eval([''if '' num2str(get(ddedir,''value'')) ''==2 , ddepoke(ddechannel,'''''' get(dderng,''string'') '''''','' get(ddevar,''string'') '');ddeexec(ddechannel,'''''' get(ddecmd,''string'') '''''');else '' get(ddevar,''string'') ''=ddereq(ddechannel,'''''' get(dderng,''string'') '''''');figure(ddefig);'' get(ddecmd,''string'') '',if '' num2str(get(ddeadvis,''value'')) '', ddeadv(ddechannel,'''''' get(dderng,''string'') '''''',''''figure(ddefig);'' get(ddecmd,''string'') '''''','''''' get(ddevar,''string'') '''''');end;end;'']);');
  uicontrol('string','Close','Position', [235 5 60 20],'CallBack',...
            'global ddeuifig ddefig ddechannel ddeapp ddefile dderng ddevar ddedir ddeadvis ddecmd;if ddechannel, eval([''ddeunadv(ddechannel,'''''' get(ddefile,''string'') '''''');ddeterm(ddechannel);'']);end;close(ddeuifig);clear global ddeuifig ddefig ddechannel ddeapp ddefile dderng ddevar ddedir ddeadvis ddecmd');
end

