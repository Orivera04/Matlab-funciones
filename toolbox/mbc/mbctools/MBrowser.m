function h=MBrowser(varargin)
% MBROWSER Instantiate a Model Browser object
%
%  obj=MBrowser;

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.9.4.2 $  $Date: 2004/02/09 08:20:38 $

% This file also houses the activeX callbacks for the MBrowser object

persistent objH

% Search for a current MBrowser, else return a new one 
if isempty(objH)
    % make absolutely sure MB isn't around somewhere?     
    fH=mvf;
    if ~isempty(fH)         
        % get handle from userdata
        objH= get(handle(fH),'MBH');
    else
        % create a blank new object
        objH= xregtools.MBrowser;
    end
    %  MLOCK might make the objH appear more often - won't have to go to fH userdata
    %mlock;   
end


if nargin
    % ActiveX event codes
    ev=varargin{2};
    srcobj=varargin{1};
    try
        srcobj.Nodes;
        tree=1;
    catch
        tree=0;
    end
    hFig=objH.Figure;
    MM=MotionManager(hFig);
    MM.EnableTree=false;
    if tree
        %%%%%  TreeView Callbacks  %%%%%
        switch ev
            case {13,11}
                % click event, node collapse event
                PR=xregGui.PointerRepository;
                ptrID=PR.stackSetPointer(hFig,'watch');
                try
                    key= srcobj.SelectedItem.Key;
                    pindex= str2num(key(2:end));
                    p= assign(xregpointer,pindex);
                catch
                    PR.stackRemovePointer(hFig,ptrID);
                    return
                end
                objH.SelectNode(p);
                PR.stackRemovePointer(hFig,ptrID);
            case 3
                % Key press event
                keycode= double(varargin{3});
                switch keycode
                    case {16,17}
                        % shift and control keys
                        return
                    case 45
                        % Insert
                        objH.NewNode;
                    case 46
                        % Delete
                        objH.DeleteNode;
                    case 113
                        % F2 edit
                        srcobj.StartLabelEdit;
                    otherwise
                        % Spoof a click event
                        MBrowser(varargin{1}, 13);
                end
            case 9
                % Label Event
                cancel=varargin{3};
                newstring=varargin{4};
                if ~cancel
                    if ~isempty(deblank(newstring)) 
                        p= assign(xregpointer,srcobj.SelectedItem.Tag);
                        oldname = p.name;
                        p.name(newstring);
                        newname = p.name;
                        if ~strcmp(newname, newstring)
                            % Name was rejected by node: revert to old name
                            p.name(oldname);
                            srcobj.CancelNextLabelEdit = 1;
                            h = errordlg(sprintf(['Cannot rename %s: an item with the name you' ...
                                    ' specified already exists.  Specify a different name.'], oldname), ...
                                'Error Renaming Item', 'modal');
                            waitfor(h);
                        else
                            objH.doDrawText;
                        end
                    else
                        srcobj.CancelNextLabelEdit = 1;
                    end
                end
            case 14
                % Right-click event
                % Call the context handler for the current node
                objH.opencontext(srcobj,varargin{3},varargin{4});
        end
    else
        %%%%%  ListView Callbacks  %%%%%
        switch ev
            case 2
                % Double click - same as tree nodeclick
                PR=xregGui.PointerRepository;
                ptrID=PR.stackSetPointer(hFig,'watch');
                try
                    key= srcobj.SelectedItem.Key;
                    pindex= str2num(key(2:end));
                    p= assign(xregpointer,pindex);
                catch
                    PR.stackRemovePointer(hFig,ptrID);
                    return
                end
                objH.SelectNode(p);
                PR.stackRemovePointer(hFig,ptrID);
            case 5
                % Key up
                keycode= double(varargin{3});
                switch keycode
                    case 45
                        % Insert
                        objH.NewNode;
                    case 46
                        % Delete
                        objH.DeleteNode('ListView');
                end
        end
    end
    MM.EnableTree=true;
else
    h=objH;
end
return

