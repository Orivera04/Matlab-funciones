function hnp = plotorder(varargin)
%PLOTORDER renders graphycally the order computed by multi attribute value analysis functions
%
%   syntax : plotorder(varargin)
%
%   INPUT ARGUMENTS
%       varargin     has a different format depending on which analysis function generated it.
%
%   OUTPUT PLOTS
%       Each multi-value attribute analysis function generates a differnt plot:
%           - mavt      the resulting plot represents the final order of the alternatives considered;
%                       each alternative is represented as ellipse-circle. By clicking on an alternative,
%                       the utility value associated to it its displayed in the text field at the bottom of 
%                       the figure.
%                       Alternatives are normally filled in red; neighbor alternatives with the same
%                       performance are filled in green.
%           - hyea      two plots are produced. The first plot represents the final order of the alternatives
%                       considered, while the second plot shows the hyeararchy arising from the input data.
%                       By clicking on an element of a a particular level, the partial order of the alternatives 
%                       yielded at that point is shown in the text field at the bottom of the figure.
%           - electre3  the resulting plot shows the alternatives dominance matrix. 
%                       If at the position i,j there is the symbol X, it means that the alternative i is dominant
%                       with respect to the alternative j. If the element at the position i,j is empty, it means 
%                       that alternative i is not comparable to the alternative j.
%
%                              
%                              
%
%   Please refer to the calling functions to have detailed informations on input parameters.
%
%   See also: MAVT, HYEA, ELECTRE3.

% Author:       Francesco di Pierro         Dep. of Electronics and Computer Science (DEI)
%                                           Politecnico di Milano
%                                           e-mail: f_dipierro@yahoo.com


if ischar(varargin{1})
    try
		[varargout{1:nargout}] = feval(varargin{:});
	catch
		disp(lasterr);
	end
else
    ORD = varargin{1};
    name = varargin{end};
    switch name
    case 'mavt'
        hnp = plotordmavt(name,ORD);
    case 'hyea'
        PERFPAR = varargin{2};
        W = varargin{3};
        hnp = plothyea(name,PERFPAR,W);
     case 'electre3'
        hnp = plotelectre3(name,ORD);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function hnp = plotordmavt(name,ORD)

hnp = figure;
set(gca,{'Position','Color','box','xtick','ytick'},{[.01,.1,.98,.88],'none','on',[],[]},'Nextplot','add');
set(hnp,'Name',['Order obtained trhough the function "',name,'"'],'NumberTitle','off');
hedit = uicontrol('Style','edit','Units','normalized','Position',[.01,.01,.98,.07],'Enable','inactive','BackgroundColor','w','Tag','edittext');
set(hedit,'String','To visualize the utility function associated to an alternative, left click on it','Fontsize',10,'FontWeight','Bold');
handles = guihandles(hnp);
guidata(hnp, handles);
set(hnp,'WindowButtonupFcn',['plotorder(''restoretext'',guidata(gcbo),''To visualize the utility function associated to an alternative, left click on it'')']);
if length(ORD.alt)<100
    col = 1:10;
    row = 1:ceil(length(ORD.alt)/col(end));
else 
    col = 1:round(sqrt(length(ORD.alt)));
    row = 1:ceil(length(ORD.alt)/col(end)); 
end
ri = length(row);
ci = 0;
NoPatch = 0;
for i=1:length(ORD.alt)
    if ci>=col(end) ri = ri-1; ci = 1; else ci = ci+1;  end
    hr(i) = rectangle('Position',[col(ci)-.25,row(ri)-.25,.5,.5],'Curvature',[1,1]);
    if i==1
        if ORD.perf(i)==ORD.perf(i+1)
            set(hr(i),'EdgeColor','b','FaceColor','g','Linewidth',2);
            NoPatch = 1;
        else
            set(hr(i),'EdgeColor','b','FaceColor','r','Linewidth',2);
            NoPatch = 0;
        end
    elseif i~=1 & i~=length(ORD.alt)
        if ORD.perf(i)==ORD.perf(i+1)
            set(hr(i),'EdgeColor','b','FaceColor','g','Linewidth',2);
            NoPatch = 1;
        else
            NoPatch = 0;
            if ORD.perf(i)==ORD.perf(i-1)
                set(hr(i),'EdgeColor','b','FaceColor','g','Linewidth',2);
            else
                set(hr(i),'EdgeColor','b','FaceColor','r','Linewidth',2);
            end
        end
    else
        if ORD.perf(i)~=ORD.perf(i-1)
            set(hr(i),'EdgeColor','b','FaceColor','r','Linewidth',2);
        else
            set(hr(i),'EdgeColor','b','FaceColor','g','Linewidth',2);
        end
    end
    txt_alt(i) = text(col(ci),row(ri),['A',int2str(ORD.alt(i))],'HorizontalAlignment','center','Fontweight','bold');
    txt = ['''Performance function associated to alternative A',int2str(ORD.alt(i)),': ',num2str(ORD.perf(i)),''''];
    set(txt_alt(i),'ButtondownFcn',['plotorder(''showperf'',guidata(gcbo)',',',txt,')']);
    if ci==col(end) & i~=length(ORD.alt)
        plot([col(ci)+.25,col(ci)+.75],[row(ri),row(ri)],'-k','Linewidth',2);
        plot([col(ci)+.75,col(ci)+.75],[row(ri),row(ri)-.5],'-k','Linewidth',2);
        plot([col(1)-.75,col(ci)+.75],[row(ri)-.5,row(ri)-.5],'-k','Linewidth',2);
        plot([col(1)-.75,col(1)-.75],[row(ri)-.5,row(ri-1)],'-k','Linewidth',2);
        plot([col(1)-.75,col(1)-.25],[row(ri-1),row(ri-1)],'-k','Linewidth',2);
        if ~NoPatch
            patch(col(ci)+.5,row(ri),0,'Marker','>','MarkerFaceColor','y','MarkerEdgeColor','k','MarkerSize',5);
            patch(col(ci)+.75,row(ri)-.25,0,'Marker','v','MarkerFaceColor','y','MarkerEdgeColor','k','MarkerSize',5);
            patch(col(1)-.75+(col(ci)+.75-col(1)+.75)/2,row(ri)-.5,0,'Marker','<','MarkerFaceColor','y','MarkerEdgeColor','k','MarkerSize',5);
            patch(col(1)-.75,row(ri-1)+.25,0,'Marker','v','MarkerFaceColor','y','MarkerEdgeColor','k','MarkerSize',5);
            patch(col(1)-.5,row(ri-1),0,'Marker','>','MarkerFaceColor','y','MarkerEdgeColor','k','MarkerSize',5);
        end                
    elseif i~=length(ORD.alt)
        plot([col(ci)+.25,col(ci)+.75],[row(ri),row(ri)],'-k','Linewidth',2);
        if ~NoPatch
            patch(col(ci)+.5,row(ri),0,'Marker','>','MarkerFaceColor','y','MarkerEdgeColor','k','MarkerSize',5);
        end
    end
end
if i<10
    axis([0,i+1,0,row(end)+1])
else
    axis([0,col(end)+1,0,row(end)+1])
end
set(hnp,'handlevisibility','off')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function hnp = plothyea(name,PERFPAR,W)

hnp = figure;
set(gca,{'Position','Color','box','xtick','ytick'},{[.01,.16,.98,.82],'none','on',[],[]},'Nextplot','add');
set(hnp,'Name',['Hyeararchy obtained trhough the function "',name,'"'],'NumberTitle','off');
hedit = uicontrol('Style','edit','Units','normalized','Position',[.01,.01,.98,.13],'Enable','inactive','BackgroundColor','w','Tag','edittext');
set(hedit,'String',{'';'To visualize the partial order associated to a node, left click on it';''},'Fontsize',10,'FontWeight','Bold','Max',3);
handles = guihandles(hnp);
guidata(hnp, handles);
set(hnp,'WindowButtonupFcn',['plotorder(''restoretext'',guidata(gcbo),{'''';''To visualize the partial order associated to a node, left click on it'';''''})']);
A = [];
B = [];
for i=1:length(PERFPAR)
    for j=1:size(PERFPAR{i}.alt,2)
        if i==1 & j==1
            for k=1:size(PERFPAR{i}.alt,1)
                hr = rectangle('Position',[2*k,0,1,.5],'Curvature',[.5,1],'EdgeColor','b','FaceColor','r','Linewidth',2);
                txt_alt = text(2*k+.5,.25,['A',int2str(k)],'HorizontalAlignment','center','Fontweight','bold');
                pos(i).start(k,:) = [2*k+.5,.5];
            end
            center = 2+(2*k+1-2)/2;
        end
        if j==1
            posinit = center-(2*size(PERFPAR{i}.alt,2)-1)/2;
        end
        if i~=length(PERFPAR)
            hr = rectangle('Position',[posinit+2*(j-1),i,1,.5],'EdgeColor','b','FaceColor','r','Linewidth',2);            
            txt1 = ['''Partial order associated to the node ',char(65+i),int2str(j),''''];
            txt2 = ['''Alternatives: ',mat2str(PERFPAR{i}.alt(:,j)),''''];
            txt3 = ['''Performances: ',mat2str(PERFPAR{i}.perf(:,j),2),''''];
            txt_alt = text(posinit+2*(j-1)+.5,i+.25,[char(65+i),int2str(j)],'HorizontalAlignment','center','Fontweight','bold');
        else
            hr = patch([posinit+2*(j-1)-.5,posinit+2*(j-1)+.5,posinit+2*(j-1)+1.5,posinit+2*(j-1)+.5],[i+.25,i+.5,i+.25,i],'r','EdgeColor','b','Linewidth',2);        
            txt1 = ['''Final order associated to the supercriterion '''];
            txt2 = ['''Alternatives: ',mat2str(PERFPAR{i}.alt(:,j)),''''];
            txt3 = ['''Performances: ',mat2str(PERFPAR{i}.perf(:,j),2),''''];
            txt_alt = text(posinit+2*(j-1)+.5,i+.25,'S','HorizontalAlignment','center','Fontweight','bold');
        end
        set(txt_alt,'ButtondownFcn',['plotorder(''showperf'',guidata(gcbo),',txt1,',',txt2,',',txt3,')']);
        if i==1 
            pos(i).stop(j,:) = [posinit+2*(j-1)+.5,i];
        elseif j==1
            pos(i).start = pos(i-1).stop;
            pos(i).start(:,2) = pos(i).start(:,2)+.5;
            pos(i).stop(j,:) = [posinit+2*(j-1)+.5,i];
        else
            pos(i).stop(j,:) = [posinit+2*(j-1)+.5,i];
        end
        nolink = find(isnan(W{i}(j).ord));
        A = [pos(i).start(:,1),repmat(pos(i).stop(j,1),size(pos(i).start,1),1)];
        B = [pos(i).start(1,2);pos(i).stop(j,2)];
        A(nolink,:) = [];
        plot(A',B,'linewidth',2,'Color','y');
        A = []; B = [];
    end
end
coord = axis;
axis([coord(1)-.5,coord(2)+.5,-.5,coord(4)+.5]);
axis equal
set(hnp,'handlevisibility','off')    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function hnp = plotelectre3(name,ORD)

hnp = figure;
set(gca,{'Position','Color','box','xtick','ytick'},{[.01,.1,.98,.88],'none','on',[],[]},'Nextplot','add');
set(gcf,'Name',['Order obtained trhough the function "',name,'"'],'NumberTitle','off');
hedit = uicontrol('Style','edit','Units','normalized','Position',[.01,.01,.98,.07],'Enable','inactive','BackgroundColor','w','Tag','edittext');
set(hedit,'String','Row index represents outcompeting alternatives; column index alternatives outcompeted','Fontsize',8,'FontWeight','Bold');
handles = guihandles(hnp);
guidata(hnp, handles);
len = length(ORD)+1;
for i=1:len
    for j=1:len
        if i==1 & j==1
            plot([1.5,len+.5],[len-i+.5,len-i+.5],'linewidth',2,'Color','k');
            plot([1.5,1.5],[len-i+.5,.5],'linewidth',2,'Color','k');
            continue
        elseif i==1
            text(j,len-i+1,['A',int2str(j-1)],'Fontsize',10,'FontWeight','Bold','Color','r');
        elseif j==1
            text(j,len-i+1,['A',int2str(i-1)],'Fontsize',10,'FontWeight','Bold','Color','r');
        elseif ~isnan(ORD(i-1,j-1))
                text(j,len-i+1,'X','Fontsize',10,'FontWeight','Bold','Color','y')
        end
        if j==1
            plot([1.5,len+.5],[len-i+.5,len-i+.5],'linewidth',2,'Color','k');
        end
        if i==1
            plot([j+.5,j+.5],[len-i+.5,.5],'linewidth',2,'Color','k');
        end
    end
end
axis([.5,j+1,0,j+.5])
set(hnp,'handlevisibility','off')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function showperf(handles,varargin)

if length(varargin)==1
    set(handles.edittext,'String',varargin{1});
else
    set(handles.edittext,'String',{varargin{1};varargin{2};varargin{3}});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function restoretext(handles,text)

set(handles.edittext,'String',text);