function ok= isOnlySibling(T);
%ISONLYSIBLING

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:47:52 $

if T.Parent==0
	% at root
	ok=1;
else
	T= info(T.Parent);
	n= length(T.Children);
	while n==1
		T= info(T.Children);
		n= length(T.Children);
	end
	% n==0 when you have got to bottom of tree
	ok = n==0;	
end
