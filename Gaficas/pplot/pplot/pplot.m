function ret1=pplot(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,...
                    arg9,arg10,arg11,arg12,arg13,arg14,arg15,...
                    arg16,arg17,arg18,arg19,arg20);

% PPLOT A graphical plot layout and design tool. (Shareware)
%       PPLOT is a  substitute  for the Matlab PLOT command.
%       PPLOT  without  arguments it is a substitute for the 
%       Matlab  FIGURE  command. Now you can create legends,
%       insert  text, titles and labels. You can place, move
%       and  resize  objects  simply  by  'click  and drag'. 
%       You can change properties on any object like colors, 
%       font, linewidth, linetype  etc., you can even rotate
%       text. 
%
%       The original  data  is  saved  to be able to analyse
%       complex data. You can make all kinds of calculations
%       and analyses on the plotted data.
% 
%       Any number of figures  containing any number of axes
%       can be created. The plot  goes  to the active figure
%       and  you  can  select  destination  axes  simply  by
%       clicking with the mouse. An unlimited  undo makes it
%       easy to test different layouts. PPLOT  comes  with a
%       large number of plugins to  plot Smith  charts, draw
%       arrows, filters for a number of file formats etc.
%
%       - Everything  you  wanted  to do with your plots but
%       were afraid to ask... 
%       
%       See also PLOT, FIGURE and AXES      
%
% ----------------------------------------------------------
% (c) 1997-1999 Joachim Johansson 
%               <Joachim.K.Johansson@telia.se>
%               http://extwww.lulea.trab.se/users/joajoh/    
% ----------------------------------------------------------

% ----------------------------------------------------------
% (c) 1997-1999     Joachim Johansson.  All rights reserved.
%
% No part of this software  may be reproduced or transmitted
% in  any  form  or by any means,  electronic or mechanical,
% for any purpose without thinking of registering.
% 
% While  the software  is assumed to be accurate, the author
% assume no  responsibility  for  any  errors  or omissions.
% In  no  event  shall the author of this software be liable
% for special,  direct,  indirect,  or consequential damage,
% losses,  costs,  charges,  claims, demands, claim for lost
% profits, fees, or expences of any nature or kind. 
%
% This program is ShareWare. Please send Name, address, 
% e-mail address and USD 15.00 or equivalent amount in your
% local currency, or whatever you think it is worth, to the 
% address below. (30 days free)
%
%                                    Joachim Johansson
%                                    Docentv. 239
%                                    S-977 51  LULEÅ
%                                    SWEDEN
% ----------------------------------------------------------

pgver=version;
mat5=str2num(pgver(1))>4;
if mat5, warning('off'); end

%-Customise-here------------------------------------------------------
%
% Format choises:
%
pgwidths=['0.5'; '1  '; '2  '; '3  '; '4  '];

pglines=['  - '; '  --'; '  : '; '  -.'];

if mat5
  pglines=[pglines; 'none'];
  pgmarkers=['         +'; '         o'; '         *'; '         .'; '         x'; '    square'; '   diamond'; '         v'; '         ^'; '         >'; '         <'; ' pentagram'; '  hexagram'; '      none'];
else
  pgtypes=[pglines; '  o '; '  x '; '  + '; '  * '; '  . '];
end

pgrots=[' 90'; ' 45'; '  0'; '-45'; '-90'];

pgsaveforms=['                    ';'-ascii              ';'-ascii -double      ';'-ascii -double -tabs'];

%---------------------------------------------------------------------

if nargin==0

  % Plugins:  Description (in menu):    Filename:
  %
  plugins=['S-parameter Tool...      ';'spar                     ';...
           'DDE Conversation...      ';'ddeconv                  '];

  %---------------------------------------------------------------------
  if isempty(findstr(get(gcf,'name'),'PowerGraf Plot')) 
    new=isempty(findobj(gcf,'type','line'));
    if ~new
      pgdlguifig=figure;
      clf;
      set(pgdlguifig,'NumberTitle','off','Name','PowerGraf Question','color', [1 1 1], 'Resize', 'off','MenuBar','none','Position', [130 150 300 60],'userdata',0);
      set(gca,'units','normal','pos',[0 0 1 1]);
      axis('off');
      text(0,0,'Do you want to grab the current figure?','color',[0.4 0.3 0],'units','pixels','pos',[5 40]);
      uicontrol('string','Yes', 'Position', [170 5 60 20],'CallBack','set(gcf,''userdata'',''Yes'');');
      uicontrol('string','No', 'Position', [235 5 60 20],'CallBack','set(gcf,''userdata'',''No'');');
      click=get(pgdlguifig,'UserData');
      while ~click,
        click=get(pgdlguifig,'UserData');
        drawnow;
      end
      close(pgdlguifig);
      if strcmp(click,'No')
        ps=get(gcf,'pos');
        figure;
        set(gcf,'pos',[ps(1)+21 ps(2)-21 ps(3) ps(4)]);
        new=1;
      end
    end
  else
    ps=get(gcf,'pos');
    figure;
    set(gcf,'pos',[ps(1)+21 ps(2)-21 ps(3) ps(4)]);
    new=1;
  end
  if new
    delete(findobj(gcf,'type','axes'));
    whitebg(gcf,[1 1 1]);
    set([gcf,gca],'units','pixels');
    ps=get(gcf,'pos');
    pos=get(gca,'pos');
    set(gcf,'pos', [ps(1) ps(2)+ps(4)-420 560 420]);
    pos=[pos(1)+5 pos(2)+5 pos(3)-10 pos(4)-10];
    set(gca,'pos',[-1 -1 1 1],'userdata',[0 0 0 0 0 0],'xgrid','on','ygrid','on','box','on');
  end
  set(0,'defaulttextfontsize',10);
  set(gcf,'userdata',gca,...
    'defaultaxesxgrid','on','defaultaxesygrid','on',...
    'defaultaxesbox','on','defaultaxesunits','pixels','defaultaxesfontsize',10,...
    'NumberTitle','off','Name','PowerGraf Plot Editor','MenuBar','none',...
    'WindowButtonUpFcn','set(gcf,''WindowButtonMotionFcn'','''');set(gcf,''WindowButtonDownFcn'',''pplot(''''info'''',''''off'''');'');set(gcf,''pointer'',''arrow'');clear pgxdat pgydat pgcpnt pgcpos pgnpnt pgp1 pgp2 pgobj pgpcol pgaxpos;');
  
  %---------------------------------------------------------------------
  pffilemn=uimenu(gcf,'Label','&File','Callback','pplot(''info'',''off'');');
  pgeditmn=uimenu(gcf,'Label','&Edit','Callback','pplot(''info'',''off'');');
  pginsmenu=uimenu(gcf,'Label','&Insert','Callback','pplot(''info'',''off'');');
  pgselmn=uimenu(gcf,'Label','&Select','Callback','pplot(''info'',''off'');');
  pgformatmn=uimenu(gcf,'Label','F&ormat','Callback','pplot(''info'',''off'');');
  pgdatamn=uimenu(gcf,'Label','&Data','Callback','pplot(''info'',''off'');');
  pgmvmn=uimenu(gcf,'Label','&Move','Callback','pplot(''info'',''off'');');
  pgdelmn=uimenu(gcf,'Label','&Delete','Callback','pplot(''info'',''off'');');
  pgtoolmenu=uimenu(gcf,'Label','&Tools','Callback','pplot(''info'',''off'');');
  drawnow;

  %---------------------------------------------------------------------
    uimenu(pffilemn,'Label','&New Window','CallBack','pplot;');
    uimenu(pffilemn,'Label','&Open...','Separator','On','CallBack','[pgname,pgpath]=uigetfile(''*.m'',''Load Saved File'');if pgname, eval([''cd('''''' pgpath '''''');'']);eval([ lower(name(1:find(pgname==''.'')-1)) '';'']);end;clear pgname pgpath');
    uimenu(pffilemn,'Label','&Save...','CallBack','[pgname,pgpath]=uiputfile(''*.m'',''Save File'');if pgname,set(findobj(gcf,''type'',''axes''),''userdata'',[]);eval([''print -dmfile '',pgpath,lower(pgname)]);end;clear pgname pgpath');
    pffilesvimn=uimenu(pffilemn,'Label','&Save Image');
    if (strcmp(computer,'PCWIN')|strcmp(computer,'MAC2'))
      uimenu(pffilesvimn,'Label','Save as &Metafile...','CallBack','pplot(''setsize'');[pgname,pgpath]=uiputfile(''*.wmf'',''Save Metafile Figure'');if pgname,eval([''print -dmeta '',pgpath,lower(pgname)]);end;clear pgname pgpath');
      uimenu(pffilesvimn,'Label','Save as &Bitmap...','CallBack','pplot(''setsize'');[pgname,pgpath]=uiputfile(''*.bmp'',''Save Bitmap Figure'');if pgname,eval([''print -dbitmap '',pgpath,lower(pgname)]);end;clear pgname pgpath');
      uimenu(pffilesvimn,'Label','Save as &EPS...','CallBack','pplot(''setsize'');[pgname,pgpath]=uiputfile(''*.eps'',''Save as Encapsulated Postscript'');if pgname,eval([''print -depsc2 '',pgpath,pgname]);end;clear pgname pgpath');
    else
      uimenu(pffilesvimn,'Label','Save as &EPS...','Separator','On','CallBack','pplot(''setsize'');[pgname,pgpath]=uiputfile(''*.eps'',''Save as Encapsulated Postscript'');if pgname,eval([''print -depsc2 '',pgpath,pgname]);end;clear pgname pgpath');
      uimenu(pffilesvimn,'Label','Save as &HPGL...','CallBack','pplot(''setsize'');[pgname,pgpath]=uiputfile(''*.hgl'',''Save as HP Graphic Language'');if pgname,eval([''print -dhpgl '',pgpath,pgname]);end;clear pgname pgpath');
      uimenu(pffilesvimn,'Label','Save as &Bitmap...','CallBack','pplot(''setsize'');[pgname,pgpath]=uiputfile(''*.bmp'',''Save as Bitmap'');if pgname,eval([''print -dbmp256 '',pgpath,pgname]);end;clear pgname pgpath');
      uimenu(pffilesvimn,'Label','Save as P&DF...','CallBack','pplot(''setsize'');[pgname,pgpath]=uiputfile(''*.pdf'',''Save as Adobe Acrobat'');if pgname,pgname=pgname(1:find(pgname==''.'')-1);eval([''print -dpsc2 '' pgpath pgname ''.ps;unix(''''distill '' pgpath pgname ''.ps'''');unix(''''rm '' pgpath pgname ''.ps'''');'']);end;clear pgname pgpath');
    end
    pffileldmn=uimenu(pffilemn,'Label','&Load','Separator','On');
      uimenu(pffileldmn,'Label','Default X-parameter...','CallBack','pplot(''load'',''xpar'');');
    pffileclmn=uimenu(pffilemn,'Label','&Clear');
      uimenu(pffileclmn,'Label','Clear Default X-parameter','CallBack','global defaultx;defaultx=[];clear defaultx;clear global defaultx;');
      uimenu(pffileclmn,'Label','Workspace','Separator','On','CallBack','clear all;clear global');
    if (strcmp(computer,'PCWIN')|strcmp(computer,'MAC2'))
      uimenu(pffilemn,'Separator','On','Label','&Print...','CallBack','pplot(''setsize'');print -v');
      uimenu(pffilemn,'Label','P&rinter Setup...','CallBack','pplot(''setsize'');print -dsetup');
    else
      pffileprmn=uimenu(pffilemn,'Separator','On','Label','&Print');
        uimenu(pffileprmn,'Label','Print to Default','CallBack','pplot(''setsize'');print -depsc2');
        uimenu(pffileprmn,'Separator','On','Label','Print to Digital (lw)','CallBack','pplot(''setsize'');print -Plw');
        uimenu(pffileprmn,'Label','Print to lw1','CallBack','pplot(''setsize'');print -Plw1');
        uimenu(pffileprmn,'Label','Print to lw2','CallBack','pplot(''setsize'');print -Plw2');
        uimenu(pffileprmn,'Label','Print to color','CallBack','pplot(''setsize'');print -Pcolor');
    end
    uimenu(pffilemn,'Label','Close','Separator','On','CallBack','close(gcf);');

  %---------------------------------------------------------------------
    uimenu(pgeditmn,'Label','&Undo','enable','off','Callback','pplot(''undo'');');
    if (strcmp(computer,'PCWIN')|strcmp(computer,'MAC2'))
      uimenu(pgeditmn,'Label','Copy as &Metafile','Separator','On','Callback','pplot(''setsize'');print -dmeta');
      uimenu(pgeditmn,'Label','Copy as &Bitmap','Callback','pplot(''setsize'');print -dbitmap');
    else
      uimenu(pgeditmn,'Label','Copy as &Metafile','Separator','On','enable','off');
      uimenu(pgeditmn,'Label','Copy as &Bitmap','enable','off');
    end
    uimenu(pgeditmn,'Label','&Clear figure','Separator','On','Callback','pplot(''clear'',''figure'');');

  %---------------------------------------------------------------------
    uimenu(pginsmenu,'Label','Te&xt...','Callback','pplot(''insert'',''text'');');
    uimenu(pginsmenu,'Label','&Title...','Callback','pplot(''insert'',''title'');');
    uimenu(pginsmenu,'Label','&X-Label...','Callback','pplot(''insert'',''xlabel'');');
    uimenu(pginsmenu,'Label','&Y-Label...','Callback','pplot(''insert'',''ylabel'');');
    uimenu(pginsmenu,'Label','&Legend...','Callback','pplot(''insert'',''legend'');');
    uimenu(pginsmenu,'Label','New &Axis +','Separator','On','Callback','pplot(''insert'',''axes'');');

  %---------------------------------------------------------------------
    uimenu(pgselmn,'Label','L&ine +','Callback','pplot(''select'',''line'');');
    uimenu(pgselmn,'Label','Te&xt +','Callback','pplot(''select'',''text'');');
    uimenu(pgselmn,'Label','&Legend +','Callback','pplot(''select'',''legend'');');
    uimenu(pgselmn,'Label','&Axis +','Separator','On','Callback','pplot(''select'',''axes'');');

  %---------------------------------------------------------------------
    pglinemn=uimenu(pgformatmn,'Label','L&ine');
      pglinecolmn=uimenu(pglinemn,'Label','Color...','Callback','pplot(''format'',''line'',''color'');');
      pglinewidthmn=uimenu(pglinemn,'Label','Width','Separator','On');
        for i=1:size(pgwidths,1)
          uimenu(pglinewidthmn,'Label',pgwidths(i,:),'Callback',['pplot(''format'',''line'',''linewidth'',' pgwidths(i,:) ');']);
        end
      if mat5
        pglinelinemn=uimenu(pglinemn,'Label','LineStyle');
          for i=1:size(pglines,1)
            uimenu(pglinelinemn,'Label',pglines(i,:),'Callback',['pplot(''format'',''line'',''linestyle'',''' pglines(i,:) ''');']);
          end
        pglinemarkmn=uimenu(pglinemn,'Label','Marker');
          for i=1:size(pgmarkers,1)
            uimenu(pglinemarkmn,'Label',pgmarkers(i,:),'Callback',['pplot(''format'',''line'',''marker'',''' pgmarkers(i,:) ''');']);
          end
      else
        pglinetypemn=uimenu(pglinemn,'Label','Type');
          for i=1:size(pgtypes,1)
            uimenu(pglinetypemn,'Label',pgtypes(i,:),'Callback',['pplot(''format'',''line'',''linestyle'',''' pgtypes(i,:) ''');']);
          end
      end
  
    pgtextmn=uimenu(pgformatmn,'Label','Te&xt','Separator','On');
      uimenu(pgtextmn,'Label','Color...','Callback','pplot(''format'',''text'',''color'');');
      uimenu(pgtextmn,'Label','Font...','Callback','pplot(''format'',''text'',''font'');');
      uimenu(pgtextmn,'Label','Edit...','Callback','pplot(''format'',''text'',''edit'');');
      pgtextrotmn=uimenu(pgtextmn,'Label','Rotate','Separator','On');
        uimenu(pgtextrotmn,'Label','Free','Callback','pplot(''format'',''text'',''rotate'',-1000);');
        for i=1:size(pgrots,1)
          uimenu(pgtextrotmn,'Label',pgrots(i,:),'Callback',['pplot(''format'',''text'',''rotate'',' pgrots(i,:) ');']);
        end

    pgtitlemn=uimenu(pgformatmn,'Label','&Title');
      uimenu(pgtitlemn,'Label','Color...','Callback','pplot(''format'',''title'',''color'');');
      uimenu(pgtitlemn,'Label','Font...','Callback','pplot(''format'',''title'',''font'');');
      uimenu(pgtitlemn,'Label','Edit...','Callback','pplot(''format'',''title'',''edit'');');

    pgxlabelmn=uimenu(pgformatmn,'Label','&X-Label');
      uimenu(pgxlabelmn,'Label','Color...','Callback','pplot(''format'',''xlabel'',''color'');');
      uimenu(pgxlabelmn,'Label','Font...','Callback','pplot(''format'',''xlabel'',''font'');');
      uimenu(pgxlabelmn,'Label','Edit...','Callback','pplot(''format'',''xlabel'',''edit'');');

    pgylabelmn=uimenu(pgformatmn,'Label','&Y-Label');
      uimenu(pgylabelmn,'Label','Color...','Callback','pplot(''format'',''ylabel'',''color'');');
      uimenu(pgylabelmn,'Label','Font...','Callback','pplot(''format'',''ylabel'',''font'');');
      uimenu(pgylabelmn,'Label','Edit...','Callback','pplot(''format'',''ylabel'',''edit'');');

    pglegmn=uimenu(pgformatmn,'Label','&Legend','Separator','On');
      uimenu(pglegmn,'Label','Color...','Callback','pplot(''format'',''legend'',''color'');');
      uimenu(pglegmn,'Label','Font...','Callback','pplot(''format'',''legend'',''font'');');
      uimenu(pglegmn,'Label','Reposition +','Separator','On','callback','pplot(''format'',''legend'',''resize'');');
      pglegboxmn=uimenu(pglegmn,'Label','Box');
        uimenu(pglegboxmn,'Label','On','Callback','pplot(''format'',''legend'',''box'',''on'');');
        uimenu(pglegboxmn,'Label','Off','Callback','pplot(''format'',''legend'',''box'',''off'');');
      uimenu(pglegmn,'Label','Bring to front','Separator','On','callback','pplot(''format'',''legend'',''front'');');

    pgaxmn=uimenu(pgformatmn,'Label','&Axis');
      uimenu(pgaxmn,'Label','Color...','Callback','pplot(''format'',''axes'',''color'');');
      uimenu(pgaxmn,'Label','Font...','Callback','pplot(''format'',''axes'',''font'');');
      pgaxlimmn=uimenu(pgaxmn,'Label','Limits','Separator','On');
        uimenu(pgaxlimmn,'Label','Auto','callback','pplot(''format'',''axes'',''limits'',''auto'');');
        uimenu(pgaxlimmn,'Label','Freeze','callback','pplot(''format'',''axes'',''limits'',''freeze'');');
        uimenu(pgaxlimmn,'Label','Fit','Separator','On','callback','pplot(''format'',''axes'',''limits'',''fit'');');
        uimenu(pgaxlimmn,'Label','Set...','callback','pplot(''format'',''axes'',''limits'',''set'');');
      pgaxsizemn=uimenu(pgaxmn,'Label','Size');
        uimenu(pgaxsizemn,'Label','Reposition +','callback','pplot(''format'',''axes'',''size'',''reposition'');');
        uimenu(pgaxsizemn,'Label','Copy Size +','callback','pplot(''format'',''axes'',''size'',''copy'');');
        uimenu(pgaxsizemn,'Label','Square','Separator','On','callback','pplot(''format'',''axes'',''size'',''square'');');
      pgaxalignmn=uimenu(pgaxmn,'Label','Align');
        pgaxalignwmn=uimenu(pgaxalignmn,'Label','To Window');
          pgaxalignhwmn=uimenu(pgaxalignwmn,'Label','Horizontal');
            uimenu(pgaxalignhwmn,'Label','Left','callback','pplot(''format'',''axes'',''align'',''window'',''hleft'');');
            uimenu(pgaxalignhwmn,'Label','Center','callback','pplot(''format'',''axes'',''align'',''window'',''hcent'');');
            uimenu(pgaxalignhwmn,'Label','Right','callback','pplot(''format'',''axes'',''align'',''window'',''hright'');');
          pgaxalignvwmn=uimenu(pgaxalignwmn,'Label','Vertical');
            uimenu(pgaxalignvwmn,'Label','Top','callback','pplot(''format'',''axes'',''align'',''window'',''vtop'');');
            uimenu(pgaxalignvwmn,'Label','Center','callback','pplot(''format'',''axes'',''align'',''window'',''vcent'');');
            uimenu(pgaxalignvwmn,'Label','Bottom','callback','pplot(''format'',''axes'',''align'',''window'',''vbottom'');');
        pgaxalignomn=uimenu(pgaxalignmn,'Label','To Other');
          pgaxalignhomn=uimenu(pgaxalignomn,'Label','Horizontal');
            uimenu(pgaxalignhomn,'Label','Left +','callback','pplot(''format'',''axes'',''align'',''other'',''hleft'');');
            uimenu(pgaxalignhomn,'Label','Center +','callback','pplot(''format'',''axes'',''align'',''other'',''hcent'');');
            uimenu(pgaxalignhomn,'Label','Right +','callback','pplot(''format'',''axes'',''align'',''other'',''hright'');');
          pgaxalignvomn=uimenu(pgaxalignomn,'Label','Vertical');
            uimenu(pgaxalignvomn,'Label','Top +','callback','pplot(''format'',''axes'',''align'',''other'',''vtop'');');
            uimenu(pgaxalignvomn,'Label','Center +','callback','pplot(''format'',''axes'',''align'',''other'',''vcent'');');
            uimenu(pgaxalignvomn,'Label','Bottom +','callback','pplot(''format'',''axes'',''align'',''other'',''vbottom'');');
      pgxaxismn=uimenu(pgaxmn,'Label','X-axis','Separator','On');
        uimenu(pgxaxismn,'Label','Color...','Callback','pplot(''format'',''axes'',''xaxis'',''color'');');
        pgxaxiscalemn=uimenu(pgxaxismn,'Label','Scale','Separator','On');
          uimenu(pgxaxiscalemn,'Label','Linear','Callback','pplot(''format'',''axes'',''xaxis'',''scale'',''linear'');');
          uimenu(pgxaxiscalemn,'Label','Logarithmic','Callback','pplot(''format'',''axes'',''xaxis'',''scale'',''log'');');
        pgxaxigridmn=uimenu(pgxaxismn,'Label','Grid');
          uimenu(pgxaxigridmn,'Label','On','Callback','pplot(''format'',''axes'',''xaxis'',''grid'',''on'');');
          uimenu(pgxaxigridmn,'Label','Off','Callback','pplot(''format'',''axes'',''xaxis'',''grid'',''off'');');
        uimenu(pgxaxismn,'Label','Flip','Separator','On','Callback','pplot(''format'',''axes'',''xaxis'',''flip'');');
      pgyaxismn=uimenu(pgaxmn,'Label','Y-axis');
        uimenu(pgyaxismn,'Label','Color...','Callback','pplot(''format'',''axes'',''yaxis'',''color'');');
        pgyaxiscalemn=uimenu(pgyaxismn,'Label','Scale','Separator','On');
          uimenu(pgyaxiscalemn,'Label','Linear','Callback','pplot(''format'',''axes'',''yaxis'',''scale'',''linear'');');
          uimenu(pgyaxiscalemn,'Label','Logarithmic','Callback','pplot(''format'',''axes'',''yaxis'',''scale'',''log'');');
        pgyaxigridmn=uimenu(pgyaxismn,'Label','Grid');
          uimenu(pgyaxigridmn,'Label','On','Callback','pplot(''format'',''axes'',''yaxis'',''grid'',''on'');');
          uimenu(pgyaxigridmn,'Label','Off','Callback','pplot(''format'',''axes'',''yaxis'',''grid'',''off'');');
        uimenu(pgyaxismn,'Label','Flip','Separator','On','Callback','pplot(''format'',''axes'',''yaxis'',''flip'');');
      pgaxboxmn=uimenu(pgaxmn,'Label','Box','Separator','On');
        uimenu(pgaxboxmn,'Label','On','Callback','pplot(''format'',''axes'',''box'',''on'');');
        uimenu(pgaxboxmn,'Label','Off','Callback','pplot(''format'',''axes'',''box'',''off'');');
      pgaxgtypemn=uimenu(pgaxmn,'Label','Gridtype');
        for i=1:size(pglines,1)
          uimenu(pgaxgtypemn,'Label',pglines(i,:),'Callback',['pplot(''format'',''axes'',''gridtype'',''' pglines(i,:) ''');']);
        end

    gcfmn=uimenu(pgformatmn,'Label','&Window');
      uimenu(gcfmn,'Label','Color...','Callback','pplot(''format'',''window'',''color'');');

  %---------------------------------------------------------------------
    pgdatacdmn=uimenu(pgdatamn,'Label','Current Line Data','Callback','pplot(''info'',''Apply to the (complex) data of the current line'');');
      pgdatacddsmn=uimenu(pgdatacdmn,'Label','Display');
        uimenu(pgdatacddsmn,'Label','real(Y)','Callback','pplot(''data'',''current'',''data'',''display'',''real(Y)'');');
        uimenu(pgdatacddsmn,'Label','imag(Y)','Callback','pplot(''data'',''current'',''data'',''display'',''imag(Y)'');');
        uimenu(pgdatacddsmn,'Label','abs(Y)','Callback','pplot(''data'',''current'',''data'',''display'',''abs(Y)'');');
        uimenu(pgdatacddsmn,'Label','angle(Y)','Callback','pplot(''data'',''current'',''data'',''display'',''angle(Y)'');');
        uimenu(pgdatacddsmn,'Label','10.*log10(Y)','Separator','On','Callback','pplot(''data'',''current'',''data'',''display'',''10.*log10(Y)'');');
        uimenu(pgdatacddsmn,'Label','20.*log10(Y)','Callback','pplot(''data'',''current'',''data'',''display'',''20.*log10(Y)'');');
        uimenu(pgdatacddsmn,'Label','Custom...','Separator','On','Callback','pplot(''data'',''current'',''data'',''display'',''custom'');');
      pgdatacdnlmn=uimenu(pgdatacdmn,'Label','New Line','Separator','On');
        pgdatacdnlftmn=uimenu(pgdatacdnlmn,'Label','Fit Line');
          uimenu(pgdatacdnlftmn,'Label','Constant','Callback','pplot(''data'',''current'',''data'',''newline'',''fitline'',0);');
          uimenu(pgdatacdnlftmn,'Label','Line','Callback','pplot(''data'',''current'',''data'',''newline'',''fitline'',1);');
          pgdatacdnlftplmn=uimenu(pgdatacdnlftmn,'Label','Polynom');
            for i=1:9
              uimenu(pgdatacdnlftplmn,'Label',['Degree ' num2str(i)],'Callback',['pplot(''data'',''current'',''data'',''newline'',''fitline'',' num2str(i) ');']);
            end
        uimenu(pgdatacdnlmn,'Label','max(Y)','Separator','On','Callback','pplot(''data'',''current'',''data'',''newline'',''max(Y)'');');
        uimenu(pgdatacdnlmn,'Label','min(Y)','Callback','pplot(''data'',''current'',''data'',''newline'',''min(Y)'');');
        uimenu(pgdatacdnlmn,'Label','mean(Y)','Callback','pplot(''data'',''current'',''data'',''newline'',''mean(Y)'');');
        uimenu(pgdatacdnlmn,'Label','median(Y)','Callback','pplot(''data'',''current'',''data'',''newline'',''median(Y)'');');
        uimenu(pgdatacdnlmn,'Label','std(Y)','Callback','pplot(''data'',''current'',''data'',''newline'',''std(Y)'');');
        uimenu(pgdatacdnlmn,'Label','Custom...','Separator','On','Callback','pplot(''data'',''current'',''data'',''newline'',''custom'');');
      pgdatacdspmn=uimenu(pgdatacdmn,'Label','New Plot');
        if exist('smith')==2
          uimenu(pgdatacdspmn,'Label','Smith Chart','Callback','pplot(''data'',''current'',''data'',''newplot'',''smith(Y,135);'');');
        else
          uimenu(pgdatacdspmn,'Label','Smith Chart','enable','off');
        end
        uimenu(pgdatacdspmn,'Label','Polar Plot','Callback','pplot(''data'',''current'',''data'',''newplot'',''polar(angle(Y),abs(Y))'');');
        uimenu(pgdatacdspmn,'Label','Complex Plot','Callback','pplot(''data'',''current'',''data'',''newplot'',''plot(real(Y),imag(Y))'');');
        uimenu(pgdatacdspmn,'Label','Angle Histogram','Callback','pplot(''data'',''current'',''data'',''newplot'',''rose(angle(Y))'');');
        uimenu(pgdatacdspmn,'Label','hist(Y)','Separator','On','Callback','pplot(''data'',''current'',''data'',''newplot'',''hist(Y)'');');
        uimenu(pgdatacdspmn,'Label','stem(X,Y)','Callback','pplot(''data'',''current'',''data'',''newplot'',''stem(X,Y)'');');
        uimenu(pgdatacdspmn,'Label','stairs(X,Y)','Callback','pplot(''data'',''current'',''data'',''newplot'',''stairs(X,Y)'');');
        uimenu(pgdatacdspmn,'Label','Custom...','Separator','On','Callback','pplot(''data'',''current'',''data'',''newplot'',''custom'');');
      pgdatacdsvmn=uimenu(pgdatacdmn,'Label','Save...','Separator','On','Callback','pplot(''data'',''current'',''data'',''save'');');
    pgdatactmn=uimenu(pgdatamn,'Label','Current Line Trace','Callback','pplot(''info'',''Apply to the displayed trace of the current line'');');
      pgdatactdsmn=uimenu(pgdatactmn,'Label','Display');
        uimenu(pgdatactdsmn,'Label','10.*log10(Y)','Callback','pplot(''data'',''current'',''trace'',''display'',''10.*log10(Y)'');');
        uimenu(pgdatactdsmn,'Label','20.*log10(Y)','Callback','pplot(''data'',''current'',''trace'',''display'',''20.*log10(Y)'');');
        uimenu(pgdatactdsmn,'Label','Custom...','Separator','On','Callback','pplot(''data'',''current'',''trace'',''display'',''custom'');');
      pgdatactnlmn=uimenu(pgdatactmn,'Label','New Line','Separator','On');
        pgdatactnlftmn=uimenu(pgdatactnlmn,'Label','Fit Line');
          uimenu(pgdatactnlftmn,'Label','Constant','Callback','pplot(''data'',''current'',''trace'',''newline'',''fitline'',0);');
          uimenu(pgdatactnlftmn,'Label','Line','Callback','pplot(''data'',''current'',''trace'',''newline'',''fitline'',1);');
          pgdatactnlftplmn=uimenu(pgdatactnlftmn,'Label','Polynom');
            for i=1:9
              uimenu(pgdatactnlftplmn,'Label',['Degree ' num2str(i)],'Callback',['pplot(''data'',''current'',''trace'',''newline'',''fitline'',' num2str(i) ');']);
            end
        uimenu(pgdatactnlmn,'Label','max(Y)','Separator','On','Callback','pplot(''data'',''current'',''trace'',''newline'',''max(Y)'');');
        uimenu(pgdatactnlmn,'Label','min(Y)','Callback','pplot(''data'',''current'',''trace'',''newline'',''min(Y)'');');
        uimenu(pgdatactnlmn,'Label','mean(Y)','Callback','pplot(''data'',''current'',''trace'',''newline'',''mean(Y)'');');
        uimenu(pgdatactnlmn,'Label','median(Y)','Callback','pplot(''data'',''current'',''trace'',''newline'',''median(Y)'');');
        uimenu(pgdatactnlmn,'Label','std(Y)','Callback','pplot(''data'',''current'',''trace'',''newline'',''std(Y)'');');
        uimenu(pgdatactnlmn,'Label','Custom...','Separator','On','Callback','pplot(''data'',''current'',''trace'',''newline'',''custom'');');
      pgdatactspmn=uimenu(pgdatactmn,'Label','New Plot');
        uimenu(pgdatactspmn,'Label','hist(Y)','Callback','pplot(''data'',''current'',''trace'',''newplot'',''hist(Y)'');');
        uimenu(pgdatactspmn,'Label','stem(X,Y)','Callback','pplot(''data'',''current'',''trace'',''newplot'',''stem(X,Y)'');');
        uimenu(pgdatactspmn,'Label','stairs(X,Y)','Callback','pplot(''data'',''current'',''trace'',''newplot'',''stairs(X,Y)'');');
        uimenu(pgdatactspmn,'Label','Custom...','Separator','On','Callback','pplot(''data'',''current'',''trace'',''newplot'',''custom'');');
      pgdatactsvmn=uimenu(pgdatactmn,'Label','Save...','Separator','On','Callback','pplot(''data'',''current'',''trace'',''save'');');
    pgdataadmn=uimenu(pgdatamn,'Label','All Lines Data','Separator','On','Callback','pplot(''info'',''Apply to the (complex) data of all lines'');');
      pgdataaddsmn=uimenu(pgdataadmn,'Label','Display');
        uimenu(pgdataaddsmn,'Label','real(Y)','Callback','pplot(''data'',''all'',''data'',''display'',''real(Y)'');');
        uimenu(pgdataaddsmn,'Label','imag(Y)','Callback','pplot(''data'',''all'',''data'',''display'',''imag(Y)'');');
        uimenu(pgdataaddsmn,'Label','abs(Y)','Callback','pplot(''data'',''all'',''data'',''display'',''abs(Y)'');');
        uimenu(pgdataaddsmn,'Label','angle(Y)','Callback','pplot(''data'',''all'',''data'',''display'',''angle(Y)'');');
        uimenu(pgdataaddsmn,'Label','10.*log10(Y)','Separator','On','Callback','pplot(''data'',''all'',''data'',''display'',''10.*log10(Y)'');');
        uimenu(pgdataaddsmn,'Label','20.*log10(Y)','Callback','pplot(''data'',''all'',''data'',''display'',''20.*log10(Y)'');');
        uimenu(pgdataaddsmn,'Label','Custom...','Separator','On','Callback','pplot(''data'',''all'',''data'',''display'',''custom'');');
      pgdataadnlmn=uimenu(pgdataadmn,'Label','New Line','Separator','On');
        uimenu(pgdataadnlmn,'Label','max(Y)','Callback','pplot(''data'',''all'',''data'',''newline'',''max(Y)'');');
        uimenu(pgdataadnlmn,'Label','min(Y)','Callback','pplot(''data'',''all'',''data'',''newline'',''min(Y)'');');
        uimenu(pgdataadnlmn,'Label','mean(Y)','Callback','pplot(''data'',''all'',''data'',''newline'',''mean(Y)'');');
        uimenu(pgdataadnlmn,'Label','median(Y)','Callback','pplot(''data'',''all'',''data'',''newline'',''median(Y)'');');
        uimenu(pgdataadnlmn,'Label','std(Y)','Callback','pplot(''data'',''all'',''data'',''newline'',''std(Y)'');');
        uimenu(pgdataadnlmn,'Label','Custom...','Separator','On','Callback','pplot(''data'',''all'',''data'',''newline'',''custom'');');
      pgdataadspmn=uimenu(pgdataadmn,'Label','New Plot');
        if exist('smith')==2
          uimenu(pgdataadspmn,'Label','Smith Chart','Callback','pplot(''data'',''all'',''data'',''newplot'',''smith(Y,135);'');');
        else
          uimenu(pgdataadspmn,'Label','Smith Chart','enable','off');
        end
        uimenu(pgdataadspmn,'Label','Polar Plot','Callback','pplot(''data'',''all'',''data'',''newplot'',''polar(angle(Y),abs(Y))'');');
        uimenu(pgdataadspmn,'Label','Complex Plot','Callback','pplot(''data'',''all'',''data'',''newplot'',''plot(real(Y),imag(Y))'');');
        uimenu(pgdataadspmn,'Label','Angle Histogram','Callback','pplot(''data'',''all'',''data'',''newplot'',''rose(angle(Y))'');');
        uimenu(pgdataadspmn,'Label','hist(Y)','Separator','On','Callback','pplot(''data'',''all'',''data'',''newplot'',''hist(Y)'');');
        uimenu(pgdataadspmn,'Label','stem(X,Y)','Callback','pplot(''data'',''all'',''data'',''newplot'',''stem(X,Y)'');');
        uimenu(pgdataadspmn,'Label','stairs(X,Y)','Callback','pplot(''data'',''all'',''data'',''newplot'',''stairs(X,Y)'');');
        uimenu(pgdataadspmn,'Label','Custom...','Separator','On','Callback','pplot(''data'',''all'',''data'',''newplot'',''custom'');');
      pgdataadsvmn=uimenu(pgdataadmn,'Label','Save...','Separator','On','Callback','pplot(''data'',''all'',''data'',''save'');');
    pgdataatmn=uimenu(pgdatamn,'Label','All Lines Traces','Callback','pplot(''info'',''Apply to the displayed traces of all lines'');');
      pgdataatdsmn=uimenu(pgdataatmn,'Label','Display');
        uimenu(pgdataatdsmn,'Label','10.*log10(Y)','Callback','pplot(''data'',''all'',''trace'',''display'',''10.*log10(Y)'');');
        uimenu(pgdataatdsmn,'Label','20.*log10(Y)','Callback','pplot(''data'',''all'',''trace'',''display'',''20.*log10(Y)'');');
        uimenu(pgdataatdsmn,'Label','Custom...','Separator','On','Callback','pplot(''data'',''current'',''trace'',''display'',''custom'');');
      pgdataatnlmn=uimenu(pgdataatmn,'Label','New Line','Separator','On');
        uimenu(pgdataatnlmn,'Label','max(Y)','Callback','pplot(''data'',''all'',''trace'',''newline'',''max(Y)'');');
        uimenu(pgdataatnlmn,'Label','min(Y)','Callback','pplot(''data'',''all'',''trace'',''newline'',''min(Y)'');');
        uimenu(pgdataatnlmn,'Label','mean(Y)','Callback','pplot(''data'',''all'',''trace'',''newline'',''mean(Y)'');');
        uimenu(pgdataatnlmn,'Label','median(Y)','Callback','pplot(''data'',''all'',''trace'',''newline'',''median(Y)'');');
        uimenu(pgdataatnlmn,'Label','std(Y)','Callback','pplot(''data'',''all'',''trace'',''newline'',''std(Y)'');');
        uimenu(pgdataatnlmn,'Label','Custom...','Separator','On','Callback','pplot(''data'',''all'',''trace'',''newline'',''custom'');');
      pgdataatspmn=uimenu(pgdataatmn,'Label','New Plot');
        uimenu(pgdataatspmn,'Label','hist(Y)','Callback','pplot(''data'',''all'',''trace'',''newplot'',''hist(Y)'');');
        uimenu(pgdataatspmn,'Label','stem(X,Y)','Callback','pplot(''data'',''all'',''trace'',''newplot'',''stem(X,Y)'');');
        uimenu(pgdataatspmn,'Label','stairs(X,Y)','Callback','pplot(''data'',''all'',''trace'',''newplot'',''stairs(X,Y)'');');
        uimenu(pgdataatspmn,'Label','Custom...','Separator','On','Callback','pplot(''data'',''all'',''trace'',''newplot'',''custom'');');
      pgdataatsvmn=uimenu(pgdataatmn,'Label','Save...','Separator','On','Callback','pplot(''data'',''all'',''trace'',''save'');');

  %---------------------------------------------------------------------
    uimenu(pgmvmn,'Label','L&ine +','Callback','pplot(''move'',''line'');');
    uimenu(pgmvmn,'Label','Te&xt +','Separator','On','Callback','pplot(''move'',''text'');');
    uimenu(pgmvmn,'Label','&Title +','Callback','pplot(''move'',''title'');');
    uimenu(pgmvmn,'Label','&X-label +','Callback','pplot(''move'',''xlabel'');');
    uimenu(pgmvmn,'Label','&Y-label +','Callback','pplot(''move'',''ylabel'');');
    uimenu(pgmvmn,'Label','&Legend +','Separator','On','Callback','pplot(''move'',''legend'');');
    uimenu(pgmvmn,'Label','&Axis +','Callback','pplot(''move'',''axes'');');

  %---------------------------------------------------------------------
    uimenu(pgdelmn,'Label','L&ine','Callback','pplot(''delete'',''line'');');
    uimenu(pgdelmn,'Label','Te&xt','Separator','On','Callback','pplot(''delete'',''text'');');
    uimenu(pgdelmn,'Label','&Title','Callback','pplot(''delete'',''title'');');
    uimenu(pgdelmn,'Label','&X-label','Callback','pplot(''delete'',''xlabel'');');
    uimenu(pgdelmn,'Label','&Y-label','Callback','pplot(''delete'',''ylabel'');');
    uimenu(pgdelmn,'Label','&Legend','Separator','On','Callback','pplot(''delete'',''legend'');');
    uimenu(pgdelmn,'Label','&Axis','Callback','pplot(''delete'',''axes'');');

  %---------------------------------------------------------------------
    pgtoolpimn=uimenu(pgtoolmenu,'Label','&Plug In');
      for i=1:2:size(plugins,1)
        if exist(deblank(plugins(i+1,:)))==2
          uimenu(pgtoolpimn,'Label',plugins(i,:),'CallBack',plugins(i+1,:));
        else
          uimenu(pgtoolpimn,'Label',plugins(i,:),'enable','off','CallBack',plugins(i+1,:));
        end
      end
    pgtoolrcmn=uimenu(pgtoolmenu,'Label','R&emote Controls');
      uimenu(pgtoolrcmn,'Label','Data...','Callback','pplot(''tool'',''rc'',''display'');');
      uimenu(pgtoolrcmn,'Label','Axis...','Separator','On','Callback','pplot(''tool'',''rc'',''axes'');');
      uimenu(pgtoolrcmn,'Label','Line...','Callback','pplot(''tool'',''rc'',''line'');');
      uimenu(pgtoolrcmn,'Label','Labels...','Callback','pplot(''tool'',''rc'',''label'');');
    pgtoolzmn=uimenu(pgtoolmenu,'Label','&Zoom','Separator','On');
      uimenu(pgtoolzmn,'Label','On','Callback','pplot(''select'',''off'');zoom on;');
      uimenu(pgtoolzmn,'Label','Off','Callback','pplot(''select'',''on'');zoom off;');
    pgtoolhmn=uimenu(pgtoolmenu,'Label','&Hold');
      uimenu(pgtoolhmn,'Label','On','Callback','mench=get(findobj(gcf,''Label'',''&Hold''),''children'');set(mench(1),''enable'',''on'');set(mench(2),''enable'',''off'');hold on;clear mench;');
      uimenu(pgtoolhmn,'Label','Off','enable','off','Callback','mench=get(findobj(gcf,''Label'',''&Hold''),''children'');set(mench(1),''enable'',''off'');set(mench(2),''enable'',''on'');hold off;clear mench;');
    uimenu(pgtoolmenu,'Label','&Scroll +','Callback','pplot(''tool'',''scroll'');');
    pgtoolcolmn=uimenu(pgtoolmenu,'Label','&Color','Separator','On');
      uimenu(pgtoolcolmn,'Label','Black <-> White','Callback','pplot(''tool'',''color'',''invert'');');
      uimenu(pgtoolcolmn,'Label','Lighten','Separator','On','Callback','pplot(''tool'',''color'',''lighten'');');
      uimenu(pgtoolcolmn,'Label','Darken','Callback','pplot(''tool'',''color'',''darken'');');
      uimenu(pgtoolcolmn,'Label','Grayscale','Separator','On','Callback','pplot(''tool'',''color'',''gray'');');
      uimenu(pgtoolcolmn,'Label','Black or White','Callback','pplot(''tool'',''color'',''blw'');');
      uimenu(pgtoolcolmn,'Label','All Lines Color...','Separator','On','Callback','pplot(''tool'',''color'',''alllinecol'');');
    pgtoolmrkmn=uimenu(pgtoolmenu,'Label','&Marker');
      uimenu(pgtoolmrkmn,'Label','On Trace','Callback','mench=get(findobj(gcf,''Label'',''&Marker''),''children'');set(mench(1),''enable'',''on'');set(mench(2:3),''enable'',''off'');pplot(''tool'',''marker'',''trace'');;clear mench;');
      uimenu(pgtoolmrkmn,'Label','On Data','Callback','mench=get(findobj(gcf,''Label'',''&Marker''),''children'');set(mench(1),''enable'',''on'');set(mench(2:3),''enable'',''off'');pplot(''tool'',''marker'',''data'');;clear mench;');
      uimenu(pgtoolmrkmn,'Label','Off','Separator','On','enable','off','Callback','mench=get(findobj(gcf,''Label'',''&Marker''),''children'');set(mench(1),''enable'',''off'');set(mench(2:3),''enable'',''on'');pplot(''tool'',''marker'',''off'');;clear mench;');
    if exist('arrow')==2
      pgtoolarrmn=uimenu(pgtoolmenu,'Label','&Arrow');
        uimenu(pgtoolarrmn,'Label','Insert +','Callback','pplot(''tool'',''arrow'',''insert'');');
        uimenu(pgtoolarrmn,'Label','Select +','Separator','On','Callback','pplot(''tool'',''arrow'',''select'');');
        pgtoolarrfmn=uimenu(pgtoolarrmn,'Label','Format');
          uimenu(pgtoolarrfmn,'Label','Color...','Callback','pplot(''tool'',''arrow'',''color'');');
          pgtoolarrfwmn=uimenu(pgtoolarrfmn,'Label','Width','Separator','On');
            for i=1:size(pgwidths,1)
              uimenu(pgtoolarrfwmn,'Label',pgwidths(i,:),'Callback',['pplot(''tool'',''arrow'',''width'',' pgwidths(i,:) ');']);
            end
          pgtoolarrftmn=uimenu(pgtoolarrfmn,'Label','Type');
            for i=1:size(pglines,1)
              uimenu(pgtoolarrftmn,'Label',pglines(i,:),'Callback',['pplot(''tool'',''arrow'',''type'',''' pglines(i,:) ''');']);
            end
          uimenu(pgtoolarrmn,'Label','Reposition +','Callback','pplot(''tool'',''arrow'',''reposition'');');
          uimenu(pgtoolarrmn,'Label','Delete','Separator','On','Callback','pplot(''tool'',''arrow'',''delete'');');
    else
      pgtoolarrmn=uimenu(pgtoolmenu,'Label','&Arrow','enable','off');
    end
    uimenu(pgtoolmenu,'Label','&Refresh','Separator','On','Callback','refresh;');

  %---------------------------------------------------------------------
  pghelpmenu=uimenu(gcf,'Label','&Help','Callback','pplot(''info'',''off'');');
    uimenu(pghelpmenu,'Label','&Contents','Callback','clc;help pplot;');
    uimenu(pghelpmenu,'Label','&About PowerGraf...','Callback','pplot(''about'');');
    drawnow
    
  if new
    pplot('info','Hang on...');
    axis on;
    set(gca,'DrawMode','fast');
    for i=1:5
      set(gca,'pos',[pos(1)+pos(3)/2-(pos(3)/2)*i^2/25 pos(2)+pos(4)/2-(pos(4)/2)*i^2/25 2*(pos(3)/2)*i^2/25 2*(pos(4)/2)*i^2/25]);
      drawnow
    end
    i=0;
    while i<=90, 
      set(gca,'view',[90-i i]);
      drawnow;
      i=i+ceil((92-i)/2);
    end
    set(gca,'DrawMode','normal');
    pplot('info','off');
  end
  pplot('select','on');
  if nargout==1
    ret1=gcf;
  end
else

  %---------------------------------------------------------------------
  if strcmp(arg1,'element')
    if nargin==3
      if (size(arg3,1)==1 | size(arg3,2)==1)
        ret1=arg3(arg2);
      else
        ret1=arg3(arg2,:);
      end   
    elseif nargin==4
      ret1=arg4(arg2,arg3);
    end

  %---------------------------------------------------------------------
  elseif strcmp(arg1,'pause')
    pgtime=cputime;
    while cputime<pgtime+arg2
      drawnow
    end

  %---------------------------------------------------------------------
  elseif strcmp(arg1,'uisetcol')
    if nargin<3
      arg3='PowerGraf Set Color';
    end
    if (strcmp(computer,'PCWIN')|strcmp(computer,'MAC2'))
      if nargout==1
        ret1=uisetcolor(arg2,arg3);
      else
        uisetcolor(arg2,arg3);
      end
    else
      global pgcuifig pgcol pgobj pgrgb pgcpos pgrgbind pgfig
      pgfig=gcf;
      pgobj=arg2;
      pgcuifig=figure;
      clf;
      set(pgcuifig,'NumberTitle','off','Name',arg3,...
           'color', [0.741176 0.741176 0.741176], 'Resize', 'off','MenuBar','none',...
           'Position', [200 200 213 200],'WindowButtonUpFcn','','userdata',0);
      set(gca, 'Units','normalized','pos', [0 0 1 1]);
      load pplot.mat
      image(colim);
      colormap(colmap);
      axis('image');
      axis('off');
      uicontrol('string','Close', 'Position', [145 10 60 20],...
                'callback','global pgcuifig pgcol pgobj pgrgb pgcpos pgrgbind pgfig;close(pgcuifig);clear pgcuifig pgcol pgobj pgrgb pgcpos pgrgbind pgfig');
      if nargout==0
        set(pgcuifig,'WindowButtonDownFcn','global pgcuifig pgobj pgrgb pgcpos pgrgbind pgfig pgcol;pgcpos=get(pgcuifig,''currentpoint'');if pgcpos(2)>60 pgrgbind=max(1,min(8,ceil((pgcpos(1)-6)/25)))+8*max(0,6-ceil((pgcpos(2)-61)/22));pgcol=pgrgb(pgrgbind,:);set(pgobj,''color'',pgcol);end;');
      else
        set(pgcuifig,'WindowButtonDownFcn','global pgcuifig pgobj pgrgb pgcpos pgrgbind pgfig pgcol;pgcpos=get(pgcuifig,''currentpoint'');if pgcpos(2)>60 pgrgbind=max(1,min(8,ceil((pgcpos(1)-6)/25)))+8*max(0,6-ceil((pgcpos(2)-61)/22));pgcol=pgrgb(pgrgbind,:);set(pgcuifig,''userdata'',pgcol);end;');
        ret1=0;
        while ~ret1
          drawnow
          ret1=get(pgcuifig,'UserData');
        end
      end
    end

  %---------------------------------------------------------------------
  elseif strcmp(arg1,'info')
    if strcmp(arg2,'off')
      set(gcf,'Name','PowerGraf Plot Editor');
    else
      set(gcf,'Name',['PowerGraf Plot Editor  -  ' arg2]);
    end

  %---------------------------------------------------------------------
  elseif strcmp(arg1,'setpos')
    pplot('select','off');
    pplot('info',['Click and drag to set the position of the ' arg2 ]);
    set(pplot('buffer','get',arg2),'units','pixels');
    set(gcf,'pointer','crosshair','units','pixels','WindowButtonDownFcn',['pgp1=get(gcf,''CurrentPoint'');set(gcf,''WindowButtonMotionFcn'',''pgp2=get(gcf,''''CurrentPoint'''');set(pplot(''''buffer'''',''''get'''',''''' arg2 '''''),''''pos'''',[min(pgp1(1),pgp2(1)) min(pgp1(2),pgp2(2)) abs(pgp2-pgp1)+1])'');']);
    set(gcf,'WindowButtonUpFcn','set(gcf,''WindowButtonMotionFcn'','''');set(gcf,''WindowButtonDownFcn'',''pplot(''''info'''',''''off'''');'');set(gcf,''pointer'',''arrow'');pplot(''select'',''on'');clear pgxdat pgydat pgcpnt pgcpos pgnpnt pgp1 pgp2 pgobj pgpcol pgaxpos;');

  %---------------------------------------------------------------------
  elseif strcmp(arg1,'setsize')
    set(gcf,'units','inches');
    cpos=get(gcf,'pos');
    cpos(3:4)=min(cpos(3:4),[8 6]);
    set(gcf,'paperposition',[0.25+(8-cpos(3))/2 2.5+(8-cpos(4))/2 cpos(3) cpos(4)]);
    cobj=[findobj(gcf,'type','axes');findobj(gcf,'type','text')];
    set(cobj,'units','normal');
    set(gcf,'units','pixels');

  %---------------------------------------------------------------------
  elseif strcmp(arg1,'clear')
    pplot('info','Erasing...');
    if strcmp(arg2,'axes')
      pgax=pplot('buffer','get','axes');
      set(pgax,'units','pixels');
      pos=get(pgax,'pos');
      set(pgax,'DrawMode','fast');  
      for i=4.1:-1:0.1
        set(pgax,'pos',[pos(1)+pos(3)/2-(pos(3)/2)*i^2/25 pos(2) 2*(pos(3)/2)*i^2/25 pos(4)]);
        drawnow
      end
      delete(get(pgax,'children'));
      set(pplot('buffer','get','axes'),'units','pixels','userdata',[0 0 0 0 0 0],'xgrid','on','ygrid','on','box','on');
      for i=1:5
        set(gca,'pos',[pos(1)+pos(3)/2-(pos(3)/2)*i^2/25 pos(2) 2*(pos(3)/2)*i^2/25 pos(4)]);
        drawnow
      end
      set(pgax,'DrawMode','normal');
    elseif strcmp(arg2,'figure')
      pos=get(gcf,'pos');
      clf;
      set(gcf,'name','Erasing...');
      drawnow;
      pplot;
    end
    pplot('undo','off');
    pplot('info','off');

  %---------------------------------------------------------------------
  elseif strcmp(arg1,'undo')
    edmn=findobj(gcf,'label','&Edit');
    edmnch=get(edmn,'children');
    undomn=edmnch(4);
    emat=get(edmn,'userdata');
    umat=get(undomn,'userdata');
    if nargin>1
      if strcmp(arg2,'off')
        set(undomn,'label','&Undo','enable','off','userdata',[]);
        set(edmn,'userdata',[]);
      else
        set(undomn,'enable','on','userdata',str2mat(arg2,umat));
        if nargin==3
          set(undomn,'label',['&Undo ' arg3]); % arg2 for debug...
          set(edmn,'userdata',str2mat(arg3,emat));
        end
      end
    else
      eval(umat(1,:),'');
      if size(umat,1)<3
        set(undomn,'label','&Undo','enable','off');
        umat=[];
        emat=[];
      else
        emat=emat(2:size(emat,1),:);
        umat=umat(2:size(umat,1),:);
        set(undomn,'enable','on','label',['&Undo ' emat(1,:)]);
      end
      set(edmn,'userdata',emat);
      set(undomn,'userdata',umat);
    end
  
  %---------------------------------------------------------------------
  elseif strcmp(arg1,'load')
    global pged pguifig pgfig
    if strcmp(arg2,'xpar')
      callbackstr='global pged pguifig pgarg defaultx;pgarg=get(pged,''string'');eval([''load '' pgarg],[pgarg(1:find(pgarg==''.'')-1) ''=dlmread('''''' pgarg '''''');'']);eval([''defaultx='' pgarg(1:find(pgarg==''.'')-1) ''(:,1);'']);if size(defaultx,2)==1,defaultx=defaultx'';end;close(pguifig);pplot(''info'',''Default x-par is called defaultx on workspace'');clear pged pguifig pgarg';
    end
    pgfig=gcf;
    pguifig=figure;
    clf;
    set(pguifig,'NumberTitle','off','Name','Load file',...
                'color', [1 1 1], 'Resize', 'off','MenuBar','none',...
                'Position', [130 150 300 100]);
    set(gca,'units','normal','pos',[0 0 1 1]);
    axis('off');
    text(0,0,'Enter filename:','color','red','units','pixels','pos',[5 80]);
    uicontrol('string','Browse...', 'Position', [235 45 60 20],'CallBack',...
              'global pged;[pgname,pgpath]=uigetfile(''*.*'',''Load File'');if pgname,eval([''cd '' pgpath '';'']);set(pged,''string'',lower(pgname));end;clear pgname pgpath');
    pged=uicontrol('style','edit','units','pixels','pos',[5 45 225 20],'backgroundcolor', [0.9 0.9 0.83],'callback',callbackstr);
    uicontrol('string','Cancel', 'Position', [170 5 60 20],...
              'callback','global pguifig pged pgarg pgfig;close(pguifig);clear pguifig pged pgarg pgfig');
    uicontrol('string','OK', 'Position', [235 5 60 20],'callback',callbackstr);

  %---------------------------------------------------------------------
  elseif strcmp(arg1,'buffer')
    if ~(strcmp(arg2,'get') & strcmp(arg3,'axes'))
      pgax=pplot('buffer','get','axes');
      if pgax
        cur=get(pgax,'userdata');
      end
      if ~size(cur,2)==6 | ~pgax
        cur=[0 0 0 0 0 0];
      end
      eval('get(cur(1),''userdata'');','cur(1)=0;');
      eval('get(cur(2),''userdata'');','cur(2)=0;');
      eval('get(cur(3),''userdata'');','cur(3)=0;');
      eval('get(cur(4),''userdata'');','cur(4)=0;');
      eval('get(cur(5),''userdata'');','cur(5)=0;');
      eval('get(cur(6),''userdata'');','cur(6)=0;');
    end
    if strcmp(arg2,'select')
      if strcmp(arg3,'line') & arg4
        if nargin<5 % i.e. ~=('fast')
          pgcol=get(arg4,'color');
          set(arg4,'color',1-pgcol);
          drawnow;
          pplot('pause',0.2);
          set(arg4,'color',pgcol);
        end
        set(pplot('buffer','get','axes'),'userdata',[arg4 cur(2:6)]);
      elseif strcmp(arg3,'text') & arg4
        set(arg4,'visible','off');
        drawnow;
        pplot('pause',0.2);
        set(arg4,'visible','on');
        set(pplot('buffer','get','axes'),'userdata',[cur(1) arg4 cur(3:6)]);
      elseif strcmp(arg3,'legend') & arg4
        set(arg4,'visible','off');
        drawnow;
        pplot('pause',0.2);
        set(arg4,'visible','on','userdata',pplot('buffer','get','axes'));
        set(pplot('buffer','get','axes'),'userdata',[cur(1:5) arg4]);
      elseif strcmp(arg3,'axes') & arg4
        axes(arg4);
        set(arg4,'visible','off');
        drawnow;
        pplot('pause',0.2);
        set(arg4,'visible','on');
        set(gcf,'userdata',arg4);
      end
    elseif strcmp(arg2,'get')
      if (strcmp(arg3,'line')|strcmp(arg3,'text'))
        idx=strcmp(arg3,'text')+1;
        if strcmp(get(cur(idx),'visible'),'on') & cur(idx)>0
          ret1=cur(idx);
        else
          ret1=0;
        end;
      elseif strcmp(arg3,'title') | strcmp(arg3,'xlabel') | strcmp(arg3,'ylabel')
        if pplot('buffer','get','axes')
          ret1=get(pplot('buffer','get','axes'),arg3);
          if isempty(get(ret1,'string'))|strcmp(get(ret1,'visible'),'off')
            ret1=0;
          end
        else
          ret1=0;
        end
      elseif strcmp(arg3,'legend')
        ret1=cur(6);
      elseif strcmp(arg3,'axes')
        eval('pgaxf=strcmp(get(get(gcf,''userdata''),''type''),''axes'');','pgaxf=0;');
        if pgaxf
          ret1=get(gcf,'userdata');
        else
          ret1=0;
        end
      elseif strcmp(arg3,'window')
        ret1=gcf;
      end
    end
    
  %---------------------------------------------------------------------
  elseif strcmp(arg1,'insert')
    if strcmp(arg2,'text')
      global ped pax puifig ptxt
      pax=pplot('buffer','get','axes');
      ptxt=pplot('buffer','get','text');
      puifig=figure;
      clf;
      set(gca,'units','normal','pos',[0 0 1 1]);
      axis('off');
      uicontrol('string','Insert Date', 'Position', [140 5 90 20],'callback',...
                'global ped;set(ped,''string'',[get(ped,''string'') date]);');
      if nargin<3
        ped=uicontrol('style','edit','units','pixels','pos',[5 30 290 20],'backgroundcolor', [0.9 0.9 0.83],'callback',...
                  ['global ped pax puifig ps ptxt;ps=get(ped,''string'');close(puifig);axes(pax);pplot(''info'',''Click where you want to place the text'');pobj=text(0,0,ps,''pos'',ginput(1));pplot(''undo'',[''delete('' sprintf(''%18.13f'',pobj) '');''],''Insert text'');pplot(''buffer'',''select'',''text'',pobj);pplot(''info'',''off'');clear ped pax puifig ps ptxt pobj']);
        set(puifig,'NumberTitle','off','Name','Insert Text',...
          'color', [1 1 1], 'Resize', 'off','MenuBar','none',...
          'Position', [150 300 300 80]);
        text(0,0,'Enter the text:','color','red','units','pixels','pos',[5 60]);
        uicontrol('string','OK', 'Position', [235 5 60 20],'callback',...
                  ['global ped pax puifig ps ptxt;ps=get(ped,''string'');close(puifig);axes(pax);if ~isempty(ps), pplot(''info'',''Click where you want to place the text'');pobj=text(0,0,ps,''pos'',ginput(1),''buttondownfcn'',''pplot(''''select'''',''''text'''',gco)'');pplot(''undo'',[''delete('' sprintf(''%18.13f'',pobj) '');''],''Insert text'');pplot(''buffer'',''select'',''text'',pobj);pplot(''info'',''off'');end;clear ped pax puifig ps ptxt pobj']);
      elseif strcmp(arg3,'edit')
        if ptxt
          ps=get(ptxt,'string');
        else          
          ps='';
        end
        ped=uicontrol('style','edit','string',ps,'units','pixels','pos',[5 30 290 20],'backgroundcolor', [0.9 0.9 0.83],'callback',...
                  ['global ped pax puifig peds;peds=get(ped,''string'');close(puifig);set(pplot(''buffer'',''get'',''text''),''string'',peds);pplot(''undo'',[''set('' sprintf(''%18.13f'',pplot(''buffer'',''get'',''text'')) '',''''string'''',''''' ps ''''');''],''Edit Text'');clear ped pax puifig peds']);
        set(puifig,'NumberTitle','off','Name','Edit Text',...
          'color', [1 1 1], 'Resize', 'off','MenuBar','none',...
          'Position', [150 300 300 80]);
        text(0,0,'Enter the new text:','color','red','units','pixels','pos',[5 60]);
        uicontrol('string','OK', 'Position', [235 5 60 20],'callback',...
                  ['global ped pax puifig peds;peds=get(ped,''string'');close(puifig);set(pplot(''buffer'',''get'',''text''),''string'',peds);pplot(''undo'',[''set('' sprintf(''%18.13f'',pplot(''buffer'',''get'',''text'')) '',''''string'''',''''' ps ''''');''],''Edit Text'');clear ped pax puifig peds']);
      end
    elseif (strcmp(arg2,'title')|strcmp(arg2,'xlabel')|strcmp(arg2,'ylabel'))
      global ped pax puifig
      pax=pplot('buffer','get','axes');
      ps=get(get(pax,arg2),'string');
      puifig=figure;
      clf;
      set(gca,'units','normal','pos',[0 0 1 1]);
      axis('off');
      if strcmp(arg2,'title')
        ptstr=',''FontAngle'',''italic'',''FontWeight'',''bold'',''color'',[0 0 0.5]';
      else
        ptstr='';
      end
      ped=uicontrol('style','edit','units','pixels','pos',[5 30 290 20],'backgroundcolor', [0.9 0.9 0.83],'callback',...
                ['global ped pax puifig peds;set(get(pax,''' arg2 '''),''string'',get(ped,''string''),''buttondownfcn'',''pplot(''''select'''',''''axes'''',get(gco,''''parent''''))''' ptstr ');close(puifig);pplot(''undo'',[''set(get('' sprintf(''%18.13f'',pax) '',''''' arg2 '''''),''''string'''',''''' ps ''''');''],''Insert/Edit ' arg2 ''');clear ped pax puifig peds']);
      set(ped,'string',ps);
      set(puifig,'NumberTitle','off','Name',['Edit ' arg2],...
        'color', [1 1 1], 'Resize', 'off','MenuBar','none',...
        'Position', [150 300 300 80]);
      text(0,0,['Enter the ' arg2 ':'],'color','red','units','pixels','pos',[5 60]);
      uicontrol('string','OK', 'Position', [235 5 60 20],'callback',...
                ['global ped pax puifig peds;set(get(pax,''' arg2 '''),''string'',get(ped,''string''),''buttondownfcn'',''pplot(''''select'''',''''text'''',gco)'');close(puifig);pplot(''undo'',[''set(get('' sprintf(''%18.13f'',pax) '',''''' arg2 '''''),''''string'''',''''' ps ''''');''],''Insert/Edit ' arg2 ''');clear ped pax puifig peds']);
    elseif strcmp(arg2,'legend')
      global pplts ped pax puifig pinchk
      pax=pplot('buffer','get','axes');
      pplt=findobj(pax,'type','line','visible','on')';
      pplts=0;
      for i=1:size(pplt,2)
        eval('pud=get(pplt(i),''userdata'');arro=strcmp(get(pud(2,2),''type''),''patch'');','arro=0;');
        if ~arro
          pplts=[pplts,pplt(i)];
        end
      end
      pplts=pplts(2:size(pplts,2));
      if size(pplts,2)
        puifig=figure;
        clf;
        disp('Notice that the lines are listed in the order');
        disp('that they were plotted or selected...');
        set(puifig,'NumberTitle','off','Name','PowerGraf Legend',...
             'color', [1 1 1], 'Resize', 'off','MenuBar','none',...
             'Position', [250 50 250 65+25*size(pplts,2)]);
        set(gca, 'Units','pixels','pos', [5 55 35 25*size(pplts,2)]);
        ped=zeros(size(pplts,2),1);
        hold on
        for i=size(pplts,2):-1:1
          set(plot(0:1,[i i]-.5),'LineStyle',get(pplts(i),'LineStyle'),'LineWidth',get(pplts(i),'LineWidth'),'Color',get(pplts(i),'Color'));
          ped(i)=uicontrol('style','edit','units','pixels','pos',[45 30+25*i 200 20],'backgroundcolor', [0.9 0.9 0.83]);
        end
        axis([0 1 0 size(pplts,2)]);
        axis('off');
        pinchk=uicontrol('style','checkbox','string','Inside Plot','units','pixels',...
          'pos',[120 30 125 20],'backgroundcolor', [1 1 1],'foregroundcolor', [0.4 0.3 0]);
        uicontrol('string','Cancel','Position',[120 5 60 20],...
                  'callback','global puifig;close(puifig);clear puifig pplts ped pax pinchk')
        uicontrol('string','OK','Position',[185 5 60 20],'callback',...
                  'global pplts ped pax puifig pinchk;pt=[];ph=[];pinchk=get(pinchk,''value'')-1;for pi=1:size(pplts,2),ps=get(ped(pi),''string'');if ~isempty(ps),ph=[[ph];[pplts(pi)]];if isempty(pt),pt=['' '' ps '' ''];else pt=str2mat(pt,['' '' ps '' '']);end;end;end;close(puifig);pobj=pplot(''buffer'',''get'',''legend'');if pobj,pplot(''delete'',''legend'');end;pxp=mat2str(get(pax,''pos''));axes(pax);pleg=legend(flipud(ph),flipud(pt),pinchk);set(pleg,''userdata'',pax,''tag'',''pgleg'');pplot(''buffer'',''select'',''legend'',pleg);pplot(''undo'',[''delete('' sprintf(''%18.13f'',pleg) '');set('' sprintf(''%18.13f'',pax) '',''''pos'''','' mat2str(pxp) '');''],''Insert legend'');set(gcf,''WindowButtonDownFcn'',''pplot(''''info'''',''''off'''');'');set(findobj(gcf,''ButtonDownFcn'',''moveaxis''),''ButtonDownFcn'','''');clear pxp pt puifig pplts ped pax pleg pinchk ph pi ps pobj')
      else
        clear puifig pplts ped pax pinchk
        pplot('info','There are no lines in current axis');
      end
    elseif strcmp(arg2,'axes')
      pax=axes('pos', [-1 -1 1 1],'units','pixels','buttondownfcn','pplot(''select'',''axes'',gco)');
      pplot('undo',['delete(' sprintf('%18.13f',pax) ');'],'Insert axes');
      pplot('buffer','select','axes',pax);
      pplot('setpos','axes');
    end

  %---------------------------------------------------------------------
  elseif strcmp(arg1,'select')
    if (strcmp(arg2,'line') | strcmp(arg2,'text'))
      if isempty(findobj(gcf,'type',arg2,'visible','on'))
        pplot('info',['There is no ' arg2]);
      else
        if nargin==2
          pplot('info',['Click on the ' arg2 ' you want to select']);
          pplot('select','off');
          ginput(1);
          pgobj=gco;
          pplot('info','off');
          pplot('select','on');
        else
          pgobj=arg3;
        end
        if strcmp(get(pgobj,'Type'),arg2)
          if (get(pgobj,'parent')~=pplot('buffer','get','axes'))
            pplot('buffer','select','axes',get(pgobj,'parent'));
            pplot('buffer','select','legend',pplot('buffer','get','legend'));
          end
          eval('pgud=get(pgobj,''userdata'');arro=strcmp(get(pgud(2,2),''type''),''patch'');','arro=0;');
          leg=strcmp(get(get(pgobj,'parent'),'tag'),'pgleg')|strcmp(get(get(pgobj,'parent'),'tag'),'legend');
          if arro
            pplot('info','That was an arrow');
          elseif leg
            pplot('info',['That was a ' arg2 ' in a legend']);
          elseif pgobj==get(get(pgobj,'parent'),'title')
            pplot('info','That was the title');
          elseif pgobj==get(get(pgobj,'parent'),'xlabel')
            pplot('info','That was the xlabel');
          elseif pgobj==get(get(pgobj,'parent'),'ylabel')
            pplot('info','That was the ylabel');
          else
            pplot('buffer','select',arg2,pgobj);
            pplot('info',[arg2 ' selected']);
          end
        else
          pplot('info',['That was not a ' arg2]);
        end
      end
    elseif strcmp(arg2,'legend')
      if nargin==2
        pplot('select','off');
        pplot('info',['Click on the ' arg2 ' you want to select']);
        ginput(1);
        pgobj=gco;
        pplot('info','off');
        pplot('select','on');
      else
        pgobj=arg3;
      end
      if (strcmp(get(pgobj,'tag'),'pgleg')|strcmp(get(pgobj,'tag'),'legend'))
        pplot('buffer','select','legend',pgobj);
        pplot('info','legend selected');
      else
        pplot('info','That was not a legend to me');
      end
    elseif strcmp(arg2,'axes')
      if isempty(findobj(gcf,'Type','axes'))
        pplot('info',['There is no ' arg2]);
      else
        if nargin==2
          pplot('select','off');
          pplot('info',['Click on the ' arg2 ' you want to select']);
          ginput(1);
          pgobj=gco;
          pplot('info','off');
          pplot('select','on');
        else
          pgobj=arg3;
        end
        eval('isax=(strcmp(get(pgobj,''Type''),''axes'') & ~strcmp(get(pgobj,''tag''),''legend'') & ~strcmp(get(pgobj,''tag''),''pgleg''));','isax=0;');
        if isax  
          pplot('buffer','select','axes',pgobj);
          pplot('buffer','select','legend',pplot('buffer','get','legend'));
          pplot('info','axis selected');
        end
      end
    elseif strcmp(arg2,'on')
      set(findobj(gcf,'type','axes','visible','on'),'buttondownfcn','pplot(''select'',''axes'',gco);');
      set([findobj(gcf,'tag','pgleg','visible','on');findobj(gcf,'tag','legend','visible','on')],'buttondownfcn','pplot(''select'',''legend'',gco);');
      set(findobj(gcf,'type','line','visible','on'),'buttondownfcn','pplot(''select'',''line'',gco);');
      set(findobj(gcf,'type','text','visible','on'),'buttondownfcn','pplot(''select'',''text'',gco);');
    elseif strcmp(arg2,'off')
      set([findobj(gcf,'type','axes');findobj(gcf,'type','line');findobj(gcf,'type','text')],'buttondownfcn','');
    end

  %---------------------------------------------------------------------
  elseif strcmp(arg1,'format')
    if pplot('buffer','get',arg2)
      if strcmp(arg2,'line') 
        pgline=pplot('buffer','get','line');
        if strcmp(arg3,'color')
          pplot('undo',['set(' sprintf('%18.13f',pgline) ',''color'',' mat2str(get(pgline,'color')) ');'],['Format ' arg2]);
          pplot('uisetcol',pgline,'PowerGraf Set Color');
        elseif strcmp(arg3,'linewidth')
          pplot('undo',['set(' sprintf('%18.13f',pgline) ',''' arg3 ''',' num2str(get(pgline,arg3)) ');'],['Format ' arg2]);
          set(pgline,arg3,arg4);
        else
          pplot('undo',['set(' sprintf('%18.13f',pgline) ',''' arg3 ''',''' get(pgline,arg3) ''');'],['Format ' arg2]);
          set(pgline,arg3,arg4);
        end
      elseif strcmp(arg2,'text') 
        pgtext=pplot('buffer','get','text');
        if strcmp(arg3,'color')
          pplot('undo',['set(' sprintf('%18.13f',pgtext) ',''color'',' mat2str(get(pgtext,'color')) ');'],['Format ' arg2]);
          pplot('uisetcol',pgtext,'PowerGraf Set Color');
        elseif strcmp(arg3,'font')
          pplot('undo',['set(' sprintf('%18.13f',pgtext) ',''FontAngle'',''' get(pgtext,'FontAngle') ...
            ''',''FontName'',''' get(pgtext,'FontName') ''',''FontSize'',' num2str(get(pgtext,'FontSize')) ',''FontWeight'',''' get(pgtext,'FontWeight') ''');'],['Format ' arg2]);
          uisetfont(pgtext,'PowerGraf Set Font');
        elseif strcmp(arg3,'edit')
          pplot('insert','text','edit');
        elseif strcmp(arg3,'rotate')
          pplot('undo',['set(' sprintf('%18.13f',pgtext) ',''rotation'',' num2str(get(pgtext,'rotation')) ');'],['Format ' arg2]);
          if arg4==-1000
            if mat5
              disp('WARNING: Rotating text in Matlab 5 might cause segmentation violation.');
            end
            pplot('select','off');
            pplot('info','Click and drag to rotate the text');
            pgax=get(pgtext,'parent');
            set([pgax,pgtext],'units','pixels');
            set(gcf,'WindowButtonDownFcn','pgobj=pplot(''buffer'',''get'',''text'');pgcpos=get(pgobj,''pos'');pgaxpos=get(get(pgobj,''parent''),''pos'');pgcpos=pgcpos(1:2)+pgaxpos(1:2);pgcpnt=get(gcf,''currentpoint'');pgcpnt=pgcpnt(1:2)-pgcpos;set(gcf,''WindowButtonMotionFcn'',''pgnpnt=get(gcf,''''currentpoint'''');pgnpnt=pgnpnt(1:2)-pgcpos;set(pgobj,''''rotation'''',180/pi*(atan2(pgnpnt(2),pgnpnt(1))))'');drawnow;','WindowButtonUpFcn','set(gcf,''WindowButtonMotionFcn'','''');set(gcf,''WindowButtonDownFcn'',''pplot(''''info'''',''''off'''');'');set(gcf,''pointer'',''arrow'');pplot(''select'',''on'');clear pgxdat pgydat pgcpnt pgcpos pgnpnt pgp1 pgp2 pgobj pgpcol pgaxpos;');
          else
            set(pgtext,'rotation',arg4);
          end
        end
      elseif (strcmp(arg2,'title')|strcmp(arg2,'xlabel')|strcmp(arg2,'ylabel'))
        pgobj=pplot('buffer','get',arg2);
        if strcmp(arg3,'color')
          pplot('undo',['set(' sprintf('%18.13f',pgobj) ',''color'',' mat2str(get(pgobj,'color')) ');'],['Format ' arg2]);
          pplot('uisetcol',pgobj,'PowerGraf Set Color');
        elseif strcmp(arg3,'font')
          pplot('undo',['set(' sprintf('%18.13f',pgobj) ',''FontAngle'',''' get(pgobj,'FontAngle') ...
            ''',''FontName'',''' get(pgobj,'FontName') ''',''FontSize'',' num2str(get(pgobj,'FontSize')) ',''FontWeight'',''' get(pgobj,'FontWeight') ''');'],['Format ' arg2]);
          uisetfont(pgobj,'PowerGraf Set Font');
        elseif strcmp(arg3,'edit')
          pplot('insert',arg2,'edit');
        end
      elseif strcmp(arg2,'legend') 
        pgleg=pplot('buffer','get','legend');
        if strcmp(arg3,'color')
          if size(get(pgleg,'color'),2)==3
            pplot('undo',['set(' sprintf('%18.13f',pgleg) ',''color'',' mat2str(get(pgleg,'color')) ');'],['Format ' arg2]);
          else
            pplot('undo',['set(' sprintf('%18.13f',pgleg) ',''color'',''none'');'],['Format ' arg2]);
          end
          pplot('uisetcol',pgleg,'PowerGraf Set Color');
        elseif strcmp(arg3,'font')
          pgtexts=findobj(pgleg,'type','text');
          pplot('undo',['set(findobj(' sprintf('%18.13f',pgleg) ',''type'',''text''),''FontAngle'',''' get(pgtexts(1),'FontAngle') ''',''FontName'',''' get(pgtexts(1),'FontName') ...
            ''',''FontSize'',' num2str(get(pgtexts(1),'FontSize')) ',''FontWeight'',''' get(pgtexts(1),'FontWeight') ''');'],['Format ' arg2]);
          uisetfont(pgtexts(1),'PowerGraf Set Font');
          set(pgtexts,'FontAngle',get(pgtexts(1),'FontAngle'),'FontName',get(pgtexts(1),'FontName'),'FontSize',get(pgtexts(1),'FontSize'),'FontWeight',get(pgtexts(1),'FontWeight'));
        elseif strcmp(arg3,'box')
          if strcmp(arg4,'on')
            pplot('undo',['axes(' sprintf('%18.13f',pgleg) ');axis(''off'');'],['Format ' arg2]);
            axes(pgleg);
            axis('on');
          elseif strcmp(arg4,'off')
            pplot('undo',['axes(' sprintf('%18.13f',pgleg) ');axis(''on'');'],['Format ' arg2]);
            axes(pgleg);
            axis('off');
          end
        elseif strcmp(arg3,'resize')
          set(pgleg,'units','pixels');
          pplot('undo',['set(' sprintf('%18.13f',pgleg) ',''pos'',' mat2str(get(pgleg,'pos')) ');'],['Format ' arg2]);
          pplot('setpos','legend');
        elseif strcmp(arg3,'front')
          axes(pgleg);
          refresh;
        end
      elseif strcmp(arg2,'axes')  
        pgfax=pplot('buffer','get','axes');
        if strcmp(arg3,'color')
          pgs=mat2str(get(pgfax,'color'));
          if strcmp(pgs,'none')
            pgs=['''' pgs ''''];
          end
          pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''color'',' pgs ');'],['Format ' arg2]);
          pplot('uisetcol',pgfax,'PowerGraf Set Color');
        elseif strcmp(arg3,'font')
          pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''FontAngle'',''' get(pgfax,'FontAngle') ''',''FontName'',''' get(pgfax,'FontName') ...
            ''',''FontSize'',' num2str(get(pgfax,'FontSize')) ',''FontWeight'',''' get(pgfax,'FontWeight') ''');'],['Format ' arg2]);
          uisetfont(pgfax,'PowerGraf Set Font');
        elseif strcmp(arg3,'xaxis')
          if strcmp(arg4,'color')
            pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''xcolor'',' mat2str(get(pgfax,'xcolor')) ');'],['Format ' arg2]);
            set(pgfax,'xcolor',pplot('uisetcol',get(pgfax,'xcolor'),'Powergraf Set Color'));
          elseif strcmp(arg4,'scale')
            if strcmp(arg5,'linear')
              pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''xscale'',''log'');'],['Format ' arg2]);
              set(pgfax,'xscale','linear');
            elseif strcmp(arg5,'log')
              pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''xscale'',''linear'');'],['Format ' arg2]);
              set(pgfax,'xscale','log');
            end
          elseif strcmp(arg4,'grid')
            if strcmp(arg5,'on')
              pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''xgrid'',''off'');'],['Format ' arg2]);
              set(pgfax,'xgrid','on');
            elseif strcmp(arg5,'off')
              pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''xgrid'',''on'');'],['Format ' arg2]);
              set(pgfax,'xgrid','off');
            end
          elseif strcmp(arg4,'flip')
            pgdir=get(pgfax,'xdir');
            pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''xdir'',''' pgdir ''');'],['Format ' arg2]);
            if strcmp(pgdir,'normal')
              pgndir='reverse';
            else
              pgndir='normal';
            end
            set(pgfax,'xdir',pgndir);
          end
        elseif strcmp(arg3,'yaxis')
          if strcmp(arg4,'color')
            pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''ycolor'',' mat2str(get(pgfax,'ycolor')) ');'],['Format ' arg2]);
            set(pgfax,'ycolor',pplot('uisetcol',get(pgfax,'ycolor'),'Powergraf Set Color'));
          elseif strcmp(arg4,'scale')
            if strcmp(arg5,'linear')
              pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''yscale'',''log'');'],['Format ' arg2]);
              set(pgfax,'yscale','linear');
            elseif strcmp(arg5,'log')
              pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''yscale'',''linear'');'],['Format ' arg2]);
              set(pgfax,'yscale','log');
            end
          elseif strcmp(arg4,'grid')
            if strcmp(arg5,'on')
              pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''ygrid'',''off'');'],['Format ' arg2]);
              set(pgfax,'ygrid','on');
            elseif strcmp(arg5,'off')
              pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''ygrid'',''on'');'],['Format ' arg2]);
              set(pgfax,'ygrid','off');
            end
          elseif strcmp(arg4,'flip')
            pgdir=get(pgfax,'ydir');
            pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''ydir'',''' pgdir ''');'],['Format ' arg2]);
            if strcmp(pgdir,'normal')
              pgndir='reverse';
            else
              pgndir='normal';
            end
            set(pgfax,'ydir',pgndir);
          end
        elseif strcmp(arg3,'box')
          if strcmp(arg4,'on')
            pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''box'',''off'');'],['Format ' arg2]);
            set(pgfax,'box','on');
          elseif strcmp(arg4,'off')
            pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''box'',''on'');'],['Format ' arg2]);
            set(pgfax,'box','off');
          end
        elseif strcmp(arg3,'limits')
          if strcmp(arg4,'auto')
            zoom off;
            set(pgfax,'XLimMode','auto','YLimMode','auto');
          elseif strcmp(arg4,'fit')
            pgdlineall=[findobj(pgfax,'type','line','visible','on').'];
            pgdline=0;
            for i=1:size(pgdlineall,2)
              eval('pgud=get(pgdlineall(i),''userdata'');arro=strcmp(get(pgud(2,2),''type''),''patch'');','arro=0;');
              if ~arro
                pgdline=[pgdline,pgdlineall(i)];
              end
            end
            pgdline=pgdline(2:size(pgdline,2));
            if ~isempty(pgdline)
              pgdxmin=min(get(pgdline(1),'xdata'));
              pgdxmax=max(get(pgdline(1),'xdata'));
              pgdymin=min(get(pgdline(1),'ydata'));
              pgdymax=max(get(pgdline(1),'ydata'));
              for i=2:size(pgdline,2)
                pgdxmin=min(pgdxmin,min(get(pgdline(i),'xdata')));
                pgdxmax=max(pgdxmax,max(get(pgdline(i),'xdata')));
                pgdymin=min(pgdymin,min(get(pgdline(i),'ydata')));
                pgdymax=max(pgdymax,max(get(pgdline(i),'ydata')));
              end
              set(pgfax,'xlim',[pgdxmin pgdxmax],'ylim',[pgdymin pgdymax]);
            end
          elseif strcmp(arg4,'freeze')
            set(pgfax,'XLimMode','manual','YLimMode','manual');
          elseif strcmp(arg4,'set')
            global pglimed1 pglimed2 pglimed3 pglimed4 pgflfig;
            pgflfig=gcf;
            xlim=get(pgfax,'xlim');
            ylim=get(pgfax,'ylim');
            pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''xlim'',' mat2str(xlim) ',''ylim'',' mat2str(ylim) ');'],['Format ' arg2]);
            figure;
            clf;
            set(gcf,'NumberTitle','off','Name','PowerGraf Axis Limits',...
              'color', [1 1 1], 'Resize', 'off','MenuBar','none',...
              'Position', [450 100 330 180]);
            set(gca,'Units','pixels','pos', [135 55 190 90]);
            pgaxfill=fill([0 190 190 0 0],[0 0 90 90 0],[0.99 0.99 0.94]);
            set(pgaxfill,'edgecolor',[0 0 0]);
            axis([0 190 0 90]);
            axis('off');
            text(0,0,'Enter the limits for the axis:','color','red','Units','pixels','pos',[-130 110]);
            text(0,0,'Y-max:','color',[0 0 0],'Units','pixels','pos',[-120 80]);
            text(0,0,'Y-min:','color',[0 0 0],'Units','pixels','pos',[-120 10]);
            text(0,0,'X-min:','color',[0 0 0],'Units','pixels','pos',[-55 -15]);
            text(0,0,'X-max:','color',[0 0 0],'Units','pixels','pos',[75 -15]);
            pglimed1=uicontrol('style','edit','string',num2str(ylim(2)),'units','pixels','HorizontalAlignment','right',...
              'pos',[70 125 60 20],'backgroundcolor', [0.9 0.9 0.83],'callback',... 
              'global pglimed1 pglimed2 pglimed3 pglimed4 pgflfig;figure(pgflfig);set(pplot(''buffer'',''get'',''axes''),''ylim'',[min(eval(get(pglimed1,''string'')),eval(get(pglimed2,''string''))) max(eval(get(pglimed1,''string'')),eval(get(pglimed2,''string'')))]);');
            pglimed2=uicontrol('style','edit','string',num2str(ylim(1)),'units','pixels','HorizontalAlignment','right',...
              'pos',[70 55 60 20],'backgroundcolor', [0.9 0.9 0.83],'callback',... 
              'global pglimed1 pglimed2 pglimed3 pglimed4 pgflfig;figure(pgflfig);set(pplot(''buffer'',''get'',''axes''),''ylim'',[min(eval(get(pglimed1,''string'')),eval(get(pglimed2,''string''))) max(eval(get(pglimed1,''string'')),eval(get(pglimed2,''string'')))]);');
            pglimed3=uicontrol('style','edit','string',num2str(xlim(1)),'units','pixels','HorizontalAlignment','right',...
              'pos',[135 30 60 20],'backgroundcolor', [0.9 0.9 0.83],'callback',...
              'global pglimed1 pglimed2 pglimed3 pglimed4 pgflfig;figure(pgflfig);set(pplot(''buffer'',''get'',''axes''),''xlim'',[min(eval(get(pglimed3,''string'')),eval(get(pglimed4,''string''))) max(eval(get(pglimed3,''string'')),eval(get(pglimed4,''string'')))]);');
            pglimed4=uicontrol('style','edit','string',num2str(xlim(2)),'units','pixels','HorizontalAlignment','right',...
              'pos',[265 30 60 20],'backgroundcolor', [0.9 0.9 0.83],'callback',... 
              'global pglimed1 pglimed2 pglimed3 pglimed4 pgflfig;figure(pgflfig);set(pplot(''buffer'',''get'',''axes''),''xlim'',[min(eval(get(pglimed3,''string'')),eval(get(pglimed4,''string''))) max(eval(get(pglimed3,''string'')),eval(get(pglimed4,''string'')))]);');
            uicontrol('string','Close','units','pixels','Position',[265 5 60 20],...
              'callback','global pglimed1 pglimed2 pglimed3 pglimed4 pgflfig;close(gcf);clear pglimed1 pglimed2 pglimed3 pglimed4 pgflfig');
            end
        elseif strcmp(arg3,'size')
          if strcmp(arg4,'reposition')
            pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''pos'',' mat2str(get(pgfax,'pos')) ');'],['Format ' arg2]);
            pplot('setpos','axes');
          elseif strcmp(arg4,'copy')
            pgaps=get(pgfax,'pos');
            pplot('info','Click on the axis from which you want to copy the size');
            ginput(1);
            pplot('info','off');
            if strcmp(get(gco,'type'),'axes')   
              pgcps=get(gco,'pos');
              set(pgfax,'pos',[pgaps(1) pgaps(2) pgcps(3) pgcps(4)]);         
              pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''pos'',' mat2str(pgaps) ');'],['Format ' arg2]);
            end       
          elseif strcmp(arg4,'square')
            pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''pos'',' mat2str(get(pgfax,'pos')) ');'],['Format ' arg2]);
            pgpos=get(pgfax,'pos');
            set(pgfax,'pos',[pgpos(1) pgpos(2) pgpos(4) pgpos(4)]);
          end
        elseif strcmp(arg3,'align')
          set([gcf,pgfax],'units','pixels');
          pgaps=get(pgfax,'pos');
          pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''pos'',' mat2str(pgaps) ');'],['Format ' arg2]);
          if strcmp(arg4,'window')
            pgcps=get(gcf,'pos');
            pgcps=[60 50 pgcps(3)-100 pgcps(4)-100];
          elseif strcmp(arg4,'other')
            pplot('info','Click on the axis you want to align selected axis to');
            ginput(1);
            while ~strcmp(get(gco,'type'),'axes')
              ginput(1);
            end
            pplot('info','off');
            set(gco,'units','pixels');
            pgcps=get(gco,'pos');
          end
          if strcmp(arg5,'hleft')
            set(pgfax,'pos',[pgcps(1) pgaps(2) pgaps(3) pgaps(4)]);         
          elseif strcmp(arg5,'hcent')
            set(pgfax,'pos',[pgcps(1)+pgcps(3)/2-pgaps(3)/2 pgaps(2) pgaps(3) pgaps(4)]);         
          elseif strcmp(arg5,'hright')
            set(pgfax,'pos',[pgcps(1)+pgcps(3)-pgaps(3) pgaps(2) pgaps(3) pgaps(4)]);         
          elseif strcmp(arg5,'vtop')
            set(pgfax,'pos',[pgaps(1) pgcps(2)+pgcps(4)-pgaps(4) pgaps(3) pgaps(4)]);         
          elseif strcmp(arg5,'vcent')
            set(pgfax,'pos',[pgaps(1) pgcps(2)+pgcps(4)/2-pgaps(4)/2 pgaps(3) pgaps(4)]);         
          elseif strcmp(arg5,'vbottom')
            set(pgfax,'pos',[pgaps(1) pgcps(2) pgaps(3) pgaps(4)]);         
          end       
        elseif strcmp(arg3,'gridtype')
          pplot('undo',['set(' sprintf('%18.13f',pgfax) ',''gridlinestyle'',''' get(pplot('buffer','get','axes'),'gridlinestyle') ''');'],['Format ' arg2]);
          set(pgfax,'gridlinestyle',arg4);
        end
        if strcmp(get(gcf,'WindowButtonDownFcn'),'zoom(''down'')')
          set(pgfax,'XLimMode','auto','YLimMode','auto');
          set(get(pgfax,'ZLabel'),'UserData',[]);
        end
      elseif strcmp(arg2,'window')
        if strcmp(arg3,'color')
          curcol=get(gcf,'color');
          pgrgb=pplot('uisetcol',gcf,'PowerGraf Set Color');
          if strcmp(get(gcf,'name'),'PowerGraf Set Color')
            close(gcf);
          end
          if size(pgrgb,2)==3
            pplot('undo',['whitebg(' sprintf('%18.13f',gcf) ',' mat2str(curcol) ');'],['Format ' arg2]);
            whitebg(gcf,pgrgb);
          end
        end
      end
    else
      pplot('info',['There is no current ' arg2 ' selected']);
    end

  %---------------------------------------------------------------------
  elseif strcmp(arg1,'data')
    global pgdline pgdxdata pgdydata pgdobj ret
    pgdobj=pplot('buffer','get','line');
    datamn=get(findobj(gcf,'label','&Data'),'children');
    if strcmp(arg2,'current')
      if pgdobj
        pgdline=pgdobj;
      else
        pgdline=[];
      end
    elseif strcmp(arg2,'all')
      pgdlineall=[findobj(pplot('buffer','get','axes'),'type','line','visible','on').'];
      pgdline=0;
      for i=1:size(pgdlineall,2)
        eval('pgud=get(pgdlineall(i),''userdata'');arro=strcmp(get(pgud(2,2),''type''),''patch'');','arro=0;');
        if ~arro
          pgdline=[pgdline,pgdlineall(i)];
        end
      end
      pgdline=pgdline(2:size(pgdline,2));
    end
    if ~isempty(pgdline) & ~isempty(arg5)
      if strcmp(arg3,'data')
        pgddata=get(pgdline(1),'userdata');
        if size(pgddata,2)~=size(get(pgdline(1),'xdata'),2)
          pgddata=[[get(pgdline(1),'xdata')];[get(pgdline(1),'ydata')]];
          set(pgdline(1),'userdata',pgddata);
        end
        pgdxdata=pgddata(1,:);
        pgdydata=pgddata(2,:);
        for i=2:size(pgdline,2)
          pgddata=get(pgdline(i),'userdata');
          if size(pgddata,2)==0
            pgddata=[[get(pgdline(i),'xdata')];[get(pgdline(i),'ydata')]];
            set(pgdline(i),'userdata',pgddata);
          end
          eval('pgdxdata=[pgdxdata; pgddata(1,:)];pgdydata=[pgdydata; pgddata(2,:)];ret=0;','pplot(''info'',''ERROR: All plots must have the same X-vector'');ret=1;');
        end
      elseif strcmp(arg3,'trace')
        pgdxdata=get(pgdline(1),'xdata');
        pgdydata=get(pgdline(1),'ydata');
        for i=2:size(pgdline,2)
          eval('pgdxdata=[pgdxdata; get(pgdline(i),''xdata'')];pgdydata=[pgdydata; get(pgdline(i),''ydata'')];ret=0;','pplot(''info'',''ERROR: All plots must have the same X-vector'');ret=1;');
        end
      end
      if ret, return; end
      if strcmp(arg4,'save')
        global pgdedy pgdedx pgduifig pgdsy pgdsx pgdform
        pgduifig=figure;
        clf;
        set(pgduifig,'NumberTitle','off','Name',['Save   (' arg2 ', ' arg3 ')'],'color', [1 1 1], 'Resize', 'off','MenuBar','none','Position', [130 150 300 200]);
        set(gca,'units','normal','pos',[0 0 1 1]);
        axis('off');
        text(0,0,'The data will be saved in row-vectors','color','red','units','pixels','pos',[5 180]);
        text(0,0,'Enter filename for y-data (optional):','color','red','units','pixels','pos',[5 150]);
        pgdedy=uicontrol('style','edit','units','pixels','pos',[5 115 225 20],'backgroundcolor', [0.9 0.9 0.83]);
        uicontrol('string','Browse...', 'Position', [235 115 60 20],'CallBack',...
                  'global pgdedy;[pgdname,pgdpath]=uiputfile(''*.mat'',''Save File'');eval([''cd '' pgdpath '';'']);set(pgdedy,''string'',lower(pgdname));clear pgdname pgdpath');
        text(0,0,'Enter filename for x-data (optional):','color','red','units','pixels','pos',[5 90]);
        pgdedx=uicontrol('style','edit','units','pixels','pos',[5 55 225 20],'backgroundcolor', [0.9 0.9 0.83]);
        text(0,0,'Format:','color','red','units','pixels','pos',[5 40]);
        pgdform=uicontrol('style','popupmenu','string',pgsaveforms, ...
                'units','pixels','pos',[5 5 160 20], 'BackgroundColor', [1 1 0.9],'value',1);
        uicontrol('string','Browse...', 'Position', [235 45 60 20],'CallBack',...
                  'global pgdedx;[pgdname,pgdpath]=uiputfile(''*.mat'',''Save File'');eval([''cd '' pgdpath '';'']);set(pgdedx,''string'',lower(pgdname));clear pgdname pgdpath');
        uicontrol('string','Cancel', 'Position', [170 5 60 20],'callback',...
                  'global pgdline pgdxdata pgdydata pgdobj pgduifig pgdedx pgdedy pgdfig pgdsx pgdsy pgdform;close(pgduifig);clear pgdline pgdxdata pgdydata pgdobj pgduifig pgdedx pgdedy pgdsx pgdsy pgdfig pgddat pgdform');
        uicontrol('string','OK', 'Position', [235 5 60 20],'callback',...
                  'global pgdline pgdxdata pgdydata pgdobj pgdedx pgdedy pgduifig pgdsx pgdsy pgdform;pgdsx=get(pgdedx,''string'');pgdsx=pgdsx(1:(find(pgdsx==''.'')-1));pgdsy=get(pgdedy,''string'');pgdsy=pgdsy(1:(find(pgdsy==''.'')-1));if pgdsx,eval([pgdsx ''=pgdxdata(1,:);save '' pgdsx ''.mat '' pgdsx '';clear '' pgdsx]);end;if pgdsy,eval([pgdsy ''=pgdydata;save '' pgdsy ''.mat '' pgdsy '' '' pplot(''element'',get(pgdform,''value''),get(pgdform,''string'')) '';clear '' pgdsy]);end;close(pgduifig);clear pgdedx pgdedy pgduifig pgdsx pgdsy pgddat pgdline pgdxdata pgdydata pgdobj pgdform');
      elseif strcmp(arg5,'custom')
        global pgded pgdhist pgdhistpop pgdhistmn
        figure;
        clf;
        set(gcf,'NumberTitle','off','Name','Custom Function','color', [1 1 1],'MenuBar','none','Position', [150 300 360 100]);
        set(gca,'units','normal','pos',[0 0 1 1]);
        axis('off');
        text(0,0,'Enter the function of the original data "X" and "Y":','color','red','units','pixels','pos',[5 80]);
        if strcmp(arg4,'display')
          text(0,0,'Example: abs(Y)+2*pi.*X','color',[0.4 0.3 0],'units','pixels','pos',[5 60]);
          pgdhistmn=datamn(1);
        elseif strcmp(arg4,'newline')
          text(0,0,'Example: mean(Y)','color',[0.4 0.3 0],'units','pixels','pos',[5 60]);
          pgdhistmn=datamn(2);
        elseif strcmp(arg4,'newplot')
          text(0,0,'Example: polar(angle(Y),abs(Y))','color',[0.4 0.3 0],'units','pixels','pos',[5 60]);
          pgdhistmn=datamn(3);
        end
        pgdhist=get(pgdhistmn,'userdata');
        if isempty(pgdhist),
          pgdhist=' ';
        end
        pgded=uicontrol('style','edit','units','pixels','pos',[5 30 350 20],'backgroundcolor', [0.9 0.9 0.83],'callback',...
                  ['global pgdline pgdxdata pgdydata pgdobj pgded pgds pgdhist pgdhistpop pgdhistmn;pgds=get(pgded,''string'');pgdin=0;for pgdi=1:size(pgdhist,1),pgdin=pgdin+strcmp(deblank(pgds),deblank(pgdhist(pgdi,:)));end;if ~pgdin, set(pgdhistmn,''userdata'',str2mat(pgds,pgdhist));end;close(gcf);pplot(''' arg1 ''',''' arg2 ''',''' arg3 ''',''' arg4 ''',pgds);clear pgdline pgdxdata pgdydata pgdobj pgded pgduifig pgds pgdi pgdhist pgdhistpop pgdhistmn pgdin pgdyplt']);
        pgdhistpop=uicontrol('style','popupmenu','string',pgdhist,'units','pixels','pos',[5 5 220 20], 'BackgroundColor', [1 1 0.9],'callback',...
                  'global pgdhist pgdhistpop pgded;set(pgded,''string'',pgdhist(get(pgdhistpop,''value''),:));');
        uicontrol('string','Cancel', 'Position', [230 5 60 20],'callback',...
                  'global pgdline pgdxdata pgdydata pgdobj pgdhist pgdhistpop pgdhistmn;close(gcf);clear pgdline pgdxdata pgdydata pgdobj pgded pgdax pgdhist pgdhistpop pgdhistmn');
        uicontrol('string','OK', 'Position', [295 5 60 20],'callback',...
                  ['global pgdline pgdxdata pgdydata pgdobj pgded pgds pgdhist pgdhistpop pgdhistmn;pgds=get(pgded,''string'');pgdin=0;for pgdi=1:size(pgdhist,1),pgdin=pgdin+strcmp(deblank(pgds),deblank(pgdhist(pgdi,:)));end;if ~pgdin, set(pgdhistmn,''userdata'',str2mat(pgds,pgdhist));end;close(gcf);pplot(''' arg1 ''',''' arg2 ''',''' arg3 ''',''' arg4 ''',pgds);clear pgdline pgdxdata pgdydata pgdobj pgded pgduifig pgds pgdi pgdhist pgdhistpop pgdhistmn pgdin pgdyplt']);    
      elseif strcmp(arg5,'fitline')
        hld=ishold;
        hold on;
        [p,S]=polyfit(pgdxdata(1,:),pgdydata,arg6);
        pgds='';
        for i=1:arg6
          pgds=[pgds '+(' num2str(p(i)) ')*x^' num2str(arg6+1-i)];
        end
        if arg6
          pgds=['y=' pgds(2:length(pgds)) '+' num2str(p(arg6+1))];
        else
          pgds=['y=' num2str(p(1))];
        end
        pplot('info','See command window for equation');
        disp(pgds);
        pplot(pgdxdata(1,:),polyval(p,pgdxdata(1,:)));
        if ~hld, hold off;end
      else
        if strcmp(arg4,'newplot')
          pgdsfig=pplot;
          set(pgdsfig,'Position',[480 150 450 300]);
          set(gca,'units','normal','pos',[0.1 0.15 .85 .75],'color','none');
        end
        hld=ishold;
        pplot('info',['Function: ' arg5]);
        if strcmp(arg4,'newline')
          eval(['pgdyplt=' strrep(strrep(arg5,'X','pgdxdata(1,:)'),'Y','pgdydata') ';'],'pplot(''info'',''ERROR: Error while evaluating string.'');[]');
          if size(pgdyplt,2)==1
            pgdyplt=pgdyplt.*ones(1,size(pgdxdata,2));
          end
          pplot(pgdxdata(1,:),pgdyplt);
        else
          for i=1:size(pgdline,2)
            if strcmp(arg4,'newplot')
              eval(strrep(strrep(arg5,'X','pgdxdata(i,:)'),'Y','pgdydata(i,:)'),'pplot(''info'',''ERROR: Error while evaluating string.'');');          
              hold on;
            elseif strcmp(arg4,'display')
              eval(['pgydat=' strrep(strrep(arg5,'X','pgdxdata(i,:)'),'Y','pgdydata(i,:)') ';'],'pplot(''info'',''ERROR: Error while evaluating string.'');[]');
              if ~isempty(pgydat)
                if size(pgydat,1)>1
                  pgydat=pgydat.';
                end
                if size(pgydat,2)==1
                  pgydat=pgydat.*ones(size(pgdxdata,2));
                end
                if size(pgydat)==size(get(pgdline(i),'xdata'))
                  set(pgdline(i),'ydata',pgydat);
                else
                  set(pgdline(i),'ydata',pgydat(1,:),'xdata',1:size(pgydat(1,:),2));
                end
              end
            end
          end
        end
        if ~hld, hold off;end
      end
      clear global pgdline pgdxdata pgdydata pgdobj
      if strcmp(get(gcf,'WindowButtonDownFcn'),'zoom(''down'')')
        set(pplot('buffer','get','axes'),'XLimMode','auto','YLimMode','auto');
        set(get(gca,'ZLabel'),'UserData',[]);
      end
    else
      if isempty(pgdline)
        pplot('info','There is no data');
      end
    end

  %---------------------------------------------------------------------
  elseif strcmp(arg1,'move')
    if pplot('buffer','get',arg2)
      pplot('select','off');
      set(pplot('buffer','get','axes'),'drawmode','fast');
      set([gcf,pplot('buffer','get','axes')],'units','pixels');
      pplot('info',['Click and drag to move the selected ' arg2]);
      set(gcf,'pointer','fleur','WindowButtonUpFcn','set(pplot(''buffer'',''get'',''axes''),''drawmode'',''normal'');pplot(''info'',''off'');set(gcf,''WindowButtonMotionFcn'','''');set(gcf,''WindowButtonDownFcn'',''pplot(''''info'''',''''off'''');'');set(gcf,''pointer'',''arrow'');pplot(''select'',''on'');clear pgxdat pgydat pgcpnt pgcpos pgnpnt pgp1 pgp2 pgobj pgpcol pgaxpos;');
      if strcmp(arg2,'line')
        set(gcf,'WindowButtonDownFcn','global pgax pgobj;pgax=pplot(''buffer'',''get'',''axes'');pgobj=pplot(''buffer'',''get'',''line'');pgxdat=get(pgobj,''xdata'');pgydat=get(pgobj,''ydata'');pgcpnt=get(pgax,''currentpoint'');axis(axis);set(gcf,''WindowButtonMotionFcn'',''pgnpnt=get(pgax,''''currentpoint'''');set(pgobj,''''xdata'''',pgxdat+pgnpnt(1,1)-pgcpnt(1,1),''''ydata'''',pgydat+pgnpnt(1,2)-pgcpnt(1,2));'');');
        pplot('undo',['set(' sprintf('%18.13f',pplot('buffer','get','line')) ',''xdata'',real(pplot(''element'',1,get(' sprintf('%18.13f',pplot('buffer','get','line')) ',''userdata''))),''ydata'',real(pplot(''element'',2,get(' sprintf('%18.13f',pplot('buffer','get','line')) ',''userdata''))));'],'Move line');                  
      else
        if (strcmp(arg2,'legend') | strcmp(arg2,'axes'))
          pgs='pgcpos(3:4)';
        else
          pgs='';
        end
        set(pplot('buffer','get',arg2),'units','pixels');
        set(gcf,'WindowButtonDownFcn',['global pgobj;pgobj=pplot(''buffer'',''get'',''' arg2 ''');pgcpos=get(pgobj,''pos'');pgcpnt=get(gcf,''currentpoint'');set(gcf,''WindowButtonMotionFcn'',''pgnpnt=get(gcf,''''currentpoint'''');set(pgobj,''''pos'''',[pgcpos(1:2)+pgnpnt-pgcpnt ' pgs ']);'');']);
        pplot('undo',['set(' sprintf('%18.13f',pplot('buffer','get',arg2)) ',''pos'',' mat2str(get(pplot('buffer','get',arg2),'pos')) ');'],['Move ' arg2]);                  
      end
    else
      pplot('info',['There is no current ' arg2 ' selected']);
    end

  %---------------------------------------------------------------------
  elseif strcmp(arg1,'delete')
    if pplot('buffer','get',arg2)
      set(pplot('buffer','get','axes'),'units','pixels');
      if (strcmp(arg2,'line')|strcmp(arg2,'text'))
        pplot('undo',['set(' sprintf('%18.13f',pplot('buffer','get',arg2)) ',''visible'',''on'');'],['Delete ' arg2]);
        set(pplot('buffer','get',arg2),'visible','off');
      elseif (strcmp(arg2,'title')|strcmp(arg2,'xlabel')|strcmp(arg2,'ylabel'))
        pplot('undo',['set(' sprintf('%18.13f',pplot('buffer','get',arg2)) ',''string'',''' get(pplot('buffer','get',arg2),'string') ''');'],['Delete ' arg2]);
        set(pplot('buffer','get',arg2),'string','');
      elseif strcmp(arg2,'legend')
        pgleg=pplot('buffer','get','legend');
        set([pgleg,pplot('buffer','get','axes')],'units','pixels');
        legpos=get(pgleg,'pos');
        axpos=get(pplot('buffer','get','axes'),'pos');
        set(pgleg,'visible','off','pos',[-100 -100 1 1]);
        if ((legpos(1)+legpos(3))>(axpos(1)+axpos(3)))
          set(pplot('buffer','get','axes'),'pos',[axpos(1) axpos(2) (legpos(1)+legpos(3))-axpos(1) axpos(4)]);
          pplot('undo',['set(' sprintf('%18.13f',pgleg) ',''visible'',''on'',''pos'',' mat2str(legpos) ');set(' sprintf('%18.13f',pplot('buffer','get','axes')) ',''pos'',' mat2str(axpos) ');'],'Delete legend');
        else
          pplot('undo',['set(' sprintf('%18.13f',pgleg) ',''visible'',''on'',''pos'',' mat2str(legpos) ');'],'Delete legend');
        end
      elseif strcmp(arg2,'axes')
        pgax=pplot('buffer','get','axes');
        pgcpos12=pplot('element',1:2,get(pgax,'pos'));
        pgcpos34=pplot('element',3:4,get(pgax,'pos'));
        set(pgax,'DrawMode','fast');
        for i=1:10
          set(pgax,'pos',[pgcpos12-i^4 pgcpos34]);
          drawnow
        end
        set(pgax,'DrawMode','normal');
        if ~pplot('buffer','get','legend')
          pplot('undo',['set(' sprintf('%18.13f',pplot('buffer','get','axes')) ',''pos'',' mat2str([pgcpos12 pgcpos34]) ');'],'Delete axes');
        else
          pplot('undo',['set(' sprintf('%18.13f',pplot('buffer','get','axes')) ',''pos'',' mat2str([pgcpos12 pgcpos34]) ');set(' sprintf('%18.13f',pplot('buffer','get','legend')) ',''pos'',' mat2str(get(pplot('buffer','get','legend'),'pos')) ');'],'Delete axes');
          set(pplot('buffer','get','legend'),'pos',[-100 -100 1 1]);
        end
      end
    else
      pplot('info',['There is no current ' arg2 ' selected']);
    end

  %---------------------------------------------------------------------
  elseif strcmp(arg1,'tool')
    if strcmp(arg2,'color')
      pplot('undo','off');
      h=[gcf findobj(gcf,'type','axes')' findobj(gcf,'type','text')' findobj(gcf,'type','line')'];
      ha=findobj(gcf,'type','axes')';
      hp=findobj(gcf,'type','patch');
      if size(ha,1)==0,ha=[];end;
      if size(hp,1)==0,hp=[];end;
      if strcmp(arg3,'invert')
        whitebg;
        for i=1:size(ha,2)
          if size(get(ha(i),'color'),2)==3
            set(ha(i),'color',1-get(ha(i),'color'));
          end
        end
      elseif strcmp(arg3,'lighten')
        for i=1:size(h,2)
          if size(get(h(i),'color'),2)==3 & sum(get(h(i),'color'))
            set(h(i),'color',min([1 1 1],(get(h(i),'color')+.2)));
          end
        end
        for i=1:size(ha,2)
          if sum(get(ha(i),'xcolor'))
            set(ha(i),'xcolor',min([1 1 1],(get(ha(i),'xcolor')+.2)));
          end
          if sum(get(ha(i),'ycolor'))
            set(ha(i),'ycolor',min([1 1 1],(get(ha(i),'ycolor')+.2)));
          end
        end
        for i=1:size(hp,2)
          if sum(get(hp(i),'facecolor'))
            set(hp(i),'facecolor',min([1 1 1],(get(hp(i),'facecolor')+.2)));
          end
        end
      elseif strcmp(arg3,'darken')
        for i=1:size(h,2)
          if size(get(h(i),'color'),2)==3 & sum(get(h(i),'color'))<3
            set(h(i),'color',max([0 0 0],(get(h(i),'color')-.2)));
          end
        end
        for i=1:size(ha,2)
          if sum(get(ha(i),'xcolor'))<3
            set(ha(i),'xcolor',max([0 0 0],(get(ha(i),'xcolor')-.2)));
          end
          if sum(get(ha(i),'ycolor'))<3
            set(ha(i),'ycolor',max([0 0 0],(get(ha(i),'ycolor')-.2)));
          end
        end
        for i=1:size(hp,2)
          if sum(get(hp(i),'facecolor'))<3
            set(hp(i),'facecolor',max([0 0 0],(get(hp(i),'facecolor')-.2)));
          end
        end
      elseif strcmp(arg3,'gray')
        for i=1:size(h,2)
          if size(get(h(i),'color'),2)==3
            set(h(i),'color',sum(get(h(i),'color'))/3.*[1 1 1]);
          end
        end
        for i=1:size(ha,2)
          set(ha(i),'xcolor',sum(get(ha(i),'xcolor'))/3.*[1 1 1]);
          set(ha(i),'ycolor',sum(get(ha(i),'ycolor'))/3.*[1 1 1]);
        end
        for i=1:size(hp,2)
          set(hp(i),'facecolor',sum(get(hp(i),'facecolor'))/3.*[1 1 1]);
        end
      elseif strcmp(arg3,'blw')
        for i=1:size(h,2)
          if size(get(h(i),'color'),2)==3
            set(h(i),'color',(sum(get(h(i),'color'))>1.5).*[1 1 1]);
          end
        end
        for i=1:size(ha,2)
            set(ha(i),'xcolor',(sum(get(ha(i),'xcolor'))>1.5).*[1 1 1]);
            set(ha(i),'ycolor',(sum(get(ha(i),'ycolor'))>1.5).*[1 1 1]);
        end
        for i=1:size(hp,2)
            set(hp(i),'facecolor',(sum(get(hp(i),'facecolor'))>1.5).*[1 1 1]);
        end
      elseif strcmp(arg3,'alllinecol')
        pgccol=pplot('uisetcol',1-get(gcf,'color'));
        set(findobj(gcf,'type','patch'),'facecolor',pgccol);
        set(findobj(gcf,'type','line'),'color',pgccol);
      end
    elseif strcmp(arg2,'scroll')
      if pplot('buffer','get','axes')
        pplot('select','off');
        pplot('undo',['set(' sprintf('%18.13f',pplot('buffer','get','axes')) ',''xlim'',' mat2str(get(pplot('buffer','get','axes'),'xlim')) ',''ylim'',' mat2str(get(pplot('buffer','get','axes'),'ylim')) ');'],'Scroll');
        pplot('info',['Click and drag to scroll']);
        set(gcf,'pointer','fleur','units','pixels','WindowButtonUpFcn','set(gcf,''WindowButtonMotionFcn'','''');set(gcf,''WindowButtonDownFcn'',''pplot(''''info'''',''''off'''');'');set(gcf,''pointer'',''arrow'');pplot(''select'',''on'');clear pgaxs pgcpnt pgcpos pgnpnt pgp1 pgp2 pgobj pgpcol pgxlim pgylim;');
        set(gcf,'WindowButtonDownFcn','global pgaxs;pgaxs=pplot(''buffer'',''get'',''axes'');pgxlim=get(pgaxs,''xlim'');pgylim=get(pgaxs,''ylim'');pgcpnt=get(pgaxs,''currentpoint'');pgp1=get(pgaxs,''xtick'');pgp1=pgp1(2)-pgp1(1);pgp2=get(pgaxs,''ytick'');pgp2=pgp2(2)-pgp2(1);set(gcf,''WindowButtonMotionFcn'',''global pgaxs;pgnpnt=get(pgaxs,''''currentpoint'''');axis([pgxlim(1)-(pgnpnt(1,1)-pgcpnt(1,1)) pgxlim(2)-(pgnpnt(1,1)-pgcpnt(1,1)) pgylim(1)-(pgnpnt(1,2)-pgcpnt(1,2)) pgylim(2)-(pgnpnt(1,2)-pgcpnt(1,2))]);drawnow;pgcpnt=get(pgaxs,''''currentpoint'''');pgxlim=get(pgaxs,''''xlim'''');pgylim=get(pgaxs,''''ylim'''');'');');
      end
    elseif strcmp(arg2,'marker')
      if pplot('buffer','get','line')
        if strcmp(arg3,'off')
          global pglxdat pglydat pglydatv pgobj pgax pgcpnt pgnpnt;
          set(pgobj,'erasemode','normal');
          drawnow;
          delete(pgobj);
          pplot('info','off');
          set(gca,'drawmode','normal');
          set(gcf,'WindowButtonMotionFcn','','WindowButtonDownFcn','','pointer','arrow');
          clear global pglxdat pglydat pglydatv pgcpnt pgcpos pgnpnt pgobj pgax pgpcol pgaxpos;
          refresh;
        else
          global pglxdat pglydat pglydatv pgobj pgax
          if sum(get(gcf,'color'))>1.5
            pgcol=[0 0 0];
          else
            pgcol=[1 1 1];
          end
          pglxdat=get(pplot('buffer','get','line'),'xdata');
          pglydat=get(pplot('buffer','get','line'),'ydata');
          if strcmp(arg3,'trace')
            pglydatv=pglydat;
          elseif strcmp(arg3,'data')
            pglydatv=get(pplot('buffer','get','line'),'userdata');
            pglydatv=pglydatv(2,:);
          end
          arg3=[upper(arg3(1)) arg3(2:length(arg3))];
          pgax=pplot('buffer','get','axes');
          set(gcf,'pointer','crosshair','units','pixels');
          set(gca,'drawmode','fast','units','pixels');
          pgobj=line('color',[.7 .7 .7],'xdata',[],'ydata',[],'LineWidth',1,'LineStyle','+','EraseMode','xor');
          set(gcf,'WindowButtonMotionFcn',['global pglxdat pglydat pglydatv pgobj pgax pgcpnt pgnpnt;pgnpnt=get(pgax,''currentpoint'');pgcpnt=find(pglxdat>=pgnpnt(1,1));if isempty(pgcpnt),pgcpnt=size(pglxdat,2);end;pplot(''info'',[''' arg3 ' = '' num2str(pglydatv(pgcpnt(1))) ''   @   X('' num2str(pgcpnt(1)) '') = '' num2str(pglxdat(pgcpnt(1)),3)]);set(pgobj,''xdata'',pglxdat(pgcpnt(1)),''ydata'',pglydat(pgcpnt(1)));drawnow;']);
        end
      else
        pplot('info',['There is no current line selected']);
      end
    elseif strcmp(arg2,'arrow')
      arrmn=findobj(gcf,'label','&Arrow');
      eval('pgud=get(get(arrmn,''userdata''),''userdata'');arr=1;','pplot(''info'',''There is no current arrow selected'');arr=0;');
      if strcmp(arg3,'insert')
        global pgobj pgax
        pplot('select','off');
        pgax=pplot('buffer','get','axes');
        pgxlim=get(pgax,'xlim');
        pgylim=get(pgax,'ylim');
        pgobj=arrow([mean(pgxlim) mean(pgylim)],[mean(pgxlim) mean(pgylim)],0,pi/6,0.5,(mean(get(gcf,'color'))<.5).*[1 1 1],'-');
        pplot('info','Click and drag to place the arrow (click tail first)');
        set(gcf,'pointer','crosshair','WindowButtonDownFcn','global pgobj pgax;pgcpnt=get(pgax,''currentpoint'');set(gcf,''WindowButtonMotionFcn'',''pgnpnt=get(pgax,''''currentpoint'''');arrow(pgobj(1),[pgcpnt(1,1),pgcpnt(1,2)],[pgnpnt(1,1),pgnpnt(1,2)],0.085);'');');
        set(gcf,'WindowButtonUpFcn','set(gcf,''WindowButtonMotionFcn'','''');set(gcf,''WindowButtonDownFcn'',''pplot(''''info'''',''''off'''');'');set(gcf,''pointer'',''arrow'');pplot(''select'',''on'');clear pgxdat pgydat pgcpnt pgcpos pgnpnt pgp1 pgp2 pgobj pgpcol pgax pgaxpos;');
        set(arrmn,'userdata',pgobj(1));
        pplot('undo',['delete(' sprintf('%18.13f',pgobj(1)) ');delete(' sprintf('%18.13f',pgobj(2)) ');'],'Insert');
      elseif strcmp(arg3,'select')
        pplot('info','Click on an arrow to select');
        ginput(1);
        eval('pgud=get(gco,''userdata'');arro=strcmp(get(pgud(2,2),''type''),''patch'');','arro=0;');
        if arro
          set(arrmn,'userdata',gco);
          pgline=abs(pgud(2,1));
          pgcol=get(pgline,'color');
          set(pgline,'color',1-pgcol);
          refresh;
          pplot('pause',0.4);
          set(pgline,'color',pgcol);
          pplot('info','arrow selected');
        else
          pplot('info','That was not an arrow to me');
        end
      elseif arr
        if strcmp(arg3,'color')
          pplot('undo',['set(' sprintf('%18.13f',abs(pgud(2,1))) ',''color'',' mat2str(get(abs(pgud(2,1)),'color')) ');set(' sprintf('%18.13f',abs(pgud(2,2))) ',''facecolor'',' mat2str(get(abs(pgud(2,2)),'facecolor')) ');'],'Format arrow');
          pgccol=pplot('uisetcol',pgud(2,1));
          set(abs(pgud(2,1)),'color',pgccol);
          set(abs(pgud(2,2)),'facecolor',pgccol);
        elseif strcmp(arg3,'width')
          pg1=get(abs(pgud(2,1)),'xdata');
          pg2=get(abs(pgud(2,1)),'ydata');
          pg3=get(abs(pgud(2,2)),'xdata');
          pg4=get(abs(pgud(2,2)),'ydata');
          oldw=get(abs(pgud(2,1)),'linewidth');
          pplot('undo',['arrow(' sprintf('%18.13f',abs(pgud(2,1))) ',' mat2str([pg1(1) pg2(1)]) ',' mat2str([pg3(1) pg4(1)]) ',' mat2str((oldw+1.5)/2*0.085) ',' mat2str(pi/6) ',' mat2str(oldw) ');'],'Format arrow');
          arrow(abs(pgud(2,1)),[pg1(1) pg2(1)],[pg3(1) pg4(1)],(arg4+1.5)/2*0.085,pi/6,arg4);
        elseif strcmp(arg3,'type')
          pplot('undo',['set(' sprintf('%18.13f',abs(pgud(2,1))) ',''linestyle'',''' get(abs(pgud(2,1)),'linestyle') ''');'],'Format arrow');
          set(abs(pgud(2,1)),'linestyle',arg4);
        elseif strcmp(arg3,'reposition')
          global pgobj
          pgobj=abs(pgud(2,1));
          pplot('info','Click and drag to place the arrow (click tail first)');
          pg1=get(abs(pgud(2,1)),'xdata');
          pg2=get(abs(pgud(2,1)),'ydata');
          pg3=get(abs(pgud(2,2)),'xdata');
          pg4=get(abs(pgud(2,2)),'ydata');
          pplot('undo',['arrow(' sprintf('%18.13f',abs(pgud(2,1))) ',' mat2str([pg1(1) pg2(1)]) ',' mat2str([pg3(1) pg4(1)]) ');'],'Format arrow');
          set(gcf,'pointer','crosshair','WindowButtonDownFcn','global pgobj pgax;pgcpnt=get(pgax,''currentpoint'');set(gcf,''WindowButtonMotionFcn'',''pgnpnt=get(pgax,''''currentpoint'''');arrow(pgobj(1),[pgcpnt(1,1),pgcpnt(1,2)],[pgnpnt(1,1),pgnpnt(1,2)]);'');');
          set(gcf,'WindowButtonUpFcn','set(gcf,''WindowButtonMotionFcn'','''');set(gcf,''WindowButtonDownFcn'',''pplot(''''info'''',''''off'''');'');set(gcf,''pointer'',''arrow'');clear pgxdat pgydat pgcpnt pgcpos pgnpnt pgp1 pgp2 pgobj pgpcol pgax pgaxpos;');
        elseif strcmp(arg3,'delete')
          pplot('undo',['set([' sprintf('%18.13f',abs(pgud(2,1))) ',' sprintf('%18.13f',abs(pgud(2,2))) '],''visible'',''on'');'],'Delete');
          set([abs(pgud(2,1)),abs(pgud(2,2))],'visible','off');
        end
      end
    elseif strcmp(arg2,'rc')
      if strcmp(arg3,'display')
        global pgrcdpop1 pgrcdpop2 pgrcdpop3 pgrcdpop4 pgrcdpop5 pgrcded pgrcdfig pgrcdstrs pgrcdfuns pgrcdopts
        pgrcdfig=gcf;
        figure;
        clf;
        set(gcf,'NumberTitle','off','Name','Display Remote Control','color', [1 1 1],'MenuBar','none','Position', [270 32 295 105],'Resize','off');
        set(gca,'units','normal','pos',[0 0 1 1]);
        axis('off');
        pgrcdstrs=['all    ';'current';'data   ';'trace  '];
        pgrcdfuns=['real(Y) ';'imag(Y) ';'abs(Y)  ';'angle(Y)'];
        pgrcdopts=['display';'newline';'newplot'];
        pgrcdpop1=uicontrol('style','popupmenu','string',pgrcdstrs(1:2,:),'units','pixels','pos',[35 80 65 20], 'BackgroundColor', [1 1 0.9]);
        pgrcdpop2=uicontrol('style','popupmenu','string',pgrcdstrs(3:4,:),'units','pixels','pos',[155 80 60 20], 'BackgroundColor', [1 1 0.9]);
        pgrcdpop3=uicontrol('style','popupmenu','string',' ','units','pixels','pos',[5 5 145 20], 'BackgroundColor', [1 1 0.9],'callback',...
                  'global pgrcdpop1 pgrcdpop2 pgrcdpop3 pgrcdpop4 pgrcdpop5 pgrcded pgrcdfig pgrcdstrs pgrcdfuns pgrcdopts;pgrcdhist=get(pgrcdpop3,''string'');set(pgrcded,''string'',deblank(pgrcdhist(get(pgrcdpop3,''value''),:)));figure(pgrcdfig);drawnow;pplot(''data'',deblank(pgrcdstrs(get(pgrcdpop1,''value''),:)),deblank(pgrcdstrs(get(pgrcdpop2,''value'')+2,:)),deblank(pgrcdopts(get(pgrcdpop5,''value''),:)),deblank(get(pgrcded,''string'')));');
        pgrcdpop4=uicontrol('style','popupmenu','string',pgrcdfuns,'units','pixels','pos',[155 5 70 20], 'BackgroundColor', [1 1 0.9],'callback',...
                  'global pgrcdpop1 pgrcdpop2 pgrcdpop3 pgrcdpop4 pgrcdpop5 pgrcded pgrcdfig pgrcdstrs pgrcdfuns pgrcdopts;set(pgrcded,''string'',deblank(pgrcdfuns(get(pgrcdpop4,''value''),:)));figure(pgrcdfig);drawnow;pplot(''data'',deblank(pgrcdstrs(get(pgrcdpop1,''value''),:)),deblank(pgrcdstrs(get(pgrcdpop2,''value'')+2,:)),deblank(pgrcdopts(get(pgrcdpop5,''value''),:)),deblank(get(pgrcded,''string'')));');
        pgrcdpop5=uicontrol('style','popupmenu','string',pgrcdopts,'units','pixels','pos',[220 80 70 20], 'BackgroundColor', [1 1 0.9]);
        text(0,0,'On','color',[0.4 0.3 0],'units','pixels','pos',[5 90]);
        text(0,0,'line(s)','color',[0.4 0.3 0],'units','pixels','pos',[110 90]);
        text(0,0,'Enter expression of "X" and "Y":','color',[0.4 0.3 0],'units','pixels','pos',[5 60]);
        pgrcded=uicontrol('style','edit','units','pixels','pos',[5 30 220 20],'backgroundcolor', [0.9 0.9 0.83],'callback',...
                  'global pgrcdpop1 pgrcdpop2 pgrcdpop3 pgrcdpop4 pgrcdpop5 pgrcded pgrcdfig pgrcdstrs pgrcdfuns pgrcdopts;pgrcds=get(pgrcded,''string'');pgrcdhist=get(pgrcdpop3,''string'');pgrcdin=0;for pgrcdi=1:size(pgrcdhist,1),pgrcdin=pgrcdin+strcmp(deblank(pgrcds),deblank(pgrcdhist(pgrcdi,:)));end;if ~pgrcdin, set(pgrcdpop3,''string'',str2mat(pgrcds,pgrcdhist));end;figure(pgrcdfig);drawnow;pplot(''data'',deblank(pgrcdstrs(get(pgrcdpop1,''value''),:)),deblank(pgrcdstrs(get(pgrcdpop2,''value'')+2,:)),deblank(pgrcdopts(get(pgrcdpop5,''value''),:)),deblank(get(pgrcded,''string'')));clear pgrcdhist pgrcds pgrcdi pgrcdin');
        uicontrol('string','Close', 'Position', [230 5 60 20],'callback',...
                  'global pgrcdpop1 pgrcdpop2 pgrcdpop3 pgrcdpop4 pgrcdpop5 pgrcded pgrcdfig pgrcdstrs pgrcdfuns pgrcdopts pgrcdhist;close(gcf);clear pgrcdpop1 pgrcdpop2 pgrcdpop3 pgrcdpop4 pgrcdpop5 pgrcded pgrcdfig pgrcdstrs pgrcdfuns pgrcdhist pgrcdopts');
        uicontrol('string','Apply', 'Position', [230 30 60 20],'callback',...
                  'global pgrcdpop1 pgrcdpop2 pgrcdpop3 pgrcdpop4 pgrcdpop5 pgrcded pgrcdfig pgrcdstrs pgrcdfuns pgrcdopts;figure(pgrcdfig);drawnow;pplot(''data'',deblank(pgrcdstrs(get(pgrcdpop1,''value''),:)),deblank(pgrcdstrs(get(pgrcdpop2,''value'')+2,:)),deblank(pgrcdopts(get(pgrcdpop5,''value''),:)),deblank(get(pgrcded,''string'')));');
      elseif strcmp(arg3,'axes')
        global pgrcapop1 pgrcaed1 pgrcaed2 pgrcaed3 pgrcaed4 pgrcac1 pgrcac2 pgrcac3 pgrcac4 pgrcac5 pgrcac6 pgrcafig
        pgrcafig=gcf;
        pglim=[get(pplot('buffer','get','axes'),'xlim') get(pplot('buffer','get','axes'),'ylim')];
        pgbox=strcmp(get(pplot('buffer','get','axes'),'box'),'on');
        pgxlog=strcmp(get(pplot('buffer','get','axes'),'xscale'),'log');
        pgylog=strcmp(get(pplot('buffer','get','axes'),'yscale'),'log');
        pgxgrid=strcmp(get(pplot('buffer','get','axes'),'xgrid'),'on');
        pgygrid=strcmp(get(pplot('buffer','get','axes'),'ygrid'),'on');
        figure;
        clf;
        set(gcf,'NumberTitle','off','Name','Axis Remote Control','color', [1 1 1],'MenuBar','none','Position', [5 32 255 190],'Resize','off');
        sparfill=fill([0 255 255 0 0],[30 30 135 135 30],[0.99 0.99 0.94],[0 255 255 0 0],[0 0 30 30 0],[0.9 0.9 0.83]);
        set(sparfill,'edgecolor',[1 1 1]);
        set(gca,'units','normal','pos',[0 0 1 1]);
        axis([0 255 0 190]);
        axis('off');
        text(0,0,'Axis:','color','blue','units','pixels','pos',[5 175]);
        text(0,0,'X-axis:','color','red','units','pixels','pos',[5 120]);
        text(0,0,'Y-axis:','color','red','units','pixels','pos',[5 70]);
        uicontrol('string','Font...','units','pixels','pos',[125 165 60 20],'Callback','global pgrcafig;figure(pgrcafig);pplot(''format'',''axes'',''font'');');
        uicontrol('string','Color...','units','pixels','pos',[60 165 60 20],'Callback','global pgrcafig;figure(pgrcafig);pplot(''format'',''axes'',''color'');');
        uicontrol('string','Color...','units','pixels','pos',[190 110 60 20],'Callback','global pgrcafig;figure(pgrcafig);pplot(''format'',''axes'',''xaxis'',''color'');');
        uicontrol('string','Flip','units','pixels','pos',[190 85 60 20],'Callback','global pgrcafig;figure(pgrcafig);pplot(''format'',''axes'',''xaxis'',''flip'');');
        uicontrol('string','Color...','units','pixels','pos',[190 60 60 20],'Callback','global pgrcafig;figure(pgrcafig);pplot(''format'',''axes'',''yaxis'',''color'');');
        uicontrol('string','Flip','units','pixels','pos',[190 35 60 20],'Callback','global pgrcafig;figure(pgrcafig);pplot(''format'',''axes'',''yaxis'',''flip'');');
        pgrcapop1=uicontrol('style','popupmenu','string',pglines,'units','pixels','pos',[190 165 60 20], 'BackgroundColor', [1 1 0.9],'Callback','global pgrcafig pgrcapop1;pgs=get(pgrcapop1,''string'');figure(pgrcafig);pplot(''format'',''axes'',''gridtype'',pgs(get(pgrcapop1,''value''),:));');
        pgrcac1=uicontrol('style','check','string','AutoScale','value',0,'pos',[60 140 125 20],'foregroundcolor',[0.4 0.3 0],'backgroundcolor',[1 1 1],'Callback','global pgrcaed1 pgrcaed2 pgrcaed3 pgrcaed4 pgrcac1 pgrcafig;figure(pgrcafig);if get(pgrcac1,''value''),pplot(''format'',''axes'',''limits'',''auto'');pgxlim=get(pplot(''buffer'',''get'',''axes''),''xlim'');pgylim=get(pplot(''buffer'',''get'',''axes''),''ylim'');set(pgrcaed1,''string'',num2str(pgxlim(1)));set(pgrcaed2,''string'',num2str(pgxlim(2)));set(pgrcaed3,''string'',num2str(pgylim(1)));set(pgrcaed4,''string'',num2str(pgylim(2)));else axes(pplot(''buffer'',''get'',''axes''));axis(axis);end;');
        pgrcac2=uicontrol('style','check','string','Box','value',pgbox,'pos',[190 140 60 20],'foregroundcolor',[0.4 0.3 0],'backgroundcolor',[1 1 1],'Callback','global pgrcac2 pgrcafig;figure(pgrcafig);if get(pgrcac2,''value''),pplot(''format'',''axes'',''box'',''on'');else pplot(''format'',''axes'',''box'',''off'');end;');
        pgrcac3=uicontrol('style','check','string','LOG','value',pgxlog,'pos',[60 85 60 20],'foregroundcolor',[0.4 0.3 0],'backgroundcolor',[0.99 0.99 0.94],'Callback','global pgrcac3 pgrcafig;figure(pgrcafig);if get(pgrcac3,''value''),pplot(''format'',''axes'',''xaxis'',''scale'',''log'');else pplot(''format'',''axes'',''xaxis'',''scale'',''linear'');end;');
        pgrcac4=uicontrol('style','check','string','LOG','value',pgylog,'pos',[60 35 60 20],'foregroundcolor',[0.4 0.3 0],'backgroundcolor',[0.99 0.99 0.94],'Callback','global pgrcac4 pgrcafig;figure(pgrcafig);if get(pgrcac4,''value''),pplot(''format'',''axes'',''yaxis'',''scale'',''log'');else pplot(''format'',''axes'',''yaxis'',''scale'',''linear'');end;');
        pgrcac5=uicontrol('style','check','string','Grid','value',pgxgrid,'pos',[125 85 60 20],'foregroundcolor',[0.4 0.3 0],'backgroundcolor',[0.99 0.99 0.94],'Callback','global pgrcac5 pgrcafig;figure(pgrcafig);if get(pgrcac5,''value''),pplot(''format'',''axes'',''xaxis'',''grid'',''on'');else pplot(''format'',''axes'',''xaxis'',''grid'',''off'');end;');
        pgrcac6=uicontrol('style','check','string','Grid','value',pgygrid,'pos',[125 35 60 20],'foregroundcolor',[0.4 0.3 0],'backgroundcolor',[0.99 0.99 0.94],'Callback','global pgrcac6 pgrcafig;figure(pgrcafig);if get(pgrcac6,''value''),pplot(''format'',''axes'',''yaxis'',''grid'',''on'');else pplot(''format'',''axes'',''yaxis'',''grid'',''off'');end;');
        pgrcaed1=uicontrol('style','edit','string',num2str(pglim(1)),'units','pixels','HorizontalAlignment','right','pos',[60 110 60 20],'backgroundcolor', [0.9 0.9 0.83],'callback',... 
              'global pgrcaed1 pgrcaed2 pgrcaed3 pgrcaed4 pgrcafig pgrcac1;set(pgrcac1,''value'',0);figure(pgrcafig);set(pplot(''buffer'',''get'',''axes''),''xlim'',[min(eval(get(pgrcaed1,''string'')),eval(get(pgrcaed2,''string''))) max(eval(get(pgrcaed1,''string'')),eval(get(pgrcaed2,''string'')))]);');
        pgrcaed2=uicontrol('style','edit','string',num2str(pglim(2)),'units','pixels','HorizontalAlignment','right','pos',[125 110 60 20],'backgroundcolor', [0.9 0.9 0.83],'callback',... 
              'global pgrcaed1 pgrcaed2 pgrcaed3 pgrcaed4 pgrcafig pgrcac1;set(pgrcac1,''value'',0);figure(pgrcafig);set(pplot(''buffer'',''get'',''axes''),''xlim'',[min(eval(get(pgrcaed1,''string'')),eval(get(pgrcaed2,''string''))) max(eval(get(pgrcaed1,''string'')),eval(get(pgrcaed2,''string'')))]);');
        pgrcaed3=uicontrol('style','edit','string',num2str(pglim(3)),'units','pixels','HorizontalAlignment','right','pos',[60 60 60 20],'backgroundcolor', [0.9 0.9 0.83],'callback',... 
              'global pgrcaed1 pgrcaed2 pgrcaed3 pgrcaed4 pgrcafig pgrcac1;set(pgrcac1,''value'',0);figure(pgrcafig);set(pplot(''buffer'',''get'',''axes''),''ylim'',[min(eval(get(pgrcaed3,''string'')),eval(get(pgrcaed4,''string''))) max(eval(get(pgrcaed3,''string'')),eval(get(pgrcaed4,''string'')))]);');
        pgrcaed4=uicontrol('style','edit','string',num2str(pglim(4)),'units','pixels','HorizontalAlignment','right','pos',[125 60 60 20],'backgroundcolor', [0.9 0.9 0.83],'callback',... 
              'global pgrcaed1 pgrcaed2 pgrcaed3 pgrcaed4 pgrcafig pgrcac1;set(pgrcac1,''value'',0);figure(pgrcafig);set(pplot(''buffer'',''get'',''axes''),''ylim'',[min(eval(get(pgrcaed3,''string'')),eval(get(pgrcaed4,''string''))) max(eval(get(pgrcaed3,''string'')),eval(get(pgrcaed4,''string'')))]);');
        uicontrol('string','Close', 'Position', [190 5 60 20],'callback',...
              'global pgrcapop1 pgrcaed1 pgrcaed2 pgrcaed3 pgrcaed4 pgrcac1 pgrcac2 pgrcac3 pgrcac4 pgrcac5 pgrcac6 pgrcafig pgs pgxlim pgylim;close(gcf);clear  pgrcapop1 pgrcaed1 pgrcaed2 pgrcaed3 pgrcaed4 pgrcac1 pgrcac2 pgrcac3 pgrcac4 pgrcac5 pgrcac6 pgrcafig pgs pgxlim pgylim');
      elseif strcmp(arg3,'label')
        global pgrclfig
        pgrclfig=gcf;
        figure;
        clf;
        set(gcf,'NumberTitle','off','Name','Label Remote Control','color', [1 1 1],'MenuBar','none','Position', [5 250 200 115],'Resize','off');
        sparfill=fill([0 200 200 0 0],[30 30 85 85 30],[0.9 0.9 0.83]);
        set(sparfill,'edgecolor',[1 1 1]);
        set(gca,'units','normal','pos',[0 0 1 1]);
        axis([0 200 0 115]);
        axis('off');
        uicontrol('string','Title...','units','pixels','pos',[5 90 60 20],'Callback','global pgrclfig;figure(pgrclfig);pplot(''insert'',''title'');');
        uicontrol('string','Color...','units','pixels','pos',[70 90 60 20],'Callback','global pgrclfig;figure(pgrclfig);pplot(''format'',''title'',''color'');');
        uicontrol('string','Font...','units','pixels','pos',[135 90 60 20],'Callback','global pgrclfig;figure(pgrclfig);pplot(''format'',''title'',''font'');');
        uicontrol('string','Xlabel...','units','pixels','pos',[5 60 60 20],'Callback','global pgrclfig;figure(pgrclfig);pplot(''insert'',''xlabel'');');
        uicontrol('string','Color...','units','pixels','pos',[70 60 60 20],'Callback','global pgrclfig;figure(pgrclfig);pplot(''format'',''xlabel'',''color'');');
        uicontrol('string','Font...','units','pixels','pos',[135 60 60 20],'Callback','global pgrclfig;figure(pgrclfig);pplot(''format'',''xlabel'',''font'');');
        uicontrol('string','Ylabel...','units','pixels','pos',[5 35 60 20],'Callback','global pgrclfig;figure(pgrclfig);pplot(''insert'',''ylabel'');');
        uicontrol('string','Color...','units','pixels','pos',[70 35 60 20],'Callback','global pgrclfig;figure(pgrclfig);pplot(''format'',''ylabel'',''color'');');
        uicontrol('string','Font...','units','pixels','pos',[135 35 60 20],'Callback','global pgrclfig;figure(pgrclfig);pplot(''format'',''ylabel'',''font'');');
        uicontrol('string','Close', 'Position', [135 5 60 20],'callback','global pgrclfig;close(gcf);clear pgrclfig;');
      elseif strcmp(arg3,'line')
        global pgrcifig pgrcipop1 pgrcipop2 pgrcipop3
        pgrcifig=gcf;
        figure;
        clf;
        if mat5
          set(gcf,'NumberTitle','off','Name','Line RC','color', [1 1 1],'MenuBar','none','Position', [5 393 335 30],'Resize','off');
          uicontrol('string','Color...','units','pixels','pos',[5 5 60 20],'Callback','global pgrcifig;figure(pgrcifig);pplot(''format'',''line'',''color'');');
          pgrcipop1=uicontrol('style','popupmenu','string',pglines,'units','pixels','pos',[70 5 50 20], 'BackgroundColor', [1 1 0.9],'Callback','global pgrcifig pgrcipop1;pgs=get(pgrcipop1,''string'');figure(pgrcifig);pplot(''format'',''line'',''linestyle'',pgs(get(pgrcipop1,''value''),:));');
          pgrcipop2=uicontrol('style','popupmenu','string',pgmarkers,'units','pixels','pos',[125 5 70 20], 'BackgroundColor', [1 1 0.9],'Callback','global pgrcifig pgrcipop2;pgs=get(pgrcipop2,''string'');figure(pgrcifig);pplot(''format'',''line'',''marker'',pgs(get(pgrcipop2,''value''),:));');
          pgrcipop3=uicontrol('style','popupmenu','string',pgwidths,'units','pixels','pos',[200 5 60 20], 'BackgroundColor', [1 1 0.9],'Callback','global pgrcifig pgrcipop3;pgs=get(pgrcipop3,''string'');figure(pgrcifig);pplot(''format'',''line'',''linewidth'',eval(pgs(get(pgrcipop3,''value''),:)));');
          uicontrol('string','Close', 'Position',[270 5 60 20],'callback','global pgrcifig pgrcipop1 pgrcipop2 pgrcipop3;close(gcf);clear pgrcifig pgrcipop1 pgrcipop2 pgrcipop3;');
        else
          set(gcf,'NumberTitle','off','Name','Line RC','color', [1 1 1],'MenuBar','none','Position', [5 393 270 30],'Resize','off');
          uicontrol('string','Color...','units','pixels','pos',[5 5 60 20],'Callback','global pgrcifig;figure(pgrcifig);pplot(''format'',''line'',''color'');');
          pgrcipop1=uicontrol('style','popupmenu','string',pgtypes,'units','pixels','pos',[70 5 60 20], 'BackgroundColor', [1 1 0.9],'Callback','global pgrcifig pgrcipop1;pgs=get(pgrcipop1,''string'');figure(pgrcifig);pplot(''format'',''line'',''linestyle'',pgs(get(pgrcipop1,''value''),:));');
          pgrcipop2=uicontrol('style','popupmenu','string',pgwidths,'units','pixels','pos',[135 5 60 20], 'BackgroundColor', [1 1 0.9],'Callback','global pgrcifig pgrcipop2;pgs=get(pgrcipop2,''string'');figure(pgrcifig);pplot(''format'',''line'',''linewidth'',eval(pgs(get(pgrcipop2,''value''),:)));');
          uicontrol('string','Close','Position',[205 5 60 20],'callback','global pgrcifig pgrcipop1 pgrcipop2;close(gcf);clear pgrcifig pgrcipop1 pgrcipop2;');
        end
      end
    end

  %---------------------------------------------------------------------
  elseif strcmp(arg1,'test')
    pplot(1:100,(-1)^rand.*0.3.*exp(rand.*sin(rand.*(.1:.1:10))+.1.*rand(1,100)+j.*pi.*rand.*(sin(.1:.1:10)+.1.*rand(1,100))),1:100,(-1)^rand.*0.3.*exp(rand.*sin(rand.*(.1:.1:10))+.1.*rand(1,100)+j.*pi.*rand.*(sin(.1:.1:10)+.1.*rand(1,100))),1:100,(-1)^rand.*0.3.*exp(rand.*sin(rand.*(.1:.1:10))+.1.*rand(1,100)+j.*pi.*rand.*(sin(.1:.1:10)+.1.*rand(1,100))),1:100,(-1)^rand.*0.3.*exp(rand.*sin(rand.*(.1:.1:10))+.1.*rand(1,100)+j.*pi.*rand.*(sin(.1:.1:10)+.1.*rand(1,100))),1:100,(-1)^rand.*0.3.*exp(rand.*sin(rand.*(.1:.1:10))+.1.*rand(1,100)+j.*pi.*rand.*(sin(.1:.1:10)+.1.*rand(1,100))),1:100,(-1)^rand.*0.3.*exp(rand.*sin(rand.*(.1:.1:10))+.1.*rand(1,100)+j.*pi.*rand.*(sin(.1:.1:10)+.1.*rand(1,100))));

  %---------------------------------------------------------------------
  elseif strcmp(arg1,'about')
    global pguifig;
    pguifig=figure;
    clf;
    set(pguifig,'NumberTitle','off','Name','About PowerGraf',...
         'color', [0.752941 0.752941 0.752941], 'Resize', 'off','MenuBar','none',...
         'Position', [250 200 350 100]);
    set(gca, 'Units','normalized','pos', [0 0 1 1]);
    load pplot.mat;
    image(pgim);
    colormap(pgmap);
    axis image;
    axis off;
    uicontrol('string','Close', 'Position', [285 5 60 20],...
              'callback','global pguifig;close(pguifig);clear pguifig;')
    redax=axes('units','pixels','pos',[158 60 190 2]);
    axis([0 190 0 2]);
    axis('off');
    pplot('pause',1);
    pgl=line('color','y','xdata',[190],'ydata',[1],'LineWidth',1,'LineStyle','-','EraseMode','none');
    for i=190:-1:1
      set(pgl,'xdata',[get(pgl,'xdata') i],'ydata',[get(pgl,'ydata') 1])
      drawnow
    end
    for x=1:3
      pgl=line('color','y','xdata',[0],'ydata',[1],'LineWidth',1,'LineStyle','-','EraseMode','none');
      for i=1:2:190
        set(pgl,'xdata',[get(pgl,'xdata') i],'ydata',[get(pgl,'ydata') 1])
        drawnow
      end
      pgl=line('color','red','xdata',[0],'ydata',[1],'LineWidth',1,'LineStyle','-','EraseMode','none');
      for i=1:3:190
        set(pgl,'xdata',[get(pgl,'xdata') i],'ydata',[get(pgl,'ydata') 1])
        drawnow
      end
      pgl2=line('color','blue','xdata',[190],'ydata',[1],'LineWidth',1,'LineStyle','-','EraseMode','none');
      for i=189:-3:0
        set(pgl2,'xdata',[i get(pgl2,'xdata')],'ydata',[get(pgl2,'ydata') 1])
        drawnow
      end
    end
    pgl=line('color','y','xdata',[0],'ydata',[1],'LineWidth',1,'LineStyle','-','EraseMode','none');
    for i=1:190
      set(pgl,'xdata',[get(pgl,'xdata') i],'ydata',[get(pgl,'ydata') 1])
      drawnow
    end
    if mat5
      boom=line('color',[0.3 0.3 0.1],'marker','o','erase','xor','xdata',[190],'ydata',[1],'markersize',2);
    else
      boom=line('color',[0.3 0.3 0.1],'linestyle','o','erase','xor','xdata',[190],'ydata',[1],'LineWidth',2);
    end
    for i=2:20:320
      if mat5
        set(boom,'markersize',i)
      else
        set(boom,'linewidth',i)
      end
      pplot('pause',0.05);
      drawnow
    end

  %---------------------------------------------------------------------
  else
    if isempty(findstr(get(gcf,'name'),'PowerGraf Plot'))
      pplot;
    end
    axes(pplot('buffer','get','axes'));
    if strcmp(get(gca,'nextplot'),'replace') & ~isempty(findobj(gcf,'type','line'))
      pplot('clear','axes');
    end
    for i=1:nargin,
      eval(['if size(arg' num2str(i) ',2)==1,arg' num2str(i) '=rot90(arg' num2str(i) ');end']);
    end
    args='arg1';
    for i=2:nargin,
      args=[args ',arg' num2str(i)];
    end
    if nargin==1
      global defaultx
      if size(defaultx,2)==size(arg1,2)
        eval(['pgplt=plot(defaultx,arg1);']);
        set(pgplt,'userdata',[[defaultx];[arg1]]);
        disp('Vector plotted against default X-parameter (defaultx)');
      else
        eval(['pgplt=plot(arg1);']);
        set(pgplt,'userdata',[[(1:size(arg1,2))];[arg1]]);
        if size(defaultx,2)
          disp('Vector could not be plotted against default X-parameter (defaultx)');
          disp('Either clear the default X-parameter or correct the vector');
        end
      end
    elseif nargin==2
      eval(['pgplt=plot(' args ');']);
      for row=1:length(pgplt)
        set(pgplt(row),'userdata',[[arg1(min(row,size(arg1,1)),:)];[arg2(row,:)]]);
      end
    else
      eval(['pgplt=plot(' args ');']); 
      row=1;
      step=2+(isstr(arg3)&size(pgplt,1)==(nargin)/3);
      for i=1:step:nargin
        for k=1:eval(['size(arg' num2str(i+1) ',1)'])
          eval(['set(pgplt(' num2str(row) '),''userdata'',[[arg' num2str(i) '(min(' num2str(k) ',size(arg' num2str(i) ',1)),:)];[arg' num2str(i+1) '(' num2str(k) ',:)]]);']);
          row=row+1;
        end
      end
    end    
    if size(pgplt,1)==1
      if pplot('buffer','get','line')
        lnum=size(findobj(gcf,'type','line'),1);
        cols=get(gca,'ColorOrder');
        set(pgplt,'color',cols(rem(lnum-1,6)+1,:));
      end
    else
      pgplt=flipud(pgplt);
    end
    xmin=min(get(pgplt(1),'xdata'));
    xmax=max(get(pgplt(1),'xdata'));
    for i=size(pgplt,1):-1:1
      pplot('buffer','select','line',pgplt(i),'fast');
      set(pgplt(i),'buttondownfcn','pplot(''select'',''line'',gco);');
      pplot('undo',['delete(' sprintf('%18.13f',pgplt(i)) ')'],'Plot');
      if ~isreal(get(pgplt(i),'userdata'))
        disp('UNWARNING: Complex parts of X and/or Y arguments saved.');
        pplot('info','Complex parts of X and/or Y arguments saved');
      end
      xmin=min(xmin,min(get(pgplt(i),'xdata')));
      xmax=max(xmax,max(get(pgplt(i),'xdata')));
    end
    zoom off;
    drawnow;
    set(gca,'xlim',[xmin xmax],'buttondownfcn','pplot(''select'',''axes'',gco)');
    if nargout==1
      ret1=pgplt;
    end
  end
end

if mat5, warning('on'); end

