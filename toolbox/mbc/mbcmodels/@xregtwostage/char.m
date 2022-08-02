function ch= char(TS,TeX);
% TWOSTAGE/CHAR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:59:20 $


if nargin==1 
   TeX=1;
end

% Local Model
ch{1}= ['Local: ',str_func(TS.Local,TeX)];

if DatumType(TS.Local)
   % DatumType display
   dtypes= {'Maximum','Minimum','Datum Link'};
   ch{2}= ['DatumType: ',dtypes{DatumType(TS.Local)}];
   st=3;
else
   st=2;
end
ch{st}= 'Global Models';

if TeX
	rf= char(detex(RespFeatName(TS.Local)));
else
	rf= char(RespFeatName(TS.Local));
end	
xi= globalinfo(TS);
for i=1:length(TS.Global);
   % Global response features
	m= xinfo(TS.Global{i},xi);
	ch{st+i}= ['  ',rf(i,:),': ',str_func(m,TeX)];
end

if RFstart(TS.Local)
   % display datum model
	m= xinfo(TS.datum,xi);
   ch{st+i+1}= [' Datum: ',str_func(m,TeX)];
end

ch= char(ch);
