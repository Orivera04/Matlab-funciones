function Value= get(OM,Property);
% xregoptmgr/GET 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:56:45 $


if nargin==1
	% return structure
	Value= structopts(OM);
else
	Property= upper(Property);
	pos= findstr(Property,'.');
	if ~isempty(pos);
		% uses the dot notation
		mainProp= get(OM,Property(1:pos(1)-1));
		Value= get(mainProp,Property(pos(1)+1:end));
		return
	end
	
	% find paramter
	opts= upper({OM.foptions.Param});
	pind= strmatch(Property,opts);
	
	if isempty(pind)
		% search sub optim managers
		[s,subOM]= suboptimMgrs(OM);
		found=0;
		for i=1:length(subOM);
			try
				Value= get(subOM{i},Property);
				found=found+1;
			end
		end
		if found==0
			error('mbc:xregoptmgr:InvalidProperty', 'Invalid property "%s" for optimisation manager options', Property)
		elseif found>1
			error('Ambiguous property for optimisation manager')
		end
	elseif length(pind)>1
		pind= strmatch(upper(Property),upper(opts),'exact');
		if isempty(pind)
			error('Ambiguous property for optimisation manager')
		end
		Value= OM.foptions(pind).Value;
	else
		Value= OM.foptions(pind).Value;
	end	
	
end



	
	