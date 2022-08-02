function varargout = CopyOutliers(mdev)
%COPYOUTLIERS Show the Copy Outliers dialog
%
%  MDEV = COPYOUTLIERS( MDEV );
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.3 $  $Date: 2004/04/04 03:31:40 $

if address(mdev)==0
    mbh= MBrowser;
    p = get(mbh,'CurrentNode');
    mdev= info(p);
end

fPos = [1  1 240 340];
fh = xregdialog('Name','Copy Outliers',...
    'position',fPos,...
    'Resize', 'off',...
    'visible','off');

xregcenterfigure(fh);
T= mdevtestplan(mdev);

h= treeview(T,'create',[20 20 200 400],double(fh),cell(0,2),1);

helpStr = 'Select the model whose outliers you want to copy.';
txt = uicontrol('Parent', fh,...
    'Style', 'text',...
    'HorizontalAlign', 'left',...
    'String', helpStr);

u{1}= uicontrol('parent',fh,...
    'string','Cancel',...
    'callback','set(gcbf,''visible'', ''off'');');

u{2}= uicontrol('parent',fh,...
    'string','OK',...
    'callback','set(gcbf,''tag'',''ok'', ''visible'', ''off'');');

els = {txt,[],[];
    actxcontainer(h),[],[];
    [],u{2},u{1}};

lyt=xreggridbaglayout(fh,...
    'dimension',[3,3],...
    'correctalg','on',...
    'rowsizes', [32, -1, 25],...
    'colsizes',[-1,65,65],...
    'border', [5, 5, 5,5],...
    'gapx',7,...
    'gapy', 7,...
    'elements',els,...
    'mergeblock', {[1 1], [1 3]},...
    'mergeblock', {[2 2], [1 3]});

fh.LayoutManager = lyt;

% Select this mdev
treeview(mdev,'select',h);

fh.showDialog(u{2});

if strcmp(get(fh,'tag'),'ok')

    p= treeview(T,'current',h);
    Xc= getdata(mdev,'X');
    Xn= p.getdata('X');

    if size(Xn,1)==size(Xc,1) && p~=address(mdev) && ~p.isa('mdevtestplan')
        mv_busy('Refitting Model');
        mdNew= p.info;
        mdev.Outliers=  mdNew.Outliers;
        % refit model
        refit(mdev);
        mdev= info(mdev);
        if isa(mdev,'mdev_local')
            % refit all response features
            bm= postorder(T,'bestmdev');
            mv_busy('Refitting response features');
            children(mdev,'preorder','refit');
            % reselect bestmodels
            postorder(mdev,'RedoSelect',bm);
        end
        mv_busy('delete');
        ViewNode(MBrowser);
    else
        h = warndlg('Incorrect Node Selected','Copy Outliers','modal');
        waitfor(h);
    end

end
delete(fh);

if nargout
    varargout{1}= info(mdev);
end
