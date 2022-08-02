function s=getstyleinfo(des)
%GETSTYLEINFO  Return string containing design type description
%
%  STR=GETDESIGNSTYLE(DES)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:41 $

if size(des,1)
   switch getstyle(des)
   case 0
      s='Custom';
   case 1
      s=des.style.baseinfo;
   case {2,3}
      s=CandidateSetInformation(des.style.baseinfo);
   case 4
      s='Experimental data';
   otherwise
      s='Unknown';
   end
else
   s='Empty design';
end