function cghistcb(varargin)
% callbacks from history manager activeX controls

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:39:33 $

persistent doing_cb
% initialised as empty

if ischar(varargin{1}) & strcmp(lower(varargin{1}),'clear')
    doing_cb = [];
elseif isempty(doing_cb) | (now - doing_cb ) > 5e-5
    % Prevent re-entering code whilst already in callback
    %  - this can cause real problems.
    doing_cb = now;
    try
        if nargin>1 & isnumeric(varargin{2})
            switch varargin{2}
            case 13 %rightclick
                ExprListFcns(N,d,'right_click',ud);
            case 11 % colclick
            case 1 %click
                cghistorymanager('itemselect');
            case 5 %key press
            case 2 % double click
            otherwise
                %disp('got here');
            end
        end
    catch
    end
    doing_cb = [];
end