function tbl=autosize(tbl,varargin)
% AUTOSIZE   Resize table rows/cols to fit
%
%  AUTOSIZE(T) adjusts the table rows and cols size parameter
%  so there is no grey gap between the last cell and the slider.
%
%  AUTOSIZE(T,'rows') does it just for rows.  AUTOSIZE(T,'cols')
%  does it just for columns.
%
%  AUTOSIZE(T,'rows',rownum[,'cols'[,colnum]]) sizes to display the
%  given number of rows/columns.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:25 $

% Created 21/3/2000

fud=get(tbl.frame.handle,'userdata');

opt='';
rnum=[];
cnum=[];
if isempty(varargin)
   opt='both';
else
   n=1;
   while n<=length(varargin)
      if ischar(varargin{n})
         tp=find(strcmp(lower(varargin{n}),{'rows','cols'})) - 1;
         if isempty(opt)
            opt=varargin{n};
         else
            opt='both';
         end
         if nargin>(n+1) & isnumeric(varargin{n+1})
            if tp
               cnum=varargin{n+1};
            else
               rnum=varargin{n+1};
            end
            n=n+2;
         else
            n=n+1;
         end
      else
         n=n+1;
      end
   end
end

if isempty(rnum)
   % get the current number of visible rows
   rnum=size(fud.cells.ftophandles,1) + size(fud.cells.shandles,1);
end
if isempty(cnum)
   % get the current number of visible cols
   cnum=size(fud.cells.flefthandles,2) + size(fud.cells.shandles,2);
end


switch lower(opt)
case 'rows'
   w = fud.position(4) - sum(fud.frame.vborder) - strcmp(fud.hslider.visible,'on').*fud.hslider.width;
   sz=i_calcsize(w,fud.rows.spacing,rnum);
   clear('fud');
   set(tbl,'rows.size',sz);
case 'cols'  
   w = fud.position(3) - sum(fud.frame.hborder) - strcmp(fud.vslider.visible,'on').*fud.vslider.width;
   sz=i_calcsize(w,fud.cols.spacing,cnum);
   clear('fud');
   set(tbl,'cols.size',sz);
case 'both'
   w = fud.position(4) - sum(fud.frame.vborder) - strcmp(fud.hslider.visible,'on').*fud.hslider.width;
   sz = i_calcsize(w,fud.rows.spacing,rnum);
   w = fud.position(3) - sum(fud.frame.hborder) - strcmp(fud.vslider.visible,'on').*fud.vslider.width;
   sz(2) = i_calcsize(w,fud.cols.spacing,cnum);
   clear('fud');
   set(tbl,'rows.size',sz(1),'cols.size',sz(2));
end
return




function sz=i_calcsize(width, cellsp, cellnum)

sz=(width - (cellnum - 1).*cellsp)./cellnum;

return


