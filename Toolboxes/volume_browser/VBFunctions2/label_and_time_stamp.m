function label_and_time_stamp(time,label,axis_handle)
% Function creates time stamp and possibly a label on a plot
%
% Written by: E. Rietsch: October 21, 2006
% Last updated:
%
%         label_and_time_stamp(time,label)
% INPUT
% time    string with date and time (e.g. output of "datestr(now)")
% label   optional string for the left-hand corner of the plot
%
% EXAMPLE
%    figure; plot(1:11)
%    label_and_time_stamp(datestr(now),'This is a test')

drawnow		% Force any graphic object in the queue to be plotted

if nargin < 3 
   axis_handle=gca;	% Save handle to current axes
end

h=axes('Position',[0 0 1 1],'Visible','off');
yt=0.02;
text(0.8,yt,time,'FontSize',7); 

if nargin > 1  && ~isempty(label)
   text(0.1,yt,label,'FontSize',7);
end

set(h,'HandleVisibility','off');

axes(axis_handle)	% Make original axes the current axes
