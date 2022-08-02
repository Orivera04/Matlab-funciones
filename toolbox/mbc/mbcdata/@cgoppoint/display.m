function display(P)
% cgOpPoint / display

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:38 $

nf = get(P,'numfactors');
np = get(P,'numpoints');
if ~nf & ~np
	disp('')
	disp('Empty operating point set')
	disp('')
elseif ~np
	disp('')
    pl = ''; if nf~=1, pl = 's'; end
	disp(['Empty operating point set with ' num2str(nf) ' factor' pl])
	disp('')
else
	str = 'Operating point set with ';
	S = size(P);
	str = [str,num2str(S(2)),' factor'];
	if S(2) > 1
		str = [str,'s'];
	end
	str = [str,' and ',num2str(S(1)),' point'];
	if S(1) > 1
		str = [str,'s'];
	end
	disp('');
	disp(str);
	disp('');
end