function varargout=SelectDataGui(T,action,varargin);
% MDEVTESTPLAN/SELECTDATA

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.4 $  $Date: 2004/02/09 08:07:26 $



switch lower(action)
case 'layout'
	varargout{1}= i_createLyt(varargin{:});
case 'update'
	[varargout{1:2}]= i_Update(T);
end

function lyt= i_createLyt(fH,p)

if isa(fH,'xregcontainer')
	lyt= fH;
	fH= allchild(0);
	udh= findobj(fH(1),'tag','DataList');
	ud= get(udh,'userdata');
	ud.pointer= p;

	i_setValues(info(p),ud);
	
	return
end

ud.pointer= p;

% Make a title for this ListBox
title= uicontrol('parent',fH,...
   'style','text',...
   'horizontalalignment','left',...
	'FontWeight','bold',...
   'String','Data');
t= uicontrol('parent',fH,...
   'style','text',...
   'horizontalalignment','left',...
   'String','All Data Sets');
% listbox with all Names
ud.DataList=uicontrol('parent',fH,...
   'style','listbox',...
   'tag','DataList',...
   'backgroundcolor',[1 1 1],...
   'string','',...
   'callback',@i_select);
udh= ud.DataList;

datalistlyt= xreggridlayout(fH,...
	'dimension',[2 1],...
	'elements',{t,ud.DataList},...
	'correctalg','on',...
	'rowsizes',[18 -1]);

uStr= uicontrol('parent',fH,...
   'style','text',...
   'horizontalalignment','left',...
   'String','Load new dataset');
uLoad= xregGui.iconuicontrol('parent',fH,...
   'imageFile',[xregrespath,filesep,'fileOpen.bmp'],...
	'transparentColor', [0 255 0],...
   'callback',{@i_importFile,udh});

loadlyt= xreggridlayout(fH,...
	'dimension',[1 2],...
	'elements',{uStr uLoad },...
	'correctalg','on',...
	'colsizes',[-1 20 ]);

datalyt= xreggridlayout(fH,...
	'dimension',[4 1],...
	'elements',{title loadlyt [] datalistlyt},...
	'correctalg','on',...
	'rowsizes',[20 20 20 -1]);


ud.RadioDes(2,1)= uicontrol('parent',fH,...
   'style','radio',...
   'string','Match selected data to design',...
   'callback',{@i_DesignType,udh,2});
ud.RadioDes(1,1)= uicontrol('parent',fH,...
   'style','radio',...
   'string','No design, use all selected data',...
   'callback',{@i_DesignType,udh,1});

ud.DesignLabel= uicontrol('parent',fH,...
   'style','text',...
   'horizontalalignment','left',...
   'String','All Designs');

ud.DesignList= uicontrol('parent',fH,...
   'style','listbox',...
   'backgroundcolor',[1 1 1],...
   'string','',...
   'callback',{@i_SelectDesign,udh});

deslyt= xreggridlayout(fH,...
	'dimension',[2 1],...
	'elements',{ud.DesignLabel,ud.DesignList},...
	'correctalg','on',...
	'rowsizes',[18 -1]);


deslyt= xreggridlayout(fH,...
	'dimension',[1 2],...
	'elements',{[],deslyt},...
	'correctalg','on',...
	'colsizes',[15 -1]);
t= uicontrol('parent',fH,...
   'style','text',...
   'horizontalalignment','left',...
	'FontWeight','bold',...
   'String','Design');

deslyt= xreggridlayout(fH,...
	'dimension',[4 1],...
	'elements',{t,ud.RadioDes(1),ud.RadioDes(2),deslyt},...
	'correctalg','on',...
	'rowsizes',[20 20 20 -1]);


lyt= xreggridlayout(fH,...
	'dimension',[1 5],...
	'elements',{ [], deslyt,[], datalyt,[] },...
	'correctalg','on',...
	'colsizes',[20 -1 40 -1 20],...
	'packstatus','on');

i_setValues(info(p),ud);



function i_setValues(T,ud);

mp= project(T);

nf= nfactors(HSModel(T.DesignDev));

dlist= mp.DataNames;
dp= mp.dataptrs;
Valid= false(size(dp));
for i=1:length(dp)
    Valid(i)= dp(i).size(2) > nf;
end
% must have more than nf variables
dlist= dlist(Valid);
dp   = dp(Valid);
    


NStages= length(designdev(T));

if isempty(dp)
    sel=0;
    set(ud.DataList,'enable','off');
else    
    sel=find(dp==T.DataLink);
    if isempty(sel)
        sel=1;
    end
    set(ud.DataList,'enable','on');
end

ud.Data= dp;
set(ud.DataList,'string',dlist,'value',sel,'userdata',ud);

[desNames,selIndex,desIndex,T] = i_DesignList(T);
set(ud.DesignList,...
	'string',desNames,'value',selIndex);
if isExpData(T.DesignDev) 
	if isempty(desNames)
		set(ud.RadioDes(2),'enable','off');
	end
	set(ud.DesignList,'enable','off','backgroundcolor',get(0,'DefaultUIcontrolBackgroundColor'));
	set(ud.DesignLabel,'enable','off');
	set(ud.RadioDes,{'value'},{1 0}')
else
	set(ud.DesignList,'enable','on','backgroundcolor','w');
	set(ud.DesignLabel,'enable','on');
	set(ud.RadioDes,{'value'},{0 1}')
end



function [desNames,selIndex,desIndex, T]= i_DesignList(T);


[desList,chosen] = DesignList(T.DesignDev);
desList= desList(2:end);


desNames= cell(size(desList));
ok =false(size(desList));
for i=1:length(desList);
    ok(i)= size(desList{i},1)>0;
    desNames{i}= name(desList{i});
end
% remove zero size designs
desList= desList(ok);
desNames= desNames(ok);

if ~isempty(desNames) & chosen<=1 
    % select first design
    selIndex= 1;
    chosen= find(ok);
    chosen= chosen(1)+1;
    % make sure that a design is chosen
    T.DesignDev(end)= setBestDesign(T.DesignDev(end),chosen) ;
    xregpointer(T);
else
    selIndex= sum( ok(1:chosen-1) );
end

% indices to design tree
desIndex= find( ok )+1;


function T= i_select(udh,evt);

ud= get(udh,'userdata');

T   = info(ud.pointer);
sel = get(ud.DataList,'value');

if sel
    d= ud.Data(sel);
%     if T.DataLink ~= 0 && d ~= T.DataLink
%         MP = info(project(T));
%         switch numSharedData(MP,T.DataLink)
%             case 0
%                 % do nothing
%             case 1
%                 % turn back to sweepsetfilter
%                 T.DataLink.info= sweepsetfilter(T.DataLink.info);
%             otherwise
%                 % remove tssf from data list if there are more than one with the same
%                 % base ssf
%                 removeData(MP, T.DataLink);
%                 T.DataLink= xregpointer;
%         end
%     end
    % make copy of pointer
    T.DataLink  = d;
    xregpointer(T);
end


function [T,OK]= i_Update(T);

fH= allchild(0);
udh= findobj(fH(1),'tag','DataList');

T= i_select(udh);

OK= T.DataLink~=0;
if OK
    ud= get(udh,'userdata');
    
    if get(ud.RadioDes(1),'value')
        d= ud.Data(get(ud.DataList,'value'));
        T= DataDesign(T);
    end
else
    errordlg('You must load a new dataset.','Data Error','modal');
end


function i_SelectDesign(h,evt,udh);

ud= get(udh,'userdata');

T   = info(ud.pointer);

[desNames,selIndex,desIndex,T]= i_DesignList(T);
[dList,chosen]= DesignList(T.DesignDev);

NewDesign = get(ud.DesignList,'value');
if desIndex(NewDesign)~= chosen
	% select design from list
    T.DesignDev(end)= setBestDesign(T.DesignDev(end),desIndex(NewDesign));
    xregpointer(T);
end


function i_DesignType(h,evt,udh,Type);

ud= get(udh,'userdata');

T   = info(ud.pointer);

set(ud.RadioDes,'value',0);
set(ud.RadioDes(Type),'value',1);

dtree= T.DesignDev(end).DesignTree;

switch Type
case 2
	set(ud.DesignList,'enable','on','backgroundcolor','w');
	set(ud.DesignLabel,'enable','on');
	% match to design
	if isExpData(T.DesignDev(end));
		% delete old data design
		i_SelectDesign(h,evt,udh);
	end
case 1
	set(ud.DesignList,'enable','off','backgroundcolor',get(0,'DefaultUIcontrolBackgroundColor'));
	set(ud.DesignLabel,'enable','off');
end




% ------------------------------------------------------------------------------
%
% ------------------------------------------------------------------------------
function i_importFile(h,evt,udh);

% Get the figure handle
ud = get(udh,'userdata');
f = get(udh,'parent');
T   = info(ud.pointer);

% Indicate this task might take a little time
% Get the sweepset to merge with

% Get the data using the data loading wizard
[OK, out] = xregwizard(f, 'Data Import Wizard', {@xregLoadDataWiz 'cardOne'} );
% Did it all work out OK
if OK
    MP= info(Parent(T));
    % create new data object
    [MP, pSSF] = createDataObject(MP);
        % convert to sweepsetfilter
    ssf= i_setSweepsetfilterData(pSSF.info,out);

    % check enough factors available
    if pSSF.size(2)> nfactors( HSModel(T.DesignDev) )
        % make tssf
        pSSF.info= testplansweepsetfilter(ssf,T);
        % link to testplan
        T.DataLink = pSSF;
        xregpointer(T);
        % set current values
        i_setValues(T,ud);
    else
        uiwait(errordlg('There are insufficient variables in this data set to use with this test plan','Data Selection','modal'));
    end

end



% ------------------------------------------------------------------------------
%
% ------------------------------------------------------------------------------
function ssf= i_setSweepsetfilterData( ssf, data);
filename = data.filename;
ss = data.sweepset;
% Sort the variables alphabetically
ss = sort(ss);
% Add the filename to the sweepset
ss = set(ss, 'filename', filename);
% Set the sweepset for the sweepsetfilter (This will trigger an UpdateAll in the
% sweepsetfilter and hence all relevent events will be triggered)
ssf = setSweepset(ssf, ss);
% Do we need to set any default test groupings?
if isempty(get(ssf, 'definetests'))
    % TO DO - Get these names from the user settings
    names = {'LOGNO' 'logno' 'TESTNUM' 'testnum'};
    [dummy, ind] = find(ss, names);
	% Remove the not found names
	ind = find(ind ~= -1);
	if ~isempty(ind)
        % Create the test definition structure - note use of eps rather
        % than zero since we require the change to be greater than or equal
        % to the tolerance
        testDefinition = struct('variable', names{ind(1)}, 'tolerance', eps, 'reorder', false, 'testnumAlias', names{ind(1)});
    else
        testDefinition = struct('variable', '#rec', 'tolerance', 1, 'reorder', false, 'testnumAlias', '');
    end
    % Add it to the 
    ssf = modifyTestDefinition(ssf, testDefinition);    
end
