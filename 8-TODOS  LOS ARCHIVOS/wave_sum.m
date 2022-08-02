function wave_sum
% FUNCTION WAVE_SUM
%
% Wave_Sum is a gui that allows the user to explore how two waves add
% together. 
% To activate set matlabs current directory to the save location of the file.
% Then type wave_sum in the command window
%
%
% Author: Ryan Van Fleet
% Email: ryan.van.fleet@gmail.com
% Date:   6/22/07
%
% wave_sum is a free Matlab function.  

% intialize and hides Gui as it is being constructed.
f =     figure('Visible','off','MenuBar','None','Name','Wave Sumation',...
        'Position',[200,400,800,450]);

hp1       = uipanel('Units','Pixels','Title','Axis Control',...
    'Position',[50,20,700,210]);

% Left panel side

htitle1  = uicontrol('Style','Text','String','A*sin(w(1)t)',...
            'Position',[110,180,100,30],'fontsize',16);
        
hA       = uicontrol('Style','Text','String','A',...
            'Position',[60,150,60,20],'Fontsize',14);
        
hEdit_A  = uicontrol('Style','Edit','String','5',...
            'Position',[150,150,50,20],'Callback', @EditCallBackA,...
            'BackgroundColor',[1 1 1]);
        
hSlider_A= uicontrol('Style','Slider','Position',[220,150,100,20],...
             'CallBack', @SliderCallBackA, 'Value',5,...
             'Min',0,'Max',10);

        
hw1      = uicontrol('Style','Text','String','w(1)',...
            'Position',[60,100,60,20],'fontsize',14);
    
hEdit_w1  = uicontrol('Style','Edit','String','10',...
            'Position',[150,100,50,20],'Callback', @EditCallBackw1,...
            'BackgroundColor',[1 1 1]);
        
hSlider_w1= uicontrol('Style','Slider','Position',[220,100,100,20],...
             'CallBack', @SliderCallBackw1, 'Value',10,...
             'Min',0,'Max',100);

hreset    = uicontrol('Style','PushButton','String','Reset',...
            'Position',[180,50,60,20],'CallBack', @ResetCallBack);
        
        % right panel side
        
htitle2  = uicontrol('Style','Text','String','B*sin(w(2)t + phi)',...
            'Position',[470,180,180,30],'fontsize',16);
        
hB       = uicontrol('Style','Text','String','B',...
            'Position',[450,150,60,20],'fontsize',14);

hEdit_B  = uicontrol('Style','Edit','String','5',...
            'Position',[540,150,50,20],'Callback', @EditCallBackB,...
            'BackgroundColor',[1 1 1]);
        
hSlider_B= uicontrol('Style','Slider','Position',[610,150,100,20],...
             'CallBack', @SliderCallBackB, 'Value',5,...
             'Min',0,'Max',10);
         
hw2      = uicontrol('Style','Text','String','w(2)',...
            'Position',[450,100,60,20],'fontsize',14);
     
hEdit_w2  = uicontrol('Style','Edit','String','10',...
            'Position',[540,100,50,20],'Callback', @EditCallBackw2,...
            'BackgroundColor',[1 1 1]);
        
hSlider_w2= uicontrol('Style','Slider','Position',[610,100,100,20],...
             'CallBack', @SliderCallBackw2, 'Value',10,...
             'Min',0,'Max',100);
         
hPhi      = uicontrol('Style','Text','String','Phi',...
            'Position',[450,50,60,20],'fontsize',14);
        
hEdit_Phi = uicontrol('Style','Edit','String','0',...
            'CallBack',@EditCallBackPhi,'BackgroundColor',[1 1 1],...
            'Position',[540,50,50,20]);
        
hSlider_Phi=uicontrol('Style','Slider','Position',[610,50,100,20],...
            'CallBack',@SliderCallBackPhi,'Value',0,...
            'Min',0,'Max',6.2832);
        
        % Axes
ha       =  axes('Units','Pixels','Position',[50,260,700,180]);


% Initialize the GUI
% Changes the Units to normalized so components resize automatically
set([f,hp1,htitle1,hA,hEdit_A,hSlider_A,hw1,hEdit_w1,hSlider_w1,...
    htitle2,hB,hEdit_B,hSlider_B,hw2,hEdit_w2,hSlider_w2,...
    hPhi,hEdit_Phi,hSlider_Phi,ha],'Units','normalized');

% Generate Plot Data
time = 0:.001:3*pi;
Wave1 = 5*sin(10*time);
Wave2 = 5*sin((10*time) + 0);
Wave3 = Wave1 + Wave2;
% Plot data
hold on
plot(time,Wave1,'--g');
plot(time,Wave2,':b');
plot(time,Wave3,'-r')
axis([0,3*pi,-25,25]);
xlabel('Time')
ylabel('Amplitude')
hold off

set(f,'Visible','on');

% functions for A values
    function EditCallBackA(varargin)
        % function sets slide bar to edit box's value
        num = str2num(get(hEdit_A,'String')); % Use str2num -> allows use of pi in edit box
        if length(num) == 1 && num <= 10 & num>=0
            set(hSlider_A,'Value',num);
     GetnPlot;
        else
            msgbox('The value should be a number in the range [0,100]',...
                'Error','error','modal');
        end

    end
    function SliderCallBackA(varargin)
        % function sets edit box to sliders value
        num = get(hSlider_A, 'Value');
        set(hEdit_A, 'String', num2str(num));
    GetnPlot;
    end

% functions for w1 values
    function EditCallBackw1(varargin)
        % function sets slide bar to edit box's value
        num = str2num(get(hEdit_w1,'String'));
        if length(num) == 1 && num <= 1000 & num>=0
            set(hSlider_w1,'Value',num);
          GetnPlot;
        else
            msgbox('The value should be a number in the range [0,100]',...
                'Error','error','modal');
        end

    end
    function SliderCallBackw1(varargin)
        % function sets edit box to sliders value
        num = get(hSlider_w1, 'Value');
        set(hEdit_w1, 'String', num2str(num));
      GetnPlot;
    end

% functions for B values
    function EditCallBackB(varargin)
        % function sets slide bar to edit box's value
        num = str2num(get(hEdit_B,'String'));
        if length(num) == 1 && num <=10 & num>=0
            set(hSlider_B,'Value',num);
        GetnPlot;
        else
            msgbox('The value should be a number in the range [ 0, 10 ]',...
                'Error','error','modal');
        end

    end
    function SliderCallBackB(varargin)
        % function sets edit box to sliders value
        num = get(hSlider_B, 'Value');
        set(hEdit_B, 'String', num2str(num));
      GetnPlot;
    end

% functions for w2 values
    function EditCallBackw2(varargin)
        % function sets slide bar to edit box's value
        num = str2num(get(hEdit_w2,'String'));
        if length(num) == 1 && num <=100 & num >= 0
            set(hSlider_w2,'Value',num);
         GetnPlot;
        else
            msgbox('The value should be a number in the range [ 0, 100 ]',...
                'Error','error','modal');
        end

    end
    function SliderCallBackw2(varargin)
        % function sets edit box to sliders value
        num = get(hSlider_w2, 'Value');
        set(hEdit_w2, 'String', num2str(num));
        GetnPlot;
    end

% Functions for Phi Values
    function EditCallBackPhi(varargin)
        % function sets slider to edit boxes value
        num = str2num(get(hEdit_Phi,'String'));
        if length(num) == 1 && num <= 6.2832 & num >= 0
            set(hSlider_Phi,'Value',num);
        GetnPlot;
        else
            msgbox('The value should be a number in the range [ 0, 6.2832 ]',...
                'Error','error','modal');
        end
    end
    function SliderCallBackPhi(varargin)
        % function sets edit box to slides value
        num = get(hSlider_Phi,'Value');
        set(hEdit_Phi,'String',num2str(num));
        GetnPlot;
    end
    function GetnPlot(varargin)
        A =   get(hSlider_A,'Value');
        w1 =  get(hSlider_w1,'Value');
        B =   get(hSlider_B,'Value');
        w2 =  get(hSlider_w2,'Value');
        phi = get(hSlider_Phi,'Value');

        Wave1 = A*sin(w1*time);
        Wave2 = B*sin((w2*time) + phi);
        Wave3 = Wave1 + Wave2;
        cla('reset')
        hold on
        plot(time,Wave1,'--g');
        plot(time,Wave2,':b');
        plot(time,Wave3,'-r')
        axis([0,3*pi,-25,25]);
        xlabel('Time')
        ylabel('Amplitude')
        hold off
    end
    function ResetCallBack(varargin)
        % Returns all values to default
        set(hSlider_A,'Value',5);
        set(hEdit_A,'String',5);
        set(hSlider_w1,'Value',10);
        set(hEdit_w1,'String',10);
        set(hSlider_B,'Value',5);
        set(hEdit_B,'String',5);
        set(hSlider_w2,'Value',10);
        set(hEdit_w2,'String',10);
        set(hSlider_Phi,'Value',0);
        set(hEdit_Phi,'String',0);
        time = 0:.001:3*pi;
        Wave1 = 5*sin(10*time);
        Wave2 = 5*sin((10*time) + 0);
        Wave3 = Wave1 + Wave2;
        % Plot data
        cla('reset')
        hold on
        plot(time,Wave1,'--g');
        plot(time,Wave2,':b');
        plot(time,Wave3,'-r')
        axis([0,3*pi,-25,25]);
        xlabel('Time')
        ylabel('Amplitude')
        hold off
    end
end