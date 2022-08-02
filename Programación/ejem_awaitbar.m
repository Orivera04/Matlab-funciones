 abort = false;	% This initialisation is needed to use abort the process. 
										% Please do not change variable name "abort" otherwise 
										% "abort" button will not work
   h = awaitbar(0,'Running Monte-Carlo, please wait...'); 
   for i=1:100,
			pause(0.2); % Do some computational stuff
			hh=awaitbar(i/100,h,'Running the process','Progress'); 
																			% asssign the ouput to the variable "hh"
																			% in order to abort the process by closing
																			% the waitbar figure
			if abort; close(h);break; end   % Abort the process by clicking abort button
			if isempty(hh); break; end      % Break the process when closing the figure
		end