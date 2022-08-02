function out = set(rules,index,varargin)
% rules = set(rules,index,prop,value,...)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:55:27 $

if nargin==1
    out = [];
    out.exclude = 'exclude/include points';
    out.enable = 'enable/disable rule';
    out.state = 'disable/include/exclude (0 1 -1)';
else
    out = rules;
    for i = 1:2:nargin-2
        value = varargin{i+1};
        switch lower(varargin{i})
        case 'exclude'
            out.exclude(index) = value;
        case 'enable'
            out.enable(index) = value;
        case 'state'
            out.exclude(index) = (value==-1);
            out.enable(index) = (value~=0);
        end
    end
end