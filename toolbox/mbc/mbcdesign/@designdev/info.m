function info(obj)
%INFO

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:03:10 $

level = count(obj);
d = obj.design;

% Format channel names nicely
[names, units] = channelNames(obj, level);
leadSpaces = strvcat('  Channel names : ', repmat(' ',length(names)-1,1));
spaces = repmat(' (', length(names), 1);
endBracket = repmat(')', length(names), 1);
names = strvcat(names);

% Format model information
modelChar = char(model(obj.design));
modelLeadSpaces = repmat('        ', size(modelChar, 1), 1);

disp(' ')
disp(['Level ' num2str(level) ' of DesignDev object :'])
disp(' ')
disp(['  Design with ' num2str(nfactors(d)) ' factors and ' num2str(npoints(d)) ' points']);
disp([ leadSpaces names spaces endBracket]);
disp(['  ' num2str(length(obj.constraints)) ' valid constraints']);
disp( '  Modeled on :')
disp([ modelLeadSpaces modelChar]);
disp(['  getConstraints function : ' i_callback2str(obj.getConstraints)]);
disp(['  modifyDesign function   : ' i_callback2str(obj.modifyDesign)]);
disp(['  setDesignPoint function : ' i_callback2str(obj.setDesignPoint)]);
disp(['  runExperiment function  : ' i_callback2str(obj.runExperiment)]);
disp( '  Data :');
disp(obj.data);

info(obj.next);


function str = i_callback2str(callback)

switch class(callback{1})
case 'char'
	str = callback{1};
case 'function_handle'
	str = func2str(callback{1});
end

for i = 2:length(callback)
	switch class(callback{i})
	case 'char'
		str = [str ' {' callback{i} '}'];
	case 'function_handle'
		str = [str ' {' func2str(callback{i}) '}'];
	end
end