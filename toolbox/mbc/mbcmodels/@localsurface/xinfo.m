function out= xinfo(m,xi);
% LOCALSURFACE/XINFO xinfo structure access
%
% fields 'Names','Units','Symbols'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:42:47 $

if nargin==1
   out= xinfo(m.xregmodel);
else
	oldFeats= get(m,'features');
	flist= features(m);


   m.xregmodel= xinfo(m.xregmodel,xi);
   m.userdefined= xinfo(m.userdefined,xi);

	newlist= features(m);
	vals= get(m,'values');
	lims= get(m,'limits');
	
	% update rf names
    Ind= [];
    Nindex=[];
	for i=1:length(oldFeats);
		Nind= strmatch(lower(oldFeats(i).Display ),lower({flist.Display}),'exact');
		if ~isempty(Nind) & ~strcmp(oldFeats(i).Display,newlist(Nind).Display)
			% this is expensive so don't do it unless we have to
           Ind= [Ind i];
           Nindex= [Nindex Nind];
		end
	end		
    if ~isempty(Ind)
        m= EditFeat(m,Ind,vals(Ind,:),Nindex,lims(:,Ind));
    end
	
	out= m;
end      