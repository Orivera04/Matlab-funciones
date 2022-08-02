function m= xreguncodedpoly(varargin);
%XREGUNCODEDPOLY polynomial model without coding

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.3.6.2 $  $Date: 2004/02/09 08:00:27 $

if nargin==0;
    varargin= {'nfactors',2};
elseif isstruct(varargin{1})
    ms= varargin{1};
    varargin= {ms.xregcubic};
end

m.Version= 1;
if isa(varargin{1},'xregcubic')
    mc= varargin{1};
    [Bnds,g,Tgt]= getcode(mc);
    NewTgt= recommendedTgt(mc);
    Tgt(:,1)= -Inf;
    Tgt(:,2)= Inf;
    mc= setcode(mc,Bnds,g,Tgt);
else
    mc= xregcubic(varargin{:});
end
m= class(m,'xreguncodedpoly',mc);
