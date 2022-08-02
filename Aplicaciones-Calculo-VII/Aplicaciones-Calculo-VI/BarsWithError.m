function [hBars,errorbarprop] =  BarsWithError(Y,ErrorL,ErrorU,opt,xlabels,TitleGraph);
%% BarsWithError : To Solve the need for a decent bar plot with the
%% corresponding errorbars, probably the most useful thing in psychology
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BarsWithError
% Hacked by Chandramouli Chandrasekaran.
% The script plots a Bar graph of data along with corresponding errors which are
% provided to the script. Plots as follows. Given an m*n array it plots m
% groups of n bars each and their corresponding error values. As in the
% example provided. All Data must be provided at once, you cannot hold and
% plot Bars one by one. Here is an example and the sample output generated
% by such an operation. Sometimes errobars are not symmetric thats why I
% use
%
%
% Parameters
%     Y : The Matrix you would like to plot
%     ErrorL : The Standard error for the lower errorbar
%     ErrorU : The Standard error for the upper errorbar
%     opt : can be one of three
%         - 'default' : takes from a rough default color palette I have
%         - 'random' : takes a random color palette
%         - 'gray' : starts at a intermediate gray value and goes on
%         depending on the number of levles needed
%     xlabels : A default set of labels for the bars
%     TitleGraph : Something to name your graph
%
% Return Values
%     The handles to all barseries plotted in here for you to change the colors
%     The handles to all lines in the errorbars for you to change linewidth and color and so on 
% 
%%%%% Example %%%%%%%%
%   This is the matrix we have which we would like to plot with errorbars
%   Y = [1:1:10;2:2:20];
%   YError = [1 1 1 1 1 1 1 1 1 1 ; 2 2 2 2 2  2 2 2 2 2];
%   BarsWithError(Y,YError,YError);
%   BarsWithError(Y',YError',YError');
%   [hBars,hError] = BarsWithError(Y,YError,YError,'random',{'Group 1','Group 2'},'Sample Bar Chart')
%   IF YOU NEED TO CHANGE COLORS HERE YOU GO
%   set(hBars,'FaceColor',[1 1 1]); 
%%%%% End Example %%%%
% 
% 
% 
% Comments
% 1) Please Clear your axis before you pass any input already existing bars
% cause problems in the calculation of the x position for the errorbars
% 2) I plan to introduce a draft mode and a publish mode where I change the
% linewidths and so on.

hold on;
cla;
hBars = bar(Y);
H = findobj(gca,'type','patch');
H = sort(H);
EdgeColor = [0 0 0];
if length(H) <=7
FaceColor = [
    240 240 240;
    127 127 127;
    200 0 0;
    0 200 0;
    0 0 200;
    255 128 0;
    255 0 255;
    ]./255;
else
    warning('Number of Bars > 7 defaulting to Random');
    opt = 'random'
end
%%% Choose what colors you would need
try
    opt = lower(opt);
    switch(opt)
        case 'random',
            FaceColor = rand(length(H),3);
        case 'default',
            if length(H) <= 7
                FaceColor = [
                    240 240 240;
                    127 127 127;
                    200 0 0;
                    0 200 0;
                    0 0 200;
                    255 128 0;
                    255 0 255;
                    ]./255;
            else
                FaceColor = rand(length(H),3);
            end
        case 'gray',
            EdgeColor = [0 0 0 ];
            step = (1 / (2*length(H)+1));
            RawValue = [0.4:step:1-step];
            FaceColor = repmat(RawValue',1,3);

    end
catch
end
errorbarprop = [];
for barnumber=1:1:length(H)
    h = H(barnumber);
    set(h,'FaceColor',FaceColor(barnumber,:),'EdgeColor',EdgeColor,'linewidth',1);
    XP = get(h,'XData');
    CalculatedX = mean(XP);
    hold on;
    errorbarprop(barnumber) = errorbar(CalculatedX,Y(:,barnumber),ErrorL(:,barnumber),ErrorU(:,barnumber));
    set(errorbarprop(barnumber),'linestyle','none','Color',EdgeColor,'linewidth',1);
end
set(gca,'fontsize',24);
try
        set(gca,'xtick',[0:1:size(Y,1)+1],'xticklabel',strvcat('',xlabels(end:-1:1),''));
        hTitle = title(TitleGraph);
        set(hTitle,'fontsize',24);
catch
end
try
        
catch
end
% clear all;


