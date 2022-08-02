function TS=InitStore(TS,Xcode,Yrf);
%INITSTORE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:12 $

RF1= RFstart(TS.Local);
DatumType= get(TS.Local,'DatumType');
if DatumType
   bd= ~isfinite(Yrf(:,1));
   TS.datum= InitStore(TS.datum,Xcode,Yrf(:,1),bd,false);
end

if RF1 & size(Yrf,2)>size(TS.Local,1)
   Yrf(:,1)=[];
end

for i=1:length(TS.Global);
   bd= ~isfinite(Yrf(:,i));
   TS.Global{i}= InitStore(TS.Global{i},Xcode,Yrf(:,i),bd,false);
end
