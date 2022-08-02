function hx=legend(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11)
%LEGEND Graph legend.
%	LEGEND(string1,string2,string3, ...) puts a legend on the
%	current plot using the specified strings as labels.
%
%	LEGEND(linetype1,string1,linetype2,string2, ...) specifies
%	the line types/colors for each label.
%	Linetypes can be any valid PLOT linetype.
%
%	LEGEND(h,...) puts a legend on the plot with handle h.
%
%	LEGEND(M), where M is a string matrix, and LEGEND(H,M)
%	where H is a vector of handles to lines also works.
%
%	LEGEND OFF removes the legend from the current axes.
%
%	LEGEND(...,TOL) sets the tolerance for covering data points.
%	If LEGEND finds no location where less than TOL data points are
%	covered, LEGEND resizes the plot and places the legend outside. 
%	TOL = -1 forces the legend to be placed outside the plot. 
%	TOL =  0 places the legend on the plot unless no location can be
%	found that will not obscure data points.
%
%	To move the legend, press the left mouse button on the
%	legend and drag to the desired location.
%
%	Examples:
%	    x = 0:.2:12;
%	    plot(x,bessel(1,x),x,bessel(2,x),x,bessel(3,x));
%	    legend('First','Second','Third');
%	    legend('First','Second','Third',-1)
%
%	To avoid grid or plot lines obscuring the legend, make the legend
%	the current axes before printing. For example:
%
%	    h=legend('string')
%	    axes(h)
%	    print
%
%	When the legend axes are made the current axes, the figure window
%	may not be redrawn. To force a redraw, use REFRESH.
%
%	See also REFRESH, PLOT.

%	D. Thomas 5/6/93
%		  9/24/93  Latest update
%	Copyright (c) 1984-94 by The MathWorks, Inc.

%       LEGEND searches for the best place on the graph according
%       to the following rules.
%           1. Legend must obscure as few data points as possible.
%              Number of data points the legend may cover before plot
%              is "squeezed" can be set with TOL. The default is a 
%              large number so to enable squeezing, TOL must 
%              be set. A negative TOL will force squeezing.
%           2. Regions with neighboring empty space are better.
%           3. Top and right are better than bottom and left.
%           4. If a legend already exists and has been manually placed,
%              then try to put new legend "close" to old one. 


if nargin==0,
	help legend;
	return;
end;

% Set the tolerance for obscuring data points

tol=1e6;     % Big
tolflag=0;
if nargin>1,
	tmp = eval(['arg',num2str(nargin)]);
	if (~isstr(tmp)),
		tol=tmp(1);
		tolflag=-1;
%		nargin=nargin-1;
	end	
end

% See if first argument is a handle, if not then use current axis

if (~isstr(arg1)),
	if (strcmp(get(arg1(1),'type'),'axes')),
		ha=arg1;
		shift=1;
	else,
		ha=get(arg1(1),'Parent');
		shift=0;
	end
else,
	ha=gca;
	shift=0;
end

hf=get(ha,'parent');
haold=gca;                          % Remember starting axes handle
punits=get(hf,'units');
aunits=get(ha,'units');

% If legend off, then don't do all the work

if ~ (strcmp('off',lower(arg1)) & (nargin==1)),

ud=get(ha,'UserData');
if ~(isempty(ud)),
	if ud(1)==1.1,       % Magic number for legends
		disp('Can''t put a legend on a legend')
		return
	end
end	

set(ha,'units','normalized');


% Parse other arguments to LEGEND

S=eval(['arg',num2str(1+shift)]);
[nstack,tmp]=size(S);

if ~(isstr(S)),   % Vector of Handles
	lstrings=eval(['arg',num2str(shift+2)]);
	if size(lstrings,1) ~= size(S,1),
		for i = (shift+3):(shift+2+size(S,1)-size(lstrings,1)),
			if (i <= nargin),
				if (eval(['isstr(arg',num2str(i),')'])),
					lstrings = eval(['str2mat(lstrings,arg',num2str(i),')']);
				else,
					lstrings = str2mat(lstrings,'');
				end
			else,
					lstrings = str2mat(lstrings,'');
			end
		end
	end		
	lntyp='';
	lnclr=[0 0 0];
	lnwth=0;	
	for i=1:nstack,
		lntyp=str2mat(lntyp,get(S(i),'LineStyle'));
		lnclr=[lnclr',get(S(i),'Color')']';			 
		lnwth=[lnwth,get(S(i),'LineWidth')];
	end;
	[n,tmp]=size(lstrings);
	lntyp=lntyp(2:(nstack+1),:);
	lnclr=lnclr(2:(nstack+1),:);
	lnwth=lnwth(2:(nstack+1));
	if n>nstack,
		lntyp=str2mat(lntyp,45*ones(n-nstack,2));
		lnclr=[lnclr',zeros(3,n-nstack)]';
		lnwth=[lnwth,ones(1,n-nstack)];
	elseif n<nstack,
		lstrings=[lstrings',32*ones(tmp,nstack-n)]';
	end
else,
	if nstack>1,
		lstrings=eval(['arg',num2str(shift+1)]);
		mode=1;
	else,
		if sum(S(1)=='ymcrgbwk'), % See if first non-handle argument
			if length(S)==1,      % is a linetype or a string
				mode=2;
			elseif sum(S(2)=='.ox+-*:'),
				if length(S)==2,
					mode=2;
				elseif sum(S(3)=='.-'),
					mode=2;
				else,
					mode=1;
				end;
			else
				mode=1;
			end
		elseif sum(S(1)=='.ox+-*:'),
			if length(S)==1,
				mode=2;
			elseif sum(S(2)=='-.ymcrgbwk'),
				if length(S)==2,
					mode=2;
				elseif sum(S(3)=='-.ymcrgbwk'),
					mode=2;
				else,
					mode=1;
				end;
			else,
				mode=1;
			end;
		else,
			mode=1;
		end

%	Create the label strings matrix

		lstrings=eval(['arg',num2str(shift+mode)]);
		for i=(shift+2*mode):mode:(nargin+tolflag),
			lstrings=eval(['str2mat(lstrings,arg',num2str(i),')']);
		end
	end

	[nstack,tmp]=size(lstrings);

	if (mode==1),
		Kids=flipud(get(ha,'Children'));
		[nk,tmp]=size(Kids);
		if nk==0,
			disp('Warning: Plot Empty')
			return
		end
		lntyp='';
		lnclr=[0 0 0];
		lnwth=0;
		for i=1:nk,
			if (strcmp(get(Kids(i),'type'),'line')),
				lntyp=str2mat(lntyp,get(Kids(i),'LineStyle'));
				lnclr=[lnclr',get(Kids(i),'Color')']';
				lnwth=[lnwth,get(Kids(i),'LineWidth')];
			end
		end
		[n,tmp]=size(lntyp);
		if n ~= 0,
			lntyp=str2mat(lntyp(2:n,:),setstr('.'*ones(nstack-n+1,1)));
			lnclr=[lnclr(2:n,:)',get(hf,'color')'*ones(1,nstack-n+1)]';
			lnwth=lnwth(2:n);
		else
			lntyp=setstr('.'*ones(nstack,1));
			lnclr=[get(hf,'color')'*ones(1,nstack-n+1)]';
			lnwth=ones(nstack,1);
		end
	else,
		for i=(shift+1):2:(nargin+tolflag)		
			lnt='-';lnc='w';flag=1;	%defaults
			S=['lnstr=arg',num2str(i),';'];
			eval(S)
			for j=1:length(lnstr)
				if flag,	 
					if sum(lnstr(j)=='ymcrgbwk'),
						lnc=lnstr(j);
					elseif sum(lnstr(j)=='ox+*:')
						lnt=lnstr(j);
	 				elseif sum(lnstr(j)=='-.')
						if (j==length(lnstr)),
							lnt=lnstr(j);
						elseif sum((lnstr(j+1)=='.-')),
							lnt=lnstr([j j+1]);
							flag=0;
						else
							lnt=lnstr(j);
						end
				 	end
				else,
					flag=1;
				end
			end
			if isempty(lntyp),
				lntyp=lnt;	
			else
				lntyp=str2mat(lntyp,lnt);
			end
			if isempty(lnclr),
				lnclr=lnc;
			else
				lnclr=str2mat(lnclr,lnc);
			end
			
		end
	end

end
[nstack,tmp]=size(lstrings);

end;    % Jump to here if legend off

% Get current axis position, See if current axis has been
% squeezed by a previous Legend 

caps=[];hl=-1;
Kids=get(hf,'Children');
for i=1:(length(Kids)),
 	if strcmp(get(Kids(i),'Type'),'axes'),
	    Tmp=get(Kids(i),'userdata');

		if sum(size(Tmp)) > 2,
			if (Tmp(1)==1.1)    % 1.1 is Magic number for legends
				if (Tmp(2)==ha),
					cap=Tmp(1,3:6); 
					hl=Kids(i);
				else
					tmp = 0;
					eval('get(Tmp(2),''userdata'');','tmp=1;');
					if tmp, delete(Kids(i)); end
				end
			end
		end
	end
end
tmp = get(ha,'Position');	
squeezed = 0;
if any(tmp ~= cap),
	squeezed = 1;
end
if cap==[],
 	cap=tmp;	
end
		set(ha,'position',cap);	
if nargin==1,
	if isstr(arg1),
		if strcmp(lower(arg1),'off'),
%		set(ha,'position',cap);	
		if hl>0, delete(hl), end;
		return;		
		end
	end
end

% Determine Legend size

fontn = get(ha,'fontname');
fonts = get(ha,'fontsize');

maxp=0;
capc=get(ha,'Position');
h=text(0,0,lstrings,'fontname',fontn,'fontsize',fonts);
set(h,'units','normalized','visible','off');

for i=1:nstack
	ext = get(h(i),'extent');
	delete(h(i));
	maxp=max(maxp,ext(3));
end
llen=(maxp+.07)*capc(3);
lhgt=(ext(4))*nstack*cap(4);
					
% if (ext(4) > 1),                    % Fix for bug in 4.0a, if
%	set(hf,'units','pixels');     % you have this version you 
%	tmp=get(hf,'position');       % should upgrade, until then
%	llen=llen/tmp(3)/cap(3)*1.2;  % uncomment this section.
%	lhgt=lhgt/tmp(4)/cap(4)*1.2;  %
% end                                 %

if (llen > cap(3)) | (lhgt > cap(4)),
	disp('Insufficient space to draw legend');
	axes(haold)
	set(hf,'units',punits)
	set(ha,'units',aunits)
	return
end
set(ha,'units','normalized','Position',cap);

% Decide where to put the legend

stickytol=1; Pos = -1;

if hl > 0, tmp=get(hl,'userdata'); end
if (tol >= 0),
	if (length(tmp) == 7) & squeezed & (hl > 0),
		if tmp(7) == 1,
			tmp(7)=0;
			set(hl,'userdata',tmp);
		end
	end		
	Pos=lscan(ha,llen,lhgt,tol,stickytol,hl);
end
sticky=0;

if hl>0,
	tmp=get(hl,'userdata');
	if length(tmp)>6,
		if tmp(7)==1,sticky=1;end;
	end
	delete(hl);
end

if (Pos ~= -1),
	nap=cap;
	lpos=[Pos(1) Pos(2) llen lhgt];
else,
	nap=[cap(1) cap(2) cap(3)-llen-.03 cap(4)];
	lpos=[cap(1)+cap(3)-llen .8*cap(4)+cap(2)-lhgt llen lhgt];
	if sum(nap<0)+sum(lpos<0),
		disp('Insufficient space to draw legend')
		return
	end;
end
% Resize Graph

set(ha,'units','normalized','Position',nap);

% Draw legend object

hl=axes('units','normalized','position',lpos,'box','on','drawmode', ...
      'fast','nextplot','add','xtick',[-1],'ytick',[-1], ...
      'xticklabels','','yticklabels','','xlim',[0 1],'ylim',[0 1], ...
      'clipping','on','color',get(hf,'color'));


if isempty(lnwth),
	lnwth = .5*ones(1,nstack);
end


for i=1:nstack,

% draw text

	text('position',[.07*capc(3)/llen,1-i/(nstack+1)],'string',lstrings(i,:),'fontname',fontn,'fontsize',fonts);

% draw lines

	if sum(lntyp(i,1)=='+*o.x') & (sum(lntyp(i,1) ~= ' ')==1),
	     line('xdata',[.025*capc(3)/llen],'ydata',1-i/(nstack+1), ...
                  'linestyle',lntyp(i,:),'color',lnclr(i,:));
	else,
	     line('xdata',[.01 .06]*capc(3)/llen,'ydata',[1-i/(nstack+1) ...
                  1-i/(nstack+1)], 'linestyle',lntyp(i,:),'color',lnclr(i,:),'linewidth',lnwth(i));
	end
end;
    
% Clean up a bit
axes(haold)
set(hf,'units',punits)
set(ha,'units',aunits)
data=[1.1,ha,cap,sticky];
set(hl,'userdata',data)
if nargout>0,
	hx=hl;
end
if exist('moveaxis'),
set(hf,'WindowButtonDownFcn','moveaxis');
end
