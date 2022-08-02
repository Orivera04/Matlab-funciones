function T= mctree(NewName,varargin);
% MCTREE tree constructor

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:47:58 $



if nargin==0
   NewName='Node';
end
if  nargin== 2 & (isa(varargin{1},'struct') | isa(varargin{1},'tree'))
   T= struct(varargin{1});
	NewName= T.Name;
   Par= T.Parent;
   ch= T.Children;
   node= T.node;
elseif nargin== 2 & isa(varargin{1},'mctree')
   T= varargin{1};
   return
else
   Par=xregpointer;
   ch=[];
   node= xregpointer;
end

   
T= struct('Name',NewName,...    
   'Parent',Par,...         % pointer to parent
   'Children',ch,...        % array of pointers to children
   'node',node,...          % pointer to self. This is needed to update dynamic copy of tree node
   'TreeIndex',0,...;
   'Version',1);

T= class(T,'mctree');