function hrect = rsplot(cmodel,m,x,ah)
%RSPLOT Draw boundary constraints on cross-section plot
%
%  hrect= RSPLOT(cmodel,m,x,ah) draws vertical constraint lines on the
%  cross-section plots in the validation tool.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/04/04 03:26:25 $

[LB,UB]= range(m);
for i=1:length(ah)
    xcurrent = x;
    allLines= findobj(ah(i),'type','line');
    % find xlimits from data
    xdata= get(allLines,'xdata');
    xlim= [min([LB(i) xdata{:}]) max([UB(i) xdata{:}])];
    set(ah(i),'xlim',xlim);
    xcurrent{i}= linspace(xlim(1),xlim(2),51);
    % find region which is outside boundary
    cvals= cgrideval(cmodel,xcurrent,m)>=0;
    pos= find(diff([false;cvals(:);false]));
    ylim= get(ah(i),'ylim');
    ymin= ylim(1);
    height= diff(ylim);
    hrect=[];
    k=1;
    for j= 1:length(pos)-1;
        % loop through the region
        if cvals(pos(j))
            % draw region to show invalid regions
            x1eft = xcurrent{i}(pos(j));
            % add a little bit to the right of the region
            width= xcurrent{i}(pos(j+1)-1)-x1eft + diff(xlim)/101;
            % draw region
            hrect(k)= rectangle('parent',ah(i),...
                'position',[x1eft,ymin,width,height],...
                'FaceColor',mbcbdrycolor,...
                'tag','boundarydisplay',...
                'hittest','off');
            k=k+1;
        end
    end
    % send rectangles to back so the other lines are visible
    set(ah(i),'children',[allLines(:); hrect(:)]);
end
% all boundary rectangles
hrect= findobj(ah,'tag','boundarydisplay');
