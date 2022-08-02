function updatePath(location)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename:     updatePath.m
%
% Description:  Function adds subdirectories to the current path
%
% Input:        path to the directories that should be added.
%               eg updatePath(c:\matlab\files) will add all the directories
%               under files and recursive add their subdirectories as well.
%               It will NOT add c:\matlab\files to the path
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   $Revision: 1.1 $   
%   $Date: 2004/10/30 18:11:38 $
%
%   Version History:
%   ----------------
%   $Log: updatePath.m,v $
%   Revision 1.1  2004/10/30 18:11:38  jasmine
%   Created Graph Theory folder in STB repository
%
%

temp  = strfind(location,'/');	% if this is not empty --> using Linux
files = dir(location);

if( isempty(temp) == 0)
	% linux

	for ind = 3:size(files,1) 
		% files(1:2).name is . and .. basically the current directory and the
		% one above it. It adds current directory . to the path
		if( files(ind).isdir == 1)
			add = [location,'/',files(ind).name];
			addpath( add, 0);
			disp(['Added ',num2str(add),' to current path beginning']);

			% Recurse through the directories
			updatePath(add);
		end
	end
else
	% windows

	for ind = 3:size(files,1) 
		% files(1:2).name is . and .. basically the current directory and the
		% one above it. It adds current directory . to the path
	    if( files(ind).isdir == 1)
	        add = [location,'\',files(ind).name];
	        addpath( add, 0);
	        disp(['Added ',num2str(add),' to current path beginning']);
			
			% Recurse through the directories
			updatePath(add);
	    end
	end
end
