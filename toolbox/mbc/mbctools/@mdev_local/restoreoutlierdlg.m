function olIndex= restoreoutlierdlg(action,mdev)
% MODELDEV/RESTOREOUTLIERDLG - presents the user with a list of outliers to restore

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.2 $  $Date: 2004/02/09 08:05:03 $



% get the current modeldev pointer
% get the outlier line
mbH= MBrowser;

p= mbH.CurrentNode;
mdev= info(p);
View= mbH.GetViewData;
ol= View.OutlierLine;
SNo= View.SweepPos;

Y= getdata(mdev,'Y');
% find all bad data in that sweep
sweepindex= sindex(Y,SNo);

% tnum starts from 1
tnum= 1:length(sweepindex);

% Find bad data that has been selected with 'rubber box'
[RecInd,bdind]=intersect(sweepindex,outliers(mdev));
olIndex=[];

if ~isempty(RecInd)

    switch lower(action)
        case 'create'
            [fH,lst]=i_create(tnum,bdind);
            drawnow
            waitfor(fH,'tag');
            switch get(fH,'tag');
                case 'ok'
                    olIndex= lst.selectedindices;
                    RecInd=setdiff(outliers(mdev),RecInd(olIndex));
                    mdev= ApplyOutliers(mdev,SNo,RecInd);
                case 'cancel'
                    olIndex=[];
            end
            delete(fH);
    end
    %% set ol indices to be these new ones
    ol.outlierIndices = olIndex;
end

function [fH,sl]= i_create(tnum,bdind)
pos= get(0,'screensize');
pos= pos(3:4)/2 - [145 155];
% now create the figure and lists
fH= xregfigure('Name','Restore Removed Data',...
   'Menubar','none',...
   'numbertitle','off',...
   'tag','empty',...
   'closerequestfcn','set(gcbf,''tag'',''cancel'')',...
   'resize','off',...
   'visible','off',...
   'color',get(0,'defaultuicontrolbackgroundcolor'));

mb = MBrowser;
xregcenterfigure(fH, [290, 310], mb.Figure);
fH= double(fH);

sl= listitemselector('parent',fH,...
   'itemlist',tnum(bdind),...
   'selectionstyle','multiple',...
   'unselectedtitle','Removed data:',...
   'selectedtitle','Points to restore:');
btn{2}= uicontrol('parent',fH,...
   'string','OK',...
   'position',[0 0 65 25],...
   'callback','set(gcbf,''tag'',''ok'')');
btn{1}= uicontrol('parent',fH,...
   'string','Cancel',...
   'position',[0 0 65 25],....
   'callback','set(gcbf,''tag'',''cancel'')');
helpbtn = mv_helpbutton(fH,'xreg_globalRestoreOutliers');

lyt = xreggridbaglayout(fH,...
   'dimension',[2 4],...
   'gapy',10,...
   'border',[7 7 7 7],...
   'gapx',7,...
   'rowsizes',[-1 25],...
   'colsizes',[-1 65 65 65],...
   'mergeblock',{[1 1],[1 4]},...
   'elements',{sl,[],[],btn{2},[],btn{1},[],helpbtn},...
   'container',fH);

set(fH,'Windowstyle','modal','Visible','on');
% % 
