function des=deletefreepoints(des)
%DELETEFREEPOINTS Delete unfixed design points
%
%  D=deletefreepoints(D) deletes all the points in D which have
%  not been fixed.
%
%  SEE ALSO: FIXPOINTS, FREEPOINTS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:06:24 $


if des.npoints
    fp = fixpoints(des);
    if ~all(fp)
        % remove unfixed points
        des.design = des.design(fp,:);
        des.designindex = des.designindex(fp);
        des.npoints = size(des.design,1);
        des.designpointflags = des.designpointflags(fp);
        des = DesignType(des,0,[]);
        des = timestamp(des,'stamp');
        des.designstate = des.designstate+1;
    end
end
