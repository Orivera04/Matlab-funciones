function T= MakeDesign(T,Type,varargin);
%MAKEDESIGN
% 
% T= MakeDesign(T,Type,varargin);
%   Type: only 'lhs' supported at present
%   Property,Value pairs
%   'constraint',conobject

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:07:21 $


[dlist,index] = DesignList(T.DesignDev);
% get default design
des= dlist{1};
m= model(des);

ConProp= find(strcmpi('constraint',varargin(1:2:end)));
for i=1:length(ConProp)
    % code parameters of constraint
    c= code(varargin{ConProp(i)+1},m);
    des= addConstraint(des,c);
end
% delete constraints
if ~isempty(ConProp)
    varargin(ConProp)=[];
    varargin(ConProp)=[];
end

if strcmpi(Type,'lhs')
    des= LHSdesign(des,varargin{:});
else
    error('Design type not implemented')
end

% add new design to tree
T.DesignDev = addDesign(T.DesignDev,des);
% set design to best
T.DesignDev = setBestDesign(T.DesignDev, length(dlist)+1 );

xregpointer(T);
