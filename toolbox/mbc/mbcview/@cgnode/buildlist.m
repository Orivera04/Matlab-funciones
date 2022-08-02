function buildlist(T,List,IL,tpfilter)
%BUILDLIST   Create nodes in activex list
%
%  buildlist(node, AXlist, IL,tpfilter)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 08:24:41 $


% call a recursive method to return column headers and values for all nodes
T=address(T);

[nds,cheaders,vals,numcol,colsize]= nodelist(T.info,tpfilter);

% set up column headers
ch=List.ColumnHeaders;
ch.Clear;
c = ch.Add;              % add the name column by default 
c.text='Name';
c.width=150;
for n=1:length(cheaders)
   c=ch.Add;
   c.text=cheaders{n};
   if colsize(n)>0
      c.width=colsize(n);
   end
   if numcol(n)
      c.tag='num';
      c.alignment='lvwColumnRight';
   end
end

% add nodes
li=List.ListItems;
li.Clear;
for n=1:length(nds)
   nds(n).addtolistview(vals(n,:), li, IL);
end