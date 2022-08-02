Submission name: dateticks_after_zoom
Keywords: datetick, ticks, ticklabel, auto, zoom
Summary: Correct problem with time-date marks (tick labels) 
         after zoom in/out if using 'datetick' function



ATTENTION! 
You can use attached updated files directly 
ONLY with Matlab 6 Release 12.1
Otherwise, it is better to done the following:


After 'datetick' function used, all date-time tickmarks becomes fixed 
and not updated automatically after zoom in/out operation. One of the 
ways to solve this problem is proposed: one should edit standard Matlab 
distribution files: zoom.m and datetick.m
Idea:
in function 'datetick.m' we will change the 'Tag' property of current
axis to 'DateTick-##', where ## stands for selected date-time format code.
After that in function 'zoom.m' (which is called after zoom in/out 
operations) we will check for this property and if necessary call for 
'datetick.m' again.


1. Find in Matlab installation directory next files:
  \toolbox\matlab\timefun\datetick.m
  \toolbox\matlab\graph2d\zoom.m
   and made back-up copy of them.

2. Type in Matlab command window:
   edit datetick

   In the source code find second occurance of the word 'function'
   (first occurance will be at the very beginning of the file).
   Exact _before_ this line:
   function [labels,format] = bestscale(ax,xmin,xmax,dateform,dateChoice)....
   place additional code:
   
   set(gca,'Tag',['DateTick-' num2str(dateform)]);

   So, just at the and of execution of the datetick.m main function we set
   'Tag' property of the current axis to 'DateTick-###', where ### stands
   for user-selected format of the tickmarks.


2. Type in Matlab command window:
   edit zoom.m

   Using Ctrl-F find the 'if zoomx' string in the sourcecode.


   Place the following codelines just before the 'end' statement,
   which corresponds to 'if' you find:

    % support for DateTick autolabels
    tag=get(gca,'Tag');
    if length(tag)>9
        if strcmp(tag(1:9),'DateTick-')==1
            prev_mode=zoom(fig,'getmode');
            datetick('x',str2num(tag(10:end)),'keeplimits');
            zoom(fig,[prev_mode 'mode']);% somehow datetick function causes reset of the zoom mode...
        end
    end;

    You will get something like this:

% Update circular list of connected axes
list = zoom(fig,'getconnect'); % Circular list of connected axes.
if zoomx,
    if a(1)==a(2), return, end % Short circuit if zoom is moot.
    set(ax,'xlim',a(1:2))
    h = list(1);
    while h ~= ax,
        set(h,'xlim',a(1:2))
        % Get next axes in the list
        hz = get(h,'ZLabel');
        next = getappdata(hz,'ZOOMAxesData');
        if all(size(next)==[2 4]), h = next(2,1); else h = ax; end
    end

    % support for DateTick autolabels
    tag=get(gca,'Tag');
    if length(tag)>9
        if strcmp(tag(1:9),'DateTick-')==1
            prev_mode=zoom(fig,'getmode');
            datetick('x',str2num(tag(10:end)),'keeplimits');
            zoom(fig,[prev_mode 'mode']);% somehow datetick function causes reset of the zoom mode...
        end
    end;
    
end

3. Save all files and enjoy!
   

