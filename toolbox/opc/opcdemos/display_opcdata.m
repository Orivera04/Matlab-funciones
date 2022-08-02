function display_opcdata(obj,event)
%DISPLAY_OPCDATA Displays recently logged data in a figure window.

% Copyright 2004 The MathWorks, Inc.

numRecords = min(obj.RecordsAvailable, 60);
lastRecords = peekdata(obj,numRecords);
[i, v, q, t, et] = opcstruct2array(lastRecords);
plot(t, v);
isBad = strncmp('Bad', q, 3);
isRep = strncmp('Repeat', q, 6);
hold on
for k=1:length(i)
  h = plot(t(isBad(:,k),k), v(isBad(:,k),k), 'o');
  set(h,'MarkerEdgeColor','k', 'MarkerFaceColor','r')
  h = plot(t(isRep(:,k),k), v(isRep(:,k),k), '*');
  set(h,'MarkerEdgeColor',[0.75, 0.75, 0]);
end
axis tight;
set(gca,'YLim',[0, 200]);
datetick('x','keeplimits');
eventTime = event.Data.LocalEventTime;
title(sprintf('Event occured at %s', ...
  datestr(eventTime, 13)));
drawnow; % force an update of the figure window
hold off;