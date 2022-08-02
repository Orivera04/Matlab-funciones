function assen=plotmat(e,kols,x,naame,de,doyyplot,fignr)
% PLOTMAT - plot data from an array (matrix)
%    plotmat creates a new figure and creates multiple graphs, plotting
%        columns of a matrix as a function of an x-column, x-array, or
%        with a fixed spacing.
%    plotmat(e[,cols[,x[,ne[,de[,doyyplot[,fignr]]]]]])
%        e : the input matrix, 1 column per channel
%        cols : rows with columns to be plotted in different axes
%           (if empty every channel is plotted in a different axes)
%               cols=[c1_1  c1_2 .... 0 0 0;
%                     c2_1  c2_2 .... ;
%                     ........
%                     ...............]
%               first graph : columns c1_1, c1_2, ...
%               second graph : columns c2_1, ...
%        x : different possibilities
%            - x-channel (or x-channels)
%                (example :
%                   plotmat(e,[2 3;4 0],1) does :
%                        figure
%                        subplot(2,1,1)
%                        plot(e(:,1),e(:,[2 3]));grid
%                        subplot(2,1,2)
%                        plot(e(:,1),e(:,4));grid)
%                 if multple x-channels is given, the number must be
%                    equal to the number of graphs (number of rows on cols)
%            - dx : 0:dx:<lastx> is taken as input.
%               the difference between this and x-channel is :
%                   if x is an integer, it is used as an column-index of e
%                   otherwise it is used as a distance between samples
%               to allow distances of integers : negative values can be applied :
%                   (example :
%                      plotmat(e,1,-1) does :
%                         figure
%                         plot(0:size(e,1)-1,e(:,1));grid)
%           (if empty or not given, first column is taken as X)
%        ne : the names of the channels
%           if given the plotted channels are shown in the title and
%              the x-label is also applied if a column is used as x-data
%           this can be a string array or a cell array
%        de : the dimensions of the channels
%           this can be a string array or a cell array
%        doyyplot : if doyyplot~=0 (or doyyplot is empty or not given)
%              a second y-axle is plotted if different dimensions are used
%        fignr : plot on a specified figure (don't make a new one)

% Copyright (c)1993-2002, Stijn Helsen <SHelsen@compuserve.com> August 2002

% Revision history:
%         1993  SHe  Created (for matlab 4.2)
%    8/08/2002  SHe  Translated to English and prepared for "publication"
%                      parts which worked well in matlab 4, but not for
%                      later versions were corrected (a bit) (the plotyy-part)

% comments
%   - the english translation only was done for the help-part
%   - the plotting of the second axis is not always "nice" because the grids
%     are not matched.  That is done because I didn't like the fixed y-axis
%     when "scrolling" through measurements.  "Better view" was preferred
%     over a "nice view".

if nargin==0
	help plotmat
	return
end
if ~exist('kols');kols=[];end
if ~exist('x');x=[];end
if ~exist('naame');naame='';end
if ~exist('de');de='';end
if ~exist('doyyplot');doyyplot=[];end
if ~exist('fignr');fignr=[];end

if all(size(x)==[1 1])&(x>0)&(x~=floor(x))
	x=-x;
end
if isempty(doyyplot)
	doyyplot=1;	% default value for double axes
end
if iscell(naame)
	naame=strvcat(naame);	% convert cell-array to stringarray
end
if iscell(de)
	de=strvcat(de);	% convert cell-array to stringarray
end

if isempty(x)
	x=1;	% default x-column
elseif length(x)==size(e,1)	% different x-values for different graphs
	e=[x(:) e];
	kols=kols-(kols<=0);
	x=1;
	kols=kols+1;
elseif x<=0	% equidistant plot of data
	if x==0
		x=1;
	else
		x=abs(x);
	end
	e=[(0:size(e,1)-1)'*x e];
	kols=kols-(kols<=0);
	x=1;
	kols=kols+1;
end
if isempty(kols)
	kols=(2:size(e,2))';	% default channels : one channel/axes
end

xl=0;
if ~isempty(naame)
	xl=1;
	if size(naame,1)==size(e,2)-1
		% if number of dimensions is one less then the number
		%   data-columns, it is assumed that the first one
		%   is time with dimension [s]
		naame=strvcat('t',naame(1,:));
		xl=0;
	end
end
if ~isempty(de)
	if size(de,1)==size(e,2)-1
		% if number of dimensions is one less then the number
		%   data-columns, it is assumed that the first one
		%   is time with dimension [s]
		de=strvcat('s',de);
	end
end

% if number of axes<4, then set all axes below each other
%  otherwise use two columns of graphs
nkan=size(kols,1);
if nkan<4
	nrij=nkan;
	nkol=1;
else
	nrij=ceil(nkan/2);
	nkol=2;
end

if length(x)<nkan
	x=x(:)*ones(1,ceil(nkan/length(x)));
end

if isempty(fignr)
   fignr=figure;
else
   figure(fignr)
   clf
end

% landscape if two columns of graphs
if (nkan<4)&(nkan>1)
	orient tall
else
	orient landscape
end
corder=get(fignr,'DefaultAxesColorOrder');
ass=zeros(nkan,2);
for i=1:nkan
	ass(i)=subplot(nrij,nkol,i);
	k=kols(i,:);
	k(find(k<=0))=[];
	k2=[];
	if ~isempty(de)
		% look for equal dimensions (if not all equal, and doyyplot, use two axes)
		de1=upper(deblank(de(k(1),:)));
		for j=2:length(k)
			if doyyplot&~strcmp(de1,upper(deblank(de(k(j),:))))
				k2=[k2 j];
			end
		end
		k3=k(k2);
		k(k2)=[];
	else
		k3=[];
	end
	xxx=[];
	if isempty(xxx)
		pl=plot(e(:,x(i)),e(:,k));grid
		if ~isempty(naame)
			n=[];
			kt=[k k3];
			for j=1:length(kt)
				n=[n ', ' deblank(naame(kt(j),:))];
			end
			title(n(3:length(n)))
		end
		if ~isempty(de)
			de1=de(k(1),:);
			if de1(1)==';'
				j=find(de1==';');
				dex='';
				j(length(j)+1)=length(de1)+1;
				for j1=1:length(j)-1
					dex=addstr(dex,de1(j(j1)+1:j(j1+1)-1));
				end
				set(gca,'YTick',0:length(j)-2,'YTickLabel',dex);
			else
				ylabel(['[' deblank(de1) ']'])
			end
		end
	end
	if ~isempty(k3)	% second axis
		% (plotyy (in the current version) does a "nicer" job, but when
		% because the vertical scaling is fixed, this was not always
		% what I wanted, therefore a simple replacement.)
		p=get(ass(i),'Position');
		ass(i,2)=axes('Position',p  ...
			,'Box','off'	...
			,'Color','none'	...
			,'YAxisLocation','right'      ...
			);
		pl=line(e(:,x(i)),e(:,k3));
		for ipl=1:length(pl)
			set(pl(ipl),'Color',corder(1+rem(ipl-1+length(k),size(corder,1)),:))
		end
		      
		ylabel(['[' deblank(de(k3(1),:)) ']'])
		ylab=get(ass(i,2),'YLabel');
	end
	if xl
		if isempty(de)
			xlabel(sprintf('%s',deblank(naame(x(i),:))))
		else
			xlabel(sprintf('%s [%s]',deblank(naame(x(i),:)),deblank(de(x(i),:))))
		end
	end
end
if nargout
	if all(ass(:,2)==0)
		ass=reshape(ass(:,1),nrij,nkol);
	end
	assen=ass;
end
