function h=mmtile(n)
%MMTILE Tile Figure Windows. (MM)
% MMTILE with no arguments, tiles the current figure windows
% and brings them to the foreground.
% Figure size is adjusted so that 4 figure windows fit on the screen.
% Figures are arranged clockwise starting in the upper left corner.
% Hf=MMTILE returns the current figure handles.
%
% MMTILE(N) makes tile N the current figure if it exists.
% Otherwise, the next tile is created for subsequent plotting.
% Hf=MMTILE(N) returns the figure handle for the N-th tile or next figure.
%
% Tiled figure windows are titled TILE #1, TILE #2, TILE #3, TILE #4.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 12/5/95, revised 4/29/96. v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

HT=38;	% tile height fudge in pixels
WD=20;	% tile width fudge in pixels
% adjust the above as necessary to eliminate tile overlaps
% bigger fudge numbers increase gaps between tiles

Hf=get(0,'Children');	% get handles of all current figures
nHf=length(Hf);

Ht=findobj(Hf,'flat','Tag','MMTILE'); % find existing tiles
nHt=length(Ht);
ntile=zeros(1,nHt);  % find out which tile is which
atile=1:4;
for i=1:nHt
   Fn=get(Ht(i),'Name');
   Fn=Fn(end);
   ntile(i)=find(Fn=='1234'); % tile number of Ht(i)
   atile(ntile(i))=0;
   Hf(find(Ht(i)==Hf))=[]; %throw tile out of general list
   nHf=nHf-1;
end
atile=atile(atile~=0);
naT=length(atile);


% tile position specifications
set(0,'Units','Pixels')		% set screen dimensions to pixels
sz=get(0,'Screensize');		% get screen size in pixels
tsz=0.95*sz(3:4);			% default tile area is almost whole monitor
if sz(4)>sz(3),				% if portrait monitor
   tsz(2)=.75*tsz(1);		% take a landscape chunk
end
tsz=min(tsz,[920 690]);		% hold tile area on large screens to 920 by 690
tl(1,1)=sz(3)-tsz(1)+1;		% left side of left tiles
tl(2,1)=tl(1,1)+tsz(1)/2;	% left side of right tiles
tb(1,1)=sz(4)-tsz(2)+1;		% bottom of bottom tiles
tb(2,1)=tb(1,1)+tsz(2)/2;	% bottom of top tiles

tpos=zeros(4);				% matrix holding tile position vectors
tpos(:,1)=tl([1 2 2 1],1);			% left sides
tpos(:,2)=tb([2 2 1 1],1);			% bottoms
tpos(:,3)=(tsz(1)/2-WD)*ones(4,1);	% widths
tpos(:,4)=(tsz(2)/2-HT)*ones(4,1);	% heights
tpos=fix(tpos);						% make sure pixel positions are integers

% now consider input arguments
if nargin==0				% tile figures as needed
   for i=1:nHt  % place previous tiles first
      set(Ht(i),'Position',tpos(ntile(i),:))
      figure(Ht(i))
   end
   for i=1:min(nHf,naT)  % place any new figures as tiles
      set(Hf(i),	'Units','Pixels',...
         'Position',tpos(atile(i),:),...
         'NumberTitle','off',...
         'Name',sprintf('TILE #%.0f',atile(i)),...
         'Tag','MMTILE')
      figure(Hf(i))
   end
   if nargout, h=findobj(0,'Tag','MMTILE'); end
   
else  						% go to tile N or create it
   n=rem(abs(n)-1,4)+1;	% N must be between 1 and 4
   i=find(n==atile);
   if isempty(i)			% tile N exists, make it current
      figure(Ht(ntile(n)))
   else					% tile N does not exist, create next one
      figure( 'Units','pixels',...
         'Position',tpos(atile(1),:),...
         'NumberTitle','off',...
         'Name',sprintf('TILE #%.0f',atile(1)),...
         'Tag','MMTILE')
      
   end
   if nargout, h=get(0,'CurrentFigure'); end
end
