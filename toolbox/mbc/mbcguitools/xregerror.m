function h= xregerror(Title,err);
% XREGERROR 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:34:21 $

if nargin==0
	Title= 'MBC Error';
end
if nargin<2
	% get error from laster
	err= lasterr;
	% strip of error source
	pos= findstr(err,sprintf('\n'));
	if ~isempty(pos)
		err= err(pos(1)+1:end);
	end
end
h= errordlg(err,Title,'modal');