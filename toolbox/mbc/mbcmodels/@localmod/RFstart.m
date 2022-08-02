function ind= RFstart(L)
% LOCALMOD/RFSTART returns 1 if a non-response feature datum is used
%
% currently this is true for polynom
% and false for polysplines and quadsplines

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:38:43 $

ind=false;
if (L.DatumType==1 | L.DatumType==2 ) & ~isempty(L.Values) 
   % if datumtype is maximum and some response features are defined
   ind= ~L.Type(1).IsDatum;
   % Datum model is an extra response features
end