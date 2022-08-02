function T= Restore(T,OldTP,oldTSSF);
%RESTORE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:07:25 $

% restore old testplan
[xp,yp]= dataptr(T);
newp=0;





% delete extra data set objects which have been created
MP = info(project(T));

if IsMatched(OldTP) && isvalid(OldTP.DataLink);
    OldTP.DataLink.info= oldTSSF;
else
    OldTP.DataLink = xregpointer;
end

xregpointer(OldTP);
MP = cleanupData(MP,address(T));


if ~IsMatched(OldTP)
	% data design might have done a match
	if yp~=0
		freeptr(xp);
		freeptr(yp);
        [xp,yp]= dataptr(OldTP);
	end
    OldTP.DataLink= xregpointer;
else
	% restore old match
    if  numstages(T)~= numstages(OldTP) 
        newp= 1;
		freeptr(xp);
		freeptr(yp);
        [xp,yp]= dataptr(OldTP);
    end
end
pointer(OldTP);
if newp
	% restore data
	OldTP= AssignData(OldTP,{xp,yp});
	% keep children
	ch= children(T);
	OldTP= AssignChildren(OldTP,ch);
end

T= OldTP;
