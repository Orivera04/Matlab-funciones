function [nds,cheaders,vals,numcol,colsize]= nodelist(T,tpfilter)
%NODELIST  return a list of nodes with info to add to listview
%
%  [NDS,CHEADERS,VALS,NUMCOL,COLSIZE]=NODELIST(T,TPFILTER)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:25:11 $

% default action is to add self then add children.
T=address(T);
[nds,cheaders,vals,numcol,colsize,recurse]=listinfo(T.info,tpfilter);

if recurse
   % recurse into children
   ch=T.children;
   for n=1:length(ch);
      [ch_nds,ch_cheaders,ch_vals,ch_numcol,ch_colsize]= nodelist(ch(n).info,tpfilter);
      if length(ch_numcol)
         [nds,cheaders,vals,numcol,colsize]= i_squishtogether(nds,cheaders,vals,numcol,colsize,ch_nds,ch_cheaders,ch_vals,ch_numcol,ch_colsize);
      end
   end
end





function  [nds,cheaders,vals,numcol,colsize]= i_squishtogether(nds,cheaders,vals,numcol,colsize,ch_nds,ch_cheaders,ch_vals,ch_numcol,ch_colsize);

% add any new columns.  Generate an index list that tells us where to place values
indx=zeros(size(ch_cheaders));
for n=1:length(ch_cheaders)
   i=find(strcmp(ch_cheaders{n},cheaders));
   if ~isempty(i)
      indx(n)=i;
   else
      indx(n)=length(cheaders)+1;
      cheaders=[cheaders ch_cheaders(n)];
      numcol=[numcol ch_numcol(n)];
      colsize=[colsize ch_colsize(n)];
      if length(vals)
         vals(:,end+1)={'-'};   % current values don't use this column
      end
   end
end

if length(ch_nds)
   % disperse values correctly
   nds=[nds ch_nds];
   vals(end+1:end+length(ch_nds),:)={'-'};
   vals(end:end+length(ch_nds)-1,indx)=ch_vals;   
end
return