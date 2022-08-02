function out=end(hnd,k,n)
%TABLE/END   Overloaded end function
%   End provides support for the 'end' keyword in
%   table indexing

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:31 $


fud=get(hnd.frame.handle,'Userdata');

switch n
case 1
   out=fud.rows.number*fud.cols.number;
case 2
   if k==1
      out=fud.rows.number-fud.zeroindex(1)+1;
   else
      out=fud.cols.number-fud.zeroindex(2)+1;
   end
otherwise
  error('Bad indexing');   
end



