function varargout= xregxregmenutool(flag,varargin)
% XREGMENUTOOL - Vectorised uimenu tool  
% varargout=xregmenutool(flag,varargin)
%
% Description: Creates uimenus  
%                             
% Inputs       Action - string
%              various depending on Action
% Returns      depend on actions
%              returns uimenu handle/s on creation and find
% Actions
%    Create        create uimenus
%    Find          find handle for uimenu based on position
%    Set           set uimenu properties.
% hm= xregmenutool('Create',MenuPos,Prop1,Value1,Prop2,Value2)
% hm= xregmenutool('Find',MenuPos)
% xregmenutool('Set',MenuPos,Prop1,Value1,Prop2,Value2)
%
% MenuPos can be specified by either a handle (Figure or Uimenu) or a menu position 
% index e.g. 1 , 2 , 3 or [1 2 3]. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:34:29 $

switch lower(flag)
case 'create'
   if  ( ~ishandle(varargin{1}) )
      error('Graphics Handle Required for first input argument');
   end
   h=CreateMenus(varargin{:});
   if nargout==1
      varargout{1}= h;
   end
case 'set'
   if ishandle(varargin{1}) 
      SetMenu(varargin{:});
   else
      error('Invalid Input Parameters');
   end
case 'find'
   h=FindMenu(varargin{:});
   if nargout==1
      varargout{1}=h;
   else
      error('Only One Output argument permitted');
   end
   
end


% Set Menu Properties
function Menu=SetMenu(h,varargin)

pos=1;
while isa(varargin{pos},'double')
   pos=pos+1;
end
if pos==1 & ~strcmp(get(h,'Type'),'uimenu')
   error('Menu Position or UIMENU handle required');
end
if pos>1
   h= FindMenu(h,varargin{1:pos-1});
end

if (length(varargin)-pos-1)/2 ~= fix((length(varargin)-pos-1)/2)
   error('Properties must be paired with Values');
end

SetPropertyList = fieldnames(set(h));
Parse_Properties(SetPropertyList,varargin{pos:2:end});
set(h,varargin{pos:end});   


function hm=FindMenu(parent,varargin)

pos= [varargin{:}];
   
for i=pos
   hm=findobj(get(parent,'children'),'flat','Type','uimenu','position',i);
   parent=hm;
end

function Parse_Properties(PropertyList,varargin);

PropertyList=lower(char(PropertyList));
% Parse Properties
for i= 1:length(varargin)
   Property= varargin{i};
   I=strmatch(lower(Property),PropertyList);
   if isempty(I)
      error(['Invalid Property - ',Property]);
   elseif prod(size(I))>1
      error(['Ambiguous Property - ',Property]);
   end
end


function h=CreateMenus(parent,varargin)

pos=1;
while isa(varargin{pos},'double')
   pos=pos+1;
end
if pos>1
   parent= FindMenu(parent,varargin{1:pos-1});
end
hm=uimenu('parent',parent);
SetPropertyList = fieldnames(set(hm));
delete(hm);

PropertyList=varargin(pos:2:end);
Values=varargin(pos+1:2:end);

if (length(Values) ~= length(PropertyList))
   error('Properties must be paired with Values');
end

Parse_Properties(SetPropertyList,PropertyList{:});

NumMenus=1;
for i=1:length(Values)
   NumMenus=max(NumMenus,prod(size(Values{i})) );
end

PropertyValues=cell(NumMenus,length(Values));
for i=1:length(Values);
   if iscell(Values{i})
      [PropertyValues{:,i}]=deal(Values{i}{:});
   else
      [PropertyValues{:,i}]=deal(Values{i});
   end
end

for i= 1:NumMenus
  h(i)=uimenu('Parent',parent,'Position',i,PropertyList',PropertyValues(i,:));
end

