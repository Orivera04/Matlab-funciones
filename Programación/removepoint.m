function removepoint(position)
% Syntax:
% removepoint
% removepoint(position)
%
% Creates a pushbutton in the current figure to remove point(s) by mouse clicks.
% 
% When clicked, the datatip cursor is switch on, waiting a click on a point to be deleted from the plot.
% Alternatively, if the cursor was previoulsy enabled, a click on the pushbutton gives a deletion of the point.
% When done, a variable "remaingindexes_tag" is created in the work space. It contains
%       the indexes of the remaining points. Tag is a number which is attributed
%       to each line of the plot for identification purpose.
% Notes:
%       - markers are created if necessary to facilate point localization.
%       - for 3D compatibility reasons, ZDATA properties are zero-ed for the
%         lines which had empty ZDATA property.
%       - the pushbutton position is defined by the vector position.
%         If not given by the user, the position is set by default.
%
% may 2006
% jean-luc.dellis@u-picardie.fr
% Thanks to dutmatlab (dutmatlab@yahoo.fr) for judicious advices in using SETAPPDATA allowing to
% leave free the TAG and USERDATA line properties
if isequal(nargin,0),position=[20,20,80,20];end             % default position
hui=findobj(gcf,'tag','removepoint');
if isempty(hui)
    hui=uicontrol(gcf,'style','pushbutton','string','Remove a point','position',position,...
        'callback',@remove,'tag','removepoint');
end
marks=['+','o','*','.','x','s','d','^','v','>','<','p','h',];
colo=['m','c','r','g','b','k'];
hl=findobj(gcf,'type','line');                              % get all line handles
set(hui,'userdata',length(hl))
itag=0;
for i=length(hl):-1:1
    mar=get(hl(i),'marker');
    if isequal(mar,'none')
        im=ceil(rand(1,1)*length(marks));
        ic=ceil(rand(1,1)*length(colo));
        set(hl(i),'marker',marks(im),'color',colo(ic))                     % set lines with markers if they have not
    end
    xdat=get(hl(i),'xdata');
    ydat=get(hl(i),'ydata');
    zdat=get(hl(i),'zdata');
    if isempty(zdat)
        zdat=zeros(size(xdat));
        set(hl(i),'zdata',zdat)                             % set lines with zeroed zdata if they have not
    end
    itag=itag+1;
    setappdata(hl(i),'tag',num2str(itag))                   % set lines with tag
    if isempty(getappdata(hl(i),'userdata'))
    setappdata(hl(i),'userdata',[xdat(:),ydat(:),zdat(:)])  % set userdata to initial data for the first time
    end
end
%---------------------------------------------%
function remove(no_use1,no_use2)                            % the uicontrol callback does Not Use inputs
                                                            % when 2 arguments are required
hl=findobj(gcf,'type','line');                              % get all line handles
hui=findobj(gcf,'tag','removepoint');
hln=get(hui,'userdata');
if ~isequal(length(hl),hln)                                 % a new line was plotted when remopoint was previouly
    removepoint                                             % running. So, run again to update
    set(gca,'xlimmode','auto','ylimmode','auto','zlimmode','auto')
end                 
                                                            
    dcm_obj = datacursormode(gcf);
    set(dcm_obj,'enable','on')
    infostruct = [];
while isempty(infostruct)                   
    pause(0.1)
    infostruct=getCursorInfo(dcm_obj);                      % get data_index + position + handle from the cursor
end
set(dcm_obj,'enable','off')
delete(findall(gca,'type','hggroup','marker','square'))     % delete datatip (handlevisibility off ==> findall)
fgx=get(gca,'xlim');fgy=get(gca,'ylim');fgz=get(gca,'zlim');% get limits of the current axe
target=infostruct.Target;                                   % handle of clicked line
xdat=get(target,'xdata');
ydat=get(target,'ydata');
zdat=get(target,'zdata');

A=getappdata(target,'userdata');                            % retrieves original data, and
                                                            % identifies the index of the clicked point
i=(A(:,3)==zdat(infostruct.DataIndex) & A(:,2)==ydat(infostruct.DataIndex) & A(:,1)==xdat(infostruct.DataIndex));
A(i,:)=nan;                                                 % deleted data is naned, and
setappdata(target,'userdata',A);                            % remaining index data are identified:
survyvingindex=find(~isnan(A(:,1)) & ~isnan(A(:,2)) & ~isnan(A(:,3)));

xdat(infostruct.DataIndex)=nan;                             % remove the coordinates, changing them in NAN
ydat(infostruct.DataIndex)=nan;
zdat(infostruct.DataIndex)=nan;
xdat = xdat(~isnan(xdat));                                  % NANs are removed from data
ydat = ydat(~isnan(ydat));
zdat = zdat(~isnan(zdat));
modifdata=[xdat(:),ydat(:),zdat(:)]; 
set(infostruct.Target,'xdata',modifdata(:,1))               % updates the line
set(infostruct.Target,'ydata',modifdata(:,2))
set(infostruct.Target,'zdata',modifdata(:,3))
set(gca,'xlim',fgx);set(gca,'ylim',fgy);set(gca,'zlim',fgz);% holds the limits
                    
assignin('base',['remaingindexes_',getappdata(infostruct.Target,'tag')],survyvingindex)% put the modifyied data in the Matlab memory


