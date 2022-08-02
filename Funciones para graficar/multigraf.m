function multigraf(arg)
  
% MULTIGRAF enables putting up to six MATLAB figures into a single
%           figure.  To use it, simply enter MULTIGRAF at the MATLAB
%           prompt.  This will open a figure with six available slots.
%           Simply make a choice for each slot.  When you are satisfied,
%           click the Finish button.
%     
%           There are special buttons for DFIELD and PPLANE figures,
%           since these need special handling.

  if nargin == 0
    arg = 'initialize';
    ngraphs = 6;
  end
  
  switch arg
   case 'initialize'
    fsize = [560 705];
    left = [45,305,45,305,45,305];
    bot = [50,50,275,275,500,500];
    paperpos = [0.25,0.25,fsize/70];
    
    ud.left = left;
    ud.bot = bot;
    mgh = findobj('tag','MF');
    if ~isempty(mgh),delete(mgh);end
    newfig = figure('pos',[40,40,fsize],...
		    'paperposition',paperpos,...
		    'vis','off','tag','MF');
    dbutt(1) = uicontrol('style','push',...
			 'string',' Insert the current DFIELD Display here ');
    ext = get(dbutt(1),'extent');
    texth = 24;
    bw = ext(3);
    for jj = 2:ngraphs
      dbutt(jj) = uicontrol('style','push',...
			    'string',' Insert the current DFIELD Display here ');
      call = 'multigraf(''dinsert'')';
    end
    for j=1:ngraphs
      set(dbutt(j),'pos',[left(j),bot(j),bw,texth],...
		   'user',j,'call',call);
    end
    
    call = 'multigraf(''pinsert'')';
    for jj = 1:ngraphs
      pbutt(jj) = uicontrol('style','push',...
			    'string',' Insert a PPLANE graph here ',...
			    'pos',[left(jj),bot(jj)+texth,bw,texth],...
			    'user',jj,'call',call);
    end
    
    call = 'multigraf(''ginsert'')';
    for jj = 1:ngraphs
      gbutt(jj) = uicontrol('style','push',...
			    'string',' Insert a MATLAB graph here ',...
			    'pos',[left(jj),bot(jj)+2*texth,bw,texth],...
			    'user',jj,'call',call);
    end
    
    call = 'multigraf(''delete'')';
    for jj = 1:ngraphs
      delbutt(jj) = uicontrol('style','push',...
			      'string',' Delete ');
    end
    ext = get(delbutt(1),'extent');
    bwd = ext(3);
    call = 'multigraf(''delete'')';
    shift = 30;
    for j=1:ngraphs
      set(delbutt(j),'pos',[left(j)-shift,bot(j),bwd,texth],...
		     'user',j,'call',call);
    end
    
    call = 'multigraf(''finish'')';
    ud.finish = uicontrol('style','push',...
			  'string',' Finish ',...
			  'pos',[left(2),10,bw,texth],...
			  'call',call);
    
    call = 'multigraf(''refresh'')';
    ud.refresh = uicontrol('style','push',...
			   'string',' Start over ',...
			   'pos',[left(1),10,bw,texth],...
			   'call',call);
    set([newfig,dbutt,pbutt,gbutt,ud.finish,ud.refresh],'vis','on');
    set(delbutt,'vis','off')
    ud.dbutt = dbutt;
    ud.pbutt = pbutt;
    ud.gbutt = gbutt;
    ud.delbutt = delbutt;
    ud.axes = cell(1,ngraphs);
    set(newfig,'user',ud);
    
   case 'dinsert'
    hhsetup = get(0,'ShowHiddenHandles');
    set(0,'showhiddenhandles','on');
    figh5 = findobj('name','DFIELD5 Display');
    figh6 = findobj('name','DFIELD6 Display');
    figh = [figh5;figh6]
    if isempty(figh)
      mess = 'There is no DFIELD Display figure.';
      title = 'No figures';
      msgbox(mess,title,'help');
      return
    end
    oldax = findobj(figh,'type','axes');
    newfig = gcf;
    ud = get(newfig,'user');
    newax = copyobj(oldax,newfig);
    ht = 165; width = 210;
    left = ud.left;
    bot = ud.bot;
    jj = get(gcbo,'user');
    oldunits = get(newax,'units');
    set(newax,'units','pix');
    set(newax,'pos',[left(jj),bot(jj),210,165]);
    set(newax,'units',oldunits);
    set([ud.dbutt(jj),ud.pbutt(jj),ud.gbutt(jj)],'vis','off');
    set(ud.delbutt(jj),'vis','on');
    ud.axes{jj} = newax;
    set(newfig,'user',ud);
    set(0,'showhiddenhandles',hhsetup);
    th(1) = get(newax,'title');
    th(2) = get(newax,'xlabel');
    th(3) = get(newax,'ylabel');
    fs = 7;
    set(th,'fontsize',fs);
    set(newax,'fontsize',fs);
    
   case 'ginsert'
    mgfig = gcf;
    hhsetup = get(0,'ShowHiddenHandles');
    set(0,'showhiddenhandles','on');
    fh = get(0,'children');
    fh(find(fh == mgfig)) = [];
    nf =0;
    nfh = zeros(0,1);
    for k = 1:length(fh)
      tag = get(fh(k),'tag');
      if ~strcmp(tag,'DFIELD5') & ~strcmp(tag,'DFIELD6') & ~strcmp(tag,'PPLANE5')& ~strcmp(tag,'PPLANE6')
	axhh = findobj(fh(k),'type','axes');
	if ~isempty(axhh)
	  nf = nf + 1;
	  name = get(fh(k),'name');
	  if strcmp(name,''),
	    name = ['Figure No. ',int2str(fh(k))];
	  end,
	  winstr{nf} = name;
	  nfh = [nfh;fh(k)];
	end
      end
    end
    if nf == 0
      mess = 'There are no suitable figures.';
      title = 'No figures';
      msgbox(mess,title,'help');
      return
    elseif nf == 1
      sel = 1;
    else
      [sel,ok] = listdlg('liststring',winstr,...
			 'selectionmode','single',...
			 'listsize',[270,100],...
			 'name','Figure selection',...
			 'promptstring','Select a figure:',...
			 'OKString','Select');
      if ~ok, return,end
    end
    figh = nfh(sel);
    oldax = findobj(figh,'type','axes');
    newfig = gcf;
    ud = get(newfig,'user');
    newax = copyobj(oldax,newfig);
    LLL = length(newax);
    ht = 165; width = 210;
    left = ud.left;
    bot = ud.bot;
    jj = get(gcbo,'user');
    oldunits = get(newax,'units');
    set(newax,'units','pix');
    set(newax,'pos',[left(jj),bot(jj),210,165]);
    if LLL == 1
      set(newax,'units',oldunits);
    else
      for k = 1:LLL
	set(newax(k),'units',oldunits{k});
      end
    end
    set([ud.dbutt(jj),ud.pbutt(jj),ud.gbutt(jj)],'vis','off');
    set(ud.delbutt(jj),'vis','on');
    ud.axes{jj} = newax;
    set(newfig,'user',ud);
    set(0,'showhiddenhandles',hhsetup);
    th = findobj(newax,'type','text');
    fs = 7;
    set(th,'fontsize',fs);
    set(newax,'fontsize',fs);
    
   case 'pinsert'
    mgfig = gcf;
    hhsetup = get(0,'ShowHiddenHandles');
    set(0,'showhiddenhandles','on');
    fh = get(0,'children');
    fh(find(fh == mgfig)) = [];
    nf =0;
    nfh = zeros(0,1);
    for k = 1:length(fh)
      tag = get(fh(k),'tag');
      if strcmp(tag,'PPLANE5') | strcmp(tag,'PPLANE6') 
	axhh = findobj(fh(k),'type','axes');
	if ~isempty(axhh)
	  nf = nf + 1;
	  name = get(fh(k),'name');
	  if strcmp(name,''),
	    name = ['Figure No. ',int2str(fh(k))];
	  end,
	  winstr{nf} = name;
	  nfh = [nfh;fh(k)];
	end
      end
    end
    if nf == 0
      mess = 'There are no suitable figures.';
      title = 'No figures';
      msgbox(mess,title,'help');
      return
    elseif nf == 1
      sel = 1;
    else
      [sel,ok] = listdlg('liststring',winstr,...
			 'selectionmode','single',...
			 'listsize',[270,100],...
			 'name','Figure selection',...
			 'promptstring','Select a figure:',...
			 'OKString','Select');
      if ~ok, return,end
    end
    figh = nfh(sel);
    name = get(figh,'name');
    if findstr('t-plot',name)
      ooldax = findobj(figh,'type','axes');
      raxh = findobj(ooldax,'tag','rotaObj'); % Is rotate3d on?
      ooldax = setdiff(ooldax,raxh);
      L = length(ooldax);
      oldax = [0;0];
      for k = 1:L
	th = findobj(ooldax(k),'type','text','vis','on');
	if ~isempty(th)
	  ist = strcmp(get(th,'string'),'t');
	  if sum(ist)
	    oldax(1) = ooldax(k);
	  else
	    oldax(2) = ooldax(k);
	  end
	end
      end
    else
      oud = get(figh,'user');  % Works for Display, not for t-plot.
      oldax = [oud.axes;oud.title.axes];
    end

    newfig = gcf;
    ud = get(newfig,'user');
    left = ud.left;
    bot = ud.bot;
    newax = copyobj(oldax,newfig);
    ht = 165; width = 210;
    jj = get(gcbo,'user');
    set(newax,'units','pix');

    campos = get(oldax(1),'cameraposition');
    camup = get(oldax(1),'cameraupvector');
    set(newax(1),'cameraposition',campos);
    camposmode = get(oldax(1),'camerapositionmode');
    camtarget = get(oldax(1),'cameratarget');
    camtargmode = get(oldax(1),'cameratargetmode');
    camupvectormode = get(oldax(1),'cameraupvectormode');
    set(newax(1),'camerapositionmode',camposmode,...
		 'cameraposition',campos,...
		 'cameratarget',camtarget,...
		 'cameratargetmode',camtargmode,...
		 'cameraupvectormode',camupvectormode,...
		 'cameraupvector',camup);    
    
    
    set(newax(1),'pos',[left(jj),bot(jj),210,165]);
    set(newax(2),'pos',[left(jj),bot(jj)+165,210,30]);
    set(newax,'units','normal');
    set([ud.dbutt(jj),ud.pbutt(jj),ud.gbutt(jj)],'vis','off');
    set(ud.delbutt(jj),'vis','on');
    ud.axes{jj} = newax;
    set(newfig,'user',ud);
    set(0,'showhiddenhandles',hhsetup);
    th = findobj(newax,'type','text');
    fs = 7;
    set(th,'fontsize',fs);
    set(newax,'fontsize',fs);
    tith = findobj(newax(2),'type','text','vis','on');
    titl = length(tith);
    pos = zeros(titl,3);
    for k = 1:length(tith)
      pos(k,:)=get(tith(k),'pos');
    end
    [y,kk] = sort(pos(:,1));
    tith = tith(kk);
    ext = get(tith(3),'extent');
    p3 = 1-ext(3);
    set(tith(3),'pos',[p3,0.5]);
    ext = get(tith(2),'extent');
    p2 = p3 -ext(3) - 0.01;
    set(tith(2),'pos',[p2,0.5]);
    set(tith(1),'pos',[0,0.5]);
    

    
   case 'delete' 
    ud = get(gcf,'user');
    jj = get(gcbo,'user');
    delete(ud.axes{jj});
    ud.axes{jj} = [];
    set(gcf,'user',ud);
    set([ud.dbutt(jj),ud.pbutt(jj),ud.gbutt(jj)],'vis','on');
    set(ud.delbutt(jj),'vis','off');
    
   case 'finish'
    ud = get(gcf,'user');
    delete([ud.dbutt,ud.pbutt,ud.gbutt,ud.delbutt,ud.refresh]);
    delete(ud.finish);
    
   case 'refresh'
    ud = get(gcf,'user');
    axes = ud.axes;
    ngraphs = length(axes);
    axh = [];
    for jj = 1:ngraphs
      axh = [axh;ud.axes{jj}];
    end
    if ~isempty(axh),delete(axh);end
    set([ud.dbutt,ud.pbutt,ud.gbutt],'vis','on');
    set(ud.delbutt,'vis','off')
    ud.axes = cell(1,ngraphs);
    set(gcf,'user',ud);
    
   otherwise
    mess = 'MULTIGRAF does not need any input parameters.';
    title = 'Incorect input';
    msgbox(mess,title,'help');
    return
    
    
  end
  
