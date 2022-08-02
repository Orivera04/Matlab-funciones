function [totalH, totalW]=xregtextlist(axH,pos,strings,indents,bolds,spacing,indent_size)
%XREGTEXTLIST  Create a series of text items in an axes
%
%  totalH=XREGTEXTLIST(axH, [XPOS YPOS ZPOS], STR, INDENT, BOLD, SPACING, INDENTSZ)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:34:39 $


if nargin<7
   indent_size=15;  % (points)
end
if nargin<6
   spacing=0;  % (points)
end
if nargin<5
   bolds=[];
end
if nargin<4
   indents=[];
end

% ensure all 3 lists are the same length
Nstr=length(strings);
if length(bolds)<Nstr
   bolds(end+1:Nstr)=0;   
end
if length(indents)<Nstr
   indents(end+1:Nstr)=0;   
end

% Get default fontsize in points
DaxH=double(axH);
deftextunits=get(DaxH,'defaultTextFontUnits');
set(DaxH,'defaultTextFontUnits','points');
txsize=get(DaxH,'defaultTextFontSize');
set(DaxH,'defaultTextFontUnits',deftextunits);

% Create items
count=0;
for n=Nstr:-1:1
   if bolds(n)
      fw='bold';
   else
      fw='normal';
   end
   tH(n)=text('parent',axH,...
      'units','points',...
      'position',pos+[indents(n)*indent_size count*(txsize+spacing) 0],...
      'verticalalignment','baseline',...
      'horizontalalignment','left',...
      'string',strings{n},...
      'fontweight',fw);
   count=count+1;
end

if nargout
   pos=get(tH(1),'position');
   pixperpoint=pos(2);
   set(tH(1),'units','pixels');
   pos=get(tH(1),'position');   
   pixperpoint=pos(2)/pixperpoint;
   set(tH(1),'units','points');
   totalH = (Nstr*(txsize+spacing)-spacing)*pixperpoint;
   if nargout>1
      % calculate the horizontal extent
      ext=get(tH,{'extent'});
      ext=cat(1,ext{:});
      ext=(ext(:,3)+indents(:)*indent_size)*pixperpoint;
      totalW=max(ext);      
   end
end


