function fh = rmse_explorer(mdev,Action)
%RMSE_EXPLORER Create RMSE explorer GUI
%
%  FIG = RMSE_EXPLORER(MDEV) creates a the RMSE Explorer GUI.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.4.5 $  $Date: 2004/04/04 03:31:17 $

fh= findobj(allchild(0),'flat','tag','RMSE Explorer');

if isempty(fh)
    fh= xregfigure('Name','RMSE Explorer',...
        'IntegerHandle','off',...
        'HandleVisibility','callback',...
        'NumberTitle','off',...
        'tag','RMSE Explorer');
    fh= double(fh);
    g2= mvgraph2d(fh);
    uic= uicontextmenu('parent',fh);
    um= uimenu('parent',uic,...
        'Label','&Test Number',...
        'Callback','rmse_explorer(mdev_local,''changetestnum'');');
    set(g2,'grid','on','factorsettings','exclusive',...
        'Callback','rmse_explorer(mdev_local,''showtestnum'');');
    set(g2.axes,'uicontextmenu',uic);

    ud.p= address(mdev);
    ud.g2= g2;
    ud.testnum= um;

    set(fh,'userdata',ud,...
        'resizefcn','rmse_explorer(mdev_local,''resize'');');
else
    figure(fh);
    ud= get(fh,'userdata');
    g2= ud.g2;
    mdev= ud.p.info;
    if nargin>1
        switch lower(Action)
            case 'resize'
                fpos= get(fh,'position');
                set(g2,'position',[20 20 fpos(3:4)-40]);
            case 'showtestnum';
                i_ShowTestNum(ud);
            case 'changetestnum';
                i_ChangeTestNum(ud);
        end
        return;
    end
end

% local
df= mdev.MLE.df;

OK= mdev.FitOK;
if any(OK)
    df(df==0)=1;
    RMSE= sqrt(mdev.MLE.SSE_nat(OK)./df(OK));
else
    RMSE= zeros(0,1);
end

R= zeros(length(RMSE),1+size(mdev.MLE.Sigma,1));
R(:,1)= RMSE(:);
for i=1:size(mdev.MLE.Sigma,1)
    r= squeeze(sqrt(mdev.MLE.Sigma(i,i,OK))).*RMSE; % *Pooled_RMSE;
    R(:,i+1)= r(:);
end

X= getdata(mdev,'FIT');
Xg= X(2);

set(get(g2.axes,'ylabel'),'interpreter','none');
set(get(g2.axes,'xlabel'),'interpreter','none');
R= [ (1:size(R,1))', R,double(Xg{1}(OK,:))];
g2.data=R;
set(g2.axes,'box','on');
set(g2,'grid','on');
rfnames=children(mdev,'name');
for i=1:length(rfnames);
    rfnames{i}= ['s_',lower(rfnames{i})];
end
g2.factors= [{'Test Number','s_e'},rfnames,get(Xg{1},'name')'];
g2.limits = repmat({'auto'},1,size(R,2));
i_ShowTestNum(ud);

set( fh, 'Visible', 'on' );
return;

% -------------------------
function i_ShowTestNum(Tool)

mdev= Tool.p.info;
hTxt= findobj(Tool.g2.axes,'tag','TestNumText');
if ~isempty(hTxt)
    delete(hTxt);
end

if strcmp(get(Tool.testnum,'checked'),'on')
    set(Tool.g2.line,'tag','main line');
    ShowTestNum(mdev,Tool.g2.axes,0);
end

% -------------------------
function i_ChangeTestNum(Tool)

if strcmp(get(Tool.testnum,'checked'),'on')
    set(Tool.testnum,'checked','off');
else
    set(Tool.testnum,'checked','on');
end
i_ShowTestNum(Tool);
