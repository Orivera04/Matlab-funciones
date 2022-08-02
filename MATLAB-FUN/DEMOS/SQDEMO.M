%SQDEMO	Demonstrate UIControls with Superquadrics.
%
%	Click "help" to see this preamble.
%	Vary the superquadric shape parameters with the "roundness" sliders.
%	Click "first" to select the current shape as the first one in a movie.
%	Click "make" to select the current shape as the last one, and make a
%	   movie, interpolating between the shapes, and rotating 1/4 turn.
%	Click "play" to play the movie.  If the first and last shapes are
%	   the same, play the movie forward to get a spinning effect.
%	   Otherwise, play the movie back and forth to get a pulsing effect.
%	Click "done" to clear the window.
%	The pulldown menu, colormaps, offers several color maps.
%
%	*  WARNING: When a button is green, work is in progress.  *
%	*  Do not click another button.                           *
%
%	Other parameters can be altered by typing in the command window.
%	   nf = number of frames, initially 12.
%	   dt = rotation increment, initially pi/24, so 12 frames is 1/4 turn.
%	   np = number of plays, initially 10.
%
%	See also: SUPERQUAD.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

echo off
% Initialize

nf = 12;       % Number of frames
dt = pi/2/nf;  % Rotation increment
np = 10;       % Number of plays

clf reset
darkgray = [1/3 1/3 1/3];
set(gcf,'color',darkgray')
gcfpos = zeros(1,4);

rand('seed',fix(100*sum(clock)))
n = max(0,1+randn/2);
e = max(0,1+randn/2);
shape1 = [n e];
superquad(n,e)

% Callback strings

helps = 'help sqdemo;';

firsts = 'shape1 = [n e];';

makes = [ ...
  'set(makeh,''back'',''g''); ' ...
  'if any(get(gcf,''pos'') ~= gcfpos), ' ...
     'clear M; ' ...
     'M = moviein(nf); ' ...
     'moviebytes = 8*prod(size(M)), ' ...
     'gcfpos = get(gcf,''pos''); ' ...
  'end, ' ...
  'shapef = [n e]; ' ...
  't = 0; ' ...
  'for j = 1:nf, ' ...
     'shape = ((j-1)*shapef + (nf-j)*shape1)/(nf-1); ' ...
     'set(nc,''value'',shape(1)); ' ...
     'set(ec,''value'',shape(2)); ' ...
     '[x,y,z] = superquad(shape(1),shape(2)); ' ...
     'xy = [x(:) y(:)]*[cos(t) sin(t); -sin(t) cos(t)]; ' ...
     'x(:) = xy(:,1); y(:) = xy(:,2); ' ...
     'surf(x,y,z); ' ...
     'axis([-1 1 -1 1 -1 1]); ' ...
     't = t + dt; ' ...
     'M(:,j) = getframe; ' ...
  'end; '...
  'np = (2*all(shapef==shape1)-1)*abs(np); ' ...
  'set(makeh,''back'',''default''); '];

plays = [ ...
  'if exist(''M'')~=1,disp([7,''You must make a movie first.'']), return, end,',...
  'set(playh,''back'',''g'');'];
com = computer;
if ~(strcmp(com(1:2),'PC') | strcmp(com(1:2),'MA'))
   plays = [plays ...
     'disp(''Please wait while MATLAB sends data to the graphics server...'');'];
end
plays = [plays ...
  'movie(M,np);' ...
  'set(playh,''back'',''default'');'];

done = 'clf reset';


% Sliders

nc = uicontrol('style','slider','units','normal','pos',[.05 .05 .25 .035], ...
     'min',0,'max',6,'val',n, ...
     'call','n = get(nc,''value''); superquad(n,e)');
nct = uicontrol('style','text','units','normal','pos',[.05 .09 .25 .04], ...
     'string','Vertical roundness','fore','white','back',darkgray);
ec = uicontrol('style','slider','units','normal','pos',[.70 .05 .25 .035], ...
     'min',0,'max',6,'val',e, ...
     'call','e = get(ec,''value''); superquad(n,e)');
ect = uicontrol('style','text','units','normal','pos',[.70 .09 .25 .04], ...
     'string','Horizontal roundness','fore','white','back',darkgray);

% Push buttons

helph = uicontrol('style','push','units','normal','pos',[.9 .9 .08 .06], ...
        'string','help','call',helps);
firsth = uicontrol('style','push','units','normal','pos',[.9 .82 .08 .06], ...
        'string','first','call',firsts);
c = computer;
if strcmp(c(1:2),'PC')
   if get(0,'screendepth') <= 4
      makes = 'disp(''Sorry, MATLAB requires more than 16 colors for movies.'')';
   end
end
makeh = uicontrol('style','push','units','normal','pos',[.9 .74 .08 .06], ...
        'string','make','call',makes);
playh = uicontrol('style','push','units','normal','pos',[.9 .66 .08 .06], ...
        'string','play','call',plays);
endh = uicontrol('style','push','units','normal','pos',[.9 .58 .08 .06], ...
        'string','done','call',done);

% Color map menu

colormenu
