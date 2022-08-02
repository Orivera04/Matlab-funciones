function str = getTipOfTheDay(index)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 08:05:55 $


persistent tips
if isempty(tips)
	filename = which('tipoftheday.txt', '-all');
	if isempty(filename)
		tips = {'No tips found'};
	else
		tips = textread(filename{1}, '%s', 'delimiter', '\n');
	end
end

index = mod(index - 1, length(tips) - 1) + 1;
str = tips{index};