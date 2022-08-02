function derivtool(callaction,tabid)
%DERIVTOOL Derivatives Toolbox Demonstration.

%   Copyright 1998-2003 The MathWorks, Inc.
%   $Revision: 1.40.2.3 $   $Date: 2004/04/06 01:08:27 $

set(findobj('Type','figure'),'Pointer','watch') %Set figure pointer busy

%Define Colors for tree viewer actions (used by more than one switch case)
ColorOne = [1 .15 0];    %Path One
ColorTwo = [.6 0 .6];    %Path Two
ColorThree = [1 0 0];    %Node and Children

%Get portfolio object that contains portfolio information (used in many switch cases)
portobj = findobj('Tag','portfolio');

if nargin == 0
  callaction = 'dialog';    %Default calling option is 'dialog' to open window
end

fnt = get(0,'Fixedwidthfont');  %Font to use for all listboxes

switch callaction
  
  case {'addinstrument','addunderlyinginstrument'}   %Add instruments to portfolio
    
    %Get current Tree and Portfolio
    HJMTree = getappdata(gcf,'HJMTREE');
    Port = get(portobj,'Userdata');
    
    %Determine if adding or editing an instrument, non-zero is index
    aobj = findobj(gcf,'String','Add');
    addflag = get(aobj,'Userdata');
    
    %Intrument type
    if strcmp(callaction,'addinstrument')
      iobj = findobj(gcf,'Tag','instruments');
      ival = get(iobj,'Value');
      istr = get(iobj,'String');
      inst = istr{ival};
    elseif strcmp(callaction,'addunderlyinginstrument')
      inst = 'Bond';   %Instrument type is hardcoded to Bond for now.
    end
        
    %Get id/cusip number, for all instruments
    if strcmp(callaction,'addunderlyinginstrument') %Don't overwrite underlying name with Option name
      try
        idcusip = instget(Port,'FieldName',{'Name'},'Index',addflag);            
      catch
        idcusip = ' ';
      end
    else
      idcusip = get(findobj(gcf,'Tag','idcusip'),'String'); %Default name is instrument type
      if isempty(idcusip)
        idcusip = inst;
      end
    end
    
    %Number of contracts, all instruments
    contracts = get(findobj(gcf,'Tag','contracts'),'String');

    %Basis, all instruments
    try
      bobj = findobj(gcf,'Tag','basis');
      bval = get(bobj,'Value');
      bstr = get(bobj,'String');
      bas = bstr{bval};
    catch
      %Option choice will fail
    end
      
    %Get dates, getting all possible date types for code simplicity
    settlement = get(findobj(gcf,'Tag','settlement'),'String');
    start = get(findobj(gcf,'Tag','start'),'String');    
    maturity = get(findobj(gcf,'Tag','maturity'),'String');
    issue = get(findobj(gcf,'Tag','issue'),'String');
    firstcoupon = get(findobj(gcf,'Tag','firstcoupon'),'String');
    lastcoupon = get(findobj(gcf,'Tag','lastcoupon'),'String');
    expiry = get(findobj(gcf,'Tag','expiration'),'String');
    
    %Trap bad date inputs
    try
      tmpdat = {settlement;start;maturity;issue;firstcoupon;lastcoupon;expiry};
      for i = 1:length(tmpdat)
        datestr(tmpdat{i});
      end
    catch
      errordlg('Date input error.')
      set(findobj('Type','figure'),'Pointer','arrow')
      return
    end
      
    %Period/Reset, for all instruments
    try
      pobj = findobj(gcf,'Tag','period');
      pval = get(pobj,'Value');
      pstr = get(pobj,'String');
      per = str2double(pstr{pval});
    catch
      %Option choice will fail
    end
    
    %Fields for all instruments
    coup = get(findobj(gcf,'Tag','coupon'),'String'); %Coupon
    parvalue = get(findobj(gcf,'Tag','parvalue'),'String'); %par value
    strike = get(findobj(gcf,'Tag','strike'),'String');  %strike    
    prin = get(findobj(gcf,'Tag','principal'),'String'); %principal    
    spread = get(findobj(gcf,'Tag','spread'),'String'); %spread
   
    switch inst   %Instrument specific fields
      
      case 'Bond'
        
        if addflag   %editing instrument
          Port = instsetfield(Port,'Index',addflag,'FieldName',...
            {'CouponRate','Settle','Maturity','Period','Basis','IssueDate',...
              'FirstCouponDate','LastCouponDate','Face','Name','Quantity'},...
            'Data',{coup settlement maturity per bas issue firstcoupon ...
              lastcoupon parvalue idcusip contracts});
        else
          Port = instadd(Port,inst,coup,settlement,maturity,per,bas,[],...
            issue,firstcoupon,lastcoupon,[],parvalue);
          Port = instsetfield(Port,'Index',instlength(Port),...
            'FieldName',{'Name','Quantity'},'Data',{idcusip contracts});
        end
                 
      case {'Cap','Floor'}
        
        if strcmp(inst,'Cap')
          resetname = 'CapReset';
        else
          resetname = 'FloorReset';
        end
        
        if addflag  %editing instrument
          Port = instsetfield(Port,'Index',addflag,'FieldName',...
            {'Strike','Settle','Maturity',resetname,'Basis','Principal',...
              'Name','Quantity'},...
            'Data',{strike start maturity per bas prin idcusip contracts});
        else
          Port = instadd(Port,inst,strike,start,maturity,per,bas,prin);
          Port = instsetfield(Port,'Index',instlength(Port),...
            'FieldName',{'Name','Quantity'},'Data',{idcusip contracts});
        end
        
      case 'Fixed Rate Note'
        
        if addflag  %editing instrument
          Port = instsetfield(Port,'Index',addflag,'FieldName',...
            {'CouponRate','Settle','Maturity','FixedReset','Basis','Principal',...
             'Name','Quantity'},...
            'Data',{coup start maturity per bas prin idcusip contracts});
        else
          Port = instadd(Port,'Fixed',coup,start,maturity,per,bas,prin);
          Port = instsetfield(Port,'Index',instlength(Port),...
            'FieldName',{'Name','Quantity'},'Data',{idcusip contracts});
        end
        
      case 'Floating Rate Note'
        
        if addflag  %editing instrument
          Port = instsetfield(Port,'Index',addflag,'FieldName',...
            {'Spread','Settle','Maturity','FloatReset','Basis','Principal',...
             'Name','Quantity'},...
            'Data',{coup start maturity per bas prin idcusip contracts});
        else
          Port = instadd(Port,'Float',spread,start,maturity,per,bas,prin);
          Port = instsetfield(Port,'Index',instlength(Port),...
            'FieldName',{'Name','Quantity'},'Data',{idcusip contracts});
        end
        
      case 'Option'
        
        %Number of option contracts
        nocontracts = get(findobj(gcf,'Tag','nocontracts'),'String');
        
        %Get information about underlying choice
        uobj = findobj(gcf,'Tag','underlying');
        uval = get(uobj,'Value');
        ustr = get(uobj,'String');
        ulen = length(ustr)-1;
        
        %Option type
        if isempty(findobj(gcf,'String','Call','Value',1))
            optspec = 'put';
          else
            optspec = 'call';
        end
        
        %Option flavor
        if isempty(findobj(gcf,'String','European','Value',1))
            opttype = 1;
        else
            opttype = 0;
        end
        
        %There are four possible combinations of editing/adding options
        %   1. New option, new underlying
        %   2. New option, existing underlying
        %   3. Existing option, existing underlying
        %   4. Existing option, new underlying
        
        if addflag   %editing instrument
          
          datc = instgetcell(Port,'Index',addflag);
          
          if uval <= ulen           %Case 3
            underind = datc{1};     %Underlying exists
            set(aobj,'Userdata',underind)    %Reset add flag to underlying inst index  
          else   %Case 4
            underind = instlength(Port)+1;   %New underlying
            set(aobj,'Userdata',0)      %Add new instrument  
          end
          
          %Add underlying instrument to portfolio
          derivtool('addunderlyinginstrument')
          
          %Portfolio was updated by previous call to add underlyinginstrument
          Port = get(portobj,'Userdata');   
          
          Port = instsetfield(Port,'Index',addflag,'FieldName',...
            {'UnderInd','OptSpec','Strike','ExerciseDates','AmericanOpt',...
             'Name','Quantity'},...
           'Data',{underind optspec strike expiry opttype idcusip nocontracts});
                   
        else   %adding option instrument
          
          if uval <= ulen       %Case 2
            undindex = uval;    %Underlying exists
            set(aobj,'Userdata',undindex)
          else                  %Case 1
            undindex = instlength(Port)+2;   %New underlying
            set(aobj,'Userdata',0)  
          end  
          Port = instadd(Port,'OptBond',undindex,optspec,strike,expiry,opttype);
          Port = instsetfield(Port,'Index',instlength(Port),...
            'FieldName',{'Name','Quantity'},'Data',{idcusip nocontracts});
          set(portobj,'Userdata',Port)
          derivtool('addunderlyinginstrument')
          Port = get(portobj,'Userdata');
          
        end
        
      case 'Swap'
        
        %Get objects
        startobj = findobj(gcf,'Tag','start');
        matobj = findobj(gcf,'Tag','maturity');
        prinobj = findobj(gcf,'Tag','principal');
        conobj = findobj(gcf,'Tag','contracts');
        basobj = findobj(gcf,'Tag','basis');
        perobj = findobj(gcf,'Tag','period');
        couobj = findobj(gcf,'Tag','coupon');
        typobj = findobj(gcf,'Tag','swaptype');
        
        %Get application data for legs, leg data not currently used but will be
        paystart = getappdata(startobj,'paystart');
        paymat = getappdata(matobj,'paymat');
        payprin = getappdata(prinobj,'payprin');
        paycon = getappdata(conobj,'paycon');
        paybas = getappdata(basobj,'paybas');
        payper = getappdata(perobj,'payper');
        recper = getappdata(perobj,'recper');
        typval = get(typobj,'Value')-1;
        paycoup = getappdata(couobj,'paycou');
        reccoup = getappdata(couobj,'reccou');
        paytype = getappdata(typobj,'paytype');
        rectype = getappdata(typobj,'rectype');
      
        if addflag  %editing instrument
          Port = instsetfield(Port,'Index',addflag,'FieldName',...
            {'LegRate','Settle','Maturity','LegReset','Basis','Principal','LegType'...
             'Name','Quantity'},...
            'Data',{[reccoup paycoup] start maturity [recper payper] bas prin [rectype paytype] idcusip contracts});
        else
          Port = instadd(Port,'Swap',[reccoup paycoup],start,maturity,[recper payper],bas,prin);
          Port = instsetfield(Port,'Index',instlength(Port),...
            'FieldName',{'Name','Quantity'},'Data',{idcusip contracts});
        end
        
    end
    
    %reset index flag, clear uicontrols
    derivtool('clear')
    
    %Store portfolio and update prices
    updateportfolio(Port,HJMTree,0)
    
  case {'addhedge','addusetohedge'}
    
    %Add selected instruments as hedge or use to hedge instruments
    
    %Number of hedged and hedging instruments cannot exceed number of sensitivities
    sobj = findobj(gcf,'Userdata','Sens','Value',1);   %Get sensitivities chosen
    hiobj = findobj(gcf,'Tag','HedgingInstruments');   %All instruments object
    hival = get(hiobj,'Value');                        
    histr = get(hiobj,'String');
        
    %Hedging instruments listbox information
    tmp = []; hdins = {};
    Port = get(hiobj,'Userdata');  %Hedge portfolio stored in hiobj
    
    if ~isempty(hival)             %Remove chosen instrument strings from main list
      
      for i = 1:length(hival) 
        if ~isempty(histr{hival(i)})  
          hdins(i) = histr(hival(i));
        else
          tmp = [tmp;i];
        end
        histr{hival(i)} = [];
      end
      
      hival(tmp) = [];
      set(hiobj,'String',histr,'Value',[])
      
      %Get sensitivities settings
      sensvals = getappdata(findobj('Tag','HJMDLG'),'DeltaGammaVega');
      
      %Remove unrequested sens. from instrument
      for w = 1:i
        j = find(hdins{w} == ' ');
        k = diff(j);
        m = [find(k > 1) length(k)];
        pad = ' ';
        if ~sensvals(1)
          hdins{w}(:,j(m(end-2)):j(m(end-1))) = pad(:,ones(1,length(j(m(end-2)):j(m(end-1)))));
        end  
        if ~sensvals(2)
          hdins{w}(:,j(m(end-1)):j(m(end))) = pad(:,ones(1,length(j(m(end-1)):j(m(end)))));
        end  
        if ~sensvals(3)
          hdins{w}(:,j(end):length(hdins{i})) = pad(:,ones(1,length(j(end):length(hdins{i}))));
        end
      end
      
      if strcmp(callaction,'addhedge')  %Add instrument to Hedge listbox
        
        %Hedged instrument listbox information
        hdobj = findobj(gcf,'Tag','Hedge');
        hdstr = get(hdobj,'String');
        hdval = get(hdobj,'Userdata');
        hdval = [hdval;hival(:)];
        hdstr = [hdstr;hdins];
        set(hdobj,'String',hdstr,'Userdata',hdval)
             
      elseif strcmp(callaction,'addusetohedge')  %Add instrument to Use to Hedge listbox
        
        %Hedging instrument listbox information
        huobj = findobj(gcf,'Tag','UsetoHedge');  
        hustr = get(huobj,'String');
        huval = get(huobj,'Userdata');
        huval = [huval;hival(:)];
        hustr = [hustr;hdins];
        set(huobj,'String',hustr,'Userdata',huval)
        
      end
      
    end
    
    derivtool('hedgetotals')   %Compute hedge portfolios
    
  case 'removehedge'
    
    %Put instruments back in main instrument list
    
    iobj = findobj(gcf,'Tag','HedgingInstruments');
    dobj = findobj(gcf,'Tag','Hedge');
    uobj = findobj(gcf,'Tag','UsetoHedge');
    
    istr = get(iobj,'String');
    
    %Put hedged instruments back in list
    dval = get(dobj,'Value');
    if ~isempty(dval)
      dusd = get(dobj,'Userdata');
      dstr = cellstr(get(dobj,'String'));
      istr(dusd(dval)) = dstr(dval);
      dusd(dval) = [];
      dstr(dval) = [];
      set(dobj,'String',dstr,'Userdata',dusd,'Value',[])   
    end
    
    %Put use to hedge instruments back in list
    uval = get(uobj,'Value');
    if ~isempty(uval)
      uusd = get(uobj,'Userdata');
      ustr = cellstr(get(uobj,'String'));
      istr(uusd(uval)) = ustr(uval);
      uusd(uval) = [];
      ustr(uval) = [];
      set(uobj,'String',ustr,'Userdata',uusd,'Value',[])   
    end
    
    set(iobj,'String',istr)
    
    derivtool('hedgetotals')    %Compute hedge portfolios


  case 'calcfwdterm'
    
    %Calculate the forward term date interval
    
    HJMTree = get(gcf,'Userdata');
    ValuationDate = intenvget(HJMTree.RateSpec, 'ValuationDate');
    StartDates = intenvget(HJMTree.RateSpec,'StartDates');
    EndDates = intenvget(HJMTree.RateSpec,'EndDates');
   

    %Test interval between StartDates and EndDates
    m = months(StartDates,EndDates);
    tmpd = datemnth(StartDates,m);
    if any((tmpd - EndDates)) | any(diff(diff(m)))
      fwdterm = -99;   %Uneven date interval in EndDates, use Uneven
    else
      fwdterm = m(1);  %date interval is month value
    end
    
    %Set Forward Term popupmenu
    switch fwdterm
      case 1
        fval = 1;
      case 3
        fval = 2;
      case 6
        fval = 3;
      case 12
        fval = 4;
      case 18
        fval = 5;
      case 24
        fval = 6;
      case 60
        fval = 7;
      case 120
        fval = 8;
      case 240 
        fval = 9;
      case 360
        fval = 10;
      otherwise
        fval = 11;
    end
    
    set(findobj(gcf,'Tag','forwardterm'),'Value',fval)
    
  case 'clear'   
    
    %Clear instrument edit fields
    iobj = findobj(gcf,'Style','edit','Userdata','instfield');
    oobj = findobj(gcf,'Style','edit','Userdata','optfield');
    set([iobj;oobj],'String',[])
    
    %Reset popupmenus
    iobj = findobj(gcf,'Style','popupmenu','Userdata','instfield');
    set(iobj,'Value',1)
    
    %Reset radio buttons
    robj = findobj(gcf,'Style','radiobutton');
    if ~isempty(robj)
      t = get(robj,'Tag');
      t = unique(t);
      for i = 1:length(t)
        nobj = findobj(gcf,'Tag',t{i});
        set(min(nobj),'Value',1)
        set(max(nobj),'Value',0)
      end
    end
    
    set(findobj(gcf,'String','Add'),'Userdata',0)
    
  case 'compounding'
    
    cobj = findobj(gcf,'Tag','Compounding');
    cval = get(cobj,'Value');
    cstr = get(cobj,'String');
    CompoundingNew = str2double(cstr{cval});
    HJMTree = get(gcf,'Userdata');
    HJMTree.RateSpec = intenvset(HJMTree.RateSpec, 'Compounding', CompoundingNew);
    TimeSpecNew = hjmtimespec(HJMTree.TimeSpec.ValuationDate, HJMTree.TimeSpec.Maturity, CompoundingNew);
    HJMTree = hjmtree(HJMTree.VolSpec, HJMTree.RateSpec, TimeSpecNew);
    Rates = intenvget(HJMTree.RateSpec, 'Rates');
    
    if findobj(gcf,'String','Times','Value',1)
      rflag = getcurvetype;
      ratedisplay(Rates,HJMTree,rflag);
    end
    
    set(gcf,'Userdata',HJMTree)    
    
  case 'curveok'
    
    %Save and close  (initial curve) window
    
    %Get HJMTree
    HJMTree = get(gcf,'Userdata');
      
    close(gcf)   %Close dialog
    
    %Store HJMTree
    hobj = findobj('Tag','HJMDLG');
    setappdata(hobj,'HJMTREE',HJMTree)
    
  case 'curverestore'
    
    %Close window and reopen
    close
    
    derivtool('scenario')
    
  case 'deleteinstrument'
    
    %Remove instrument from list
    pval = get(portobj,'Value');
    if isempty(pval)
      set(findobj('Type','figure'),'Pointer','arrow')
      return
    end
    
    Port = get(portobj,'Userdata');
    Port = instdelete(Port,'Index',pval);
    set(portobj,'Userdata',Port,'Value',[])
    
    %Build instrument descriptions
    if getappdata(gcf,'PriceFlag')
      [Name,Quan,Price,Delta,Gamma,Vega] = instget(Port,'FieldName',...
        {'Name','Quantity','Price','Delta','Gamma','Vega'});
      [Portfolio,Totals] = buildinstrumentlist({Name Quan Price Delta Gamma Vega});
      set(findobj('Tag','totals'),'String',Totals)  
    else
      [Name,Quan] = instget(Port,'FieldName',{'Name','Quantity'});
      Portfolio = buildinstrumentlist({Name Quan});
    end
      
    set(portobj,'String',Portfolio)
        
  case 'dialog'
     
    %Refocus existing window and return if already open
    hobj = findobj('Tag','HJMDLG');
    if ~isempty(hobj)
      figure(hobj)
      set(findobj('Type','figure'),'Pointer','arrow')
      return
    end
    
    %Open dialog if not already open
    fobj = figure('Numbertitle','off','Name','Derivtool','Resize','off',...
      'Menubar','none','Tag','HJMDLG','Nextplot','new');
    
    %Initialize pricing flag as zero, gets set to 1 after portfolio is priced
    setappdata(gcf,'PriceFlag',0)
    
    %File Menu
    fu = uimenu('Label','&File','Accelerator','F');
    % uimenu('Parent',fu,'Label','New','Accelerator','N');
    uimenu('Parent',fu,'Label','Open','Accelerator','O','Callback','derivtool(''portfolioopen'')');
    uimenu('Parent',fu,'Label','Save','Accelerator','S','Callback','derivtool(''portfoliosave'')');
    uimenu('Parent',fu,'Label','Exit','Accelerator','X','Callback','close');
    
    %Model menu
    tu = uimenu('Label','&Model','Accelerator','M');
    hu = uimenu('Parent',tu,'Label','HJM','Accelerator','H',...
      'Checked','on','Callback','derivtool(''model'')','Tag','model');
    uimenu('Parent',tu,'Label','Zero Curve','Accelerator','Z','Callback','derivtool(''model'')','Tag','model');   
     
    %Settings Menu
    su = uimenu('Label','&Settings','Accelerator','S');
    uimenu('Parent',su,'Label','Initial Curve','Accelerator','I','Callback','derivtool(''scenario'')');
    uimenu('Parent',su,'Label','Sensitivities','Accelerator','E','Callback','derivtool(''sensitivity'')');
    uimenu('Parent',su,'Label','Volatility Model','Accelerator','V','Callback','derivtool(''volatilitymodel'')');
    uimenu('Parent',su,'Label','Tree Construction','Accelerator','T','Callback','derivtool(''treeconstruction'')');
         
    %Actions Menu
    au = uimenu('Label','&Actions','Accelerator','A');
    uimenu('Parent',au,'Label','Price','Accelerator','R','Callback','derivtool(''priceportfolio'')');
    uimenu('Parent',au,'Label','Hedge','Accelerator','H','Callback','derivtool(''hedge'')','Enable','off');
    
    %View rates and curves menu
    vu = uimenu('Label','&View','Accelerator','V');
    uimenu('Parent',vu,'Label','Spot Rates',...
      'Callback','set(gcbo,''Checked'',''on''),set(findobj(''Label'',''Unit Bond Prices''),''Checked'',''off''),derivtool(''viewtree'')')
      uimenu('Parent',vu,'Label','Unit Bond Prices','Callback','set(gcbo,''Checked'',''on''),set(findobj(''Label'',''Spot Rates''),''Checked'',''off''),derivtool(''viewtree'')')
    
    %Get figure position and set spacing parameters
    [bspc,bwid,bhgt,top,rgt,fhgt1,fhgt2,fwid1] = spacing;
        
    %Build portfolio display frame
    uicontrol('Enable','off','Position',[bspc top-(bspc+fhgt1) fwid1 fhgt1]);
    uicontrol('Style','text','String','Portfolio','Position',[2*bspc top-(bhgt) bwid bhgt]);
               
    %Column headers
    uicontrol('Style','text','String','Instrument','Position',[2*bspc top-(bspc+2*bhgt) bwid bhgt]);
    uicontrol('Style','text','String','Quantity','Position',[3*bspc+1.1*bwid top-(bspc+2*bhgt) bwid bhgt]);
    uicontrol('Style','text','String','Price','Position',[4*bspc+1.8*bwid top-(bspc+2*bhgt) bwid bhgt]);
    uicontrol('Style','text','String','Delta','Position',[5*bspc+2.55*bwid top-(bspc+2*bhgt) bwid bhgt]);
    uicontrol('Style','text','String','Gamma','Position',[6*bspc+3.2*bwid top-(bspc+2*bhgt) bwid bhgt]);
    uicontrol('Style','text','String','Vega','Position',[7*bspc+4.05*bwid top-(bspc+2*bhgt) bwid bhgt]);

    %Portfolio listbox
    uicontrol('Style','listbox','Tag','portfolio','Fontname',fnt,'String','',...
      'Tooltip','Double click to edit an instrument',...
      'Max',2,'Value',[],'Userdata',[],'Callback','derivtool(''editinstrument'')',...
      'Position',[2*bspc top-(6*bhgt) 4*bspc+5*bwid 4*bhgt]);
    
    %Instrument action buttons
    uicontrol('String','Edit','Callback','derivtool(''editinstrument'')',...
      'Tooltip','Edit an instrument',...
      'Userdata',0,'Position',[7*bspc+5*bwid top-(bspc+3*bhgt) bwid bhgt]);
    uicontrol('String','Delete','Callback','derivtool(''deleteinstrument'')',...
      'Tooltip','Delete an instrument',...
      'Position',[7*bspc+5*bwid top-(2*bspc+4*bhgt) bwid bhgt]);
    uicontrol('String','View Tree','Callback','derivtool(''viewtree'')','Enable','off',...
      'Tooltip','View instrument price trees',...
      'Position',[7*bspc+5*bwid top-(3*bspc+5*bhgt) bwid bhgt]);

    %Totals
    uicontrol('Style','text','String','Totals:',...
      'Position',[3*bspc+bwid top-(3*bspc+7*bhgt) bwid bhgt]);
    uicontrol('Style','edit','Tag','totals','String','','Fontname',fnt,...
      'Position',[4*bspc+1.6*bwid top-(2*bspc+7*bhgt) 2*bspc+3.4*bwid bhgt]);
    
    %Instrument frame
    uicontrol('Enable','off','Position',[bspc bspc fwid1 fhgt2]);
    uicontrol('Style','text','String','Instrument Selection','Position',[2*bspc top-fhgt1-bhgt-2*bspc bwid bhgt]);
    
    %Instrument list and popup
    insts = {'Bond';'Cap';'Fixed Rate Note';'Floating Rate Note';'Floor';'Option';'Swap'};
    uicontrol('Style','popupmenu','String',insts,'Tag','instruments','Callback','derivtool(''instruments'')',...
      'Position',[2*bspc top-(2*bspc+2*bhgt+fhgt1) bspc+2*bwid bhgt]); 
    
    %Display default portfolio
    try
      
      load deriv.mat   %Load default portfolio
      
      %Update portfolio
      updateportfolio(HJMInstSet,HJMTree,0,0);

      setappdata(gcf,'HJMTREE',HJMTree)

    catch 
      %Do nothing if default portfolio load and displays fails  
    end
    
    derivtool('instruments')   %Build instrument entry uicontrols
    
    %Calculated sensitivity settings
    calcdelta = 0;    %1 means to calculate and display this sensitivity
    calcgamma = 0;
    calcvega = 0;
    setappdata(gcf,'DeltaGammaVega',[calcdelta calcgamma calcvega])
        
  case {'editinstrument','underlyingeditinstrument'}
    
    %Enable Control/Shift click of multiple instruments
    if length(get(findobj(gcf,'Tag','portfolio'),'Value')) > 1
      set(findobj(gcf,'Type','figure'),'Pointer','arrow')
      return 
    end
      
    %Enable double click edit of instrument
    if ~strcmp(get(gcbo,'String'),'Edit')
      if (now - get(findobj(gcf,'String','Edit'),'Userdata')) > 1e-5
        set(findobj(gcf,'String','Edit'),'Userdata',now)
        set(findobj(gcf,'Type','figure'),'Pointer','arrow')
        return
      end
    end
    
    %Edit selected instrument
    if nargin == 2
      pval = tabid;    %Instrument index is given value
    else  
      pval = get(portobj,'Value');  %Get instrument index from listbox
    end  
    
    if isempty(pval)    %Do nothing is no instrument given or selected
      set(findobj(gcf,'Type','figure'),'Pointer','arrow')
      return
    end
    
    Port = get(portobj,'Userdata');   %Get portfolio information
    
    flds = instfields(Port,'Index',pval);   %Get fieldnames for chosen instrument
    datc = instgetcell(Port,'Index',pval);  %Get data for chosen instrument
    inst = instget(Port,'FieldName',{'Type'},'Index',pval);   %Get instrument type
    
    switch inst     %These instruments have different display and actual types
      case 'Float'
        inst = 'Floating Rate Note';
      case 'Fixed'
        inst = 'Fixed Rate Note';
      case 'OptBond'
        inst = 'Option';
    end
          
    %Store index of edited instrument
    set(findobj(gcf,'String','Add'),'Userdata',pval)    

    %Display proper uicontrols for selected instrument
    if nargin == 1  %Underlying instrument for options skips this 2nd time thru
      iobj = findobj(gcf,'Tag','instruments');
      instruments = get(iobj,'String');
      x = find(strcmp(inst,instruments));
      set(iobj,'Value',x)
      derivtool('instruments')
    end
    
    %Convert NaN's to empty
    L = length(datc);
    for i = 1:L
      if isnan(datc{i})
        datc{i} = [];
      end
    end
    
    %Fields for all instruments
    if nargin == 1   %Don't overwrite option name
      if isstr(datc{end-1})
        idname = datc{end-1};
      else
        idname = datc{end-5};
      end
      set(findobj(gcf,'Tag','idcusip'),'String',idname)    %Name
    end 
    if isstr(datc{end-1})
      quant = datc{end};
    else
      quant = datc{end-4};
    end
    set(findobj(gcf,'Tag','contracts'),'String',num2str(quant)) %Quantity
    
    %Set default principal and parvalues if they are empty
    i = find(strcmp(flds,'Face'));   %Par Value is named Face
    if ~isempty(i) & isempty(datc{i})
      datc{i} = 100;
    end
    i = find(strcmp(flds,'Principal'));   %Principal
    if ~isempty(i) & isempty(datc{i})
      datc{i} = 100;
    end
    
    %Convert period and basis to popupmenu value
    basfld = find(strcmp(flds,{'Basis'}));
    if ~isempty(basfld)
      basset = datc{basfld}+1;
      pervals = [1,2,3,4,6,12];
      pernum = datc{basfld-1};   %Period is always field before Basis
      if length(pernum) > 1
        perset = find(pernum(2) == pervals);
      else
        perset = find(pernum == pervals);
      end
      if isempty(basset)
        basset = 1;
      end
      if isempty(perset)
        perset = 1;
      end
    end
    
    %Instrument specific fields
    switch inst
      
      case {'Bond'}
        
        set(findobj(gcf,'Tag','basis'),'Value',basset)
        set(findobj(gcf,'Tag','period'),'Value',perset)
        set(findobj(gcf,'Tag','coupon'),'String',num2str(datc{1}))
        set(findobj(gcf,'Tag','settlement'),'String',datestr(datc{2}))
        set(findobj(gcf,'Tag','maturity'),'String',datestr(datc{3}))
        set(findobj(gcf,'Tag','issue'),'String',datestr(datc{7}))
        set(findobj(gcf,'Tag','firstcoupon'),'String',datestr(datc{8}))
        set(findobj(gcf,'Tag','lastcoupon'),'String',datestr(datc{9}))
        set(findobj(gcf,'Tag','parvalue'),'String',num2str(datc{11}))
        
      case {'Cap','Floor'}
        
        set(findobj(gcf,'Tag','basis'),'Value',basset)
        set(findobj(gcf,'Tag','period'),'Value',perset)
        set(findobj(gcf,'Tag','start'),'String',datestr(datc{2}))
        set(findobj(gcf,'Tag','maturity'),'String',datestr(datc{3}))
        set(findobj(gcf,'Tag','strike'),'String',num2str(datc{1}))
        set(findobj(gcf,'Tag','principal'),'String',num2str(datc{6}))
        if nargin == 1   %Don't overwrite option name
          set(findobj(gcf,'Tag','idcusip'),'String',datc{7})    %Name
        end  
        set(findobj(gcf,'Tag','contracts'),'String',num2str(datc{8})) %Quantity
        
      case {'Fixed Rate Note','Floating Rate Note'}
        
        set(findobj(gcf,'Tag','basis'),'Value',basset)
        set(findobj(gcf,'Tag','period'),'Value',perset)
        set(findobj(gcf,'Tag','start'),'String',datestr(datc{2}))
        set(findobj(gcf,'Tag','maturity'),'String',datestr(datc{3}))
        set(findobj(gcf,'Tag','principal'),'String',num2str(datc{6}))
        set(findobj(gcf,'Tag','coupon'),'String',num2str(datc{1}))
        
        if nargin == 1   %Don't overwrite option name
          set(findobj(gcf,'Tag','idcusip'),'String',datc{7})    %Name
        end  
        set(findobj(gcf,'Tag','contracts'),'String',num2str(datc{8})) %Quantity


      case 'Option'
                
        %Save index of current option so it underlying call doesn't overwrite
        aobj = findobj(gcf,'String','Add');
        optindex = get(aobj,'Userdata');
        
        derivtool('underlying')   %Display uicontrols for underlying instrument
        derivtool('underlyingeditinstrument',datc{1})  %Fill controls for underlying instrument
        
        set(aobj,'Userdata',optindex)   %Calling underlyinginstrument overwrites stored index in edit option case
        
        set(findobj(gcf,'Tag','optiontype'),'Value',0)
        switch datc{2}
          case 'put '
            set(findobj(gcf,'String','Put'),'Value',1)
          case 'call'
            set(findobj(gcf,'String','Call'),'Value',1)
        end
        set(findobj(gcf,'Tag','strike'),'String',num2str(datc{3}))
        set(findobj(gcf,'Tag','nocontracts'),'String',num2str(datc{7}))
        set(findobj(gcf,'Tag','exercisetype'),'Value',0)
        set(findobj(gcf,'Tag','expiration'),'String',datestr(datc{4}))
        opttype = 1;   %Start with American option
        if isempty(datc{5})
          opttype = 0;      %Empty entry, default to European
        elseif isnan(datc{5})
          opttype = 0;      %NaN, default to Euro
        else
          opttype = datc{5};      %
        end
        if opttype   %Opttype = 1, American
          tmpdat = instgetcell(Port,'Index',datc{1});
          set(findobj(gcf,'Tag','start'),'String',datestr(tmpdat{2}))
          set(findobj(gcf,'String','American'),'Value',1)
          set(findobj(gcf,'Tag','start'),'Enable','on')
          set(findobj(gcf,'String','Start:'),'Enable','on')
        else
          set(findobj(gcf,'String','European'),'Value',1)
          set(findobj(gcf,'Tag','start'),'Enable','off')
          set(findobj(gcf,'String','Start:'),'Enable','off')
        end
        
      case 'Swap'
        
        %Storing information for both legs for later version of GUI
        
        %Get leg types
        legtype = datc{7};
        if isempty(legtype)
          legtype = [1 0];
        end
        
        swapobj = findobj(gcf,'Tag','swaptype');
        
        couobj = findobj(gcf,'Tag','coupon');
        
        setappdata(couobj,'paycou',datc{1}(2));
        setappdata(couobj,'reccou',datc{1}(1));
        set(couobj,'String',num2str(datc{1}(2)))
        setappdata(swapobj,'paytype',legtype(2));
        setappdata(swapobj,'rectype',legtype(1));
        set(swapobj,'Value',abs(legtype(2)-2));
        
        %Set coupon/spread string correctly
        stval = get(swapobj,'Value');
        switch stval
          case 1
            set(findobj(gcf,'String','Spread:'),'String','Coupon:')
          case 2
            set(findobj(gcf,'String','Coupon:'),'String','Spread:')
        end
         
        startobj = findobj(gcf,'Tag','start');
        setappdata(startobj,'paystart',datestr(datc{2}));
        setappdata(startobj,'recstart',datestr(datc{2}));
        set(startobj,'String',datestr(datc{2}))

        matobj = findobj(gcf,'Tag','maturity');
        setappdata(matobj,'paymat',datestr(datc{3}));
        setappdata(matobj,'recmat',datestr(datc{3}));
        set(matobj,'String',datestr(datc{3}))
        
        prinobj = findobj(gcf,'Tag','principal');
        setappdata(prinobj,'payprin',datc{6});
        setappdata(prinobj,'recprin',datc{6});
        set(prinobj,'String',num2str(datc{6}))

        conobj = findobj(gcf,'Tag','contracts');
        setappdata(conobj,'paycon',datc{9});
        setappdata(conobj,'reccon',datc{9});
        set(conobj,'String',num2str(datc{9}))
        
        basobj = findobj(gcf,'Tag','basis');
        setappdata(basobj,'paybas',datc{6});
        setappdata(basobj,'recbas',datc{6});
        set(basobj,'Value',basset)
        
        perobj = findobj(gcf,'Tag','period');
        setappdata(perobj,'payper',datc{4}(2));
        setappdata(perobj,'recper',datc{4}(1));
        set(perobj,'Value',perset);
        
        if nargin == 1   %Don't overwrite option name
          set(findobj(gcf,'Tag','idcusip'),'String',datc{8})    %Name
        end  
        
    end
    
  case 'forwardterm'
    
   %Update curve dates based on Analysis date and forward term period
   try
     
     %Get analysis date
     adate = datenum(get(findobj(gcf,'Tag','analysisdate'),'String'));
    
     %Get HJMTree
     HJMTree = get(gcf,'Userdata');
       
     %Get period (in months)
     fobj = findobj(gcf,'Tag','forwardterm');
     fval = get(fobj,'Value');
     fusd = get(fobj,'Userdata');
     try
       mnth = fusd(fval);  %Forward term in months stored in uicontrol userdata
     catch
       set(findobj('Type','figure'),'Pointer','arrow')
       return
     end
    
     HJMTree.RateSpec = intenvset(HJMTree.RateSpec,'ValuationDate',adate);
     EndDates = intenvget(HJMTree.RateSpec, 'EndDates');
     if (mnth ~= -99)
       StartDates = max(datemnth(EndDates, -mnth), intenvget(HJMTree.RateSpec, 'ValuationDate'));
       HJMTree.RateSpec = intenvset(HJMTree.RateSpec, 'StartDates', StartDates);
     else
       StartDates = intenvget(HJMTree.RateSpec,'StartDates');
     end  
     HJMTree = hjmtree(HJMTree.VolSpec, HJMTree.RateSpec, HJMTree.TimeSpec);
     set(gcf,'Userdata',HJMTree)
    
     %Display new dates
     dstr = get(findobj(gcf,'Value',1,'Tag','curvedates'),'String');
     
     switch dstr
      case 'Start dates'
        Dates = StartDates;
      case 'Maturity dates'
        Dates = EndDates;
     end
     
     LD = length(Dates);
     dobj = findobj(gcf,'Tag','CurveDates');
     set(dobj(1:LD),{'String'},cellstr(datestr(Dates)))
    
     %Display new settings
     Rates   = intenvget(HJMTree.RateSpec, 'Rates');
     
     if findobj(gcf,'String','Curve','Value',1)
       plot(Rates,'Linewidth',2)
       set(gca,'Xtick',1:length(Rates),'Xlim',[-.5 10.5])
     else
       ratedisplay(Rates,HJMTree,1)
     end

   catch 
      errordlg(lasterr)
   end
  
  case 'fzview'
    
    %Build forward and zero rates viewer
    [bspc,bwid,bhgt] = spacing;
    set(gcf,'Windowstyle','normal')
    h = dialog('Closerequestfcn','delete(gcf),set(findobj(''Tag'',''Scenario''),''Windowstyle'',''modal'')');
    
    %Build axes
    subplot(2,1,1)
    p = get(gca,'Position');
    set(gca,'Tag','Forwards','Position',[p(1) p(2) p(3)*.75 p(4)])
    title('Forward Rates')
    
    subplot(2,1,2)
    p = get(gca,'Position');
    set(gca,'Tag','Zeros','Position',[p(1) p(2) p(3)*.75 p(4)])
    title('Zero Rates')
    
  case 'hedge'
    
    %Hedging dialog
    
    Port = get(portobj,'Userdata');   %Get portfolio information
    [Name,Quan,Price,Delta,Gamma,Vega] = instget(Port,'FieldName',{'Name','Quantity','Price','Delta','Gamma','Vega'});
    instruments = cellstr(buildinstrumentlist({Name Quan Delta Gamma Vega}));
        
    [bspc,bwid,bhgt] = spacing;   %Get uicontrol and figure window spacing
    
    %Get sensitivities
    sensvals = getappdata(findobj('Tag','HJMDLG'),'DeltaGammaVega');
    
    %Build dialog
    h = dialog('Name','Hedging','Userdata',Port);
    p = get(gcf,'Position');
    rgt = p(3);
    top = p(4);
    fwid = rgt-2*bspc;
    fhgt1 = 14*bspc+13*bhgt;
    set(gcf,'Position',[p(1) p(2) p(3) fhgt1+2*bhgt])
    
    %Cancel, OK buttons
    uicontrol('String','Help','Callback','derivtool(''help'',''hedging'')','Position',[rgt-3*(bspc+bwid) bspc bwid bhgt]);
    uicontrol('String','OK','Callback','derivtool(''hedgeok'')',...
      'Tooltip','Close window and save hedging settings',...
      'Position',[rgt-2*(bspc+bwid) bspc bwid bhgt]);
    uicontrol('String','Cancel','Callback','close',...
        'Tooltip','Close window without saving hedging settings','Position',[rgt-(bspc+bwid) bspc bwid bhgt]);

    
    %Build Instrument Selection panel
    uicontrol('Enable','off','Position',[bspc 2*bspc+bhgt fwid fhgt1]);
    uicontrol('Style','text','String','Instrument Selection',...
      'Position',[3*bspc 3*bspc+fhgt1 bwid bhgt]); 
    
    %Restore, Hedge buttons
    uicontrol('String','Hedge','Callback','derivtool(''hedgetotals'')',...
      'Tooltip','Perform hedging',...
      'Position',[rgt-(2*bspc+bwid) 3*bspc+bhgt bwid bhgt]);
    uicontrol('String','Restore','Callback','derivtool(''restore'')',...
      'Tooltip','Restore initial settings',...  
      'Position',[rgt-(3*bspc+2*bwid) 3*bspc+bhgt bwid bhgt]);
    
    %Portfolio Totals frame
    uicontrol('Style','frame','Position',[2*bspc 4*bspc+2*bhgt bspc+2*bwid 4*bspc+3*bhgt]);
    uicontrol('Style','frame','Position',[bspc+2*bwid 4*bspc+2*bhgt bspc+1.85*bwid 4*bspc+3*bhgt]);
    uicontrol('Style','frame','Position',[2*bspc+3.6*bwid 4*bspc+2*bhgt 4*bspc+1.28*bwid 4*bspc+3*bhgt]);
    uicontrol('Style','frame','Position',[4*bspc+4.88*bwid 4*bspc+2*bhgt 2*bspc+1.24*bwid 4*bspc+3*bhgt]);
    uicontrol('Style','frame','Position',[2*bspc 7.9*bspc+5*bhgt 4*bspc+6.12*bwid bspc+bhgt])
    uicontrol('Style','text','Tag','TotalInstruments','Fontweight','bold',...
      'String','Overall Portfolio','Position',[3*bspc 5*bspc+2*bhgt 3*bwid bhgt]);
    uicontrol('Style','text','Tag','UsetoHedgeInstruments','Fontweight','bold',...
      'String','Hedging Instruments','Position',[3*bspc 6*bspc+3*bhgt 3*bwid bhgt]);
    uicontrol('Style','text','Tag','HedgeInstruments','Fontweight','bold',...
      'String','Hedged Instruments','Position',[3*bspc 7*bspc+4*bhgt 3*bwid bhgt]);
    uicontrol('Style','text','String','Portfolio Totals',...
      'Fontweight','bold','Position',[3*bspc 8*bspc+5*bhgt 3*bwid bhgt]);
    uicontrol('Style','text','Tag','TotalDelta','Fontweight','bold',...
      'Position',[4*bspc+2*bwid 5*bspc+2*bhgt 1.55*bwid bhgt]);
    uicontrol('Style','text','Tag','UsetoHedgeDelta','Fontweight','bold',...
      'Position',[4*bspc+2*bwid 6*bspc+3*bhgt 1.55*bwid bhgt]);
    uicontrol('Style','text','Tag','HedgeDelta','Fontweight','bold',...
      'Position',[4*bspc+2*bwid 7*bspc+4*bhgt 1.55*bwid bhgt]);
    uicontrol('Style','text','String','Delta',...
      'Fontweight','bold','Position',[4*bspc+2*bwid 8*bspc+5*bhgt bwid bhgt]);
    uicontrol('Style','text','Tag','TotalGamma','Fontweight','bold',...
      'Position',[5*bspc+3.55*bwid 5*bspc+2*bhgt 1.55*bwid bhgt]);
    uicontrol('Style','text','Tag','UsetoHedgeGamma','Fontweight','bold',...
      'Position',[5*bspc+3.55*bwid 6*bspc+3*bhgt 1.55*bwid bhgt]);
    uicontrol('Style','text','Tag','HedgeGamma','Fontweight','bold',...
      'Position',[5*bspc+3.55*bwid 7*bspc+4*bhgt 1.55*bwid bhgt]);
    uicontrol('Style','text','String','Gamma',...
      'Fontweight','bold','Position',[5*bspc+3.55*bwid 8*bspc+5*bhgt bwid bhgt]);
    uicontrol('Style','text','Tag','TotalVega','Fontweight','bold',...
      'Position',[5*bspc+5*bwid 5*bspc+2*bhgt 1.55*bwid bhgt]);
    uicontrol('Style','text','Tag','UsetoHedgeVega','Fontweight','bold',...
      'Position',[5*bspc+5*bwid 6*bspc+3*bhgt 1.55*bwid bhgt]);
    uicontrol('Style','text','Tag','HedgeVega','Fontweight','bold',...
      'Position',[5*bspc+5*bwid 7*bspc+4*bhgt 1.55*bwid bhgt]);
    uicontrol('Style','text','String','Vega',...
      'Fontweight','bold','Position',[6*bspc+5*bwid 8*bspc+5*bhgt bwid bhgt]);
    
    %Instrument frame
    uicontrol('Style','frame','Position',[2*bspc 10*bspc+6*bhgt fwid-2*bspc 4*bspc+8*bhgt]);
    uicontrol('Style','listbox','String',instruments,'Userdata',Port,'Max',2,'Value',[],...
      'Tag','HedgingInstruments',...
      'Fontname',fnt,'Position',[3*bspc 11*bspc+6*bhgt 1.5*bwid 7.25*bhgt]);
    uicontrol('Style','text','String','Instruments','Position',[3*bspc 11*bspc+13.25*bhgt bwid bhgt]);
    uicontrol('String','<< Remove','Callback','derivtool(''removehedge'')',...
      'Tooltip','Removed selected instrument from hedged or hedging list',...
      'Position',[4*bspc+1.5*bwid 15*bspc+8*bhgt bwid bhgt]);
    uicontrol('String','Hedging >>','Callback','derivtool(''addusetohedge'')',...
      'Tooltip','Add selected instrument to hedging list',...
      'Position',[4*bspc+1.5*bwid 11*bspc+7*bhgt bwid bhgt]);
    uicontrol('String','Hedged >>','Callback','derivtool(''addhedge'')',...
      'Tooltip','Add selected instrument to hedged list',...
      'Position',[4*bspc+1.5*bwid 15*bspc+10*bhgt bwid bhgt]);
    uicontrol('Style','listbox','String','','Userdata',[],'Max',2,'Value',[],'Tag','UsetoHedge',...
      'Foregroundcolor',[1 0 0],...
      'Fontname',fnt,'Position',[5*bspc+2.5*bwid 11*bspc+6*bhgt 2*bspc+3.5*bwid 3*bhgt]);
    uicontrol('Style','text','String','Hedging','Position',[5*bspc+2.5*bwid 11*bspc+9*bhgt bwid bhgt]);
    uicontrol('Style','text','String','Quantity','Position',[6*bspc+3.5*bwid 11*bspc+9*bhgt bwid bhgt]);
    uicontrol('Style','text','String','Delta','Position',[7*bspc+4.2*bwid 11*bspc+9*bhgt bwid bhgt]);
    uicontrol('Style','text','String','Gamma','Position',[8*bspc+4.7*bwid 11*bspc+9*bhgt bwid bhgt]);
    uicontrol('Style','text','String','Vega','Position',[9*bspc+5.3*bwid 11*bspc+9*bhgt bwid bhgt]);
    uicontrol('Style','listbox','String','','Userdata',[],'Max',2,'Value',[],'Tag','Hedge',...
      'Foregroundcolor',[0 0 1],...
      'Fontname',fnt,'Position',[5*bspc+2.5*bwid 12*bspc+10*bhgt 2*bspc+3.5*bwid 3*bhgt]);
    uicontrol('Style','text','String','Hedged','Position',[5*bspc+2.5*bwid 12*bspc+13*bhgt bwid bhgt]);
    uicontrol('Style','text','String','Quantity','Position',[6*bspc+3.5*bwid 12*bspc+13*bhgt bwid bhgt]);
    uicontrol('Style','text','String','Delta','Position',[7*bspc+4.2*bwid 12*bspc+13*bhgt bwid bhgt]);
    uicontrol('Style','text','String','Gamma','Position',[8*bspc+4.7*bwid 12*bspc+13*bhgt bwid bhgt]);
    uicontrol('Style','text','String','Vega','Position',[8*bspc+5.3*bwid 12*bspc+13*bhgt bwid bhgt]);
    
    cleanupdialog
   
  case 'hedgesens'
      
    %Get sensitivities settings, this switch is a placeholder
    sensvals = getappdata(findobj('Tag','HJMDLG'),'DeltaGammaVega');
    
  case 'hedgedemo'
    
    %Initial hedging demonstration scenario
    hobj = findobj(gcf,'Tag','HedgingInstruments');   %List of all instruments
        
    set(hobj,'Value',3)    %Instrument 3 is hedge instrument
    derivtool('addhedge')
    
    set(hobj,'Value',[2,4])
    derivtool('addusetohedge')  %Instruments 2 and 4 are use to hedge instruments
    
    derivtool('hedgetotals')
    
  case 'hedgeok'
    
    %Update main portfolio with results of hedging
    
    %Get new portfolio and close window
    Port = get(findobj(gcf,'Tag','HedgingInstruments'),'Userdata');
    
    %Get sensitivities settings
    sensvals = getappdata(findobj('Tag','HJMDLG'),'DeltaGammaVega');
    
    close
    
    %Update portfolio data
    figure(findobj('Tag','HJMDLG'))
    set(portobj,'Userdata',Port)
    
    %Save sensitivities settings
    setappdata(gcf,'DeltaGammaVega',sensvals)

    %Build instrument descriptions
    [Name,Quan,Price,Delta,Gamma,Vega] = instget(Port,'FieldName',...
      {'Name','Quantity','Price','Delta','Gamma','Vega'});
  
    tmp = '        ';
    pad = tmp(ones(size(Quan,1),1),:);
    %Blank out sens. not requested in Sensitivities dialog
    if sensvals(1) == 0
      Delta = pad;
    end
    if sensvals(2) == 0
      Gamma = pad;
    end
    if sensvals(3) == 0
      Vega = pad;
    end
    
    [Portfolio,Totals] = buildinstrumentlist({Name Quan Price Delta Gamma Vega});
    set(portobj,'String',Portfolio)
    set(findobj('Tag','totals'),'String',Totals)  
            
  case 'hedgetotals'
      
    try
    
    %Calculate hedging totals for duration and convexity
    Port = get(findobj(gcf,'Tag','HedgingInstruments'),'Userdata');
    
    %Get hedged instruments
    hobj = findobj(gcf,'Tag','Hedge');
    hInd = get(hobj,'Userdata');
    
    %Get hedging instruments
    uobj = findobj(gcf,'Tag','UsetoHedge');
    uInd = get(uobj,'Userdata');
    
    %Performing Hedge action if hedged button selected
    if strcmp(get(gcbo,'Type'),'uicontrol') & strcmp(get(gcbo,'String'),'Hedge')
      
      sensvals = getappdata(findobj('Tag','HJMDLG'),'DeltaGammaVega');
      Senses = {'Delta','Gamma','Vega'};
      
      SensNames = Senses(find(sensvals));
      
      if isempty(cat(2,SensNames{:}))
        set(findobj('Type','figure'),'Pointer','arrow')
        return
      end
      
      FixedIndex = hInd;
      Index = unique([hInd;uInd]);    
      [F, FixedInd] = intersect(Index, FixedIndex);
      SensSet = instgetcell(Port, 'Index',Index, 'FieldName', SensNames);
      Sensitivities = cat(2, SensSet{:});
      [Price, CurrentWts] = instget(Port, 'Index', Index, 'FieldName',{'Price','Quantity'}); 
      [PortSens, PortValue, PortWts] = hedgeslf(Sensitivities, Price, CurrentWts,FixedInd);
      Port = instsetfield(Port, 'Index',Index, 'FieldName','Quantity','Data',PortWts);
      
      %Update portfolio data in GUI
      set(findobj(gcf,'Tag','HedgingInstruments'),'Userdata',Port)

    end
    
    [Name,Quan,Delta,Gamma,Vega] = instget(Port,'FieldName',{'Name','Quantity','Delta','Gamma','Vega'});
    
    %Convert very small values
    s = 1e-10;
    iD = find(abs(Delta) < s);
    Delta(iD) = 0;
    iG = find(abs(Gamma) < s);
    Gamma(iG) = 0;
    iV = find(abs(Vega) < s);
    Vega(iV) = 0;
    
    tmp = '        ';
    pad = tmp(ones(size(Quan,1),1),:);
    
    %Get sensitivities
    sensvals = getappdata(findobj('Tag','HJMDLG'),'DeltaGammaVega');
    
    %Blank out sens. not requested in Sensitivities dialog
    if sensvals(1) == 0
      Delta = pad;
    end
    if sensvals(2) == 0
      Gamma = pad;
    end
    if sensvals(3) == 0
      Vega = pad;
    end
    
    %Build strings with new quantities
    if ~strcmp(get(gcbo,'Type'),'uimenu') & strcmp(get(gcbo,'String'),'Hedge')
      HedgePortfolio = buildinstrumentlist({Name Quan Delta Gamma Vega});
      set(hobj,'String',HedgePortfolio(hInd,:))
      set(uobj,'String',HedgePortfolio(uInd,:))
    end
    
    fstr = 4;    %num2str flag
    
    set(findobj(gcf,'Tag','HedgeDelta'),'String','')
    set(findobj(gcf,'Tag','HedgeGamma'),'String','')
    set(findobj(gcf,'Tag','HedgeVega'),'String','')
    set(findobj(gcf,'Tag','UsetoHedgeDelta'),'String','')
    set(findobj(gcf,'Tag','UsetoHedgeGamma'),'String','')
    set(findobj(gcf,'Tag','UsetoHedgeVega'),'String','')
    set(findobj(gcf,'Tag','TotalDelta'),'String','')
    set(findobj(gcf,'Tag','TotalGamma'),'String','')
    set(findobj(gcf,'Tag','TotalVega'),'String','')
    
    %Show hedged instruments
    if ~isempty(hInd)
      %Calculate duration and convexity
      HedgeD = sum(Quan(hInd).*Delta(hInd));
      HedgeG = sum(Quan(hInd).*Gamma(hInd));
      HedgeV = sum(Quan(hInd).*Vega(hInd));
    
      if sensvals(1)
        set(findobj(gcf,'Tag','HedgeDelta'),'String',num2str(HedgeD,fstr))
      end
      if sensvals(2)
        set(findobj(gcf,'Tag','HedgeGamma'),'String',num2str(HedgeG,fstr))
      end
      if sensvals(3)
        set(findobj(gcf,'Tag','HedgeVega'),'String',num2str(HedgeV,fstr))
      end
    end
    
    %Show hedging instruments
    if ~isempty(uInd)
      %Calculate Delta, Gamma, and Vega
      UsetoHedgeD = sum(Quan(uInd).*Delta(uInd));
      UsetoHedgeG = sum(Quan(uInd).*Gamma(uInd));
      UsetoHedgeV = sum(Quan(uInd).*Vega(uInd));
      if sensvals(1)
        set(findobj(gcf,'Tag','UsetoHedgeDelta'),'String',num2str(UsetoHedgeD,fstr))
      end
      if sensvals(2)
        set(findobj(gcf,'Tag','UsetoHedgeGamma'),'String',num2str(UsetoHedgeG,fstr))
      end
      if sensvals(3)
        set(findobj(gcf,'Tag','UsetoHedgeVega'),'String',num2str(UsetoHedgeV,fstr))
      end
    end
     
    
    %Display totals
    x = ~isempty(hInd);
    y = ~isempty(uInd);
    if x & y
      TotalD = HedgeD + UsetoHedgeD;
      TotalG = HedgeG + UsetoHedgeG;
      TotalV = HedgeV + UsetoHedgeV;
    elseif x & ~y
      TotalD = HedgeD;
      TotalG = HedgeG;
      TotalV = HedgeV;
    elseif ~x & y
      TotalD = UsetoHedgeD;
      TotalG = UsetoHedgeG;
      TotalV = UsetoHedgeV;
    else
      TotalD = [];
      TotalG = [];
      TotalV = [];
    end
    
    %Display total sensitivity values
    if sensvals(1)
      set(findobj(gcf,'Tag','TotalDelta'),'String',num2str(TotalD,fstr))
    end
    if sensvals(2)
      set(findobj(gcf,'Tag','TotalGamma'),'String',num2str(TotalG,fstr))
    end
    if sensvals(3)
      set(findobj(gcf,'Tag','TotalVega'),'String',num2str(TotalV,fstr))
    end
    
    cleanupdialog
    
    catch
        
      errordlg(lasterr)
      set(findobj('Type','figure'),'Pointer','arrow')
    
    end
    
  case 'help'
      
    %Call helpview, tabid contains topic  
    helpview([docroot '\mapfiles\finderiv.map'],tabid,'CSHelpWindow',gcf)
        
  case {'instruments','underlyinginstruments'}
    
    %Determine instrument type
    iobj = findobj(gcf,'Tag',callaction);
    ival = get(iobj,'Value');
    sval = get(iobj,'String');
    if isempty(ival)
      insttype = 'Bond';
    else
      insttype = sval{ival};
    end
    
    %Certain instruments are not supported for Zero Curve Model
    if any(strcmp(insttype,{'Cap','Floor','Option'})) & ~isempty(findobj(gcf,'Label','Zero Curve','Checked','on'))
      errordlg('Zero curve does not price Cap, Floor or Option instruments.')
      set(findobj('Type','figure'),'Pointer','arrow')
      return
    end
  
    %Delete existing instrument fields
    delete(findobj(gcf,'Userdata','instfield'))
    delete(findobj(gcf,'Userdata','optfield'))
    
    %Get figure position and spacing parameters
    [bspc,bwid,bhgt,top,rgt,fhgt1,fhgt2,fwid1] = spacing;
    
    
    
    idobj = findobj(gcf,'Tag','idcusip');   %Display ID/Cusip if not displayed
    if isempty(idobj)
      uicontrol('Style','text','String','Instrument:','Userdata','optfield',...
          'Position',[5*bspc+2*bwid top-(3*bspc+2*bhgt+fhgt1) bwid bhgt]);
      uicontrol('Style','edit','Tag','idcusip','Userdata','optfield',...
          'Position',[5*bspc+3*bwid top-(2*bspc+2*bhgt+fhgt1) bwid bhgt]);
    end
        
    switch insttype
      
      case 'Bond'
        
        %Date fields
        displaydatefields({'Settlement:';'Maturity:';'Issue:';'First Coupon:';'Last Coupon:'})
        
        %Additional fields
        commonfields(1,1,1,1)  %Number of contracts, Basis, period, coupon rate
        
        uicontrol('Style','text','String','Par Value:','Userdata','instfield',...
          'Position',[6*bspc+4*bwid top-(10*bspc+7*bhgt+fhgt1) bwid bhgt]);
        uicontrol('Style','edit','Tag','parvalue','Userdata','instfield',...
          'Position',[7*bspc+5*bwid top-(9*bspc+7*bhgt+fhgt1) bwid bhgt]);
        
      case 'Option'
        
        uicontrol('Style','text','String','No. of contracts:','Userdata','optfield',...
          'Position',[2*bspc top-(6*bspc+3*bhgt+fhgt1) bwid bhgt]);
        uicontrol('Style','edit','Tag','nocontracts','Userdata','optfield',...
          'Position',[3*bspc+bwid top-(5*bspc+3*bhgt+fhgt1) bwid bhgt]);
        
        %Date fields
        uicontrol('Style','text','String','Start:','Userdata','optfield','Enable','off',...
          'Position',[2*bspc top-(7*bspc+4*bhgt+fhgt1) bwid bhgt]);
        uicontrol('Style','edit','Tag','start','Userdata','optfield','Enable','off',...
          'Position',[3*bspc+bwid top-(6*bspc+4*bhgt+fhgt1) bwid bhgt]);
        uicontrol('Style','text','String','Expiration:','Userdata','optfield',...
          'Position',[2*bspc top-(8*bspc+5*bhgt+fhgt1) bwid bhgt]);
        uicontrol('Style','edit','Tag','expiration','Userdata','optfield',...
          'Position',[3*bspc+bwid top-(7*bspc+5*bhgt+fhgt1) bwid bhgt]);
        
        %Additional fields
        uicontrol('Style','text','String','Strike:','Userdata','optfield',...
          'Position',[2*bspc top-(9*bspc+6*bhgt+fhgt1) bwid bhgt]);
        uicontrol('Style','edit','Tag','strike','Userdata','optfield',...
          'Position',[3*bspc+bwid top-(8*bspc+6*bhgt+fhgt1) bwid bhgt]);
        
        uicontrol('Style','text','String','Underlying:','Userdata','optfield',...
          'Position',[2*bspc top-(10*bspc+7*bhgt+fhgt1) bwid bhgt]);
        
        %Add underlying instrument popup with instrument names and New option
        Port = get(portobj,'Userdata');
        [Name,Insts] = instget(Port,'FieldName',{'Name','Type'});
        i = find(strcmp('Bond',cellstr(Insts)));
        Instlist = [cellstr(Name(i,:));{'New bond'}];
        setappdata(gcf,'UnderlyingIndex',i)
        uicontrol('Style','popupmenu','Tag','underlying','Userdata','optfield',...
          'String',Instlist,...
          'Callback','derivtool(''underlying'')',...
          'Position',[3*bspc+bwid top-(9*bspc+7*bhgt+fhgt1) bwid bhgt]);
        
        uicontrol('Style','frame','Userdata','optfield',...
          'Position',[2*bspc top-(13*bspc+9*bhgt+fhgt1) bwid 2*bspc+2*bhgt]);
        uicontrol('Style','radiobutton','Tag','optiontype','String','Call','Userdata','optfield',...
          'Value',1,'Callback','derivtool(''radiobutton'')',...
          'Position',[3*bspc top-(12*bspc+8*bhgt+fhgt1) bwid-2*bspc bhgt]);
        uicontrol('Style','radiobutton','Tag','optiontype','String','Put','Userdata','optfield',...
          'Value',0,'Callback','derivtool(''radiobutton'')',...
          'Position',[3*bspc top-(12*bspc+9*bhgt+fhgt1) bwid-2*bspc bhgt]);
        
        uicontrol('Style','frame','Userdata','optfield',...
          'Position',[3*bspc+bwid top-(13*bspc+9*bhgt+fhgt1) bwid 2*bspc+2*bhgt]);
        uicontrol('Style','radiobutton','Tag','exercisetype','String','European','Userdata','optfield',...
          'Value',1,'Callback','derivtool(''radiobutton'')',...
          'Position',[4*bspc+bwid top-(12*bspc+8*bhgt+fhgt1) bwid-2*bspc bhgt]);
        uicontrol('Style','radiobutton','Tag','exercisetype','String','American','Userdata','optfield',...
          'Value',0,'Callback','derivtool(''radiobutton'')',...
          'Position',[4*bspc+bwid top-(12*bspc+9*bhgt+fhgt1) bwid-2*bspc bhgt]);
                
      case {'Cap','Floor'}
        
        %Date fields
        displaydatefields({'Start:','Maturity:'})
        
        commonfields(1,1,1,0)  %Number of contracts, Basis, period
        
        uicontrol('Style','text','String','Strike:','Userdata','instfield',...
          'Position',[6*bspc+4*bwid top-(9*bspc+6*bhgt+fhgt1) bwid bhgt]);
        uicontrol('Style','edit','Tag','strike','Userdata','instfield',...
          'Position',[7*bspc+5*bwid top-(8*bspc+6*bhgt+fhgt1) bwid bhgt]);
        uicontrol('Style','text','String','Principal:','Userdata','instfield',...
          'Position',[6*bspc+4*bwid top-(10*bspc+7*bhgt+fhgt1) bwid bhgt]);
        uicontrol('Style','edit','Tag','principal','Userdata','instfield',...
          'Position',[7*bspc+5*bwid top-(9*bspc+7*bhgt+fhgt1) bwid bhgt]);
        
        set(findobj(gcf,'String','Period:'),'String','Reset:')
        
      case {'Fixed Rate Note','Floating Rate Note','Swap'}
        
        swapflag = strcmp(insttype,'Swap');
        floatflag = strcmp(insttype,'Floating Rate Note');
        
        if swapflag
          %Make tab frame and buttons
          uicontrol('String','Pay','Userdata','instfield','Buttondownfcn','derivtool(''Pay'')',...
            'Enable','inactive','Position',[6*bspc+2*bwid 4*bspc bwid bhgt]);
          uicontrol('String','Receive','Userdata','instfield','Buttondownfcn','derivtool(''Receive'')',...
            'Enable','inactive','Position',[6*bspc+3*bwid 4.5*bspc bwid bhgt]);
          uicontrol('Enable','off','Userdata','instfield',...
            'Position',[5*bspc+2*bwid 4*bspc+bhgt 3*bspc+4*bwid 5*bspc+7*bhgt]); 
          uicontrol('Style','text','Tag','tabtext','Userdata','instfield',...
            'Position',[6.10*bspc+2*bwid 3.5*bspc+bhgt bwid-.40*bspc bspc]);
        end
        
        commonfields(1,1,1,1);  %Number of contracts, basis, period, and coupon
        
        if swapflag
          uicontrol('Style','text','String','Type:','Userdata','instfield',...
            'Position',[6*bspc+2*bwid top-(6*bspc+3*bhgt+fhgt1) bwid bhgt]);
          uicontrol('Style','popupmenu','Tag','swaptype','String',{'Fixed','Floating'},...
            'Callback','derivtool(''swaptype'')','Value',2,'Enable','on',...
            'Userdata','instfield','Position',[8*bspc+2.5*bwid top-(5*bspc+3*bhgt+fhgt1) bwid bhgt]);
          setappdata(findobj(gcf,'Tag','basis'),'paybas',1)
          setappdata(findobj(gcf,'Tag','basis'),'recbas',1)
          setappdata(findobj(gcf,'Tag','period'),'payper',1)
          setappdata(findobj(gcf,'Tag','period'),'recper',1)
          setappdata(findobj(gcf,'Tag','swaptype'),'paytype',2)
          setappdata(findobj(gcf,'Tag','swaptype'),'rectype',1)

        end 
        
        uicontrol('Style','text','String','Start:','Userdata','instfield',...
          'Position',[6*bspc+2*bwid top-(7*bspc+4*bhgt+fhgt1) bwid bhgt]);
        uicontrol('Style','edit','Tag','start',...
            'Userdata','instfield','Position',[8*bspc+2.5*bwid top-(6*bspc+4*bhgt+fhgt1) bwid bhgt]);
        uicontrol('Style','text','String','Maturity:','Userdata','instfield',...
          'Position',[6*bspc+2*bwid top-(8*bspc+5*bhgt+fhgt1) bwid bhgt]);
        uicontrol('Style','edit','Tag','maturity',...
          'Userdata','instfield','Position',[8*bspc+2.5*bwid top-(7*bspc+5*bhgt+fhgt1) bwid bhgt]);
        
        uicontrol('Style','text','String','Principal:','Userdata','instfield',...
          'Position',[6*bspc+2*bwid top-(10*bspc+7*bhgt+fhgt1) bwid bhgt]);
        uicontrol('Style','edit','Tag','principal',...
            'Userdata','instfield','Position',[8*bspc+2.5*bwid top-(9*bspc+7*bhgt+fhgt1) bwid bhgt]);
          
        if floatflag | swapflag
          csobj = findobj(gcf,'String','Coupon:');
          set(csobj,'String','Spread:')
        end
        
        set(findobj(gcf,'String','Period:'),'String','Reset:')

    end
    
    %Add and clear buttons
    aobj = findobj(gcf,'String','Add');
    if isempty(aobj)
      uicontrol('String','Add','Callback','derivtool(''addinstrument'')','Tooltip','Add/Modify an instrument',...
          'Userdata',0,'Position',[6*bspc+4*bwid top-(2*bspc+2*bhgt+fhgt1) bwid bhgt]);
      uicontrol('String','Help','Callback','derivtool(''help'',''derivtooldlg'')','Userdata',0,'Position',[rgt-(2*bspc+bwid) 2*bspc bwid bhgt]);
      uicontrol('String','Clear','Callback','derivtool(''clear'')','Tooltip','Clear instrument settings','Position',[rgt-(3*bspc+2*bwid) 2*bspc bwid bhgt]);
    end
    
    %If selected instrument popupmenu, reset instrument add index
    if strcmp(get(gcbo,'Tag'),'instruments')
      set(findobj(gcf,'String','Add'),'Userdata',0)
    end
  
    cleanupdialog
    
  case {'Pay','Receive'}
    
    set(gcbo,'selectionhighlight','off')  %Turn off visual selected indicator
    
    %Toggle panel for Swap instrument
    j = find(strcmp(callaction,{'Pay','Receive'}));  %instrument leg index
    tobj = findobj(gcf,'Tag','tabtext');
    post = get(tobj,'Position');
    pobj = findobj(gcf,'String','Pay');
    posp = get(pobj,'Position');
    robj = findobj(gcf,'String','Receive');
    posr = get(robj,'Position');
    stobj = findobj(gcf,'Tag','swaptype');
    
    %Get uicontrols objects
    startobj = findobj(gcf,'Tag','start');
    matobj = findobj(gcf,'Tag','maturity');
    prinobj = findobj(gcf,'Tag','principal');
    conobj = findobj(gcf,'Tag','contracts');
    basobj = findobj(gcf,'Tag','basis');
    perobj = findobj(gcf,'Tag','period');
    couobj = findobj(gcf,'Tag','coupon');
    stval = get(stobj,'Value');
    
    %Get period value
    perstr = get(perobj,'String');
    perval = get(perobj,'Value');
    legper = str2double(perstr{perval});
    
    if j == 1  %Pay is selected button tab
      set(pobj,'Position',[posp(1) min([posp(2) posr(2)]) posp(3) posp(4)])
      set(robj,'Position',[posr(1) max([posr(2) posp(2)]) posr(3) posr(4)])
      set(tobj,'Position',[.0015+posp(1) post(2) post(3) post(4)])
      setappdata(startobj,'recstart',get(startobj,'String'))
      if ~isempty(getappdata(startobj,'paystart')),set(startobj,'String',getappdata(startobj,'paystart')),end
      setappdata(matobj,'recmat',get(matobj,'String'))
      if ~isempty(getappdata(matobj,'paymat')),set(matobj,'String',getappdata(matobj,'paymat')),end
      setappdata(prinobj,'recprin',get(prinobj,'String'))
      if ~isempty(getappdata(prinobj,'payprin')),set(prinobj,'String',getappdata(prinobj,'payprin')),end
      setappdata(conobj,'reccon',get(conobj,'String'))
      if ~isempty(getappdata(conobj,'paycon')),set(conobj,'String',getappdata(conobj,'paycon')),end
      setappdata(couobj,'reccon',get(couobj,'String'))
      set(couobj,'String',getappdata(couobj,'paycou'))
      setappdata(stobj,'rectype',abs(stval-2))
      set(stobj,'Value',abs(getappdata(stobj,'paytype')-2))
      setappdata(perobj,'recper',legper)
      payper = getappdata(perobj,'payper');
      p = find(payper == [1,2,3,4,6,12]);
      if isempty(p),p = 1;end
      set(perobj,'Value',p)
      
    elseif j == 2   %Receive is selected button tab
      set(pobj,'Position',[posp(1) max([posp(2) posr(2)]) posp(3) posp(4)])
      set(robj,'Position',[posr(1) min([posr(2) posp(2)]) posr(3) posr(4)])
      set(tobj,'Position',[posr(1) post(2) post(3) post(4)])
      setappdata(startobj,'paystart',get(startobj,'String'))
      if ~isempty(getappdata(startobj,'recstart')),set(startobj,'String',getappdata(startobj,'recstart')),end
      setappdata(matobj,'paymat',get(matobj,'String'))
      if ~isempty(getappdata(matobj,'recmat')),set(matobj,'String',getappdata(matobj,'recmat')),end
      setappdata(prinobj,'payprin',get(prinobj,'String'))
      if ~isempty(getappdata(prinobj,'recprin')),set(prinobj,'String',getappdata(prinobj,'recprin')),end
      setappdata(conobj,'paycon',get(conobj,'String'))
      if ~isempty(getappdata(conobj,'reccon')),set(conobj,'String',getappdata(conobj,'reccon')),end
      setappdata(couobj,'paycon',get(couobj,'String'))
      set(couobj,'String',getappdata(couobj,'reccou'))
      setappdata(stobj,'paytype',abs(stval-2))
      set(stobj,'Value',abs(getappdata(stobj,'rectype')-2))
      setappdata(perobj,'payper',legper)
      recper = getappdata(perobj,'recper');
      p = find(recper == [1,2,3,4,6,12]);
      if isempty(p),p = 1;end
      set(perobj,'Value',p)

    end
    
    derivtool('swaptype')
    
  case 'swaptype'
    
    stobj = findobj(gcf,'Tag','swaptype');
    stval = get(stobj,'Value');
    if stval == 1
      set(findobj(gcf,'String','Spread:'),'String','Coupon:')
    elseif stval == 2
      set(findobj(gcf,'String','Coupon:'),'String','Spread:')
    end
    
    %Find Pay and Receive tabs
    paytab = findobj(gcf,'String','Pay');
    rectab = findobj(gcf,'String','Receive');
    pos = [get(paytab,'Position');get(rectab,'Position')];
    d = pos(1,:) - pos(2,:);
    
    if d(2) < 0   %Pay leg
      setappdata(stobj,'paytype',abs(stval-2));
    else %Receive leg
      setappdata(stobj,'rectype',abs(stval-2));
    end
    
  case 'radiobutton'
    
    t = get(gcbo,'Tag');
    if isempty(t)
      t = tabid;
    end
    if isempty(gcbo) | strcmp(get(gcbo,'Type'),'uimenu')
      cbobj = findobj(gcf,'Tag',t,'Value',1);
    else
      cbobj = gcbo;  
    end
    r = findobj(gcf,'Tag',t);
    set(r,'Value',0);
    set(cbobj,'Value',1)
    rstr = get(cbobj,'String');
    
    switch rstr    %Option radio buttons
      
      case {'Call','Put'}
        
        set(findobj('Type','Figure'),'Pointer','Arrow')
        return
        
      case {'European'}
          
        set(findobj(gcf,'String','Start:'),'Enable','off')
        set(findobj(gcf,'Tag','start'),'Enable','off')
        set(findobj('Type','Figure'),'Pointer','Arrow')
        return
        
      case {'American'}
          
        set(findobj(gcf,'String','Start:'),'Enable','on')
        set(findobj(gcf,'Tag','start'),'Enable','on')
        set(findobj('Type','Figure'),'Pointer','Arrow')
        return
          
    end
    
    %Continue for more complex actions in Initial Curve Window and Tree Viewer
    HJMTree = get(gcf,'Userdata');
    wstr = warning;
    warning off
    rflag = getcurvetype;
    warning(wstr)
    Rates = intenvget(HJMTree.RateSpec, 'Rates');    
    
    switch rstr
      
      case {'Maturity dates','Start dates'}
        
        if strcmp(rstr,'Maturity dates')
          dflg = 'EndDates';
        else
          dflg = 'StartDates';
        end
        
        Dates = intenvget(HJMTree.RateSpec, dflg);
        
        if strcmp(dflg,'StartDates')   %Zero and Cascade dates are special for StartDates
          if ~isempty(findobj(gcf,'String','Zero','Value',1))
            Dates(1:length(Dates)) = HJMTree.RateSpec.ValuationDate;
          elseif ~isempty(findobj(gcf,'String','Cascade','Value',1))
            % Find the "cascaded" dates
            EndDates = intenvget(HJMTree.RateSpec, 'EndDates');
            Dates = [intenvget(HJMTree.RateSpec, 'ValuationDate'); EndDates(1:end-1)];
          end
        end
        
        DatesStringVect = datestr(Dates, 1);
        du = findobj(gcf,'Tag','CurveDates');
        set(du,'String','')
        set(du(1:length(Dates)),{'String'},cellstr(DatesStringVect))
                
      case {'Cascade','Forward Term','Times','Zero'}
        
        switch rstr
        
          case 'Cascade'
          
            % Save the old start dates:
            StartDatesOld = intenvget(HJMTree.RateSpec, 'StartDates');

            % Find the "cascaded" dates and set them:
            EndDates = intenvget(HJMTree.RateSpec, 'EndDates');
            StartDatesNew = [intenvget(HJMTree.RateSpec, 'ValuationDate'); EndDates(1:end-1)];
            HJMTree.RateSpec = intenvset(HJMTree.RateSpec, 'StartDates', StartDatesNew);
          
            % Find new tree
            HJMTree = hjmtree(HJMTree.VolSpec, HJMTree.RateSpec, HJMTree.TimeSpec);  
            Rates = intenvget(HJMTree.RateSpec, 'Rates');
            rflag = 1;
            
          case 'Zero'
            
            %Save old start dates
            StartDatesOld = intenvget(HJMTree.RateSpec, 'StartDates');
            HJMTree.RateSpec = intenvset(HJMTree.RateSpec, 'StartDates',...
              HJMTree.RateSpec.ValuationDate);
            Rates = intenvget(HJMTree.RateSpec, 'Rates');
            EndDates = intenvget(HJMTree.RateSpec, 'EndDates');
            StartDates = intenvget(HJMTree.RateSpec, 'StartDates');
            StartDates = StartDates(ones(length(EndDates),1),:);
            rflag = 1;
            
        end
          
        if findobj(gcf,'String','Times','Value',1)
          ratedisplay(Rates,HJMTree,rflag);
        else
          plotrates(HJMTree,rflag)    
        end
        
      case 'Curve'
        
        plotrates(HJMTree,rflag) 
        
      case {'Path','Table'}
        
        %Enable Data/Plot choice
        set(findobj(gcf,'Tag','treeradio'),'Enable','on')
        
        %Get axes handle
        ChooserH = findobj(gcf,'Tag','Chooser');

        %Display data uicontrols if Data button chosen, otherwise do leave display alone
        if findobj(gcf,'String','Table','Value',1)
          set(findobj(gcf,'Userdata','pathtoroot'),'Visible','on')
          set(findobj(gcf,'Userdata','nodeandchildren'),'Visible','off')
          set(get(findobj(gcf,'Tag','treeplot'),'Children'),'Visible','off')
        end
                             
        if strcmp(rstr,'Path')
          
          setappdata(ChooserH,'CurrentPathNumber',0)    %Reset path to PathOne

          %Set selection mode of nodes
          %Clear any previous plots in Plot display window and previous paths
          aobj = findobj(gcf,'Tag','treeplot');
          delete(get(aobj,'Children'))
          pathobjs = [findobj(gcf,'Userdata','PathOne');...
              findobj(gcf,'Userdata','PathTwo');...
              findobj(gcf,'Userdata','NodeChildren')];
          set(pathobjs,'Userdata',[],'Color',[0 .5 0],'Markerfacecolor','none',...
            'Markeredgecolor',[0 0 1],'Linewidth',1)
          bushguistate('clear',ChooserH); % clear all selections
          if get(findobj(gcf,'String','Path'),'Value')
            setappdata(ChooserH, 'HighlightMode', 'path' );
          else
            setappdata(ChooserH,'HighlightMode','node');
          end
                
          %Set colors for paths, (taken from bushguistate)
          ColorOrder = get(gca,'ColorOrder');
          ColorOrder(3:4,:) = [ColorOne;ColorTwo];
          ColorOrder(5:end,:) = [];

          ColorState = ColorOrder(1,:); % Color of state markers
          ColorLine = ColorOrder(2,:);  % Color of unselected lines connecting states
          ColorSelectOrder = ColorOrder(3:end,:); % Colors available for selection
          ColorSelectInd = 1; % Location of next color in ColorSelectOrder
    
          setappdata(ChooserH, 'ColorState', ColorState);
          setappdata(ChooserH, 'ColorLine',  ColorLine);
          setappdata(ChooserH, 'ColorSelectOrder', ColorSelectOrder);
          setappdata(ChooserH, 'ColorSelectInd',   ColorSelectInd);
        
        end
                       
      case {'Node and Children','Diagram','Plot'}  
        
        ChooserH = findobj(gcf,'Tag','Chooser');

        %Disable display option for node and children
        if strcmp(rstr,'Node and Children')          
          set(findobj(gcf,'Tag','treeradio'),'Enable','off')
          set(findobj(gcf,'String','Table'),'Value',0)
          set(findobj(gcf,'String','Diagram'),'Enable','off','Value',1)
          set(findobj(gcf,'String','Plot'),'Enable','off','Value',0)
          
          %Clear any previous plots in Plot display window and previous paths
          aobj = findobj(gcf,'Tag','treeplot');
          delete(get(aobj,'Children'))
          pathobjs = [findobj(gcf,'Userdata','PathOne');...
              findobj(gcf,'Userdata','PathTwo');...
              findobj(gcf,'Userdata','NodeChildren')];
          set(pathobjs,'Userdata',[],'Color',[0 .5 0],'Markerfacecolor','none',...
            'Markeredgecolor',[0 0 1],'Linewidth',1)
          bushguistate('clear',ChooserH); % clear all selections
        end  
        
        set(findobj(gcf,'Userdata','pathtoroot'),'Visible','off')
        set(findobj(gcf,'Userdata','nodeandchildren'),'Visible','on')
               
        if ~any(strcmp(rstr,{'Diagram','Plot'}))
          setappdata(ChooserH,'CurrentPathNumber',0)    %Reset path to PathOne
        end  
        
        %Set selection mode of nodes
        if get(findobj(gcf,'String','Path'),'Value')
          setappdata(ChooserH, 'HighlightMode', 'path' );
        else
          setappdata(ChooserH,'HighlightMode','node');
        end
        
        %Path colors, Node and children uses one color only
        if isempty(findobj(gcf,'String','Path','Value',1))  
          ColorOrder = get(gca,'ColorOrder');
          ColorOrder(3,:) = ColorThree;
          ColorOrder(4:end,:) = [];
          ColorState = ColorOrder(1,:); % Color of state markers
          ColorLine = ColorOrder(2,:);  % Color of unselected lines connecting states
          ColorSelectOrder = ColorOrder(3:end,:); % Colors available for selection
          ColorSelectInd = 1; % Location of next color in ColorSelectOrde
          setappdata(ChooserH, 'ColorState', ColorState);
          setappdata(ChooserH, 'ColorLine',  ColorLine);
          setappdata(ChooserH, 'ColorSelectOrder', ColorSelectOrder);
          setappdata(ChooserH, 'ColorSelectInd',   ColorSelectInd);    
                
         %Turn off PathOne and PathTwo
         pobj = [findobj(gca,'Userdata','PathOne');findobj(gca,'Userdata','PathTwo')];
         set(pobj,'Linewidth',1,'Color',ColorOrder(2,:),'Markerfacecolor','none',...
           'Markeredgecolor',ColorOrder(1,:))
         set(findobj(gca,'Linewidth',2),'Linewidth',1)
        
       end
       
       if any(strcmp(rstr,{'Diagram','Plot'}))
         
         if isempty(findobj(gcf,'String','Node and Children','Value',1))
           
           %Get price and tree data
           P = getappdata(gcf,'PriceData');
           Tree = getappdata(gcf,'TreeData');
           
           rflag = isempty(findobj(gcf,'Tag','treeinstruments'));
           if isempty(P) & ~rflag
             %No paths to move
             set(findobj('Type','figure'),'Pointer','arrow')
             return
           end
           
           %Get existing price text 
           aobj = findobj(gcf,'Tag','treeplot');
           tobj = findobj(aobj,'Type','text');
           pstr = get(tobj,'String');
                      
           %Get paths
           poobj = findobj(ChooserH,'UserData','PathOne');
           ptobj = findobj(ChooserH,'UserData','PathTwo');
           
           %Get ydata
           poydat = get(poobj,'Ydata');
           ptydat = get(ptobj,'Ydata');
                                
           %Get number of path one and path two objects
           numpo = length(poobj);
           numpt = length(ptobj);
           
           %Get new path one and path objects
           newpoobj = findobj(aobj,'Userdata','PathOne','Linewidth',2);
           newptobj = findobj(aobj,'Userdata','PathTwo','Linewidth',2);
           
           %Build ydata and text positions
           switch rstr
             
             case 'Diagram'
               
               lyo = length(poydat);
               if lyo > 1
                 poydat = [poydat(1);flipud(poydat(2:end))];
               end
               lyt = length(ptydat);
               if lyt > 1
                 ptydat = [ptydat(1);flipud(ptydat(2:end))];
               end
               
               try
                 todat(1) = poydat{2}(1);
                 for i = 2:length(poydat)
                   todat(i) = poydat{i}(2);
                 end
               catch
                 todat = poydat;
               end
               
               try
                 ttdat(1) = ptydat{2}(1);
                 for i = 2:length(ptydat)
                   ttdat(i) = ptydat{i}(2);
                 end
               catch
                 ttdat = ptydat;
               end

               alldat = [todat(:);ttdat(:)];
               
               ylim = [min(alldat)-0.05 max(alldat)+0.05];

             case 'Plot'
               
               %Get current path to determine how price data is order
               curpath = getappdata(ChooserH,'CurrentPathNumber');
               
               %Convert price strings to numbers
               pdat = str2num(char(pstr));
               
               lpo = length(newpoobj);
               lpt = length(newptobj);
               
               poydat = [];
               ptydat = [];
               if curpath   %PathOne
                 pdat(1:lpo) = pdat(lpo:-1:1);
                 for i = 1:lpo
                   if strcmp(get(newpoobj(i),'Marker'),'o')    %Set PathOne ydata
                     try, poydat{i} = pdat(lpo); catch, poydat(i) = pdat(lpo); end
                   else
                     poydat{i} = [pdat(i-1) pdat(i)];
                   end
                 end
                 pdat(lpo+1:lpo+lpt) = pdat(lpo+lpt:-1:lpo+1);
                 for i = lpt:-1:1
                   if strcmp(get(newptobj(i),'Marker'),'o')    %Set PathTwo ydata
                     try, ptydat{i} = pdat(lpo+lpt); catch, ptydat(i) = pdat(lpo+lpt); end
                   else
                     ptydat{i} = [pdat(i-1+lpo) pdat(i+lpo)];
                   end
                 end
                 
                 todat = pdat(1:lpo);
                 ttdat = pdat(1+lpo:lpt+lpo);
                 
               else    %PathTwo
                 pdat(1:lpt) = pdat(lpt:-1:1);
                 for i = lpt:-1:1
                   if strcmp(get(newptobj(i),'Marker'),'o')    %Set PathTwo ydata
                     try, ptydat{i} = pdat(lpt); catch, ptydat(i) = pdat(lpt); end
                   else
                     ptydat{i} = [pdat(i-1) pdat(i)];
                   end
                 end
                 pdat(lpt+1:lpt+lpo) = pdat(lpt+lpo:-1:lpt+1);
                 for i = lpo:-1:1
                   if strcmp(get(newpoobj(i),'Marker'),'o')    %Set PathOne ydata
                     try, poydat{i} = pdat(lpt+lpo); catch, poydat(i) = pdat(lpt+lpo); end
                   else
                     poydat{i} = [pdat(i-1+lpt) pdat(i+lpt)];
                   end
                 end
                 
                 ttdat = pdat(1:lpt);
                 todat = pdat(1+lpt:lpo+lpt);
                                  
               end
               
               ylim = [min(pdat)-5 max(pdat)+5];
               
               if rflag   %Adjust ylimit settings for interest rate values
                 ylim = [min(pdat)-0.05 max(pdat)+0.05]; 
               end
               
           end
           
           if isempty(ylim)   %No paths to display
             set(findobj('Type','figure'),'Pointer','arrow')
             return
           end
           
           %Check length mismatches between visible objects and ydata
           lpo = length(newpoobj);
           lyo = length(poydat);
           lpt = length(newptobj);
           lyt = length(ptydat);
           if lyo == 0   %Node of PathOne is hidden
             poydat = ptydat;
             todat = ttdat;
           end
           if lyt == 0   %Node of PathTwo is hidden
             ptydat = poydat;
             ttdat = todat;
           end
           if lpo ~= lyo & lyo ~= 0  %Fill missing pieces of PathOne
             try
               poydat = [poydat(1);ptydat(2:2+(lpo-lyo-1));poydat(2:end)];
             catch
               poydat = [{poydat(1)};ptydat(2:2+(lpo-lyo-1))];
             end
             todat = [ttdat(1:lpo-lyo)';todat(:)];
           end
           if lpt ~= lyt & lyt ~= 0    %Fill missing pieces of PathTwo
             try
               ptydat = [ptydat(1);poydat(2:2+(lpt-lyt-1));ptydat(2:end)];
             catch
               ptydat = [{ptydat(1)};poydat(2:2+(lpt-lyt-1))];
             end
             ttdat = [todat(1:lpt-lyt)';ttdat(:)];
           end
           
           try, set(newpoobj,{'Ydata'},poydat(:)), catch, set(newpoobj,'Ydata',poydat), end
           try, set(newptobj,{'Ydata'},ptydat(:)), catch, set(newptobj,'Ydata',ptydat), end
           
           %Reset y position of text objects
           toobj = sort(findobj(aobj,'Type','text','Tag','PathOne'));
           ttobj = sort(findobj(aobj,'Type','text','Tag','PathTwo'));
           for i = 1:length(toobj)
             p = get(toobj(i),'Position');
             set(toobj(i),'Position',[p(1) todat(i) p(3)])
           end
           for i = 1:length(ttobj)
             p = get(ttobj(i),'Position');
             set(ttobj(i),'Position',[p(1) ttdat(i) p(3)])
           end

         end
         
         set([newpoobj;newptobj;toobj;ttobj],'Visible','on')
         set(aobj,'Ylim',ylim)
         
       end
     end
                 
  case 'sensitivity'
    
    %Get selected sensitivities
    sensvals = getappdata(gcf,'DeltaGammaVega');

    %Build sensitivity dialog
    h = dialog('Name','Sensitivities');
    [bspc,bwid,bhgt] = spacing;
    uicontrol('Enable','off','Position',[bspc bspc 2*bspc+1.5*bwid 10*bspc+7*bhgt]);
    p = get(gcf,'Position');
    set(gcf,'Position',[p(1) p(2) 4*bspc+1.5*bwid 12*bspc+7*bhgt])
    
    %Pushbutton uicontrols
    uicontrol('String','Help','Callback','derivtool(''help'',''sensitivities'')',...
      'Position',[2*bspc+0.25*bwid 5*bspc+3*bhgt bwid bhgt]);
    uicontrol('String','Defaults','Callback','derivtool(''sensdefault'')',...
      'Tooltip','Set default sensitivity values',...  
      'Position',[2*bspc+0.25*bwid 4*bspc+2*bhgt bwid bhgt]);
    uicontrol('String','OK','Callback','derivtool(''sensclose'')',...
      'Tooltip','Close window and accept settings',...  
      'Position',[2*bspc+0.25*bwid 3*bspc+bhgt bwid bhgt]);
    uicontrol('String','Cancel','Callback','close',...
        'Tooltip','Close window and revert to previous settings',...
		'Position',[2*bspc+0.25*bwid 2*bspc bwid bhgt]);
      
    %Checkboxes
    if ~isempty(findobj(findobj('Tag','HJMDLG'),'Label','Zero Curve','Checked','on'))
      vegaenable = 'off';
    else
      vegaenable = 'on';
    end
    uicontrol('Style','frame','Position',[2*bspc 6*bspc+4*bhgt 1.5*bwid 4*bspc+3*bhgt]);
    uicontrol('Style','checkbox','String','Vega','Tag','vega','Value',sensvals(3),...
      'Enable',vegaenable,'Position',[2*bspc+0.25*bwid 7*bspc+4*bhgt bwid bhgt]);
    uicontrol('Style','checkbox','String','Gamma','Tag','gamma','Value',sensvals(2),...
      'Position',[2*bspc+0.25*bwid 8*bspc+5*bhgt bwid bhgt]);
    uicontrol('Style','checkbox','String','Delta','Tag','delta','Value',sensvals(1),...
      'Position',[2*bspc+0.25*bwid 9*bspc+6*bhgt bwid bhgt]);
    
  case 'sensclose'
    
    %Get selected sensitivities
    dval = get(findobj(gcf,'Tag','delta'),'Value');
    gval = get(findobj(gcf,'Tag','gamma'),'Value');
    vval = get(findobj(gcf,'Tag','vega'),'Value');
    close(gcf)
    
    figure(findobj('Tag','HJMDLG'));
    
    setappdata(gcf,'DeltaGammaVega',[dval gval vval])

  case 'sensdefault'
    
    %Set default sensitivity selections 
    set([findobj(gcf,'Tag','vega') findobj(gcf,'Tag','gamma') findobj(gcf,'Tag','delta')],...
      'Value',0)
    
  case 'model'
    
    %Check item
    set(findobj(gcf,'Tag','model'),'Checked','off')
    set(gcbo,'Checked','on')
    l = get(gcbo,'Label');
    
    %Enable/disable menu settings based on chosen model
    mstr = get(gcbo,'Label');
    if strcmp(mstr,'HJM')
      set([findobj(gcf,'Label','Tree Construction');findobj(gcf,'Label','Volatility Model')],'Enable','on')
      set(findobj(gcf,'Label','&View'),'Enable','on')
      if ~isempty(findobj(gcf,'Label','Hedge','Enable','on'))
        set(findobj(gcf,'Style','pushbutton','String','View Tree'),'Enable','on')
      end
    else
      set([findobj(gcf,'Label','Tree Construction');findobj(gcf,'Label','Volatility Model')],'Enable','off')
      set(findobj(gcf,'Label','&View'),'Enable','off')  
      set(findobj(gcf,'Style','pushbutton','String','View Tree'),'Enable','off')
      sensvals = getappdata(gcf,'DeltaGammaVega');
      sensvals(3) = 0;
      setappdata(gcf,'DeltaGammaVega',sensvals)
    end
   
  case 'modelextract'
    
    %Get model parameters from tab
    %Get previous tab
    modval = getappdata(gcf,'PreviousModelValue');
    
    %Get hjmvolspec input string
    volstr = getappdata(gcf,'HJMVolSpecInput');
    
    %Get data from previous tab
    mtobj = findobj(gcf,'Tag','modeltype');
    mtval = get(mtobj,'Value');
    mtstr = get(mtobj,'String');
    newmodeltype = mtstr{mtval};
    
    switch newmodeltype
        
        case 'Constant'
         
          volstr{modval} = ['''Constant'',' get(findobj(gcf,'Tag','sigma'),'String')];
        
        case 'Exponential'
          
          volstr{modval} = ['''Exponential'',' get(findobj(gcf,'Tag','sigma'),'String') ',' ...
                get(findobj(gcf,'Tag','lambda'),'String')];
            
        case {'Proportional','Stationary','Vasicek'}
          
          %Get Forward Term
          VMPeriod = getappdata(gcf,'VMPeriod');
          
          tobj = findobj(gcf,'Tag','term');
          tstr = get(tobj,'String');
          sgobj = findobj(gcf,'Tag','sigmas');
          sgstr = get(sgobj,'String');
          ter = [];sig = [];
          for i = 1:length(tstr)
            if ~isempty(tstr{i})
              ter = [ter num2str(str2double(tstr{i})/VMPeriod) ' '];
              sig = [sig sgstr{i} ' '];
            end
          end
          
          if strcmp(newmodeltype,'Vasicek')
            volstr{modval} = ['''Vasicek'',' get(findobj(gcf,'Tag','sigma'),'String') ',' ...
                '[' sig ']'',[' ter ']'];
          else
            volstr{modval} = ['''Proportional'',[' sig ']'',[' ter '],1e6'];
          end
                    
    end
      
    setappdata(gcf,'HJMVolSpecInput',volstr) 
      
  case 'modelfill'
      
    %Fill current tab with corresponding model
    
    %Get current model number from selected tab
    modval = str2num(tabid(8));
    
    %Get current volspecinput string
    volstr = getappdata(gcf,'HJMVolSpecInput');
    
    if length(volstr) < modval
      
      set(findobj(gcf,'Tag','modeltype'),'Value',1)
         
    else
      
      %Extract model
      modstr = volstr{modval};
      i = find(modstr == ',');
      modeltype = modstr(2:i(1)-2);
      
      %Extract parameters based on modeltype
      switch modeltype
        
        case 'Constant'
          
          %Get sigma
          sigs = modstr(i(1)+1:length(modstr));
          set(findobj(gcf,'Tag','sigma'),'String',sigs)
          
        case 'Exponential'
          
          %Get sigma
          sigs = modstr(i(1)+1:i(2)-1);
          set(findobj(gcf,'Tag','sigma'),'String',sigs)
          
          %Get lambda
          lams = modstr(i(2)+1:length(modstr));
          set(findobj(gcf,'Tag','lambda'),'String',lams)
          
        case {'Proportional','Stationary'}
          
          %Get Forward Term
          VMPeriod = getappdata(gcf,'VMPeriod');
          
          %Get sigma values
          eval(['sigs = cellstr(num2str(' modstr(i(1)+1:i(2)-1) '));'])
          eval(['ters = cellstr(num2str(' modstr(i(2)+1:i(3)-1)  ''' * VMPeriod));'])
          
          %Fill uicontrols
          tobj = findobj(gcf,'Tag','term');
          set(tobj(1:length(ters)),{'String'},ters)
          sobj = findobj(gcf,'Tag','sigmas');
          set(sobj(1:length(sigs)),{'String'},sigs)

        case 'Vasicek'
          
          %Get sigma
          sigs = modstr(i(1)+1:i(2)-1);
          set(findobj(gcf,'Tag','sigma'),'String',sigs)
          
          %Get sigma values
          eval(['sigs = cellstr(num2str(' modstr(i(2)+1:i(3)-1) '));'])
          eval(['ters = cellstr(num2str(' modstr(i(3)+1:length(modstr)) '''));'])
          
          %Fill uicontrols
          tobj = findobj(gcf,'Tag','term');
          set(tobj(1:length(ters)),{'String'},ters)
          sobj = findobj(gcf,'Tag','sigmas');
          set(sobj(1:length(sigs)),{'String'},sigs)

      end
      
      %Display model
      modeltypes = {'Constant','Exponential','Proportional','Stationary','Vasicek'};
      i = find(strcmp(modeltype,modeltypes));
      set(findobj(gcf,'Tag','modeltype'),'Value',i)

    end
    
    derivtool('modeltype')
    
  case 'modelstring'
    
    %Build input string for hjmvolspec
    
    %Get HJMTree
    HJMTree = get(gcf,'Userdata');
        
    %Extract models, parameters and build string
    for i = 1:HJMTree.VolSpec.NumFactors
        
      modeltype = HJMTree.VolSpec.FactorModels{i};
        
      switch modeltype
          
        case 'Constant'
            
          volstr{i} = ['''Constant'',' num2str(HJMTree.VolSpec.FactorArgs{i}{1})];
            
        case 'Exponential'
            
          volstr{i} = ['''Exponential'',' num2str(HJMTree.VolSpec.FactorArgs{i}{1}) ',' ...
                num2str(HJMTree.VolSpec.FactorArgs{i}{2})];
            
        case {'Proportional','Stationary'}
            
          tmpsig = HJMTree.VolSpec.FactorArgs{i}{1}';
          volstr{i} = ['''' modeltype ''',[' num2str(tmpsig(:)') ']'',[' ...
                num2str(HJMTree.VolSpec.FactorArgs{i}{2}) '],' ...
                num2str(HJMTree.VolSpec.FactorArgs{i}{3})];
            
        case 'Vasicek'
            
          volstr{i} = ['''Vasicek'',[' num2str(HJMTree.VolSpec.FactorArgs{i}{1}) '],[' ...
                num2str(HJMTree.VolSpec.FactorArgs{i}{2}) ']'',[' ...
                num2str(HJMTree.VolSpec.FactorArgs{i}{3}) ']'];
            
      end
      
    end 
    
    %Store hjmvolspec input
    setappdata(gcf,'HJMVolSpecInput',volstr)
    
  case 'modeltab'
    
    %Get previous model tab and extract model parameters
    pmval = getappdata(gcf,'PreviousModelValue');
    if ~isempty(pmval)
      
      derivtool('modelextract')
      
    end
    
    %Identify selected tab
    curobj = findobj(gcf,'String',tabid);
    
    p = get(gcf,'Position');
    [x(1) x(2) x(3)] = spacing;
    bspc = x(1)/p(4);
    bhgt = x(3)/p(4);
    
    %Get tab objects and modify positions
    mobj = findobj(gcf,'Userdata','modeltab');
    for i = 1:length(mobj)
      p = get(mobj(i),'Position');
      set(mobj(i),'Position',[p(1) 4*bspc+bhgt p(3) p(4)])
    end
    p = get(curobj,'Position');
    set(curobj,'Position',[p(1) 3*bspc+bhgt p(3) p(4)])
    tobj = findobj(gcf,'Tag','tabtext');
    tpos = get(tobj,'Position');
    set(tobj,'Position',[p(1) tpos(2) tpos(3) tpos(4)])
    
    %Fill tab with current model
    derivtool('modelfill',tabid)       
    
    %Store last model number
    setappdata(gcf,'PreviousModelValue',str2double(tabid(8)))
    
  case 'modeltype'
    
    %Display model components
    mobj = findobj(gcf,'Tag','modeltype');
    mstr = get(mobj,'String');
    mval = get(mobj,'Value');
    model = mstr{mval};
    
    sobj = findobj(gcf,'Userdata','sigma');
    lobj = findobj(gcf,'Userdata','lambda');
    tobj = findobj(gcf,'Userdata','term');
    sgobj = findobj(gcf,'Userdata','sigmas');
    
    set([sobj;lobj;tobj;sgobj],'Visible','off')
       
    switch model
      
      case 'Constant'
      
        set(sobj,'Visible','on')
                 
      case 'Exponential'
        
        set([sobj;lobj],'Visible','on')
                  
      case {'Proportional','Stationary'}
        
        set([tobj;sgobj],'Visible','on')
        
      case 'Vasicek'
        
        set([sobj;tobj;sgobj],'Visible','on')
        
    end
    
  case 'nofradio'
    
    %Number of Factors radio button callback (Volatility Model dialog)
    
    %Set button values
    set(findobj(gcf,'Tag','nofradio'),'Value',0)
    set(gcbo,'Value',1)
    
    %Enable/disable model tabs, make correct visual settings
    fstr = get(gcbo,'String');
    t2obj = findobj(gcf,'String','Factor 2');
    t3obj = findobj(gcf,'String','Factor 3');
    set(t2obj,'Enable','inactive','Buttondownfcn','derivtool(''modeltab'',''Factor 2'')')
    set(t3obj,'Enable','inactive','Buttondownfcn','derivtool(''modeltab'',''Factor 3'')')
    
    if strcmp(fstr,'One')
      set([t2obj;t3obj],'Enable','off','Buttondownfcn','')
      derivtool('modeltab','Factor 1')
    elseif strcmp(fstr,'Two')
      set(t3obj,'Enable','off','Buttondownfcn','')
      derivtool('modeltab','Factor 2')
    else
      derivtool('modeltab','Factor 3')
    end
      
  case 'portfolioopen'
    
    %Open portfolio file
    [f p] = uigetfile('*.mat','Open Portfolio File...');
    if f
      eval(['load ' p f])
    end
    
    try
      tobj = findobj(gcf,'Tag','totals');
      
      %Build instrument descriptions
      updateportfolio(HJMInstSet,HJMTree,0);
      setappdata(gcf,'HJMTREE',HJMTree)
      
    catch
      
      errordlg('Unable to open or invalid portfolio file.')
      
    end
    
  case 'portfoliosave'
    
    %Save portfolio information
    [f p] = uiputfile('*.mat','Save Portfolio File...');
    
    if f  
      HJMInstSet = get(portobj,'Userdata');
	  HJMTree = getappdata(gcf,'HJMTREE');
      eval(['save ' p f ' HJMInstSet HJMTree']);
    end
    
  case 'restore'
    
    delete(gcf)
    derivtool('hedge')
    
  case 'priceportfolio'
    
    try
    
      %Get Portfolio and HJMTree
      Port = get(portobj,'Userdata');
   
      if ~isempty(Port)
        HJMTree = getappdata(gcf,'HJMTREE');
    
        %Set pricing flag
        setappdata(gcf,'PriceFlag',1)
    
        %Enable Hedge menu choice
        if any(getappdata(gcf,'DeltaGammaVega'))
          set(findobj(gcf,'Type','uimenu','Label','Hedge'),'Enable','on')
        end
          
        %Calculate prices, etc.
        updateportfolio(Port,HJMTree,1)
      
      else
      
        errordlg('No portfolio loaded.')
      
      end
    
      %Enable tree viewing
      if isempty(findobj(gcf,'Label','Zero Curve','Checked','on'))
        set(findobj('String','View Tree'),'Enable','on')
      end

    catch
        
      errordlg(lasterr)
      set(findobj('Type','figure'),'Pointer','arrow')
     
    end
    
  case 'scenario'
    
    %Data for gui display
    HJMTree = getappdata(gcf,'HJMTREE');
    Rates = intenvget(HJMTree.RateSpec, 'Rates');
    StartDates   = intenvget(HJMTree.RateSpec, 'StartDates');
    StartDatesStringVect = datestr(StartDates, 1);
    ValuationDate = datestr(intenvget(HJMTree.RateSpec,'ValuationDate'));
    Compounding = intenvget(HJMTree.RateSpec, 'Compounding');
    comuival = find(Compounding == [1 2 3 4 6 12 365]);
    
    %Open Initial Curve dialog
    h = dialog('Name','Initial Curve','Userdata',HJMTree);
    [bspc,bwid,bhgt] = spacing;
    p = get(h,'Position');
    rgt = p(3);
    top = p(4);
    
    uicontrol('Style','frame','Position',[2*bspc bspc+bhgt 3*bspc+2.5*bwid 9*bspc+14*bhgt]);
    
    %Cancel, OK buttons, Restore, Apply
    uicontrol('String','Cancel','Callback','close',...
      'Tooltip','Close window and revert to previous curve settings',...
      'Position',[rgt-(2*bspc+.85*bwid) 2*bspc .85*bwid bhgt]);
  	uicontrol('String','OK','Callback','derivtool(''curveok'')',...
      'Tooltip','Close window and accept curve settings',...  
      'Position',[rgt-(3*bspc+1.7*bwid) 2*bspc .85*bwid bhgt]);
  	uicontrol('String','Restore','Callback','derivtool(''curverestore'')',...
      'Tooltip','Revert to previous curve settings',...
      'Position',[rgt- (4*bspc+2.55*bwid) 2*bspc .85*bwid bhgt]);
    uicontrol('String','Help','Callback','derivtool(''help'',''initial'')',...
      'Position',[rgt-(5*bspc+3.4*bwid) 2*bspc .85*bwid bhgt]);    
  
  	uicontrol('String','Apply','Callback','derivtool(''updaterates'')',...
      'Tooltip','Accept new curve data',...
      'Position',[rgt-(2*bspc+5.5*bwid) 2*bspc+bhgt bwid bhgt]);
           
    %Build/fill rates and dates boxes
    for i = 1:10
      du(i) = uicontrol('Style','edit','Tag','CurveDates','String','',...
        'Position',[3*bspc 4*bspc+(2+i-1)*bhgt 1.25*bwid bhgt]);
      ru(i) = uicontrol('Style','edit','Tag','CurveRates','String','',...
        'Userdata',11-i,...
        'Position',[4*bspc+1.25*bwid 4*bspc+(2+i-1)*bhgt 1.25*bwid bhgt]);
    end
    set(flipud(du(10:-1:11-size(StartDatesStringVect,1))),{'String'},cellstr(StartDatesStringVect))
    set(flipud(ru(10:-1:11-size(Rates,1))),{'String'},cellstr(num2str(Rates)))

    uicontrol('Style','text','String','Dates',...
      'Position',[3*bspc 4*bspc+12*bhgt bwid bhgt]);
    uicontrol('Style','text','String','Rates',...
      'Position',[4*bspc+1.25*bwid 4*bspc+12*bhgt bwid bhgt]);
    uicontrol('Style','radiobutton','String','Maturity dates','Tag','curvedates',...
      'Callback','derivtool(''radiobutton'')',...
      'Position',[5*bspc+bwid 5*bspc+13*bhgt bwid bhgt]);
    uicontrol('Style','radiobutton','String','Start dates','Tag','curvedates',...
      'Callback','derivtool(''radiobutton'')',...
      'Value',1,'Position',[4*bspc 5*bspc+13*bhgt bwid bhgt]);
    uicontrol('Style','text','String','Analysis Date:',...
      'Position',[4*bspc 6*bspc+14*bhgt bwid bhgt]);
    uicontrol('Style','edit','String',ValuationDate,'Tag','analysisdate',...
      'Callback','derivtool(''forwardterm'')',...
      'Position',[5*bspc+bwid 7*bspc+14*bhgt bwid bhgt]);
    uicontrol('Style','text','String','Curve Data',...
      'Position',[3*bspc 7*bspc+15*bhgt bwid bhgt]);
    axes('Tag','Curves','Box','on','Position',[.5 .138 .45 .475]);
    
    %Build forward rates display data
    ratedisplay(Rates,HJMTree,1);

    uicontrol('Style','radiobutton','String','Times','Tag','timescurves',...
      'Callback','derivtool(''radiobutton'')',...
      'Value',1,'Position',[5*bspc+3.5*bwid 5*bspc+12*bhgt bwid bhgt]);
    uicontrol('Style','radiobutton','String','Curve','Tag','timescurves',...
      'Callback','derivtool(''radiobutton'')',...
      'Value',0,'Position',[5*bspc+4.5*bwid 5*bspc+12*bhgt bwid bhgt]);
    uicontrol('Style','text','String','Compounding:',...
      'Position',[7*bspc+2.5*bwid 6*bspc+14*bhgt bwid bhgt]);
    uicontrol('Style','popupmenu','String',{'1';'2';'3';'4';'6';'12';'365'},...
      'Callback','derivtool(''compounding'')','Value',comuival,...
      'Tag','Compounding','Position',[8*bspc+3.5*bwid 7*bspc+14*bhgt bwid bhgt]);

    %Curve type frame
    uicontrol('Style','frame','Position',[2*bspc 4*bspc+17*bhgt rgt-4*bspc bspc+2*bhgt]);
    uicontrol('Style','radiobutton','String','Zero','Tag','curvebuttons',...
      'Callback','derivtool(''radiobutton'')',...
      'Value',0,'Position',[4*bspc+bwid 6*bspc+17*bhgt bwid bhgt]);
    uicontrol('Style','radiobutton','String','Forward Term','Tag','curvebuttons',...
      'Callback','derivtool(''radiobutton'')','Value',1,...
      'Position',[5*bspc+1.85*bwid 6*bspc+17*bhgt bwid bhgt]);
    uicontrol('Style','popupmenu','Tag','forwardterm','Value',4,...
      'String',{'1 month';'3 months';'6 months';'1 year';'1.5 years';'2 years';...
        '5 years';'10 years';'20 years';'30 years';'Uneven'},...
      'Userdata',[1;3;6;12;18;24;60;120;240;360;-99],...
      'Callback','derivtool(''forwardterm'')',...
      'Position',[7*bspc+2.85*bwid 6*bspc+17*bhgt bwid bhgt]);
    uicontrol('Style','radiobutton','String','Cascade','Tag','curvebuttons',...
      'Callback','derivtool(''radiobutton'')',...
      'Position',[11*bspc+3.85*bwid 6*bspc+17*bhgt bwid bhgt]);
    uicontrol('Style','text','String','Curve Type',...
      'Position',[3*bspc 6*bspc+18*bhgt bwid bhgt]);
    
    %Calculate forward term interval and set in display
    derivtool('calcfwdterm')
    
    %Set to Zero or Forward Term depending on model
    set(findobj(gcf,'Tag','curvebuttons'),'Value',0)
    modelobj = findobj('Label','HJM','Checked','on');
    if ~isempty(modelobj)
      set(findobj('Tag','curvebuttons','String','Forward Term'),'Value',1);
    else
      set(findobj('Tag','curvebuttons','String','Zero'),'Value',1);
    end
    derivtool('radiobutton','curvebuttons')
    
    cleanupdialog
    
  case 'storecouponspread'
    
    %Get coupon object
    couobj = findobj(gcf,'Tag','coupon');
    
    %Find Pay and Receive tabs
    paytab = findobj(gcf,'String','Pay');
    rectab = findobj(gcf,'String','Receive');
    pos = [get(paytab,'Position');get(rectab,'Position')];
    try
      d = pos(1,:) - pos(2,:);
      couval = str2num(get(couobj,'String'));
      if d(2) < 0   %Pay leg
        setappdata(couobj,'paycou',couval);
      else %Receive leg
        setappdata(couobj,'reccou',couval);
      end
    catch
    end
    
  case 'treeaction'
    
    ChooserH = findobj(gcf,'Tag','Chooser');
      
    %Determine getting price or rate paths
    iobj = findobj(gcf,'Tag','treeinstruments');
    if isempty(iobj), rflag = 1; else, rflag = 0; end
    
    %Determine if rate path is spot rates or unit bond prices
    ubpobj = findobj('Label','Unit Bond Prices','Checked','on');
    if isempty(ubpobj), sflag = 1; else, sflag = 0; end
   
    buttontype = get(gcf,'SelectionType');
    if ~strcmp(buttontype,'normal')
      errordlg('Viewer supports primary mouse button clicks only.')
      set(findobj('Type','figure'),'Pointer','arrow')
      return
    end
    
    %Get current tree and portfolio data
    F = findobj('Tag','HJMDLG');
    if isempty(F)
      F = gcf;
    end
    Port = get(portobj,'Userdata');
    HJMTree = getappdata(F,'HJMTREE');
    
    curpath = getappdata(ChooserH,'CurrentPathNumber');
      
    thobj = findobj('Linewidth',2);
    set(thobj,'Linewidth',1)

    if ~curpath   %PathOne
      setappdata(ChooserH,'CurrentPathNumber',1)   %PathTwo is next  
      ptobj = sort(findobj('Userdata','PathTwo'));
      
      %Remove old PathOne
      lobj = findobj(ChooserH,'Color',ColorOne);
      mobj = findobj(ChooserH,'MarkerFaceColor',ColorOne);
      set(lobj,'Color',[0 .5 0]);
      set(mobj,'MarkerFaceColor','none','MarkerEdgeColor',[0 0 1]);

    else          %PathTwo
      setappdata(ChooserH,'CurrentPathNumber',0)  %PathOne is next  
      poobj = sort(findobj('Userdata','PathOne'));  
      
      %Remove old PathTwo
      lobj = findobj(ChooserH,'Color',ColorTwo);
      mobj = findobj(ChooserH,'MarkerFaceColor',ColorTwo);
      set(lobj,'Color',[0 .5 0]);
      set(mobj,'MarkerFaceColor','none','MarkerEdgeColor',[0 0 1]);

    end
    
    bushguistate('stateclick');
    
    %Get selected data
    sdat = getappdata(ChooserH,'Selection');
    sdat = sdat{:};
    Ls = length(sdat);
    
    %Get selected instrument index
    instval = get(iobj,'Value');
    
    %Need instrument price and tree information for instrument tree viewer, get stored information 
    if ~rflag, 
      P = getappdata(findobj('Tag','HJMDLG'),'PriceData');
      Tree = getappdata(findobj('Tag','HJMDLG'),'TreeData');
      if isempty(P)
		 o = derivset('Warnings', 'off');
        [P,Tree] = hjmprice(HJMTree,Port, o);
        setappdata(findobj('Tag','HJMDLG'),'PriceData',P)
        setappdata(findobj('Tag','HJMDLG'),'TreeData',Tree)
      end
    end
      
    %Get Tree used for unit bond pricing
    if ~sflag
      DTree = bushprice(HJMTree);   
    end
    
    switch lower(getappdata(ChooserH,'HighlightMode'))
      
      case 'path'
      
        %Get price path data
        pathlist = sdat(ones(Ls,1),:);     
        pathlist = tril(pathlist);
        
        if rflag   %using rate paths 
          if sflag  %spot rates
            dataall = bushpath(HJMTree.FwdTree,pathlist);
            dat = dataall(logical(eye(size(dataall))));
            starttimes = intenvget(HJMTree.RateSpec,'StartTimes');
            endtimes = intenvget(HJMTree.RateSpec,'EndTimes');
            adat = disc2rate(HJMTree.TimeSpec.Compounding, 1 ./ dat ,...
              endtimes(1:length(Ls)),starttimes(1:length(Ls)));
          else    %unit bond prices
            dataall = bushpath(DTree.PTree,pathlist);
            dataall = dataall(2:end,:);
            adat = dataall(logical(eye(size(dataall))));
          end
          
        end
          
      case 'node'
       
        %Get node and children
        if rflag   %rate path
          [dummy,NumChild] = bushshape(HJMTree.FwdTree);
        else       %instrument price path
          [dummy,NumChild] = bushshape(Tree.PBush);
        end  
        NumChild = NumChild(Ls);
        pathlist = sdat(ones(NumChild+1,1),:);   %copy the list
        pathlist = [pathlist (0:NumChild)'];
        try
          if sflag   %spot rates  
            try
              dataall = bushpath(HJMTree.FwdTree,pathlist);
            catch
              dataall = bushpath(Tree.PBush,pathlist);
              dataall = dataall(2:end,:);
            end
          else
            dataall = bushpath(DTree.PTree,pathlist);
            dataall = dataall(2:end,:);
          end
        catch
          set(findobj('Type','figure'),'Pointer','arrow')
          return
        end
        Mask = zeros(size(dataall));
        Mask(Ls,1) = 1;   %Parent
        Mask(Ls+1,2:size(dataall,2)) = 1;  %Children
        dat = dataall(logical(Mask));
        if rflag & sflag %spot rates
          starttimes = intenvget(HJMTree.RateSpec,'StartTimes');
          startparent = starttimes(Ls);
          startchildren = startparent + 1;
          endparent = startchildren;
          endchildren = startchildren + 1;
          tmp = ones(NumChild,1);
          warval = warning;
          warning off
          adat = disc2rate(HJMTree.TimeSpec.Compounding, 1 ./ dat ,...
            [endparent; endchildren * tmp],[startparent; startchildren * tmp]);
          warning(warval)
        else   %unit bond prices
          adat = dat;
        end
    end
    
    if ~rflag   %Not getting rate paths, get price paths
      adat = bushpath(Tree.PBush,pathlist);
      adat = adat(instval,:);
    end  
      
    if isempty(findobj(gcf,'String','Node and Children','Value',1))
      
      if ~curpath    %Displaying PathOne and restoring PathTwo
        set(findobj(gca,'Userdata','PathOne'),'Userdata',[])
        poobj = sort([findobj(gcf,'Color',ColorOne);findobj(gcf,'MarkerFaceColor',ColorOne)]);
        set(poobj,'Userdata','PathOne','Linewidth',2)
        for i = 1:length(ptobj)
          x = find(ptobj(i) == poobj);
          ptobj(x) = 0;  
        end
        i = find(ptobj == 0);
        ptobj(i) = [];
        if ~isempty(ptobj)
          set(ptobj,'Userdata','PathTwo','Linewidth',2,'Color',ColorTwo,...
            'MarkerFaceColor',ColorTwo,'MarkerEdgeColor',ColorTwo)
        end
      
        %Store pathone data
        setappdata(gcf,'PathOne',adat);      
      
        %For plotting path one, target color is ColorOne, delete color is ColorOne
        TargetColor = ColorOne;
        DeleteColor = ColorOne;
        TextTag = 'PathOne';

      else           %Displaying PathTwo and restoring PathOne
      
        set(findobj(gca,'Userdata','PathTwo'),'Userdata',[])
        ptobj = sort([findobj(gcf,'Color',ColorTwo);findobj(gcf,'MarkerFaceColor',ColorTwo)]);
        set(ptobj,'Userdata','PathTwo','Linewidth',2)
        for i = 1:length(poobj)
          x = find(poobj(i) == ptobj);
          poobj(x) = 0;
        end
        i = find(poobj == 0);
        poobj(i) = [];
        if ~isempty(poobj)
          set(poobj,'Userdata','PathOne','Linewidth',2,'Color',ColorOne,...
            'MarkerFaceColor',ColorOne,'MarkerEdgeColor',ColorOne)
        end
      
        %Store pathtwo data
        setappdata(gcf,'PathTwo',adat);      
      
        %For plotting path two, target color is ColorTwo, delete color is ColorTwo
        TargetColor = ColorTwo;
        DeleteColor = ColorTwo;
        TextTag = 'PathTwo';
      
      end  
    
    end
  
    set(findobj(gca,'Color',ColorThree),'Userdata','NodeChildren','Linewidth',2)
    
    %Show path or display plot
          
    pathonedat = getappdata(gcf,'PathOne');
    pathtwodat = getappdata(gcf,'PathTwo');
    L1 = length(pathonedat);
    L2 = length(pathtwodat);
      L = max(L1,L2);
      tmp = NaN;
      tmppathone = tmp(ones(L,1),:);
      tmppathtwo = tmppathone;
      tmppathone(1:L1) = pathonedat;
      tmppathtwo(1:L2) = pathtwodat;
      thval = 1e-6;
      i = find(abs(tmppathone) < thval);
      tmppathone(i) = 0;
      i = find(abs(tmppathtwo) < thval);
      tmppathtwo(i) = 0;
      
      if rflag, fstr = 3; else, fstr = 5; end    %num2str formating value
      tmp = '       ';
      pad = tmp(ones(L,1),:);
      obstime = (0:L-1)';
      if isempty(iobj)
        endtime = obstime+1;
        treedatastring = [pad(:,1:2) num2str(obstime,fstr) pad num2str(endtime,fstr) pad(:,1:2) num2str(round(tmppathone*100)/100,fstr) pad(:,1:2) num2str(round(tmppathtwo*100)/100,fstr)];  
      else
        treedatastring = [pad(:,1:2) num2str(obstime,fstr) pad pad(:,1:5) num2str(round(tmppathone*100)/100,fstr) pad(:,1:3) num2str(round(tmppathtwo*100)/100,fstr)]; 
      end
      
      %Display string
      set(findobj(gcf,'Tag','treedata'),'String',treedatastring,'Max',2,'Value',[])
      
    %Plot Data
      
      %Reset color if viewing node and children
      if ~isempty(findobj(gcf,'String','Node and Children','Value',1))
        TargetColor = ColorThree;
        DeleteColor = ColorThree;
        TextTag = 'NodeChildren';
      end
        
      %Get tree plotting axis and viewing axis
      aobj = findobj(gcf,'Tag','treeplot');
      hobj = findobj(gcf,'Tag','Chooser');

      %Get objects that represent current display (in TargetColor)
      lobj = findobj(hobj,'Color',TargetColor);
      nobj = findobj(hobj,'Markerfacecolor',TargetColor);
      cobj = findobj(hobj,'Markeredgecolor',TargetColor,'Markerfacecolor','none');
      lncobj = [lobj;nobj;cobj];
      
      dobj = get(aobj,'Children');
      delete([findobj(aobj,'Color',DeleteColor);...
              findobj(aobj,'Markerfacecolor',DeleteColor);...
              findobj(aobj,'Markeredgecolor',DeleteColor);...
              findobj(aobj,'Tag',TextTag)])    %Clear any existing display
      set(aobj,'Xlimmode','auto','Ylimmode','auto')
      
      %Make copy of objects in tree plot axis
      copyobj(lncobj,aobj);
      set(get(aobj,'Children'),'Buttondownfcn','')
      
      %Get line objects and node object
      lineobj = findobj(aobj,'Linestyle','-','Color',TargetColor);
      markerobj = findobj(aobj,'Markerfacecolor',TargetColor); 
      
      %Round price data for display
      adat = round(adat*100)/100;
      
      %If using plot option, display data at actual plot
      if ~isempty(findobj(gcf,'String','Plot','Value',1)) & ...
         isempty(findobj(gcf,'String','Node and Children','Value',1))
        for i = 1:length(lineobj)
          set(lineobj(i),'Ydat',[adat(i) adat(i+1)])
        end
        set(markerobj,'Ydat',[adat(length(adat))])
      end
      
      pobj = [lineobj;markerobj];
      
      %Adjust axis limits for better viewing
      xlim = get(aobj,'Xlim');
      ylim = get(aobj,'Ylim');
      set(aobj,'Xlim',[xlim(1) - 0.5 xlim(2) + 1],'Ylim',[ylim(1) - 0.05 ylim(2)+ 0.05])
          
      %Get data for plotting price/rate text
      xdat = get(pobj,'Xdata');
      try   %Multiple objects found
        tmpdat = [xdat{:}];
        L = length(tmpdat)-1;
        xdat = [tmpdat(1) tmpdat(2:2:L-2) tmpdat(L)];
      catch 
        %Single object found
      end
      ydat = get(pobj,'Ydata');
      try
        tmpdat = [ydat{:}];
        ydat = [tmpdat(1) tmpdat(2:2:L-2) tmpdat(L)];
      catch
        %Single object found
      end
            
      %Get pricing/rate information
      texdat = cellstr(num2str(adat(:),5));
      
      for i = 1:length(xdat)
        j = find(texdat{i} == ' ');
        texdat{i}(j) = [];    %Strip blank spaces for properly visualization
        text(xdat(i)+.2,ydat(i),texdat{i},'Parent',aobj,'Fontweight','bold','Tag',TextTag);
      end
    
    if ~isempty(findobj(gcf,'Style','radiobutton','String','Table','Value',1))  %Show data
      set(findobj(gcf,'Tag','treedata'),'Visible','on')
      set(aobj,'Visible','off')
    else     %Display plot
      set(findobj(gcf,'Tag','treedata'),'Visible','off')
      set(aobj,'Visible','on')
    end
          
  case 'treeclose'
    
    %Get HJMTree
    HJMTree = get(gcf,'Userdata');
    
    %Get valuation date
    try
      SettlementDate = datenum(get(findobj(gcf,'Tag','startdate'),'String'));
    catch
      errordlg('Invalid Valuation Date entered.')
    end
    
    %Get period
    pobj = findobj(gcf,'Tag','period');
    pval = get(pobj,'Value');
    pusd = get(pobj,'Userdata');
    Period = pusd(pval);
    
    %Get number of steps
    NumberSteps = get(findobj(gcf,'Tag','numsteps'),'Value');
    
    %Calculate maturity
    Maturity = datemnth(SettlementDate, Period*(1:NumberSteps));
    
    %Update HJMTree
    try
      TimeSpec = hjmtimespec(SettlementDate, Maturity, HJMTree.TimeSpec.Compounding);
      RateSpec = intenvset(HJMTree.RateSpec, 'ValuationDate', SettlementDate);   
      HJMTree = hjmtree(HJMTree.VolSpec, RateSpec, TimeSpec);
    catch
      errordlg(lasterr)
      set(findobj('Type','figure'),'Pointer','arrow')
      return
    end
    
    %close dialog
    close
    
    %Store HJMTree
    setappdata(findobj('Tag','HJMDLG'),'HJMTREE',HJMTree)
    setappdata(findobj('Tag','HJMDLG'),'VMPeriod',Period)
      
  case 'treeconstruction'
    
    %Get tree construction data from HJMTree
    HJMTree = getappdata(gcf,'HJMTREE');
    SettlementDate = HJMTree.TimeSpec.ValuationDate;
    Period = months(HJMTree.TimeSpec.ValuationDate, HJMTree.TimeSpec.Maturity(1), HJMTree.TimeSpec.EndMonthRule);
    NumberSteps = length(HJMTree.TimeSpec.Maturity);
    pusd = [1 3 6 12 18 24 60 120 360];
    pval = find(Period == pusd);   %Value for period popupmenu   
    
    %Build tree construction dialog
    h = dialog('Name','Tree Construction','Userdata',HJMTree);
    [bspc,bwid,bhgt] = spacing;
    uicontrol('Enable','off','Position',[bspc bspc 3*bspc+2*bwid 10*bspc+9*bhgt]);
    p = get(gcf,'Position');
    set(gcf,'Position',[p(1) p(2) 5*bspc+2*bwid 12*bspc+9*bhgt])
    
    %Pushbutton uicontrols
    uicontrol('String','Help','Callback','derivtool(''help'',''tree'')',...
      'Position',[2*bspc+0.5*bwid 6*bspc+3*bhgt bwid bhgt]);
    uicontrol('String','Defaults','Callback','derivtool(''treedefault'')',...
      'Tooltip','Use default tree construction parameters',...  
      'Position',[2*bspc+0.5*bwid 5*bspc+2*bhgt bwid bhgt]);
   	uicontrol('String','OK','Callback','derivtool(''treeclose'')',...
      'Tooltip','Close window and use new tree construction settings',...
      'Position',[2*bspc+0.5*bwid 4*bspc+1*bhgt bwid bhgt]);
    uicontrol('String','Cancel','Callback','close',...
      'Tooltip','Close window and revert to previous tree construction settings',...
	  'Position',[2*bspc+0.5*bwid 3*bspc bwid bhgt]);
    
       
    %Start date, period uicontrols
    uicontrol('Style','text','String','Period:',...
      'Position',[2*bspc 11*bspc+5*bhgt bwid bhgt]);
    uicontrol('Style','popupmenu','Tag','period',...
      'String',{'1 month';'3 months';'6 months';'1 year';'1.5 years';'2 years';...
        '5 years';'10 years';'30 years'},...
      'Userdata',[1 3 6 12 18 24 60 120 360],'Value',pval,...
      'Position',[3*bspc+bwid 12*bspc+5*bhgt bwid bhgt]);
    uicontrol('Style','text','String','Valuation date:',...
      'Position',[2*bspc 13*bspc+6*bhgt bwid bhgt]);
    uicontrol('Style','edit','Tag','startdate','String',datestr(SettlementDate),...
      'Position',[3*bspc+bwid 14*bspc+6*bhgt bwid bhgt]);
    
    %Number of steps uicontrols
    uicontrol('Style','text','String','Number of Steps:',...
      'Position',[2*bspc 9*bspc+4*bhgt bwid bhgt]);
    uicontrol('Style','popupmenu','Tag','numsteps','String',{'1';'2';'3';'4';'5';'6';'7';'8';'9';'10'},...
      'Value',NumberSteps,'Position',[3*bspc+bwid 10*bspc+4*bhgt bwid bhgt])
        
    cleanupdialog;
    
  case 'treedefault'
    
    %Start over with default information
    set(findobj(gcf,'Tag','startdate'),'String','01-Jan-2000')  %Default analysis date
    set(findobj(gcf,'Tag','period'),'Value',4)  %Default period
    set(findobj(gcf,'Tag','numsteps'),'Value',4)   %Default number of steps
    
  case 'treeinstrument'
    
    %New instrument selected in tree viewer
    setappdata(gcf,'PathOne',[]),setappdata(gcf,'PathTwo',[])
    
    %Clear any previous plots in Plot display window and previous paths
    aobj = findobj(gcf,'Tag','treeplot');
    delete(get(aobj,'Children'))
    pathobjs = [findobj(gcf,'Userdata','PathOne');...
              findobj(gcf,'Userdata','PathTwo');...
              findobj(gcf,'Userdata','NodeChildren')];
    set(pathobjs,'Userdata',[],'Color',[0 .5 0],'Markerfacecolor','none',...
            'Markeredgecolor',[0 0 1],'Linewidth',1)
    bushguistate('clear',findobj('Tag','Chooser')); % clear all selections
    set(findobj(gcf,'Style','listbox'),'String','')
    
  case 'underlying'
    
    %Change optfield uicontrols to prevent deletion
    u = findobj(gcf,'Userdata','optfield');
    set(u,'Userdata','protectfield');
    derivtool('underlyinginstruments')
    set(u,'Userdata','optfield');
    
    %If existing underlying instrument is selected, populate fields
    iobj = findobj(gcf,'Tag','underlying');
    
    %Get string and determine if new or existing instrument has been selected
    istr = get(iobj,'String');
    ilen = length(istr)-1;    %Last entry corresponds to new bond
    ival = get(iobj,'Value');
    
    if ival <= ilen   %Existing instrument selected
      iind = getappdata(gcf,'UnderlyingIndex');   %Stored index of bond instruments
      instind = iind(ival);
      derivtool('underlyingeditinstrument',instind)
      set(findobj(gcf,'String','Add'),'Userdata',0)
    end
      
  case 'updaterates'
    
   try
      
    rflag = getcurvetype;
     
    HJMTree = get(gcf,'Userdata');
    
    %Get rates
    Rates = str2double(get(findobj(gcf,'Tag','CurveRates'),'String'));
    i = isnan(Rates);
    Rates(i) = [];
     
    if rflag  %Forward curve      
            
      %Get dates
      Dates = str2mat(get(findobj(gcf,'Tag','CurveDates'),'String'));
      Dates = datenum(Dates(1:length(Rates),:));
      
      if isempty(findobj(gcf,'String','Maturity dates','Value',1))
        OtherDates = intenvget(HJMTree.RateSpec,'EndDates');
        OtherDateString = 'EndDates';
        DateString = 'StartDates';
      else
        OtherDates = intenvget(HJMTree.RateSpec,'StartDates');
        OtherDateString = 'StartDates';
        DateString = 'EndDates';
      end
      
      %If length of date vectors differs, must create new dates
      dl = length(Dates);
      ol = length(OtherDates);
      if dl > ol 
        try  %Date interval can be calculated from first start and end date
          m = months(Dates(1),OtherDates(1));
        catch  %first date get fwdterm to get m
          
          fobj = findobj(gcf,'Tag','fwdterm');
          fval = get(fobj,'Value');
          
          switch fval
            case 1, m = 1;
            case 2, m = 3;
            case 3, m = 6;
            case 4, m = 12;
            case 5, m = 18;
            case 6, m = 24;
            case 7, m = 60;
            case 8, m = 120;
            case 9, m = 240;
            case 10, m = 360;
            otherwise, m = 12;
          end
        end
          
        OtherDates(ol+1:dl) = datemnth(Dates(dl),m);
      elseif dl < ol
        OtherDates(dl+1:ol) = [];
      end
      
      %Store rates and dates
      HJMTree.RateSpec = intenvset(HJMTree.RateSpec,DateString,Dates,...
        OtherDateString,OtherDates,'Rates', Rates);
      
      %Store dates
      dstr = get(findobj(gcf,'Value',1,'Tag','curvedates'),'String');
      
      switch dstr  
        case 'Start dates'
          HJMTree.RateSpec = intenvset(HJMTree.RateSpec,'StartDates',Dates);
        case 'Maturity dates'
          HJMTree.RateSpec = intenvset(HJMTree.RateSpec,'EndDates',Dates);
      end
      
      HJMTree = hjmtree(HJMTree.VolSpec, HJMTree.RateSpec, HJMTree.TimeSpec);
      set(gcf,'Userdata',HJMTree)
      if findobj(gcf,'String','Curve','Value',1)
        plot(Rates,'Linewidth',2)
        set(gca,'Xtick',1:length(Rates),'Xlim',[-.5 10.5])
      else
        ratedisplay(Rates,HJMTree,1)
      end
      
    else    %Zero curve update
      
      OldStartDates = intenvget(HJMTree.RateSpec,'StartDates');
      HJMTree.RateSpec = intenvset(HJMTree.RateSpec,'StartDates', HJMTree.RateSpec.ValuationDate);
      HJMTree.RateSpec = intenvset(HJMTree.RateSpec,'Rates',Rates);
      if findobj(gcf,'String','Curve','Value',1)
        plot(Rates,'Linewidth',2)
        set(gca,'Xtick',1:length(Rates),'Xlim',[-.5 10.5])
      else
        ratedisplay(Rates,HJMTree,1)
      end
      
      %Reset dates for forward rates
      HJMTree.RateSpec = intenvset(HJMTree.RateSpec,'StartDates',OldStartDates);
      HJMTree = hjmtree(HJMTree.VolSpec, HJMTree.RateSpec, HJMTree.TimeSpec);
      set(gcf,'Userdata',HJMTree)
      
    end
    
    %Update forward term popupmenu
    derivtool('calcfwdterm')
    
   catch
    errordlg(lasterr)
   end
  
  case 'viewtree'
    
    %Port data
    Port = get(portobj,'Userdata');
    
    %Do nothing if Portfolio is empty
    if strcmp(get(gcbo,'Type'),'uicontrol')
      try
        instnames = cellstr(instget(Port,'FieldName',{'Name'}));
      catch
        errordlg('Portfolio must contain at least one instrument to open tree viewer.')
        set(findobj('Type','figure'),'Pointer','arrow')
        return
      end
    end
    
    %Default to first instrument if none is selected
    instval = get(portobj,'Value');
    if isempty(instval)
      instval = 1;  
    end
    
    %Get HJMTree for number of factors
    HJMTree = getappdata(gcf,'HJMTREE');
    if isempty(HJMTree)
      errordlg('HJMTree not defined.  Unable to open tree viewer.')
      set(findobj('Type','figure'),'Pointer','arrow')
      return
    end
    
    %Determine if calling treeviewer from View Tree button or View menu
    uitype = get(gcbo,'Type');
    switch uitype
      case 'uimenu'
        [NLevels, NChild] = bushshape(HJMTree.FwdTree);
        Price = [];
        PriceTree = [];
        if ~isempty(findobj(gcf,'Label','Spot Rates','Checked','on'))
          titlestr = ' - Spot Rates';
        else
          titlestr = ' - Unit Bond Prices';
        end  
      case 'uicontrol'
		  o = derivset('Warnings', 'off');
        [Price,PriceTree] = hjmprice(HJMTree,Port, o);
        [NLevels, NChild] = bushshape(PriceTree.PBush);  
        titlestr = ' - Prices';
      otherwise
	      errordlg('Input argument ''Tree'' not recognized as a valid tree')      
    end
    
    %View instrument price tree
    h = dialog('Name',['Tree Viewer' titlestr],'Userdata',HJMTree,'Tag','treeviewer');
    setappdata(findobj('Tag','HJMDLG'),'PriceData',Price)
    setappdata(findobj('Tag','HJMDLG'),'TreeData',PriceTree)
    set(h,'windowstyle','normal')
    AxesHandle = bushguistate(NChild);
    %title('Click on a Node','Fontweight','bold')
    
    %start x-axis labels at zero
    xlab = get(gca,'Xtick')-1;
    
    %reposition axis
    p = get(AxesHandle,'Position');
    set(AxesHandle,'Position',[p(1)/8 p(2) p(3)/2+p(1)/2 p(4)],'Tag','Chooser',...
      'Xticklabel',xlab,'Color',[1 1 1])
    
    
    %Set highlightmode to path to root
    setappdata(AxesHandle,'HighlightMode','path')
        
    %Build uicontrols
    
    [bspc,bwid,bhgt,top,rgt] = spacing;
    
    %OK Button
    uicontrol('String','OK','Callback','close','Tooltip','Close window','Position',[rgt-(bspc+bwid) 2*bspc bwid bhgt]);
    uicontrol('String','Help','Callback','derivtool(''help'',''treeviewer'')','Position',[rgt-(2*bspc+2*bwid) 2*bspc bwid bhgt]);
    
    %Tree Visualization frame
    uicontrol('Style','frame','Position',[rgt/2 top-5*bhgt rgt/2-bspc 2*bspc+4*bhgt]);
    uicontrol('Style','text','String','Tree Visualization',...
      'Position',[rgt/2+bspc top-(bspc+bhgt) bwid bhgt]);
    uicontrol('Style','text','String','Visualization',...
      'Position',[rgt-(bspc+1.25*bwid) top-(bspc+1.75*bhgt) bwid bhgt]);
    uicontrol('Style','radiobutton','String','Table','Tag','treeradio',...
      'Callback','derivtool(''radiobutton'')','Value',1,...
      'Position',[rgt-(bspc+1.25*bwid) top-(bspc+2.5*bhgt) bwid bhgt]);
    uicontrol('Style','radiobutton','String','Diagram','Tag','treeradio',...
      'Callback','derivtool(''radiobutton'')',...
      'Position',[rgt-(bspc+1.25*bwid) top-(bspc+3.5*bhgt) bwid bhgt]);
    uicontrol('Style','radiobutton','String','Plot','Tag','treeradio',...
      'Callback','derivtool(''radiobutton'')',...
      'Position',[rgt-(bspc+1.25*bwid) top-(bspc+4.5*bhgt) bwid bhgt]);
    uicontrol('Style','text','String','Selection',...
      'Position',[rgt-(bspc+3*bwid) top-(bspc+1.75*bhgt) bwid bhgt]);
    uicontrol('Style','radiobutton','String','Path','Tag','pathradio',...
      'Callback','derivtool(''radiobutton'')','Value',1,'Userdata','path',...
      'Position',[rgt-(bspc+3*bwid) top-(bspc+2.5*bhgt) bwid bhgt]);
    uicontrol('Style','radiobutton','String','Node and Children','Tag','pathradio',...
      'Callback','derivtool(''radiobutton'')','Userdata','node',...
      'Position',[rgt-(bspc+3*bwid) top-(bspc+3.5*bhgt) bwid+5*bspc bhgt]);
    
    %Selected instrument uicontrols, only if from View Tree in main window
    if strcmp(get(gcbo,'Type'),'uicontrol') & strcmp(get(gcbo,'String'),'View Tree')
      vflag = 1;
      uicontrol('Style','text','String','Instrument:',...
        'Position',[rgt-(bspc+3*bwid) top-(3*bspc+6*bhgt) bwid bhgt]);
      uicontrol('Style','popupmenu','String',instnames,'Tag','treeinstruments',...
        'Callback','derivtool(''treeinstrument'')',...
        'Value',instval,'Position',[rgt-(bspc+2*bwid) top-(2*bspc+6*bhgt) 1.5*bwid bhgt]);
    else
      vflag = 0;   %Do not display instrument uicontrols
    end
      
    %Data/plot frame
    bgf = axes('Units','pixels','Position',[rgt/2 5*bspc+bhgt rgt/2-bspc 12*bhgt-bspc],...
      'Box','on','Xtick',[],'Ytick',[],...
      'Color',get(0,'Defaultuicontrolbackgroundcolor'));
    set(bgf,'Units','normal')
    
    %Data uicontrols
    if vflag    %Instrument tree viewing
      uicontrol('Style','text','String','Time','Userdata','pathtoroot',...
        'Position',[rgt-(2*bspc+3*bwid) top-(6*bspc+7*bhgt) bwid bhgt]);
    else     %Rates  tree viewing
      uicontrol('Style','text','String','Start Time','Userdata','pathtoroot',...
        'Position',[rgt-(2*bspc+3*bwid) top-(6*bspc+7*bhgt) bwid bhgt]); 
      uicontrol('Style','text','String','End Time','Userdata','pathtoroot',...
        'Position',[rgt-(2*bspc+2.25*bwid) top-(6*bspc+7*bhgt) bwid bhgt]);
    end  
    uicontrol('Style','text','String','Path 1','Userdata','pathtoroot',...
      'Foregroundcolor',ColorOne,...
      'Position',[rgt-(2*bspc+1.5*bwid) top-(6*bspc+7*bhgt) bwid bhgt]);
    uicontrol('Style','text','String','Path 2','Userdata','pathtoroot',...
      'Foregroundcolor',ColorTwo,...
      'Position',[rgt-(2*bspc+.8*bwid) top-(6*bspc+7*bhgt) bwid bhgt]);
    uicontrol('Style','listbox','Tag','treedata','Userdata','pathtoroot',...
      'Fontname',fnt,...
      'Position',[rgt/2+bspc 6*bspc+bhgt rgt/2-3*bspc 10*bhgt+bspc]);
    
    %Plot axis
    pta = axes('Units','pixels','Box','on','Xtick',[],'Ytick',[],'Tag','treeplot',...
      'Userdata','nodeandchildren','Visible','off','Color',[1 1 1],...
      'Position',[rgt/2+bspc 6*bspc+bhgt rgt/2-3*bspc bspc+11*bhgt]);
    set(pta,'Units','normal')
    
    %Define callbacks for tree elements
    trobj = findobj(gcf,'Tag','StateMark');
    set(trobj,'Buttondownfcn','derivtool(''treeaction'')')
    
    %Set colors for paths, (taken from bushguistate)
    ColorOrder = get(gca,'ColorOrder');
    ColorOrder(3:4,:) = [ColorOne;ColorTwo];
    ColorOrder(5:end,:) = [];
    ColorState = ColorOrder(1,:); % Color of state markers
    ColorLine = ColorOrder(2,:);  % Color of unselected lines connecting states
    ColorSelectOrder = ColorOrder(3:end,:); % Colors available for selection
    ColorSelectInd = 1; % Location of next color in ColorSelectOrder
    
    ChooserH = findobj('Tag','Chooser');
    setappdata(ChooserH, 'ColorState', ColorState);
    setappdata(ChooserH, 'ColorLine',  ColorLine);
    setappdata(ChooserH, 'ColorSelectOrder', ColorSelectOrder);
    setappdata(ChooserH, 'ColorSelectInd',   ColorSelectInd);
    
    setappdata(ChooserH,'CurrentPathNumber',0)
        
    cleanupdialog
        
  case 'volatilitymodel'
    
    %Get the current HJMTree
    HJMTree = getappdata(gcf,'HJMTREE');
    
    %Get the current VMPeriod
    VMPeriod = getappdata(gcf,'VMPeriod');
    if isempty(VMPeriod)
      VMPeriod = 1;
    end
    
    %Open dialog
    h = dialog('Name','Volatility Model','Userdata',HJMTree,'Windowstyle','normal');
    [bspc,bwid,bhgt] = spacing;
    p = get(h,'Position');
    set(h,'Position',[p(1) p(2) 10*bspc+4*bwid 10*bspc+15*bhgt]);
    p = get(h,'Position');
    rgt = p(3);
    top = p(4);
    setappdata(h,'VMPeriod',VMPeriod)
    
    %Background frame
    uicontrol('Enable','off','Position',[bspc 2*bspc+bhgt rgt-2*bspc top-3*bspc-bhgt]);
    
    %Cancel, OK buttons
	uicontrol('String','Help','Callback','derivtool(''help'',''volatility'')',...
		'Position',[rgt-(4*bspc+3*bwid) bspc bwid bhgt]);
	uicontrol('String','OK','Callback','derivtool(''vmok'')',...
        'Tooltip','Close window and use new model settings',...
        'Position',[rgt-(3*bspc+2*bwid) bspc bwid bhgt]);
    uicontrol('String','Cancel','Callback','close',...
        'Tooltip','Close window and revert to previous model settings',...
        'Position',[rgt-(2*bspc+bwid) bspc bwid bhgt]);
    
    
    %Model tabs
    uicontrol('Enable','off','String','Factor 1','Userdata','modeltab',...
      'Buttondownfcn','derivtool(''modeltab'',''Factor 1'')','Position',[2*bspc 4*bspc+bhgt bwid bspc+bhgt]);
    uicontrol('Enable','off','String','Factor 2','Userdata','modeltab',...
      'Buttondownfcn','derivtool(''modeltab'',''Factor 2'')','Position',[2*bspc+bwid 4*bspc+bhgt bwid bspc+bhgt]);
    uicontrol('Enable','off','String','Factor 3','Userdata','modeltab',...
      'Buttondownfcn','derivtool(''modeltab'',''Factor 3'')','Position',[2*bspc+2*bwid 4*bspc+bhgt bwid bspc+bhgt]);
    
    %Model frame
    
    %Always visible components
    uicontrol('Enable','off','Position',[2*bspc 4*bspc+2*bhgt rgt-4*bspc 2*bspc+11*bhgt]);
    uicontrol('Style','text','Tag','tabtext','Position',[2*bspc 3.5*bspc+2*bhgt bwid-.5*bspc bspc]);
    uicontrol('Style','text','String','Model type:','Position',[3*bspc 4*bspc+12*bhgt bwid bhgt]);
    uicontrol('Style','popupmenu','Tag','modeltype','Callback','derivtool(''modeltype'')',...
      'String',{'Constant','Exponential','Proportional','Stationary','Vasicek'},...
      'Position',[3*bspc 4*bspc+11*bhgt 2*bwid bhgt]);
    
    %Model specific components
    uicontrol('Style','text','String','Sigma:','Visible','on','Userdata','sigma',...
      'Position',[3*bspc 4*bspc+9*bhgt bwid bhgt]);
    uicontrol('Style','edit','Tag','sigma','Visible','on','Userdata','sigma',...
      'Position',[3*bspc 4*bspc+8*bhgt 2*bwid bhgt]);
    uicontrol('Style','text','String','Lambda:','Visible','off','Userdata','lambda',...
      'Position',[3*bspc 2*bspc+7*bhgt bwid bhgt]);
    uicontrol('Style','edit','Tag','lambda','Visible','off','Userdata','lambda',...
      'Position',[3*bspc 2*bspc+6*bhgt 2*bwid bhgt]);
    uicontrol('Style','text','String','Term (months)','Userdata','term','Visible','off',...
      'Position',[6*bspc+2*bwid 4*bspc+12*bhgt bwid bhgt]);
    uicontrol('Style','text','String','Sigma','Userdata','term','Visible','off',...
      'Position',[7*bspc+3*bwid 4*bspc+12*bhgt bwid bhgt]);
    for i = 1:10
      uicontrol('Style','edit','Tag','term','Userdata','term','Visible','off',...
        'Position',[6*bspc+2*bwid 5*bspc+(2+i-1)*bhgt bwid bhgt]);
      uicontrol('Style','edit','Tag','sigmas','Userdata','sigmas','Visible','off',...
        'Position',[6*bspc+3*bwid 5*bspc+(2+i-1)*bhgt bwid bhgt]);
    end
    
    %Number of factors frame
    uicontrol('Style','frame','Position',[2*bspc 3*bspc+14*bhgt rgt-4*bspc 2*bhgt]);
    uicontrol('Style','text','String','Number of Factors',...
      'Position',[3*bspc 4*bspc+15*bhgt bwid bhgt]);
    uicontrol('Style','radiobutton','String','One','Value',0,'Tag','nofradio',...
      'Callback','derivtool(''nofradio'')',...
      'Position',[5*bspc+0.5*bwid 4*bspc+14*bhgt bwid bhgt]);
    uicontrol('Style','radiobutton','String','Two','Value',0,'Tag','nofradio',...
      'Callback','derivtool(''nofradio'')',...
      'Position',[5*bspc+1.5*bwid 4*bspc+14*bhgt bwid bhgt]);
    uicontrol('Style','radiobutton','String','Three','Value',0,'Tag','nofradio',...
      'Callback','derivtool(''nofradio'')',...
      'Position',[5*bspc+2.5*bwid 4*bspc+14*bhgt bwid bhgt]);
    
    cleanupdialog
    
    %Generate hjmvolspec input
    derivtool('modelstring')
    
    %Default tab is Factor 1
    derivtool('modeltab','Factor 1')
    
    %Enable factor buttons
    NumFactors = HJMTree.VolSpec.NumFactors;
    mtobj = flipud(findobj(gcf,'Userdata','modeltab'));
    for i = 1:NumFactors
      set(mtobj(i),'Enable','inactive')
    end
    
    %Toggle number of factors radio button
    robj = flipud(findobj(gcf,'Tag','nofradio'));
    set(robj(NumFactors),'Value',1)
    
    %Set previous model number
    setappdata(gcf,'PreviousModelValue',1)
    
  case 'vmok'
    
    %Get current HJMTree
    HJMTree = get(gcf,'Userdata');
    
    %Extract current model
    derivtool('modelextract')
    volstr = getappdata(gcf,'HJMVolSpecInput');
    
    %Fill default models if none chosen or delete deselected models
    robj = findobj(gcf,'Tag','nofradio','Value',1);
    nummodstr = get(robj,'String');
    nummod = find(strcmp(nummodstr,{'One','Two','Three'}));
    lenvol = length(volstr);
    if lenvol < nummod
      volstr{lenvol+1:nummod} = '''Constant'',0.1';
    elseif lenvol > nummod
      volstr(nummod+1:lenvol) = [];
    end  
    
    %Convert cell array to string array
    hjmvolspecinput = [];
    
    for i = 1:length(volstr)
      if isempty(volstr{i})
        volstr{i} = '''Constant'',0.1';  %Fill empty models with default entries
      end
      hjmvolspecinput = [hjmvolspecinput volstr{i} ','];
    end
    hjmvolspecinput(length(hjmvolspecinput)) = [];  %Strip trailing comma
    
    %Create new VolSpec
    eval(['VolSpecNew = hjmvolspec(' hjmvolspecinput ');'])
    HJMTree = hjmtree(VolSpecNew, HJMTree.RateSpec, HJMTree.TimeSpec);   
    
    %Close volatility model dialog
    close(gcf)
    
    %Store HJMTree in main window
    setappdata(gcf,'HJMTREE',HJMTree)
    
end

set(findobj('Type','figure'),'Pointer','arrow')

%Subfunctions

function displaydatefields(s)
%DISPLAYDATEFIELDS Build instrument date uicontrols.
%   DISPLAYDATEFIELDS(S) builds the date uicontrols for an instrument.   S is the list
%   of date identifiers, ie settlement, issue, etc.

[bspc,bwid,bhgt,top,rgt,fhgt1] = spacing;

for i = 1:length(s)
  uicontrol('Style','text','String',s{i},'Userdata','instfield',...
    'Position',[5*bspc+2*bwid top-((5+i)*bspc+(2+i)*bhgt+fhgt1) bwid bhgt]);
  tagstr = lower(s{i});
  j = find(tagstr == ' ' | tagstr == ':');
  tagstr(j) = [];
  uicontrol('Style','edit','Tag',tagstr,'Userdata','instfield',...
    'Position',[5*bspc+3*bwid top-((4+i)*bspc+(2+i)*bhgt+fhgt1) bwid bhgt]);
end


function commonfields(noc,bas,per,cou)
%COMMONFIELDS Display common instrument fields.
%   COMMONFIELDS(NOC,BAS,PER,COU) displays the common instrument fields number of contracts, 
%   basis, period and coupon if the corresponding flag NOC, BAS, PER, or COU is true.

[bspc,bwid,bhgt,top,rgt,fhgt1] = spacing;

if noc
  uicontrol('Style','text','String','No. of Contracts:','Userdata','instfield','Tag','nocstring',...
    'Position',[6*bspc+4*bwid top-(6*bspc+3*bhgt+fhgt1) bwid bhgt]);
  uicontrol('Style','edit','Tag','contracts','Userdata','instfield',...
    'Position',[7*bspc+5*bwid top-(5*bspc+3*bhgt+fhgt1) bwid bhgt]); 
end  

if bas
  uicontrol('Style','text','String','Basis:','Userdata','instfield',...
    'Position',[6*bspc+4*bwid top-(7*bspc+4*bhgt+fhgt1) bwid bhgt]);
  uicontrol('Style','popupmenu','String',{'0','1','2','3'},'Tag','basis','Userdata','instfield',...
    'Position',[7*bspc+5*bwid top-(6*bspc+4*bhgt+fhgt1) bwid bhgt]); 
end
if per
  uicontrol('Style','text','String','Period:','Userdata','instfield',...
    'Position',[6*bspc+4*bwid top-(8*bspc+5*bhgt+fhgt1) bwid bhgt]);
  uicontrol('Style','popupmenu','String',{'1','2','3','4','6','12'},'Tag','period','Userdata','instfield',...
    'Position',[7*bspc+5*bwid top-(7*bspc+5*bhgt+fhgt1) bwid bhgt]);
end
if cou
  uicontrol('Style','text','String','Coupon:','Userdata','instfield',...
    'Position',[6*bspc+4*bwid top-(9*bspc+6*bhgt+fhgt1) bwid bhgt]);
  uicontrol('Style','edit','Tag','coupon','Userdata','instfield',...
    'Callback','derivtool(''storecouponspread'')',...
    'Position',[7*bspc+5*bwid top-(8*bspc+6*bhgt+fhgt1) bwid bhgt]);
end


function [bspc,bwid,bhgt,top,rgt,fhgt1,fhgt2,fwid1] = spacing()
%SPACING GUI spacing parameters.

%Get figure position and set spacing parameters
p = get(gcf,'Position');
rgt = p(3);
top = p(4);
dfp = get(0,'DefaultFigurePosition');
mfp = [560 420];    %Reference width and height
bspc = mean([5/mfp(2)*dfp(4) 5/mfp(1)*dfp(3)]);
bhgt = 20/mfp(2) * dfp(4);
bwid = 85/mfp(1) * dfp(3);
fwid1 = rgt-2*bspc;
fhgt1 = 7*bspc+6*bhgt;
fhgt2 = top-fhgt1-4*bspc;

    
function cleanupdialog()
%CLEANUPDIALOG Visual enhancement of dialog.

%Set colors and alignment
e = findobj(gcf,'Style','edit');
l = findobj(gcf,'Style','listbox');
p = findobj(gcf,'Style','popupmenu');
set([e;l;p],'Backgroundcolor','white','Horizontalalignment','left')
dbc = get(0,'Defaultuicontrolbackgroundcolor');
set(gcf,'Color',dbc)

%Make text boxes proper width
textuis = findobj(gcf,'Style','text');
notextui = findobj(gcf,'Tag','tabtext');  %Do not alter tab cover (which is a blank text ui)
if ~isempty(notextui);
  j = find(notextui == textuis);
  textuis(j) = [];
end
for i = 1:length(textuis)
  pos = get(textuis(i),'Position');
  ext = get(textuis(i),'Extent');
  set(textuis(i),'Position',[pos(1) pos(2) ext(3) pos(4)])
end
set(textuis,'Backgroundcolor',dbc)
set(findobj(gcf,'Value',-33),'Backgroundcolor',[1 1 1])

%Normalize units
set(findobj(gcf,'Type','uicontrol'),'Units','normal')
set(findobj(gcf,'Type','axes'),'Units','normal')

function [p,t] = buildinstrumentlist(x)
%BUILDINSTRUMENTLIST Instrument list for display.
%   P = BUILDINSTRUMENTLIST(X) builds the instrument list from the instrument info, X, for 
%   display purposes.

fstr = 6;   %Format string

tmp = ' ';
pad = tmp(ones(size(x{1},1),1),:);
p = [str2mat(x{:,1}) pad int2str(x{:,2})];
n = size(x,2);
for i = 3:n
  j = find(abs(x{:,i}) < 1e-3);
  if ~isempty(j)
    x{:,i}(j) = 0;
  end
  if all(all(x{1,i}*1 == 32))
    p = [p pad pad str2mat(num2str(x{:,i},fstr))];
  else
    p = [p pad pad str2mat(num2str(round(x{:,i}*100)./100,fstr))];
  end
end

%Change NaN's to zeros for totals display purposes
for i = 2:size(x,2)
  j = find(isnan(x{:,i}));
  x{:,i}(j) = 0;
end

if nargout == 2  %Build totals string
  TotalPric = sum(x{:,2} .* x{:,3});
  if isstr(x{:,4})
    TotalDelta = '         ';
  else
    TotalDelta = sum(x{:,2} .* x{:,4});
  end
  if isstr(x{:,5})
    TotalGamma = '        ';
  else
    TotalGamma = sum(x{:,2} .* x{:,5});
  end
  if isstr(x{:,6})
    TotalVega = '         ';
  else
    TotalVega = sum(x{:,2} .* x{:,6});
  end  
  t = [num2str(TotalPric,fstr) tmp num2str(TotalDelta,fstr) tmp num2str(TotalGamma,fstr) tmp num2str(TotalVega,fstr)];
end

function ratedisplay(Rates,HJMTree,rflag)
%RATEDISPLAY Forward and zero rates graphic.

EndTimes   = intenvget(HJMTree.RateSpec, 'EndTimes');
if rflag == 0
  StartTimes = zeros(length(EndTimes),1);
else
  StartTimes = intenvget(HJMTree.RateSpec, 'StartTimes');
end

rx = [StartTimes EndTimes];
[m,n] = size(rx);
tmp = [-.5 .5];
ry = tmp(ones(m,1),:);

h = cfplot(rx,ry);
set(h,'Color',get(h(1),'Color'),'MarkerFaceColor',get(h(1),'Color'));
set(gca,'Xlim',[-.5 max(EndTimes)+.5],'Ytick',[],'Ylim',[size(h,1)-10 size(h,1)],'Box','on')

plotrates(HJMTree,rflag,1)

function rflag = getcurvetype
%GETCURVETYPE Determine if curve is forward or zero rate.

if findobj(gcf,'String','Zero','Value',1)
  rflag = 0;
  %elseif findobj(gcf,'String','Forward Term','Value',1)
else
  rflag = 1;
end

function  plotrates(HJMTree,rflag,zflag)
%PLOTRATES Plot forward or zero rates
%   PLOTRATES(HJMTree,RFLAG,ZFLAG) plots the forward rates if RFLAG = 1 or
%   the zeros rates if RFLAG = 0.   ZFLAG specifies only the rates edit boxes
%   need to be updated without showing the curve.

if rflag    %Forward rate curve
  
  DispRates = intenvget(HJMTree.RateSpec,'Rates');
   
else    %Zero rate curve
  
  OldStartDates = intenvget(HJMTree.RateSpec, 'StartDates');
  HJMTree.RateSpec = intenvset(HJMTree.RateSpec, 'StartDates', HJMTree.RateSpec.ValuationDate);

  %Get zero rates 
  DispRates = intenvget(HJMTree.RateSpec, 'Rates');
  HJMTree.RateSpec = intenvset(HJMTree.RateSpec,'StartDates',OldStartDates);
  set(gcf,'Userdata',HJMTree)
  
end

dstr = get(findobj(gcf,'Value',1,'Tag','curvedates'),'String');
switch dstr
  case 'Start dates'
    DispDates = intenvget(HJMTree.RateSpec,'StartDates');
    if ~isempty(findobj(gcf,'String','Zero','Value',1))   %Start Dates are analysis date for zero
      DispDates = DispDates(ones(length(DispRates),1),:);
    end
  case 'Maturity dates'
    DispDates = intenvget(HJMTree.RateSpec,'EndDates');
end


if nargin < 3   %ZFLAG not given, display curve
  plot(DispRates,'Linewidth',2)
  set(gca,'Xlim',[-.5 10.5],'Xtick',1:length(DispRates))
end

%Change rate and date boxes
ru = findobj(gcf,'Tag','CurveRates');
set(ru(1:length(DispRates)),{'String'},cellstr(num2str(DispRates)))
LD = length(DispDates);
dobj = findobj(gcf,'Tag','CurveDates');
set(dobj(1:LD),{'String'},cellstr(datestr(DispDates)))

function updateportfolio(Port,HJMTree,priceflag,displaypriceflag)
%UPDATEPORTFOLIO Update portfolio listbox with current information
%   UPDATEPORTFOLIO(PORT,HJMTREE,PRICEFLAG,DISPLAYPRICEFLAG)

hobj = findobj('Tag','HJMDLG');
portobj = findobj(hobj,'Tag','portfolio');

if isempty(Port.IndexTable.TypeI)
  Portfolio = [];
  Totals = [];
else
  [Name,Quan] = instget(Port,'FieldName',{'Name','Quantity'});
  
  if priceflag
    
    %Determine which sensitivities to calculate and display
    sensvals = getappdata(findobj('Tag','HJMDLG'),'DeltaGammaVega');
    numoutputs = max(find(sensvals));
    if isempty(numoutputs)
      numoutputs = 0;
    end
    
    tmp = '        ';
    pad = tmp(ones(size(Quan,1),1),:);
    Delta = zeros(size(Quan));
    Gamma = Delta;
    Vega = Delta;
    
    if ~isempty(findobj(gcf,'Label','Zero Curve','Checked','on'))
      zflag = 1;
    else
      zflag = 0;
    end
   
    %Call pricing and sens routines based on model and number of sensitivities requested
    switch numoutputs
      case 0
        if ~zflag
		  o = derivset('Warnings', 'off');	
          Price = hjmprice(HJMTree,Port, o);
        else
          Price = intenvprice(HJMTree.RateSpec,Port);
        end
      otherwise
        if ~zflag
		   o = derivset('Warnings', 'off');	
          [Delta,Gamma,Vega,Price] = hjmsens(HJMTree,Port, o);
        else
          [Delta,Gamma,Price] = intenvsens(HJMTree.RateSpec,Port);
        end
    end
    
    Port = instsetfield(Port, 'FieldName', {'Price','Delta','Gamma','Vega'}, ...
      'Data',{Price, Delta, Gamma, Vega});
    
    %Blank out sens. not requested in Sensitivities dialog
    if sensvals(1) == 0
      Delta = pad;
    end
    if sensvals(2) == 0
      Gamma = pad;
    end
    if sensvals(3) == 0
      Vega = pad;
    end
    
    [Portfolio,Totals] = buildinstrumentlist({Name Quan Price Delta Gamma Vega});
    tobj = findobj(hobj,'Tag','totals');
    set(tobj,'String',Totals)  
  else
    Price = instget(Port,'FieldName',{'Price'});
    if nargin == 4   %Don't display prices, only for initial dialog display
      tmp = '        ';
      Price = tmp(ones(size(Price,1),1),:);
    end
    Portfolio = buildinstrumentlist({Name Quan Price});
  end
  
end 

set(portobj,'Value',[],'String',Portfolio,'Userdata',Port)

