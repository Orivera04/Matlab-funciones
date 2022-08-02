%% Fern Chapter Recap
% This is an executable program that illustrates the statements
% introduced in the Fern Chapter of "Experiments in MATLAB".
% You can access it with
%
%    fern_recap
%    edit fern_recap
%    publish fern_recap
%
% Related EXM programs
%
%  fern
%  finitefern

%% fern.jpg
   F = imread('fern.png');
   image(F)

%% A few graphics commands
   shg
   clf reset
   set(gcf,'color','white')
   x = [.5; .5];
   h = plot(x(1),x(2),'.');
   darkgreen = [0 2/3 0];
   set(h,'markersize',1,'color',darkgreen,'erasemode','none');
   set(h,'xdata',x(1),'ydata',x(2));
   axis([-3 3 0 10])
   axis off
   stop = uicontrol('style','toggle','string','stop','background','white');
   drawnow
   cnt = 12345;
   t = 5.432;
   s = sprintf('%8.0f points in %6.3f seconds',cnt,t);
   text(-1.5,-0.5,s,'fontweight','bold');
   set(stop,'style','pushbutton','string','close','callback','close(gcf)')
