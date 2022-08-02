function OM= setdefaults(OM,Properties,ctxt)
%SETDEFAULTS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:57:00 $

if nargin==1
	Properties= {OM.foptions.Param};
end
if isstr(Properties)
	% make into cell
	Properties= {Properties};
end


opts= upper({OM.foptions.Param});
if nargin<3
	omdef= i_buildOM(om);
else
	omdef= i_buildOM(om,ctxt);
end
for i=1:length(Properties);
	pind= strmatch(upper(Properties{i}),opts);
	
	if isempty(pind)
		error('Invalid property for optimisation manager options')
	elseif length(pind)>1
		pind= strmatch(upper(Properties{i}),upper(opts),'exact');
		if isempty(pind)
			error('Ambiguous property for optimisation manager')
		end
	end	
	
	if isa(OM.foptions(pind).Value,'xregoptmgr');
		alts= OM.foptions(pind).Value.Alternatives;
		OM.foptions(pind).Value= omdef.foptions(pind).Value;
		% copy alternatives
		OM.foptions(pind).Value.Alternatives= alts;
	else
		OM.foptions(pind).Value= omdef.foptions(pind).Value;
	end
end



function [omdef]= i_buildOM(om,ctxt);

if nargin<2
	ctxt= feval(om.Context);
end
if isa(om.algorithm,'cell')
	% context algorithm
	omdef= feval(om.algorithm{2},ctxt);
elseif ~strcmp(om.algorithm,'contextImplementation')
	try
		omdef= xregoptmgr(om.algorithm,ctxt);
	catch
		omdef= om;
		warning('Unable to determine defaults')
	end
else
	omdef= om;
end
