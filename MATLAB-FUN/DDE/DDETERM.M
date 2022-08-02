%DDETERM Terminate DDE conversation.  
%	DDETERM takes one argument, the channel handle returned by the previous
%	call to DDEINIT that established the DDE conversation.
%
%	rc = DDETERM(channel)
%
%	rc      Return code: 0 indicates failure, 1 indicates success.
%	channel Conversation channel from DDEINIT.
%
%	For example,
%	Terminate the DDE conversation
%	rc = ddeterm(channel);
%
%       See also DDEINIT, DDEEXEC, DDEREQ, DDEPOKE, DDEADV, DDEUNADV.

%       Copyright (c) 1984-94 by The MathWorks, Inc.
