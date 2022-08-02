function enlarge
%
%function enlarge
%
%      ENLARGE Produces an enlarged plot of a section of the present
%      plot chosen with the mouse.
%      
%                                     A. Knight
%                                     
disp('Place the mouse on one corner of the section you wish to')
disp('enlarge and click the button.')
[X(1),Y(1)] = ginput(1);
holdstate = ishold;
hold on
xlims = get(gca,'xlim');
ylims = get(gca,'Ylim');
h1 = plot([X(1) X(1)],[ylims(1) ylims(2)],'g-');
h2 = plot([xlims(1) xlims(2)],[Y(1) Y(1)],'g-');

disp('Place the mouse on the other corner and click.')
[X(2),Y(2)] = ginput(1);
if X(1)==X(2) | Y(1)==Y(2),
   error('Chosen window too narrow.')
end
if X(2)<X(1)
   X = fliplr(X);
end
if Y(2)<Y(1)
   Y = fliplr(Y);
end
axis([X(1) X(2) Y(1) Y(2)])
delete(h1)
delete(h2)
if ~holdstate
  hold off
end
