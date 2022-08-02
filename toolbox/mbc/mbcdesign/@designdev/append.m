function obj  = append(obj, newobj)
% DESIGNDEV/APPEND appends a new designdev object to the bottom of a designdev list

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:58 $

if ~(isa(newobj, 'designdev') & isa(obj, 'designdev'))
	error('Appended object must be a designdev object');
end

% If we aren't at the bottom of the list simply append the new object
% to the next in the list
if ~isempty(obj.next)
   obj.next = append(obj.next, newobj);
else
   obj.next = newobj;
end
