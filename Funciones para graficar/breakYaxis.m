% breakYaxis
% This program just adds 2 yTicks at the bottom of the y-axis
% First added ytick will be assigned 0
% Second y-tick are two almost horizontal lines to break up the y-axis
%
% EXAMPLE
% plot (rand(21,1)+50)
% breakYaxis

% Created December 10th 2008
% Created by Mark de Niet in the netherlands
% Version 1.0

yTickOld = get(gca,'Ytick');
dYtick = abs(diff(yTickOld));
yTickNew = [yTickOld(1)-2*dYtick(1) yTickOld];

set(gca,'Ytick',yTickNew)
yTickLabelOld = get(gca,'Yticklabel');
yTickLabelNew = {'0';''};
for i = 1:length(yTickLabelOld)
    yTickLabelNew(i+1) = {yTickLabelOld(i,:)};
end

set(gca,'yLim', [yTickNew(1) yTickNew(end)])
set(gca,'Yticklabel',yTickLabelNew)

xLimits = get(gca,'xlim');

posGCA = get(gca,'Position');

yHeight = 1/length(yTickNew)*posGCA(4);

annotation(gcf,'line',[posGCA(1) posGCA(1)],...
    [posGCA(2)+yHeight*.95 posGCA(2)+yHeight*1.05],...
    'LineWidth',1,'Color',[.999 .999 .999]);
annotation(gcf,'line',[posGCA(1)-posGCA(3)/40 posGCA(1)+posGCA(3)/40],...
    [posGCA(2)+yHeight posGCA(2)+yHeight*1.1],'LineWidth',1);
annotation(gcf,'line',[posGCA(1)-posGCA(3)/40 posGCA(1)+posGCA(3)/40],...
    [posGCA(2)+yHeight*.9 posGCA(2)+yHeight],'LineWidth',1);

set(gca,'yLim', [yTickNew(1) yTickNew(end)])
set(gca,'xLim', xLimits)
set(gca,'Yticklabel',yTickLabelNew)

