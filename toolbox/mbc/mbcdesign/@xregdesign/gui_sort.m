function [dout,ok]=gui_sort(des)
% GUI_SORT   GUI for sorting design points
%
%   [D,OK]=GUI_SORT(D) uses the gui function UISORTDATA to 
%   sort the factor settings in D.  OK indicates whether the 
%   user pressed OK or Cancel (ie whether the design has been
%   changed or not).
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:55 $

fs=factorsettings(des);

nosort=0;
if isempty(fs)
   fs=zeros(1,nfactors(des));
   nosort=1;
end

[fs,ord]=uisortdata(fs,factors(des));

if ~nosort
   if length(fs(:))~=1 | fs~=0
      des=reorder(des,ord);
      ok=1;
   else
      ok=0;
   end
else
   if fs~=0
      ok=1;
   else
      ok=0;
   end
end

if ~nargout
   nm=inputname(1);
   assignin('caller',nm,des);
else
   dout=des;   
end
return
