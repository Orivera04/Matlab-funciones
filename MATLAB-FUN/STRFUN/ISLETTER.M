function t = isletter(c)
%ISLETTER True for letters of the alphabet.
%	For a string S, ISLETTER(S) is 1 for letters of the alphabet
%	and 0 otherwise.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Character sets supported:
%	                   Mac  : Standard Roman
%	                   PC   : Windows Latin-1
%                          UNIX : ISO Latin-1 (ISO 8859-1)
%	                   VMS  : ISO Latin-1 (ISO 8859-1)

t = (('a' <= c) & (c <= 'z')) | (('A' <= c) & (c <= 'Z'));

comp = computer;
if strcmp(comp(1:2),'PC'),
	t = t | ((c > 191) & (c < 215)) | ((c > 215) & (c < 247)) | ...
	    ((c > 247) & (c < 256)) | (c == 138) | (c == 140) | ...
	    (c == 154) | (c == 156) | (c == 159);
elseif strcmp(comp(1:2),'MA'),
	t = t | ((c > 127) & (c < 160)) | ((c > 173) & (c < 176)) | ...
	    ((c > 189) & (c < 192)) | ((c > 202) & (c < 208)) | ...
	    ((c > 215) & (c < 218)) | ((c > 228) & (c < 240)) | ...
	    ((c > 240) & (c < 245));
else,
	t = t | ((c > 191) & (c < 215)) | ((c > 215) & (c < 247)) | ...
	    ((c > 247) & (c < 256));
end

