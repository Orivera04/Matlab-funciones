function EngAnim = mv_busy(Action,Message,varargin)
%MV_BUSY  Display a busy dialog
%
%  H = MV_BUSY('create', MESSAGE) creates a dialog indicating that MBC is
%  busy.  The given message is displayed.  A handle to the figure is
%  returned.
%
%  MV_BUSY('delete') destroys all open busy dialogs.
%
%  MV_BUSY(MESSAGE) either creates or updates a current dialog with the
%  given MESSAGE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.3 $  $Date: 2004/04/04 03:29:27 $

switch Action
    case 'create'
        h = 100;
        if usejava('swing')
            % Make room for an animation
            h = h+30;
        end
        fh = xregfigure('units','pixels',...
            'Name','Model-Based Calibration Toolbox',...
            'tag','mv_busy',...
            'resize','off',...
            'windowstyle', 'modal', ...
            'position', [500 500 450 h], ...
            varargin{:});
        xregcenterfigure(fh, [450 h]);
        fh = double(fh);

        if nargin<2
            Message = '';
        end
        uicontrol('parent',fh,...
            'style','text',...
            'HorizontalAlignment','left',...
            'tag','mvstring',...
            'position',[20 h-80 410 60],...
            'string',Message);
        if usejava('swing')
            xregGui.waitbar('parent', fh, ...
                'value', NaN, ...
                'position', [20 20 410 20]);
        end

    case 'delete'
        fh = findobj(allchild(0),'tag','mv_busy');
        if ~isempty(fh) && all(ishandle(fh))
            delete(fh)
        end
    otherwise
        fh = findobj(allchild(0),'flat','tag','mv_busy');
        if isempty(fh)
            mv_busy('create',Action);
        else
            fo = findobj(fh(1),'tag','mvstring');
            set(fo,'string',Action);
        end
end
drawnow('expose');
