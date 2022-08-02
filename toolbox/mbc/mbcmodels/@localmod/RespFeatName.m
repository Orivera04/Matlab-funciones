function BNames= RespFeatName(L)
% LOCALMOD/RESPFEATNAME default names for rf modeldev objects

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:44 $

BNames= cell(size(L.Values,1),1);
for i=1:length(L.Type)
   if ~isempty( findstr(L.Type(i).Function,'Value') )
      % thus adds the value to the name
      val= L.Values(i,:);
		if length(val)==1
			vstr= strrep(num2str(abs(val)),' ','_');
			if val<0
				BNames{i} = [(L.Type(i).Name),'_less',vstr];
			elseif val>0
				BNames{i} = [(L.Type(i).Name),'_plus',vstr];
			else
				BNames{i} = [(L.Type(i).Name),'_0'];
			end
		else
			vstr= strrep(sprintf('%.3g,',val),' ','_');
			
			BNames{i} = [(L.Type(i).Name),'_[',vstr(1:end-1),']'];
		end
	else
      BNames{i} = (L.Type(i).Name);
   end
end

