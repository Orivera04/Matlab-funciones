function T=DeleteDesign(T,h);
% TESTPLAN/DELETEDESIGN delete design and any data

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:07:07 $

[Xp,Yp]= dataptr(T);
if Xp~=0
   freeptr(Xp);
   freeptr(Yp);
   T=AssignData(T,{xregpointer,xregpointer});
end
T.Matched=  0;

T.DataLink= xregpointer;

pointer(T);

if numChildren(T)
	
	if isempty(T.Responses)
		% store best models so we can build them again 
		m= children(T,'Model');
		for i=1:length(m)
			m{i}= reset(m{i});
		end
		% if there are none we will rely on any previously set responses
		T.Responses = m;
		pointer(T);
	end
	% remove children from tree and delete
	ch=children(T);
    if nargin>1 && h.GUIExists
        try
            for i=1:length(ch);
                h.treeview(ch(i),'remove');
            end
        end
    end
	children(T,'delete');
end
T= info(T);
