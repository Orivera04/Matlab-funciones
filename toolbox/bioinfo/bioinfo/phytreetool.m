function phytreetool(tr)
%PHYTREETOOL interactive tool to explore/edit phylogenetic trees.
%
%   PHYTREETOOL is an interactive tool that allows to edit phylogenetic
%   trees. The GUI allows to do branch pruning, reorder, renaming, distance
%   exploration and read/write NEWICK formatted files.
%   
%   PHYTREETOOL(TREE) loads a phylogenetic tree object into the GUI. 
%
%   PHYTREETOOL(FILENAME) loads a NEWICK file into the GUI. 
% 
%   Example:
%      
%       phytreetool('pf00002.tree')
%       
%   See also PHYTREE, PHYTREE/PLOT, PHYTREE/VIEW, PHYTREEREAD, PHYTREEWRITE.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Author: batserve $ $Date: 2004/04/14 23:57:17 $

% This function is the gateway entry to the PHYTREE/VIEW method.

if nargin == 0
    mvars = evalin('base','whos');
    mvars = mvars(strmatch('phytree',{mvars(:).class}));
    c = get(0,'ScreenSize')*[1 0;0 1;.5 0;0 .5];
    fig = figure('WindowStyle','modal','Color',[0.831373 0.815686 0.784314],...
            'Position',[c-[115 165] 230 330],'Resize','off','NumberTitle','off',...
            'Name','Open A Phylogenetic Tree','IntegerHandle','off');
    h1 = uibuttongroup('BorderWidth',1,'Position',[.03 .14 .94 .83],'Title','Choose tree source:');
    ui1 = uicontrol(fig,'style','radiobutton','Position',[15 275 190 20],'string','Import from workspace','value',1,'callback',@topRadioButtonPressed);
    ui2 = uicontrol(fig,'style','radiobutton','Position',[15 110 190 20],'string','Open phylogenetic tree file','callback',@bottomRadioButtonPressed);
    ui3 = uicontrol(fig,'style','text','Position',[30 250 170 20],'string','Select phytree object:','Horizontal','left');
    ui4 = uicontrol(fig,'style','list','Position',[35 140 120 110],'BackgroundColor','w','string',char(mvars(:).name),'Callback',{@doOK,{mvars.name}});
    ui5 = uicontrol(fig,'style','text','Position',[30 83 80 20],'string','File name:','Horizontal','left','Enable','off');
    ui6 = uicontrol(fig,'style','edit','Position',[30 60 125 20],'BackgroundColor','w','horizontalalignment','left','Enable','off','Callback',@doOK);
    ui7 = uicontrol(fig,'style','pushbutton','Position',[160 55 60 30],'string','Browse...','Enable','off','Callback',@browseFile);
    ui8 = uicontrol(fig,'style','pushbutton','Position',[40 10 60 25],'string','OK','Callback',{@doOK,{mvars.name}});
    ui9 = uicontrol(fig,'style','pushbutton','Position',[130 10 60 25],'string','Cancel','Callback','delete(gcbf)');        
    setappdata(fig,'h',[ui1 ui2 ui3 ui4 ui5 ui6 ui7 ui8 ui9])
    if isempty(mvars)
        set(ui1,'Value',0,'enable','off');
        set(ui2,'Value',1);
        set([ui3 ui4],'enable','off');
        set([ui5 ui6 ui7],'enable','on');
    end
    
    uiwait(fig) % wait until action is commanded
    return
end
    
if isa(tr,'phytree') 
    view(tr); 
    return; 
end

% at this point tr is a valid filename or some corrupted input, trying to
% read it with phytreeread

if (~ischar(tr) || size(tr,1)~=1)
    error('Bioinfo:InvalidInput','Input must be a character array')
end

try
    tr = phytreeread(tr);
catch
    rethrow(lasterror)
end

view(tr);


function topRadioButtonPressed(fh,event)
 hui = getappdata(gcbf,'h');
 set(hui(5:7),'enable','off');
 set(hui(3:4),'enable','on');
 set(hui(1),'value',1);
 set(hui(2),'value',0);

function bottomRadioButtonPressed(fh,event)
 hui = getappdata(gcbf,'h');
 set(hui(5:7),'enable','on');
 set(hui(3:4),'enable','off');
 set(hui(1),'value',0);
 set(hui(2),'value',1);
 
function browseFile(fh,event)
 [filename, pathname] = uigetfile({'*.tree';'*.dnd'},'Select Phylogenetic Tree File');
 if ~filename filename=[];
 else
     filename = [pathname, filename];
 end
 hui = getappdata(gcbf,'h');
 set(hui(6),'string',filename)
 
function doOK(h,event,varargin)
 caller = get(h,'style');
 hui = getappdata(gcbf,'h');
 if (strcmp(caller,'listbox') && strcmp(get(gcbf,'SelectionType'),'open'))...
    || (strcmp(caller,'pushbutton') && get(hui(1),'value')==1)
     mvars = varargin{1};
     view(evalin('base',mvars{get(hui(4),'value')}));
     delete(gcbf)
 elseif get(hui(2),'value')==1
     % it got here because we will try a file
     filename = get(hui(6),'string');
     if ~isempty(filename)
         if ~exist(filename,'file')
             errordlg('File not found.','Open Phylogenetic Tree','modal') 
         else
             try
                 tr = phytreeread(filename);
                 view(tr);
                 delete(gcbf);
             catch
                 errordlg('Unable to determine the file format.',...
                          'Open Phylogenetic Tree','modal') 
             end
         end
     end
 end
    
