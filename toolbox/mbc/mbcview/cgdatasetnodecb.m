function cgdatasetnodecb(varargin)
% callbacks from dataset node activeX controls

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 08:39:27 $

persistent doing_cb
% initialised as empty
doing_cb = [];
if ischar(varargin{1}) & strcmp(lower(varargin{1}),'clear')
    doing_cb = [];
elseif isempty(doing_cb)
    % Prevent re-entering code whilst already in callback
    %  - this can cause real problems.
    doing_cb = 1;
    CGBH = cgbrowser;
    pN = CGBH.CurrentNode;
    N = pN.info;
    
    d=CGBH.getViewData;
    d.pD = pN.getdata;
    d.CGBH = CGBH;
    if nargin>1 & isnumeric(varargin{2})
        h = varargin{1};
        ud = get(h,'userdata');
        switch varargin{2}
            case 13
                ExprListFcns(N,d,'right_click',ud);
            case 11
                ExprListFcns(N,d,'col_click',ud,varargin{3});

            case 1 %click
                ExprListFcns(N,d,'click',ud);
            case 5 %key press
                ExprListFcns(N,d,'click',ud);
            case 2 % double click
                ExprListFcns(N,d,'dbl_click',ud);
            otherwise
                %disp('got here');
        end
    end
    doing_cb = [];
end