function xreglvsorter(list,evcode,cheader,varargin)
%XREGLVSORTER  Function to sort items in listview
%
%   

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:34:27 $

if evcode==11
   DONUM=0;
   % decide whether column is numeric
   tg=get(cheader,'tag');
   if ~isempty(tg)
      DONUM=strcmp(tg,'num');
   else
      if cheader.alignment==1
         % right-aligned columns are assumed to be numeric
         DONUM=1;
      end
   end
   
   
   ind=double(cheader.index);
   if DONUM
      if list.sorted
         list.sorted=0;
      end
      li=list.listitems;
      vals=zeros(double(li.count),1);
      for n=1:double(li.count)
         item=get(li,'item',n);
         if ind>1
            % go into subitem interface
            si=item.listsubitems;
            if (ind-1)<=si.count
               item=get(si,'item',ind-1);
               val=sscanf(item.text,'%f',1);
               if isempty(val)
                  val=NaN;
               end
            else
               val=NaN;
            end
         else
            % use node text field
            val=sscanf(item.text,'%f',1);
            if isempty(val)
               val=NaN;
            end
         end
         vals(n)=val;
      end
      [vals,ord]=sort(vals);
      if list.sortkey==(ind-1) & list.sortorder
         ord=ord(end:-1:1);
         list.sortorder=0;
      else
         list.sortorder=1;
      end
      list.sorted=0;
      list.sortkey=ind-1;
		if length(ord)>1
         list.ReorderList = ord;
		end
   else
      % use builtin alphabetic sorting
      if list.sorted & list.sortkey==(ind-1)
         list.sorted=0;
         list.sortorder=~list.sortorder;
      else
         list.sortkey=ind-1;
         list.sortorder=0;
      end
      list.sorted=1;
   end
end