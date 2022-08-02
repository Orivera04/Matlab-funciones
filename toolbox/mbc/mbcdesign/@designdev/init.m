function err = init(obj)
%DESIGNDEV/INIT The iterative DesignDev initialisation procedure

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:11 $

% Initialise all strategies and check design variables

% Create the GCStrategy object. Then call initialisation routine
GCobj = getObjectFromCallback(obj.getConstraints);
err = init(GCobj, obj);

if ~isempty(err)
	return
end

MDobj = getObjectFromCallback(obj.modifyDesign);
err = init(MDobj, obj);

if ~isempty(err)
	return
end

SPobj = getObjectFromCallback(obj.setDesignPoint);
err = init(SPobj, obj);

if ~isempty(err)
	return
end

REobj = getObjectFromCallback(obj.runExperiment);
err = init(REobj, obj);

if ~isempty(err)
	return
end

if ~isempty(obj.next)
	err = init(obj.next);
end


