function varargout = mv_printdlg(varargin)
%MV_PRINTDLG  Print dialog box.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%  $Revision: 1.5.4.2 $  $Date: 2004/02/09 07:33:38 $

ForceBuiltIn=~isunix;
InputArgs=varargin;
NumInputArgs=nargin;
if NumInputArgs == 0
    Fig = gcf;  
else,
    if isstr(varargin{1}),
       ForceBuiltIn=false;
       if strcmp(varargin{1},'-crossplatform'),
          InputArgs(1)=[];
          NumInputArgs=NumInputArgs-1;
       elseif strcmp(varargin{1},'-setup'),
          InputArgs(1)=[];
          NumInputArgs=NumInputArgs-1;
          setupmode=1;
       end % if strcmp
    end % if isstr
    if ~isempty(InputArgs),    
      Fig=InputArgs{1};
      InputArgs(1)=[];    
    else,
      Fig=gcf;      
    end      
end

% Bring up the print dialog for PC and MAC
if ForceBuiltIn, % =============
  Data=LocalGetPlatformIndData(Fig,InputArgs{:});  
  Data=LocalHideMe(Fig,Data);  
  
  if strcmp(get(Fig,'IntegerHandle'),'on'),
    pstr = ['print -v  -f' sprintf('%d',Fig)];
  else,
    pstr = ['print -v -f' sprintf('%.16f',Fig)];
  end
  eval(pstr)
  
  LocalRevealMe(Fig,Data);  
  if nargout==1,
    varargout{1}=[];
  end
  return % ============= 
end

if ~isstr(Fig)     % initialization - open figure 
   Data=LocalGetPlatformIndData(Fig,InputArgs{:});
   if exist('setupmode')
      Data.SetupMode=1;
   else
      Data.SetupMode=0;
   end;
   Dlg=LocalInitFig(Data);
   if nargout, varargout{1}=Dlg; end  
   
else, % this must be a uicontrol callback
   if NumInputArgs==1,  
      Dlg=gcbf;
   else,
      Dlg=InputArgs{1};
   end    
   
   Data=get(Dlg,'UserData');
   if ~ishandle(Data.Fig),
      Data.Fig=[];
      LocalClose(Dlg,Data)
      return
   end
   
   switch Fig,
   case 'PageSetup',
      FigName=dlgfigname(Data.Fig);
      PageFig=findall(0,'Name',['Page Position: ' FigName]);
      if isempty(PageFig),
         Data.PageSetupFlag=true;
         set(Dlg,'UserData',Data);
      end
      PageDialog=pagesetupdlg(Data.Fig);    
      
    case 'PageDlgCall',
      if strcmp(get(Data.Fig,'PaperOrientation'),'portrait'),
        Value={1;0};
      else,
        Value={0;1};
      end % if strcmp
      set(Data.Orientation,{'Value'},Value);
      
   case 'Orientation',
      if isequal(gcbo,Data.Orientation(1)),
        set(Data.Orientation,{'Value'},{1;0});
        set(Data.Fig,'PaperOrientation','portrait');        
      else,
        set(Data.Orientation,{'Value'},{0;1});
        set(Data.Fig,'PaperOrientation','landscape'); 
      end        
      FigName=dlgfigname(Data.Fig);
      PageFig=findall(0,'Name',['Page Position: ' FigName]);
      if ~isempty(PageFig),
        pagesetupdlg('PrintDlgCall',PageFig);
      end        
      local_call_figure_resize(Data.Fig);

    case 'ToFile',
      FileInfo=get(Data.ToFile,{'String','Value'});
      if isequal(gcbo,Data.ToFile(1)),
         if ~Data.SetupMode
            set(Data.PrintHandle,'String','Print');
         end;
         set(Data.ToFile,{'Value'},{1;0});
         if (isunix),
            set(Data.Printer,'Enable','on');
         end
     else,
        if ~Data.SetupMode
           set(Data.PrintHandle,'String','Save...');
        end;
        set(Data.ToFile,{'Value'},{0;1});
        if (isunix),
           set(Data.Printer,'Enable','off');
        end
      end        
    
    case 'Print',
      LocalPrint(Dlg,Data)
      LocalClose(Dlg,Data)
      
    case 'Cancel',      
      set(Data.Fig,{'PaperType' ,'PaperOrientation', ...
                    'PaperUnits','PaperPosition', ...
                    'PaperPositionMode'},Data.OrigData);
      LocalClose(Dlg,Data)
          
    case 'Help',
      LocalHelp    

    case 'PaperType',
      TypeInfo=get(Data.PaperType,{'String','Value'});
      set(Data.Fig,'PaperType',TypeInfo{1}{TypeInfo{2}});
      FigName=dlgfigname(Data.Fig);
      PageFig=findall(0,'Name',['Page Position: ' FigName]);
      if ~isempty(PageFig),
        pagesetupdlg('PrintDlgCall',PageFig);
      end        
      local_call_figure_resize(Data.Fig);
      
  end % switch
  
end % if

%%%%%%%%%%%%%%%%%%%%%%
%%%%% LocalClose %%%%%
%%%%%%%%%%%%%%%%%%%%%%
function LocalClose(Dlg,Data)
  
% If the Page Setup Dialog was opened from the Print Dialog
% then close the page setup dialog too.
if Data.PageSetupFlag,
  FigName=dlgfigname(Data.Fig);
  PageFig=findall(0,'Name',['Page Position: ' FigName]);
  if ~isempty(PageFig),
    pagesetupdlg('Close',PageFig)
  end
end
delete(Dlg)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% LocalFindHandles %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
function Match=LocalFindHandles(NewHandleVect,OldHandleVect,FirstSecond)

if isempty(OldHandleVect)|isempty(NewHandleVect),
  Match=[];  
else,  
  OldHandleVect=reshape(OldHandleVect,prod(size(OldHandleVect)),1);
  NewHandleVect=reshape(NewHandleVect,1,prod(size(NewHandleVect)));

  OldHandleMat=OldHandleVect(:,ones(size(NewHandleVect,2),1));
  NewHandleMat=NewHandleVect(ones(size(OldHandleVect,1),1),:);
  MatchMat= OldHandleMat==NewHandleMat;
  [Row,Column]=find(MatchMat);
  Match=(1:length(NewHandleVect));
  if FirstSecond==1,  
    Match=Column;    
  else,
    Match=Row;    
  end    

end % if isempty  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% LocalGetPlatformIndData %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Data=LocalGetPlatformIndData(Fig,varargin)

Data.Fig=Fig;

if nargin < 2
    Data.Pos1 = [0 0 1 1];
else,
    Data.Pos1=varargin{1};  
end

if nargin < 3
    Data.Pos2 = [0 0 1 1];
else,
    Data.Pos2=varargin{2};  
end

if nargin < 4
    Data.HideMe = [];
else
    Data.HideMe=varargin{3};  
end    
Data.HideMeVis=[];


%%%%%%%%%%%%%%%%%%%%%
%%%%% LocalHelp %%%%%
%%%%%%%%%%%%%%%%%%%%%
function LocalHelp
ttlStr = 'Print Dialog';


hlpStr1= ...                                               
        ['                                                     '  
         '   To send the designated figure window to           '  
         '   the default printer, select "Printer" from the    '  
         '   "Send To:" radiobuttons                           '  
         '                                                     '  
         '   To send the figure to a file, select "File"       '  
         '   from the "Send To:" radiobuttons and then press   '
         '   the "Save..." pushbutton.  A dialog box           '
         '   will appear in which you can enter a              '  
         '   filename for the file.                            '
         '                                                     '  
         '   If you change your mind about printing at any     '  
         '   time, press the "Cancel" button to cancel the     '  
         '   operation.                                        '];


hlpStr2= ...                                             
        ['                                               '  
         '    DEVICES                                    '  
         '    -------                                    '  
         '                                               '  
         '    Specify a device and other options in the  '  
         '    Device Option field.                       '  
         '                                               '  
         '    Type "help print" in the command window for'  
         '    a complete list of supported devices.      '  
         '                                               '  
         '                                               '  
         '                                               '];
hlpStr3= ...                                           
        ['                                             '  
         '    PAPER ORIENTATION                        '  
         '    ----------------                         '  
         '                                             '  
         '    LANDSCAPE generates output in full-page  '  
         '    landscape orientation on the paper.      '  
         '                                             '  
         '    PORTRAIT prints the figure window        '  
         '    occupying a rectangle with aspect ratio  '  
         '    4/3 in the middle of the page.           '  
         '                                             '  
         '    These radiobuttons set the               '
         '    PaperOrientation and PaperPosition       '
         '    properties of the printed figure window. '  
         '                                             '];

helpwin({'Print Dialog'      hlpStr1 ; ...
         'Devices'           hlpStr2 ; ...
         'Paper Orientation' hlpStr3},'Print Dialog',ttlStr);


%%%%%%%%%%%%%%%%%%%%%%%
%%%%% LocalHideMe %%%%%
%%%%%%%%%%%%%%%%%%%%%%%
function Data=LocalHideMe(Fig,Data)

hidemeax = findobj(Data.HideMe,'Type','axes');   % make all axes children
             % invisible too
for i = 1:length(hidemeax)
    temp = get(hidemeax(i),'children');
    Data.HideMe = [Data.HideMe(:); temp(:)];
end

Data.HideMeVis = [];   % store which of the hidden objects are visible
for i = 1:length(Data.HideMe)
    if strcmp(get(Data.HideMe(i),'visible'),'on')
        Data.HideMeVis = [Data.HideMeVis i];
    end
end

set(Data.HideMe,'visible','off')   % vectorized set

remapfig(Data.Pos1,Data.Pos2,Fig,findobj(Fig,'type','axes'))
drawnow discard    % don't redraw on screen

%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% LocalRevealMe %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
function LocalRevealMe(Fig,Data)
remapfig(Data.Pos2,Data.Pos1,Fig,findobj(Fig,'type','axes'))
set(Data.HideMe(Data.HideMeVis),'visible','on')   % vectorized set

%%%%%%%%%%%%%%%%%%%%%%
%%%%% LocalPrint %%%%%
%%%%%%%%%%%%%%%%%%%%%%
function LocalPrint(Dlg,Data)

    if get(Data.ToFile(2),'Value')==1 & ~Data.SetupMode
        [fname, pname] = uiputfile('*.*','Save As');
        if isequal(fname,0),
          return
        end
        printer='';
        
    else
        fname = '';
        pname = '';
        if (isunix),
          printer=['-P' get(Data.Printer,'String')];
        else
          printer='';
        end
    end

    Fig=Data.Fig;
    %figure(Fig)  %is this legacy code? We don't want to draw invis figs!

    device = get(Data.Device,'String');
    device=strrep(device,' ',''',''');

    % Need to use parentheses for print command
    % Re: The Mac will otherwise error for files of paths with spaces
    if ~isempty(fname) & ~isempty(pname)
      if strcmp(get(Fig,'IntegerHandle'),'on'),
        pstr = ['print(''-f' sprintf('%d',Fig) ''','''  ...
                 printer ''',''' ...
                 device ''',''' ...
                 fullfile(pname,fname) ''')'];
      else,
        pstr = ['print(''-f' sprintf('%.16f',Fig) ''',''' ...
                 printer ''',''' ...
                 device ''',''' ...
                 fullfile(pname,fname) ''')'];
      end
    elseif ~isempty(fname) 
      if strcmp(get(Fig,'IntegerHandle'),'on'),
        pstr = ['print(''-f' sprintf('%d',Fig) ''',''' ...
                 printer ''',''' ...
                 device ''',''' ...
                 fname ''')'];
      else,
        pstr = ['print(''-f' sprintf('%.16f',Fig) ''',''' ...
                 printer ''',''' ...
                 device ''',''' ...
                 fname ''')'];
      end
    else
      if strcmp(get(Fig,'IntegerHandle'),'on'),
        pstr = ['print(''-f' sprintf('%d',Fig) ''',''' ...
                 printer ''',''' ...
                 device ''')'];
      else,
        pstr = ['print(''-f' sprintf('%.16f',Fig) ''',''' ...
                 printer ''',''' ...
                 device ''')'];
      end
    end

    Data=LocalHideMe(Fig,Data);    
    
    % NOW EVAL THE PRINT STATEMENT:
    error = 0;
    if ~Data.SetupMode
       eval(pstr,'error = 1;');   % print causes uicontrols to flash - sigh...
    end
    
    if error
       errordlg({'The attempt to print produced an error.','',...
             'Here was the print command:',pstr,'and here was the error:',...
             lasterr},'Print Error');
     else
        % save stuff in appdata for future calls to printdlg
        setappdata(0,'PrintSetupPrinter',get(Data.Printer,'string'));
        setappdata(0,'PrintSetupDeviceOption',get(Data.Device,'string'));
        setappdata(0,'PrintSetupSendTo',get(Data.ToFile,'value'));
     end

    LocalRevealMe(Fig,Data);    

%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% LocalInitFig %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
function Dlg=LocalInitFig(Data)

if length(Data.Fig)~=1, error('FIG input must be a scalar'), end

% return if fig is not a figure
if ~ishandle(Data.Fig) & ~strcmp(get(Data.Fig,'Type'),'figure'),
  warning('PRINTDLG requires a single figure handle');  
  return
end  

FigName=dlgfigname(Data.Fig);

if Data.SetupMode
   Dlgname = ['Print Setup: ' FigName ];
else
   Dlgname = ['Print: ' FigName ];
end
   
Dlg=findobj(allchild(0),'flat','Name',Dlgname);

if ~isempty(Dlg),
  figure(Dlg);
  return
end  

pos = get(0,'defaultfigureposition');

BtnWidth=75;BtnHeight=20;
Offset=3;
    
 
FigWidth=275;

BtnPos=zeros(4,4);    
BtnPos(1,:)=[Offset Offset BtnWidth BtnHeight];
BtnPos(2,:)=BtnPos(1,:);BtnPos(2,1)=FigWidth-Offset-BtnWidth;
BtnPos(3,:)=BtnPos(1,:)+[0 BtnHeight+Offset 0 0];
BtnPos(4,:)=BtnPos(2,:)+[0 BtnHeight+Offset 0 0];
    
FramePos=zeros(2,4);    
FramePos(1,:)=[0 0 FigWidth sum(BtnPos(4,[2 4]))+Offset];
FramePos(2,:)=FramePos(1,:);FramePos(2,2)=sum(FramePos(1,[2 4]));

Width=(FramePos(1,3)-3*Offset)/3;
Upper=5;
TextPos=zeros(Upper,4);
TextPos(1,:)=[FramePos(2,1)+Offset FramePos(2,2)+Offset Width BtnHeight]; 
for lp=2:Upper,
  TextPos(lp,:)=TextPos(lp-1,:)+[0 BtnHeight+2 0 0];
end      

PopupPos=TextPos([1 1 2 3 4 4 5],:);
PopupPos([1 3 4 5 7],1)=sum(TextPos(1,[1 3]))+Offset;
PopupPos([2 6],1)=sum(PopupPos(1,[1 3]));
PopupPos([1 2 5 6 7],3)=Width;  
PopupPos(3:4,3)=2*Width;  
FramePos(2,4)=sum(PopupPos(end,[2 4]))+Offset-FramePos(2,2);


Units=get(0,'Units');
set(0,'Units','points');
ScreenSize=get(0,'ScreenSize');
set(0,'Units',Units);
FigHeight=sum(FramePos(2,[2 4]))+Offset;
pos=[(ScreenSize(3)-FigWidth)/2 (ScreenSize(4)-FigHeight-40)/2 ...
        FigWidth FigHeight];


%%% Set up the controls

White=[1 1 1];Black=[0 0 0];

Std.Units                = 'points'     ;
Std.HandleVisibility     = 'callback'   ;    
Std.Interruptible        = 'off'        ;
Std.BusyAction           = 'queue'      ;    
Btn=Std;
Btn.FontUnits            = 'points'                         ;
Btn.FontSize             = get(0,'FactoryUIControlFontSize');
Btn.ForeGroundColor      = Black                            ;
Btn.HorizontalAlignment  = 'center'                         ;

Popup=Btn;
Popup.HorizontalAlignment='left'                            ;    
Btn.Style                = 'pushbutton'                     ;    
Txt=Btn;
Txt.HorizontalAlignment  ='right'                           ;    
Txt.Style                ='text'                            ;    

FigColor=get(0,'defaultuicontrolbackgroundcolor');
if Data.SetupMode
   GoLabel='OK';
else
   GoLabel='Print';
end;
BtnString={'Cancel';GoLabel;'Help';'Page Setup...'};      
BtnTag=BtnString;
BtnCall={'printdlg Cancel';'printdlg Print'
         'printdlg Help'  ;'printdlg PageSetup'
        };

TextString={'Send to:'          ;'Device option:';'Printer:'
            'Paper orientation:';'Paper type:'
         };
[pcmd,device] = printopt;
device=[device,' -noui']; 
Loc=findstr('-P',pcmd);
if isempty(Loc)
  Printer='';
  if (isunix),
    Printer=getenv('PRINTER');
  elseif strcmp(computer, 'PCWIN')
    Printer=system_dependent('getdefaultprinter');
  end
else
  Loc2=Loc-1+find(pcmd(Loc:end)==' ');
  if isempty(Loc2) % min(x,[]) --> []
    Loc2=length(pcmd);
  end
  Printer=pcmd(Loc+2:Loc2);
  pcmd(Loc:Loc2)='';
end % if isempty          

PopupString=[{'Printer';'File'}
             {device}
             {Printer}
             {'Portrait';'Landscape'}
             {set(Data.Fig,'PaperType')}
            ];                   
PopupTag={'ToPrinter';'ToFile'
         'Device';
         'Printer';
         'Portrait';'Landscape'
         'PaperOrientation'};
PopupCall={'printdlg ToFile';'printdlg ToFile'     
           ''
           ''
           'printdlg Orientation';'printdlg Orientation'
           'printdlg PaperType'};
PopupStyle={'radiobutton';'radiobutton'
            'edit'
            'edit'
            'radiobutton';'radiobutton'
            'popupmenu'};
PopupColor={FigColor;FigColor;White;White;FigColor;FigColor;White};

%%% Create Everything    
Dlg = figure(Std             , ...
    'Color'          ,FigColor         , ...
    'Colormap'       ,[]               , ...
    'Menubar'        ,menubar          , ...
    'Resize'         ,'off'            , ...
    'Visible'        ,'on'            , ...
    'WindowStyle'    ,'modal'          , ...
    'Name'           ,Dlgname          , ...
    'Position'       ,pos              , ...
    'IntegerHandle'  ,'off'            , ...            
    'CloseRequestFcn','printdlg Cancel', ...                
    'Resize'         ,'off'            , ...                
    'NumberTitle'    ,'off'              ...
    );

Std.Parent=Dlg; Btn.Parent=Dlg;
Txt.Parent=Dlg; Popup.Parent=Dlg;

for lp=1:size(FramePos,1),
  FrameHandles(lp)=uicontrol(Std, ...
      'Style'   ,'frame'        , ...
      'Position',FramePos(lp,:)   ...
      );
end      
for lp=1:length(BtnTag),
  BtnHandles(lp)=uicontrol(Btn, ...
      'Position',BtnPos(lp,:) , ...          
      'Tag'     ,BtnTag{lp}   , ...
      'Callback',BtnCall{lp}  , ...
      'String'  ,BtnString{lp}  ...
      );                          
end      
for lp=1:length(TextString),
  TextHandles(lp)=uicontrol(Txt , ...
      'Position',TextPos(lp,:)  , ...          
      'Enable'  ,'inactive'     , ...               
      'String'  ,TextString{lp}   ...
      );
end      
  
for lp=1:length(PopupString),
  PopupHandles(lp)=uicontrol(Popup        , ...
      'Position'          ,PopupPos(lp,:) , ...
      'Tag'               ,PopupTag{lp}   , ...
      'Style'             ,PopupStyle{lp} , ...
      'BackgroundColor'   ,PopupColor{lp} , ...
      'Callback'          ,PopupCall{lp}  , ...
      'String'            ,PopupString{lp}  ...
      );                          
end      

% Set default paper type to be A4

Data.PrintHandle=BtnHandles(2);                   
Data.ToFile=PopupHandles(1:2);
Data.Device=PopupHandles(3);
Data.Printer=PopupHandles(4);
Data.Orientation=PopupHandles(5:6);
Data.PaperType=PopupHandles(7);
Data.PageSetupFlag=false;

if ~(isunix),
  set(Data.Printer,'Style','text','BackgroundColor',FigColor);
end

Val=find(strcmp(get(Data.Fig,'PaperType'),set(Data.Fig,'PaperType')));
set(Data.PaperType,'Value',Val);
set(Data.ToFile(1),'Value',1);
if strcmp(get(Data.Fig,'PaperOrientation'),'portrait'),
   set(Data.Orientation,{'Value'},{1;0});
else
   set(Data.Orientation,{'Value'},{0;1});
end

% Read Default Printer, Device, and SendTo from appdata of root
if isappdata(0,'PrintSetupPrinter')
   set(Data.Printer,'string',getappdata(0,'PrintSetupPrinter'));
end
if isappdata(0,'PrintSetupDeviceOption')
   set(Data.Device,'string',getappdata(0,'PrintSetupDeviceOption'));
end
if isappdata(0,'PrintSetupSendTo')
   EachChoice=getappdata(0,'PrintSetupSendTo');
   set(Data.ToFile,{'value'},EachChoice);
   if EachChoice{2} ... % Send to File is selected
      & ~Data.SetupMode
      set(Data.PrintHandle,'String','Save...');
   end
end

% this is saved in case of "Cancel"
Data.OrigData=get(Data.Fig,{'PaperType' ,'PaperOrientation', ...
                       'PaperUnits','PaperPosition','PaperPositionMode'});

set(Dlg,'Visible','on','UserData',Data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function local_call_figure_resize(fig),
%
% Stateflow printables draw themselves based on 
% papersize.  This function is called to allow the resize
% method of the stateflow printable figure to do it's gig
% whenver the papersize is changed.

% Short circuit non-stateflow related callbacks.
if (~ishandle(fig)) return; end;
if (~strcmp(get(fig, 'Tag'), 'STATEFLOW_PRINTABLE')), return; end;

sfprint(fig, 'resize');
