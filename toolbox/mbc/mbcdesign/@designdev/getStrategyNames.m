function names = getStrategyNames(obj)
%GETSTRATEGYNAMES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:06 $

names = {{} {} {} {}};
% Save the current directory
cdir = pwd;
% Find the path the OldoeStrategy.m
w = which('oldoestrategy');
path = fileparts(w);
% Change directory to one up from @OldoeStrategy
cd(path)
cd('..')
% Get files starting with @ denoting objects
files = dir('@*');
% Change back to starting directory
cd(cdir)
% Iterate through each file found
for i = 1:length(files)
	% Is the file a directory. If so it might be a strategy
	if files(i).isdir
		% try createing the object, but leave off the @
		try
			obj = feval(files(i).name(2:end));
			if isa(obj, 'GCStrategy')
				names{1}{end+1} = files(i).name(2:end);
			elseif isa(obj, 'MDStrategy')
				names{2}{end+1} = files(i).name(2:end);
			elseif isa(obj, 'SPStrategy')
				names{3}{end+1} = files(i).name(2:end);
			elseif isa(obj, 'REStrategy')
				names{4}{end+1} = files(i).name(2:end);
			end
		catch
		end
	end
end
