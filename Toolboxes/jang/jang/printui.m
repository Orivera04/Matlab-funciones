function printui(arg1,arg2,arg3,arg4,arg5,arg6)
%PRINTUI Print figure with uicontrols.
%	PRINTUI print a figure with uicontrols on it.
%	This function will accept normal print arguments as input.  In addition
%	to the normal print flags, an addition flag (-m) may also be passed
%	which will cause this function to print the uimenus on PC and UNIX 
%	platforms.
%
%	WARNING: Due to the behavior of the GETFRAME function on the
%	PC, uicontrols still may not print properly on PC platforms.
%
%	See also PRINT.

%	Loren Dean   May 9, 1995.
%	Copyright (c) 1995 by The MathWorks, Inc.

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Get Correct Figure %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
MenuFlag=0;
Fig=get(0,'CurrentFigure');
for lp=1:nargin,
  eval(['cur_arg=arg' num2str(lp) ';']);
  if (cur_arg(2) == 'f'),
    Fig=str2num(cur_arg( 3:length(cur_arg) ));
  elseif cur_arg(2)=='m',
    MenuFlag=1;
    eval(['arg' num2str(lp) '=[];']);
  end
end

%%%%%%%%%%%%%%
%%% Set Up %%%
%%%%%%%%%%%%%%
ComputerType=computer;
OldRootUnits=get(0,'Units');
OldFigUnits=get(Fig,'Units');
OldFigCMap=get(Fig,'Colormap');
OldFigCopy=get(Fig,'InvertHardCopy');
set(0,'Units','pixels');
set(Fig,'Units','pixels','NextPlot','add');%,'InvertHardCopy','off');
FigPos=get(Fig,'Position');

%%%%%%%%%%%%%%%%%%%
%%% UI Controls %%%
%%%%%%%%%%%%%%%%%%%
UICHandles=findobj(Fig,'Type','uicontrol','Visible','on');
if ~isempty(UICHandles),
  % Making the assumption that the bottom uicontrol is usually
  % created first and underneath the others.
  UICHandles=flipud(UICHandles);
  UICUnits=[];
  for lp=1:length(UICHandles),
    UICUnits=str2mat(UICUnits,get(UICHandles(lp),'Units'));
  end % for lp
  UICUnits(1,:)=[];
  set(UICHandles,'Units','pixels');

  FramePos=[];
  FrameNum=0;
  AxisHandles=[];

  for Clp=1:length(UICHandles),
    FrameFlag=1;
    CurCtrlPos=get(UICHandles(Clp),'Position');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Check to see if completely contained in previous frames
    for Frmlp=1:FrameNum,
      if CurCtrlPos(1)>=FramePos(Frmlp,1) & ...
         CurCtrlPos(2)>=FramePos(Frmlp,2) & ...
         sum(CurCtrlPos([1 3]))<=sum(FramePos(Frmlp,[1 3])) & ...
         sum(CurCtrlPos([2 4]))<=sum(FramePos(Frmlp,[2 4])) ,         
        FrameFlag=0;
        break;
      end % if CurCtrlPos
    end % Frmlp
    %%%%%%%%%%%%%%%%%%%
    % It is a new frame
    if ~isempty(FramePos),
      RmvFrmLoc=[];
      if FrameFlag,
        for inlp=1:size(FramePos,1),
          if CurCtrlPos(1)>=FramePos(inlp,1) & ...
             CurCtrlPos(2)>=FramePos(inlp,2) & ...
             sum(CurCtrlPos([1 3]))<=sum(FramePos(inlp,[1 3])) & ...
             sum(CurCtrlPos([2 4]))<=sum(FramePos(inlp,[2 4])) ,         
             % New Frame Contains an old frame
               RmvFrmLoc=[RmvFrmLoc inlp];
           end
        end
      
        FramePos(RmvFrmLoc,:)=[];
        FrameNum=size(FramePos,1)+1;
        FramePos(FrameNum,1:4)=CurCtrlPos;
      end % if FrameFlag
    else,
      FramePos=CurCtrlPos;
      FrameNum=1;
    end % if ~isempty
  end % for Clp
  
end % if ~isempty(UIC)

%%%%%%%%%%%%%%%%%%%%%
%%% Create images %%%
%%%%%%%%%%%%%%%%%%%%%
figure(Fig);
drawnow;
if ~isempty(FramePos),
  for lp=1:length(FramePos(:,1)),
    [CaptureMat,CaptureMap]=getframe(Fig,FramePos(lp,:));
    AxisHandles(lp)=axes(           ...
                        'Units'   ,'pixels'      , ...
                        'Position',FramePos(lp,:), ...
                        'Visible' ,'off'           ...
                        ); 
    ImgHandle=image(CaptureMat);
    colormap(CaptureMap);
    drawnow;
  end % for lp

end % if ~isempty

FigAxisHandles=[];
MenuCaptureMap=[];
%%%%%%%%%%%%%%%%
%%% UI Menus %%%
%%%%%%%%%%%%%%%%
if MenuFlag,

  MenuFlag=0;
  if ~strcmp(ComputerType(1:3),'MAC'),
    if strcmp(ComputerType(1:2),'PC'),
      MenuHeight=19;
    else,
      MenuHeight=29;
    end
    
    UIMHandles=findobj(get(Fig,'Children'),'flat'  , ...
                      'Type'              ,'uimenu', ...
                      'Visible'           ,'on'      ...
                      );
                      
    if ~isempty(UIMHandles)| ...
         ( strcmp('figure',get(Fig,'Menubar')) & ...
           strcmp(ComputerType(1:2),'PC')        ...
          ),
      MenuFlag=1;
      
      %The following statement gets the image axis handles too
      %Minimal time hit, so I'm not going to worry about it.
      FigAxisHandles=findobj(Fig,'Type','axes');
      FigAxisUnits=[];
      for lp=1:length(FigAxisHandles),
        FigAxisUnits=str2mat(FigAxisUnits,get(FigAxisHandles(lp),'Units'));
      end % for lp
      FigAxisUnits(1,:)=[];
      set(FigAxisHandles,'Units','pixels');
      
      MenuFramePos=[0 FigPos(4) FigPos(3)+1 MenuHeight];
      [MenuCaptureMat,MenuCaptureMap]=getframe(Fig,MenuFramePos);
      colormap(MenuCaptureMap);
      set(Fig,'Position',FigPos+[0 0 0 MenuHeight]);
      set(FigAxisHandles,'Units','normalized');
    
      BoxHandle=axes('Units'   ,'pixels'                      , ...
                     'Position',get(Fig,'Position').*[0 0 1 1], ...
                     'XTick'   ,[]                            , ...
                     'YTick'   ,[]                            , ...
                     'Box'     ,'on'                            ...
                    );
      set(BoxHandle,'Units','normalized');
      
      if isempty(AxisHandles),
        HandleLoc=1;
      else,
        HandleLoc=length(AxisHandles)+1;
      end
      
      AxisHandles(HandleLoc)=axes(               ...
                        'Units'   ,'pixels'    , ...
                        'Position',MenuFramePos, ...
                        'Visible' ,'off'         ...
                        );
      ImgHandle=image(MenuCaptureMat);
    end % if ~isempty(UIM)
  end % if strcmp
end % if MenuFlag

if ~isempty(AxisHandles),
  set(AxisHandles,'Units','normalized','Visible','off');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Print and Clean Up %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
PrintStr='print ';
for lp=1:nargin,
  eval(['PrintStr=[PrintStr '' '' arg' num2str(lp) '];']);
end
drawnow;
eval(PrintStr);

if MenuFlag,
  delete(BoxHandle);
  set(FigAxisHandles,'Units','pixels');
  set(Fig,'Position',FigPos);
  for lp=1:length(FigAxisHandles),
    set(FigAxisHandles(lp),'Units',deblank(FigAxisUnits(lp,:)));
  end % for lp
end % if MenuFlag

delete(AxisHandles);
set(Fig            , ...
   'Units'         ,OldFigUnits, ...
   'InvertHardCopy',OldFigCopy , ...
   'Colormap'      ,OldFigCMap   ...
   );
set(0,'Units',OldRootUnits);
for lp=1:length(UICHandles),
  set(UICHandles(lp),'Units',deblank(UICUnits(lp,:)));
end % for lp

