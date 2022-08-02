function m=loadobj(m);
% XREGMODEL/LOADOBJ load object maintenance 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 07:52:28 $



if isa(m,'struct')
	m= xregmodel(m);
end	
if ~isfield(m.Stats,'Summary')
    m.Stats.Summary=[];
end

% version 5 changed the units from char to junit
if m.version<5
	% this should be the latest version number
	m.version= 6;
	
	if isempty(m.Xinfo.Units)
		m.Xinfo.Units= cell(1,nfactors(m));
	end
	
	% update units on inputs and outputs
	for i= 1:length(m.Xinfo.Units);
		uc= m.Xinfo.Units{i};
		if isstr(uc) & ~isempty(uc) & ~strcmp(uc,'?')
			u1= junit(uc);
			u2= displayname2junit(uc);
			if length(char(u1))>length(char(u2)) & isvalid(u2)
				u1= u2;
			end
			m.Xinfo.Units{i}= u1;
		else
			m.Xinfo.Units{i}= junit;
		end
	end
	yu= m.Yinfo.Units;
	if isstr(yu) & ~strcmp(yu,'?')
		u1= junit(yu);
		u2= displayname2junit(yu);
		if length(char(u1))>length(char(u2)) & isvalid(u2)
			% use displayname2junit if this is shorter
			u1= u2;
		end
		m.Yinfo.Units= u1;
	else
		m.Yinfo.Units= junit;
	end
	% old update 
	for i= 1:length(m.code);
		g= char(m.code(i).g);
		if strcmp(g,'x')
			m.code(i).g='';
		end
	end
	
end
