function varargout = con2dis(action,varargin)

% Last Update: 18-Dec-2004
%   : Revision history contained in readme.m file

% This GUI was written by Gregory Krudysz during Summer/Fall 2001. 
%
% Acknowledgement:
%  I would like to thank Jordan Rosenthal and Prof. McClellan for their support
%  and encouragement in writing this GUI.  Some of the files were written by 
% Jordan and/or modified by Prof. McClellan.
%
% Gregory Krudysz, Fall 2001
%-----------------------------------------------------------------------------
if nargin == 0
    action = 'Initialize';
else
    h = guidata(gcbf);
    mt = getappdata(gcbf,'movietoolData');
    if ~isempty(mt), pre_callbackAction(mt,action,gcbo,[],h); end
end

%globals
Ver = 'CON2DIS ver. 2.0';  % Version string for figure title
%Xlimit = 0.50;		        % x-axis limits for Axes 1 and 2
YSPMAX = 1.05;              % max height of the spectrum display
%xMAX   = 1.05;
%-----------------------------------------------------------------------------

switch action
    %====================================================================
    case 'Initialize'
        %====================================================================
        %---  Check the installation, the Matlab Version, and the Screen Size  ---%
        errCmd    = 'errordlg(lasterr,''Error Initializing Figure'');error(lasterr);';
        cmdCheck1 = 'installcheck;';
        cmdCheck2 = 'h.MATLABVER = versioncheck(5.2);'; 
        cmdCheck3 = 'screensizecheck([800 600]);';
        cmdCheck4 = ['adjustpath(''' mfilename ''');'];
        eval(cmdCheck1,errCmd);       % Simple installation check
        eval(cmdCheck2,errCmd);       % Check Matlab Version
        eval(cmdCheck3,errCmd);       % Check Screen Size
        eval(cmdCheck4,errCmd);       % Adjust path if necessary
        
        % GUI
        ver = version;
        h.MATLABVER =str2double(ver(1:3));
        if h.MATLABVER < 5.3
            gui2
        else
            gui
        end
        
        set(gcf,'Name',Ver);
        h.FigPos = get(gcf,'Pos');

        SCALE = getfontscale;          % Platform dependent code to determine SCALE parameter
        setfonts(gcf,SCALE);           % Setup fonts: override default fonts used in con2dis
        h = gethandles(h);             % Get GUI graphic handles
        h = defaultplots(h);           % Create default plots
        configresize(gcf);             % Change all 'units'/'font units' to normalized
        
        % ===== Movie-Tool call ========
        movietool('Initialize',gcf,mfilename,0.08);
        % ==============================
        
        %--- Store the structure of handles/data for use later during a callback ---%
        guidata(gcf,h);
        set(gcf,'HandleVisibility','callback'); % Make figure inaccessible from command line  
        
        %====================================================================
        %====================================================================
    case 'SetFigSize'
        %====================================================================
        set(gcbf, 'Units', 'Normalized');
        FigSize = [0.10 0.10 0.55 0.80];
        set(gcbf, 'Position', FigSize);
        %====================================================================
    case 'ResizeFcn'
        %====================================================================
        % Fix for bugs in normalized fontunits in Matlab 5.2.
        % Force constant figure aspect ratio if in Matlab 5.3.
        h.FigPos = get(gcf,'Pos');
        ver = version;
        h.MATLABVER =str2double(ver(1:3));
        
        FigPos = resizefcn(h.FigPos,gcbo,h.MATLABVER); % Version dependent resize code
        switch computer
            case 'MAC2'
                % On MAC, baseline of text inside edit boxes remains at same
                % vertical position irregardless of change in font size.
                % To properly align text, here the old edit boxes are deleted
                % and new ones created with the proper size.
                hEd = findall(gcbf,'type','uicontrol','style','edit');
                OldFontUnits = get(hEd,'FontUnits');
                set(hEd,'FontUnits','Pixels');
                hEdNew = zeros(size(hEd));
                relHeightChange = FigPos(4)/h.FigPos(4);
                for i = 1:length(hEd)
                    Props = get(hEd(i));
                    FontSize = relHeightChange*Props.FontSize;
                    Props = rmfield(Props,{'Extent','Type','FontSize','FontUnits'});
                    delete(hEd(i));
                    hEdNew(i) = uicontrol('FontUnits','Pixels', ...
                        'FontSize',FontSize,Props);
                end
                set(hEdNew,{'FontUnits'},OldFontUnits);
                h = gethandles(h);
                guidata(gcbf,h);
        end
        
        sethandles(h,'FigPos',FigPos);                  % Store old position
        %====================================================================   
    case 'WindowButtonMotionFcn'
        %==================================================================== 
        [mouse_x,mouse_y,fig_size] = mousepos;
        old_units = get(h.Axis4,'units');
        set(h.Axis4,'units','pixels');
        line4 = get(h.Line4(2),'Xdata');
        line4y = get(h.Line4(2),'Ydata');
        line4c = get(h.Line4c(2),'Xdata');
        
        ax = get(h.Axis4,'pos');
        set(h.Axis4,'units',old_units);
        
        % Cursor over object axes flag
        over_axes_flg = any( (mouse_x > ax(1)) & (mouse_x < ax(1)+ax(3)) &  ...
            (mouse_y > ax(2)) & (mouse_y < ax(2)+ax(4)) );
        
        if over_axes_flg
            
            current_pt = get(h.Axis4,'CurrentPoint');
            % specify handle tolerance whithin 10% of xlim
            axis_xlim = get(h.Axis4,'Xlim');         
            toll = axis_xlim(2)*0.1;
            
            % Cursor over either of the two stems
            y_lim_flg = current_pt(1,2) < line4y(2);
            on_right_flg = abs(current_pt(1,1)-line4(1)) < toll;
            on_left_flg = abs(current_pt(1,1)-line4c(1)) < toll;
            
            if (on_right_flg | on_left_flg) & y_lim_flg
                setptr(gcbf,'hand');
            else
                setptr(gcbf,'arrow');
            end
        else
            setptr(gcbf,'arrow');
        end
        %====================================================================
    case {'Editbox1','Slider1'}
        %====================================================================          
        
        if strcmp(action,'Slider1') %get(gco,'style')
            %-----------------------------%
            FoN = get(h.Slider1,'Value');
            
            numlim = 1e-3;      % prevent extremely small period T
            if FoN < numlim
                set(h.Slider1,'Value',numlim);
                FoN = numlim;
            end
            
            Fo = sprintf('%.1f',FoN); 
            set(h.Editbox1,'String',Fo);
            %-----------------------------%
        elseif strcmp(action,'Editbox1')
            %-----------------------------%
            Fo = get(h.Editbox1,'String');
            FoN = str2double(Fo);
            FoMAX = get(h.Slider1,'Max');
            FoN = min([FoN,FoMAX]);    
            %-----------------------------%
        else
            error(['ERROR IN ' mfilename ' case: Editbox1 : CANNOT FIND APPROPRIATE STYLE']);
        end
        
        FsN = get(h.Slider2,'Value');
        
        if h.wflag
            FoN = FoN/(2*pi);
            FsN = FsN/(2*pi);
            %Fo = sprintf('%.1f',FoN);
        end
        
        Fochange(h,FoN,FsN,h.time1);    
        %====================================================================
    case {'Editbox2','Slider2'}
        %====================================================================
        if strcmp(action,'Slider2')
            FsN = get(h.Slider2,'Value');
            if h.wflag == 1
                FsN = FsN/(2*pi);
            end
            
            numlim = 1e-3;         % prevent extremly small period T
            if FsN < numlim
                
                if h.wflag == 1
                    set(h.Slider2,'Value',2*pi*numlim);
                else
                    set(h.Slider2,'Value',numlim);
                end
                
                FsN = numlim;
                
            else
                if h.wflag == 1
                    set(h.Slider2,'Value',2*pi*FsN);
                else
                    set(h.Slider2,'Value',FsN);
                end   
            end
            
            if h.wflag == 1
                Fs = sprintf('%.1f',2*pi*FsN);   
            else
                Fs = sprintf('%.1f',FsN); 
            end
            
            set(h.Editbox2,'String',Fs); 
        end
        
        Fs = get(h.Editbox2,'String');
        FsN = str2double(Fs);
        FoN = get(h.Slider1,'Value');
        MaxFs = get(h.Slider2,'Max');
        MinFs = get(h.Slider2,'Min');
        
        if h.wflag == 1
            pi2 = 2*pi; 
            FoN = FoN/pi2;
            FsN = FsN/pi2;
            MaxFs = MaxFs/pi2;
            MinFs = MinFs/pi2;
        end
        
        FsN = min( [max([MinFs,FsN]),MaxFs] );
        
        if h.wflag == 1
            WsS = sprintf('%.1f',pi2*FsN);
            set(h.Editbox2,'String',WsS)
        else   
            FsS = sprintf('%.1f',FsN);
            set(h.Editbox2,'String',FsS)
        end
        
        if FoN>1.49*FsN
            FoN = floor(1.49*FsN*10)/10;
        end
        
        R = FoN/FsN;
        if (abs(mod(R,1))<1e-3)
            Xsp = abs(cos(h.phaseN));
        else
            Xsp = 0.5;
        end
        
        Fochange(h,FoN,FsN,h.time1)
        
        if h.wflag == 1   
            Fo = sprintf('%.1f',pi2*FoN);
            set(h.Editbox1,'String',Fo);
            set(h.Slider1,'Value',pi2*FoN,'Max',1.49*pi2*FsN);
            set(h.Slider2,'Value',pi2*FsN);   
            set(h.TextFs,'String',sprintf('\\omega_s = %.1f (rad/s)',pi2*FsN)); 
        else   
            Fo = sprintf('%.1f',FoN);
            set(h.Editbox1,'String',Fo);
            set(h.Slider1,'Value',FoN,'Max',1.49*FsN);
            set(h.Slider2,'Value',FsN);
            set(h.TextFs,'String',sprintf('f_s = %.1f (Hz)',FsN));
        end
        
        % Axes2 -------------------
        FoNc2 = phaseText(h,FoN,FsN,R);
        time2 = 0:1/FsN:0.5;
        stemdata(time2,cos(2*pi*FoNc2*time2 + h.phaseN),h.Line2);
        
        if length(time2) > 12
            time2a = 0:2/FsN:1;
            set(h.Axis2,'XTick',time2a ...
                ,'XTickLabel',2*(0:length(time2a)-1)');
        else
            set(h.Axis2,'XTick',time2 ...
                ,'XTickLabel',(0:length(time2)-1)');
        end
        
        %Axes4 --------------------
        if (abs(FoN)<1e-3)
            XCsp = abs(cos(h.phaseN));
        else
            XCsp = 0.5;
        end
        stemdata(FoN,XCsp,h.Line4);
        stemdata(-FoN,XCsp,h.Line4c);
        set(h.Line4d,'XData',[-FsN -FsN nan 0 0 nan FsN FsN] ...
            ,'YData',[0 YSPMAX nan 0 YSPMAX nan 0 YSPMAX]);
        if  h.wflag
            set([h.Axis4,h.Axis6],'XLim',[-1.5*FsN 1.5*FsN] ...
                ,'XTick',FsN*(-1:0.5:1) ...
                ,'XTickLabel',...
                {sprintf('%.1f',-pi2*FsN), sprintf('%.1f',-pi2*FsN/2), '0',...
                    sprintf('%.1f',-pi2*FsN/2), sprintf('%.1f',pi2*FsN)} );
        else
            set([h.Axis4,h.Axis6],'XLim',[-1.5*FsN 1.5*FsN] ...
                ,'XTick',FsN*(-1:0.5:1) ...
                ,'XTickLabel',...
                {sprintf('%.1f',-FsN), sprintf('%.1f',-FsN/2), '0',...
                    sprintf('%.1f',FsN/2), sprintf('%.1f',FsN)} );
        end
        set([h.Patch4,h.Patch6],'XData',[-FsN/2 FsN/2 FsN/2 -FsN/2] ...
            ,'YData',[0 0 YSPMAX YSPMAX]);         
        % Axes3 -------------------
        stemdata([-2+R -1+R 1+R  2+R],Xsp*[1,1,1,1],h.Line3out);
        stemdata([-2-R -1-R 1-R  2-R],Xsp*[1,1,1,1],h.Line3outC);
        stemdata(R,Xsp,h.Line3in);       
        stemdata(-R,Xsp,h.Line3inC);       
        
        % Axes6 -------------------
        if FoN > FsN/2
            set([h.Line6,h.Line6c],'Color','r');
            set(h.TextAlie,'Visible','On');
            set(h.Axis6,'Color', 0.75*[1,1,1]);
        elseif FoN == FsN/2
            set([h.Line6,h.Line6c],'Color','m');
            set(h.Axis6,'Color', 0.9*[1,1,1]);
            set(h.TextAlie,'Visible','Off');
        else
            set([h.Line6,h.Line6c],'Color','b');
            set(h.TextAlie,'Visible','Off');
            set(h.Axis6,'Color','w');
        end  
        %====================================================================
    case 'Editbox3'
        %====================================================================     
        FoN = get(h.Slider1,'Value');
        FsN = get(h.Slider2,'Value');
        %R = FoN/FsN;
        P = pi; 
        
        if h.wflag == 1
            FoN = FoN/(2*P);
            FsN = FsN/(2*P);
        end
        
        phase = get(h.Editbox3,'String');
        h.phaseN = str2num(phase);
        set(h.TextPh,'String',sprintf('Phase = %.2f',h.phaseN));
        
        guidata(gcbf,h);
        Fochange(h,FoN,FsN,h.time1);  
        %====================================================================
    case 'SetLineWidth'
        %====================================================================
        newLineWidth = linewidthdlg(h.LineWidth);
        h.MarkerSize = h.MarkerSize + (newLineWidth - h.LineWidth);
        h.LineWidth = newLineWidth;
        set(findobj(gcbf,'type','line'),'linewidth',h.LineWidth);
        guidata(gcbf,h);
        %====================================================================
    case 'LineDragStart'
        %====================================================================        
        CurrentPoint = eval([mfilename '(''GetCurrentPoint'')']);
        setptr(gcbf,'closedhand');
        set(gcbf,'WindowButtonUpFcn',sprintf('%s LineDragStop',mfilename), ...
            'WindowButtonMotionFcn',[mfilename ' MoveLine']);       
        %setappdata(h,'StartPos',CurrentPoint(1,1));
        %====================================================================
    case 'MoveLine'    
        %====================================================================
        CurrentPoint = eval([mfilename '(''GetCurrentPoint'')']);
        CurrentX = CurrentPoint(1,1);
        
        FoN = CurrentX*( 2*(CurrentX>0)-1 );       
        FoN = round(10*FoN)/10;         %- Round to nearest tenth
        %Fo = sprintf('%.1f',FoN);       
        FsN = get(h.Slider2,'Value');
        
        if h.wflag == 1
            FsN = FsN/(2*pi);
        end
        
        Fochange(h,FoN,FsN,h.time1);
        %====================================================================
    case 'LineDragStop'
        %====================================================================
        set(gcbf, 'WindowButtonMotionFcn','','WindowButtonUpFcn','', ...
            'WindowButtonMotionFcn', 'con2dis WindowButtonMotionFcn');
        setptr(gcbf,'arrow');
        %====================================================================
    case 'GetCurrentPoint'
        %==================================================================== 
        if isempty(get(h.Axis4,'userdata'))
            varargout = {get(h.Axis4,'CurrentPoint')};
        else
            varargout = {get(h.Axis4,'userdata')};
            set(h.Axis4,'userdata',[]);
        end
        %====================================================================
    case 'PlotsMenu'   
        %====================================================================   
        check = get(h.AllMenu,'Checked');
        if strcmp(check,'off')
            con2dis Unfold
        else
            con2dis Foldin;
        end
        %====================================================================
    case 'Unfold'
        %====================================================================   
        set(gcbo,'Checked','on')
        set(h.Group,'Units','Characters');
        FigSize = get(gcbf,'Position');
        FigSizeNew = [1 1 1.5 1].* FigSize;
        set(gcbf, 'Position', FigSizeNew);
        set(h.Group,'Units','normalized');
        set([h.Hide';h.Line6;h.Line6c],'vis','on');   
        %====================================================================
    case 'Foldin'
        %====================================================================   
        set(gcbo,'Checked','off');
        set(h.Group,'Units','Characters');
        FigSize = get(gcbf,'Position');
        FigSizeNew = [1 1 1/1.5 1].*FigSize;
        set(gcbf,'Position', FigSizeNew);
        set(h.Hide,'Visible','Off');
        set([h.Line6,h.Line6c],'Visible','Off');
        set(h.Group,'Units','Normalized');       
        %====================================================================
    case 'ShowW' 
        %====================================================================
        show = get(h.ShowW,'Checked');
        pi2 = 2*pi;
        
        if strcmp(show,'off')
            set(h.ShowW,'Checked','on'); 
            % change text labels
            set(gcbf,'CurrentAxes',h.Axis4);
            xlabel('\omega (rad/s)')
            set(gcbf,'CurrentAxes',h.Axis6);
            xlabel('\omega (rad/s)')
            
            % Find and change Fo and Fs
            %Fo = get(h.Editbox1,'String');
            FoN = get(h.Slider1,'Value');
            FsN = get(h.Slider2,'Value');
            WoN = pi2*FoN;
            WsN = pi2*FsN;
            Wo = sprintf('%.1f',WoN);
            Ws = sprintf('%.1f',WsN);
            MaxS2 = get(h.Slider2,'Max');
            MaxS2d = pi2*MaxS2;
            MinS2 = get(h.Slider2,'Min');
            MinS2d = pi2*MinS2;
            MaxS1d = pi2*1.49*FsN;
            R = FoN/FsN;
            
            set(h.TextFo,'String',sprintf('\\omega_o = %.1f (rad/s)',WoN));
            set(h.TextFs,'String',sprintf('\\omega_s = %.1f (rad/s)',WsN));
            
            set(h.Editbox1,'String',Wo);
            set(h.Editbox2,'String',Ws);
            set(h.Slider1,'Min',0,'Max',MaxS1d,'Value',WoN);
            set(h.Slider2,'Min',MinS2d,'Max',MaxS2d,'Value',WsN);        
            set([h.Axis4,h.Axis6],...
                'XTickLabel',{sprintf('%.1f',-pi2*FsN),sprintf('%.1f',-pi2*FsN/2),'0',sprintf('%.1f',pi2*FsN/2),sprintf('%.1f',pi2*FsN)} ); 
            
            set(h.RButton2,'Value',1);
            h.wflag = 1;     
        else 
            set(h.ShowW,'Checked','off');
            % change text labels
            set(gcbf,'CurrentAxes',h.Axis4);
            xlabel('f (Hz)')
            set(gcbf,'CurrentAxes',h.Axis6);
            xlabel('f (Hz)')
            
            % Find and change Fo and Fs
            %Wo = get(h.Editbox1,'String');
            WoN = get(h.Slider1,'Value');
            WsN = get(h.Slider2,'Value');
            FoN = WoN/pi2;  
            FsN = WsN/pi2;
            Fo = sprintf('%.1f',FoN);
            Fs = sprintf('%.1f',FsN);
            MaxS2 = get(h.Slider2,'Max');
            MaxS2h = MaxS2/pi2;
            MinS2 = get(h.Slider2,'Min');
            MinS2h = MinS2/pi2;
            MaxS1h = 1.49*FsN;
            R = FoN/FsN;
            
            set(h.TextFo,'String',sprintf('f_o = %.1f (Hz)',FoN));
            set(h.TextFs,'String',sprintf('f_s = %.1f (Hz)',FsN));
            
            set(h.Editbox1,'String',Fo);
            set(h.Editbox2,'String',Fs);
            set(h.Slider1,'Min',0,'Max',MaxS1h,'Value',FoN);
            set(h.Slider2,'Min',MinS2h,'Max',MaxS2h,'Value',FsN);       
            set([h.Axis4,h.Axis6],'XTickLabel',(round(10*FsN)/10)*(-1:0.5:1) );         
            
            set(h.RButton2,'Value',0);
            h.wflag = 0;
        end
        guidata(gcbf,h);
        phaseText(h,FoN,FsN,R); 
        h = guidata(gcbf);
        guidata(gcbf,h);
        %====================================================================
    case 'ShowW_hat' 
        %====================================================================
        show_hat = get(h.ShowW_hat,'Checked');
        %pi2 = 2*pi;
        
        if strcmp(show_hat,'off')
            set(h.ShowW_hat,'Checked','on'); 
            % change text labels
            h.FontSizeSym = get(h.Axis1,'FontSize');
            h.FontSizeSym = h.FontSizeSym + 0.2*h.FontSizeSym;
            set(gcbf,'CurrentAxes',h.Axis3);
            %xlabel('{}_{^{\fontsize{11}\omega = 2\pi (f_o / f_s)}}^{\^}') 
            
            xlabel('\omega = 2\pi (f_o / f_s)')
            %set(h.hat,'position',[-0.24 -0.12]);
            
            set(h.Axis3,'FontName','Symbol'...
                ,'XTick',0.5*(-2:2),'XTickLabel',{'-2p';'-p';'0';'p';'2p'}...
                ,'FontWeight','bold','FontSize',h.FontSizeSym);                  
            
            set(h.RButton22,'Value',1);
            h.w_hat_flag = 1;            
        else 
            set(h.ShowW_hat,'Checked','off');
            h.FontSize = get(h.Axis1,'FontSize');
            % change text labels
            set(gcbf,'CurrentAxes',h.Axis3);
            set(h.Axis3,'FontName','Helvetica',...
                'XTickLabel',{'-1';'-0.5';'0';'0.5';'1'},...
                'FontWeight','bold','FontSize',h.FontSize);  
            
            %xlabel('{}_{^{\fontsize{11} f = f_o / f_s}}^{\^}')
            xlabel('f = f_o / f_s')
            %set(h.hat,'position',[-0.21 -0.12]);
            
            set(h.RButton22,'Value',0);
            h.w_hat_flag = 0;
        end
        guidata(gcbf, h);
        %====================================================================
    case 'showLF'
        %====================================================================
        check = get(h.ShowLF,'Checked');
        if strcmp(check,'off')
            set(h.ShowLF,'Checked','on');
            set(h.Line11,'Visible','off');
            set(gcbf,'CurrentAxes',h.Axis2);
            set(h.Line52,'Visible','on');
        else
            set(h.ShowLF,'Checked','off');
            set(h.Line11,'Visible','on');
            set(h.Line52,'Visible','off');
        end
        set(h.TextClick,'Visible','off','color','k');  %--changing the color is a flag to turn this off.       
        %====================================================================
    case 'Help'
        %====================================================================
        hBar = waitbar(0.25,'Opening internet browser...');
        DefPath = which(mfilename);
        DefPath = ['file:///' strrep(DefPath,filesep,'/') ];
        URL = [ DefPath(1:end-9) , 'help/','index.html'];
        if h.MATLABVER >= 6
            STAT = web(URL,'-browser');
        else
            STAT = web(URL);
        end
        waitbar(1);
        close(hBar);
        switch STAT
            case {1,2}
                s = {'Either your internet browser could not be launched or' , ...
                        'it was unable to load the help page.  Please use your' , ...
                        'browser to read the file:' , ...
                        ' ', '     index.html', ' ', ...
                        'which is located in the Con2Dis help directory.'};
                errordlg(s,'Error launching browser.');
        end  
        %====================================================================
    otherwise
        %====================================================================
        error(['ERROR IN ' mfilename ' : CANNOT FIND APPROPRIATE ACTION']);
end

if nargin > 0 & gcbf
    h = guidata(gcbf);
    if ~isempty(mt), post_callbackAction(mt,action,gcbo,[],h); end
end
%e.of. con2dis

% ================================================================== %
function Handles = sethandles(Handles,field,value)
%SETHANDLES
%   Handles = sethandles(Handles,field,value) sets the field to the 
%   given value within the structure Handles and then saves the
%   structure in the current figure using guidata.
%
% Jordan Rosenthal
Handles = setfield(Handles,field,value);
guidata(gcbf,Handles);
% ================================================================== %