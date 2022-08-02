function mdev= loadobj(mdev)
% MODELDEV/LOADOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:10:33 $

if mdev.Version < 3 
	s= mdev.Statistics;
	if isa(mdev.Model,'localmod')
		% update local stats
		if length(s)>5
			s(end-1)=[];
			mdev.Statistics= s;
			mdev.Version = 3;
		end
	elseif isa(mdev.Model,'xregtwostage') 
		if islinear(mdev.Model) & length(s)==4
			s= [s(1:2) NaN s(3:4)];
			mdev.Statistics= s;
			mdev.Version = 3;
		end
	end
end
if mdev.Version < 4
   % convert numeric ViewIndex to a string
   if isnumeric(mdev.ViewIndex)
      strs={'testplan','global','local','global','global'};
		if isa(mdev.Model,'xregtwostage')
			strs{mdev.ViewIndex}= 'twostage';
		end
      mdev.ViewIndex=strs{mdev.ViewIndex};
   end
   mdev.Version=4;
end


if isa(mdev,'struct')
   mdev= modeldev(mdev);
end

