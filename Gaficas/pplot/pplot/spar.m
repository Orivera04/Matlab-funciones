function [f,Val]=spar(ainstr,afile1,afile2,avect,acalc,RN,hld)
% SPAR        A general purpose s-parameter plugin for PPLOT
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
    global spared1 spared2 spared3 sparsuifig sparsfig sparpop1 sparpop2 sparpop3 spartxt1 spartxt2 sparchk1 sparchk2 sparchk3 sparstrs1 sparstrs2 sparlogs sparf sparV sparlogs
    %                1                 2                 3                 4                 5                 6                 7                 8                 9                10                11                12                13                14                15                16                17                18                19                20                21                22
    sparstr=  ['Raw data only  ';'               ';'Impedance Zr   ';'Impedance Zt   ';'SWR            ';'               ';'Impedance Z0   ';'Gamma g        ';'Impedance Zs   ';'Impedance Yp   ';'               ';'Resistance R   ';'Inductance L   ';'Capacitance C  ';'Conductance G  ';'               ';'Insertion loss ';'Return loss    ';'               ';'NEXT           ';'FEXT           ';'EL-FEXT        '];
    sparstrs1=['s-par'          ;'     '          ;'s11  '          ;'s21  '          ;'s11  '          ;'     '          ;'s11oc'          ;'s11oc'          ;'s11oc'          ;'s11oc'          ;'     '          ;'s11oc'          ;'s11oc'          ;'s11oc'          ;'s11oc'          ;'     '          ;'s21  '          ;'s11  '          ;'     '          ;'s31  '          ;'s41  '          ;'s41  '          ];
    sparstrs2=['     '          ;'     '          ;'     '          ;'     '          ;'     '          ;'     '          ;'s11sc'          ;'s11sc'          ;'s11sc'          ;'s11sc'          ;'     '          ;'s11sc'          ;'s11sc'          ;'s11sc'          ;'s11sc'          ;'     '          ;'     '          ;'     '          ;'     '          ;'     '          ;'     '          ;'s21  '          ];
    sparlogs= [1                ;1                ;0                ;0                ;1                ;1                ;0                ;1                ;0                ;0                ;1                ;0                ;0                ;0                ;0                ;1                ;1                ;1                ;1                ;1                ;1                ;1                ];
    sparsfig=gcf;
    sparsuifig=figure;
    clf;
    set(sparsuifig,'NumberTitle','off','Name','S-parameter Tool',...
                'color', [1 1 1], 'Resize', 'off','MenuBar','none',...
                'Position', [130 150 340 250]);
    set(gca,'units','normal','pos',[0 0 1 1]);
    sparfill=fill([0 340 340 0 0],[30 30 90 90 30],[0.99 0.99 0.94],[0 340 340 0 0],[210 210 250 250 210],[0.99 0.99 0.94],[0 340 340 0 0],[0 0 30 30 0],[0.9 0.9 0.83]);
    set(sparfill,'edgecolor',[1 1 1]);
    axis([0 340 0 250]);
    axis('off');
    text(0,0,'File format (Instrument):','FontSize',10,'color',[0.4 0.3 0],'units','pixels','pos',[5 230]);
    sparpop1=uicontrol('style','popupmenu','string',['HP8751A ASCII       ';'HP VEE (HP8753A)    '], ...
              'units','pixels','pos',[195 220 140 20], 'BackgroundColor', [1 1 0.9],'value',1);
    text(0,0,'Enter filename:','FontSize',10,'color','red','units','pixels','pos',[5 190]);
    spartxt1=text(0,0,'s-par','FontSize',10,'color','blue','units','pixels','pos',[5 170]);
    uicontrol('string','Browse...', 'Position', [275 160 60 20],...
              'CallBack','global spared1;[sparname,sparpath]=uigetfile(''*.*'',''Load Saved File'');if sparname,eval([''cd '' sparpath '';'']);set(spared1,''string'',deblank(lower(sparname)));clear sparname sparpath;end');
    spared1=uicontrol('style','edit','units','pixels',...
                   'pos',[45 160 225 20],'backgroundcolor', [0.9 0.9 0.83]);
    text(0,0,'Enter optional filename:','FontSize',10,'color','red','units','pixels','pos',[5 140]);
    spartxt2=text(0,0,'     ','FontSize',10,'color','blue','units','pixels','pos',[5 120]);
    uicontrol('string','Browse...', 'Position', [275 110 60 20],...
              'CallBack','global spared2;[sparname,sparpath]=uigetfile(''*.*'',''Load Saved File'');if sparname,eval([''cd '' sparpath '';'']);set(spared2,''string'',deblank(lower(sparname)));clear sparname sparpath;end');
    spared2=uicontrol('style','edit','units','pixels',...
                   'pos',[45 110 225 20],'backgroundcolor', [0.9 0.9 0.83]);
    text(0,0,'Data to use:','FontSize',10,'color',[0.4 0.3 0],'units','pixels','pos',[5 70]);
    sparpop2=uicontrol('style','popupmenu','string',['Raw[S11]    ';'Raw[S21]    ';'Raw[S12]    ';'Raw[S22]    ';'Data        ';'Memory      ';'Unform      ';'Trace       ';'Trace Memory'], ...
              'units','pixels','pos',[90 60 120 20], 'BackgroundColor', [1 1 0.9],'value',5);
    sparchk3=uicontrol('style','check','string','Hold','pos',[215 60 50 20],'foregroundcolor',[0.4 0.3 0],'backgroundcolor',[0.99 0.99 0.94]);
    text(0,0,'Calculate:','FontSize',10,'color',[0.4 0.3 0],'units','pixels','pos',[5 45]);
    sparpop3=uicontrol('style','popupmenu','string',sparstr, ...
              'units','pixels','pos',[90 35 120 20], 'BackgroundColor', [1 1 0.9],'value',1,'callback',...
              'global spartxt1 spartxt2 sparstrs1 sparstrs2 sparlogs sparpop3 sparchk1 sparlogs;i=get(sparpop3,''value'');set(spartxt1,''string'',sparstrs1(i,:));set(spartxt2,''string'',sparstrs2(i,:));if ~sparlogs(i),set(sparchk1,''value'',0);end');
    sparchk1=uicontrol('style','check','string','LOG MAG','pos',[5 5 80 20],'foregroundcolor',[0.4 0.3 0],'backgroundcolor',[0.9 0.9 0.83]);
    sparchk2=uicontrol('style','check','string','LOG FREQ','pos',[90 5 80 20],'foregroundcolor',[0.4 0.3 0],'backgroundcolor',[0.9 0.9 0.83]);
    text(0,0,'REF IMP:','color',[0.4 0.3 0],'FontSize',10,'FontWeight','bold','units','pixels','pos',[215 15]);
    spared3=uicontrol('style','edit','string','135','units','pixels',...
                   'pos',[275 5 60 20],'backgroundcolor', [0.99 0.99 0.94]);
    uicontrol('string','Plot', 'Position', [275 60 60 20],...
              'callback','global sparf sparV spared1 spared2 spared3 sparsuifig sparsfig sparpop1 sparpop2 sparpop3 spartxt1 spartxt2 sparchk1 sparchk2 sparchk3 sparstrs1 sparstrs2 sparlogs;eval([''[sparf,sparV]=spar('' num2str(get(sparpop1,''value'')) '','''''' get(spared1,''string'') '''''','''''' get(spared2,''string'') '''''','''''' deblank(pplot(''element'',get(sparpop2,''value''),get(sparpop2,''string''))) '' Real'''','' num2str(get(sparpop3,''value'')) '','' get(spared3,''string'') '','' num2str(get(sparchk3,''value'')) '');'']);figure(sparsfig);pplot(sparf,sparV);if get(sparchk1,''value''), pplot(''data'',''current'',''data'',''display'',''20.*log10(Y)'');end;if get(sparchk2,''value''), pplot(''format'',''axis'',''xaxis'',''scale'',''log'');else pplot(''format'',''axis'',''xaxis'',''scale'',''linear'');end');
    uicontrol('string','Close', 'Position', [275 35 60 20],...
              'callback','global sparlogs sparf sparV spared1 spared2 spared3 sparsuifig sparsfig sparpop1 sparpop2 sparpop3 spartxt1 spartxt2 sparchk1 sparchk2 sparchk3 sparstrs1 sparstrs2 sparlogs;close(sparsuifig);clear spared1 spared2 spared3 sparsuifig sparsfig sparpop1 sparpop2 sparpop3 spartxt1 spartxt2 sparchk1 sparchk2 sparchk3 sparstrs1 sparstrs2 sparlogs sparf sparV sparlogs');
else
  global fg V1g V2g
  if ~hld
    if ainstr==1
      [f,V1]=spar(afile1,avect);   
      if afile2
        [f,V2]=spar(afile2,avect);   
      end
    elseif ainstr==2
      V1=sload(afile1);
      if afile2
        V2=sload(afile2);
      end
      global defaultx
      if size(defaultx,2)>0
        f=defaultx;
      else
        f=1:size(V1,1);
      end
    end
    fg=f;
    V1g=V1;
    V2g=V2;
  else
    f=fg;
    V1=V1g;
    V2=V2g;
  end

  if acalc==1      % Raw data only  
    V=V1;
  elseif acalc==2  %                 
    V=V1;
  elseif acalc==3  % Impedance Zr
    V=RN.*(1+V1)./(1-V1);
  elseif acalc==4  % Impedance Zt   
    V=2.*(1-V1)./V1;
  elseif acalc==5  % SWR            
    V=(1+V1)./(1-V1);
  elseif acalc==6  %                
    V=V1;
  elseif acalc==7  % Impedance Z0   
    V1=RN.*(1+V1)./(1-V1);
    V2=RN.*(1+V2)./(1-V2);
    V=sqrt(V2.*V1);
  elseif acalc==8  % Gamma g        
    V1=RN.*(1+V1)./(1-V1);
    V2=RN.*(1+V2)./(1-V2);
    V=atanh(sqrt(V2./V1));
  elseif acalc==9  % Impedance Zs   
    V1=RN.*(1+V1)./(1-V1);
    V2=RN.*(1+V2)./(1-V2);
    Vz=sqrt(V2.*V1);
    Vg=atanh(sqrt(V2./V1));
    V=Vg.*Vz;
  elseif acalc==10 % Impedance Yp   
    V1=RN.*(1+V1)./(1-V1);
    V2=RN.*(1+V2)./(1-V2);
    Vz=sqrt(V2.*V1);
    Vg=atanh(sqrt(V2./V1));
    V=Vg./Vz;
  elseif acalc==11 %                
    V=V1;
  elseif acalc==12 % Resistance R   
    V1=RN.*(1+V1)./(1-V1);
    V2=RN.*(1+V2)./(1-V2);
    Vz=sqrt(V2.*V1);
    Vg=atanh(sqrt(V2./V1));
    Vzs=Vg.*Vz;
    V=real(Vzs);
  elseif acalc==13 % Inductance L   
    V1=RN.*(1+V1)./(1-V1);
    V2=RN.*(1+V2)./(1-V2);
    Vz=sqrt(V2.*V1);
    Vg=atanh(sqrt(V2./V1));
    Vzs=Vg.*Vz;
    V=imag(Vzs./(2.*pi.*f));
  elseif acalc==14 % Capacitance C  
    V1=RN.*(1+V1)./(1-V1);
    V2=RN.*(1+V2)./(1-V2);
    Vz=sqrt(V2.*V1);
    Vg=atanh(sqrt(V2./V1));
    Vyp=Vg./Vz;
    V=imag(Vyp./(2.*pi.*f));
  elseif acalc==15 % Conductance G  
    V1=RN.*(1+V1)./(1-V1);
    V2=RN.*(1+V2)./(1-V2);
    Vz=sqrt(V2.*V1);
    Vg=atanh(sqrt(V2./V1));
    Vyp=Vg./Vz;
    V=real(Vyp);
  elseif acalc==16 %                
    V=V1;
  elseif acalc==17 % Insertion loss 
    V=1./V1;
  elseif acalc==18 % Return loss    
    V=1./V1;
  elseif acalc==19 %                
    V=V1;
  elseif acalc==20 % NEXT           
    V=V1;
  elseif acalc==21 % FEXT           
    V=V1;
  elseif acalc==22 % EL-FEXT        
    V=V1./V2;
  end 
  Val=V;
end

