function hgo=hgobject(h)
%HGOBJECT Handle Graphics Object Constructor.
% HGOBJECT(H) creates a Handle Graphics Object from the Handles in array H.
% All elements of H must be the same handle graphics object type.
%
% After creation, the output object has the following features:
%
% HGO = HGOBJECT(H);       % create handle graphics object object from H
%
% set(H,'PName',PValue)    % set property the conventional way
% HGO.PName = PValue;      % equivalent to the above set command
%
% set(H(3),'PName',PValue) % set property of 3rd handle only
% HGO(3).PName = PValue;   % equivalent to the above set command
%
% PValue = get(H,'PName')  % get named property
% PValue = HGO.PName       % equivalent to the above get command
%
% In all cases, 'PName' or Pname need not be a complete property name, it
% is case insensitive and need only uniquely identify a property name of
% the handle H or object HGO, in the same manner as the functions set and
% get work.
%
% H = double(HGO) returns the handles H used in the creation of HGO.
% No other operators or functions are overloaded.

% D.C. Hanselman, University of Maine, Orono, ME  04469-5708
% masteringmatlab@yahoo.com
% 2007-06-22

if nargin ~=1
   error('HGOBJECT:rhs','One Input Argument Required.')
end
h=h(:);
if isa(h,'hgobject') % input already is an hgobject, so simply return it
   hgo=h;
   return
end
if isempty(h) || ~all(ishandle(h))
   error('HGOBJECT:rhs','Input Must be an Array of Valid Graphics Handles.')
end
types=get(h,{'type'});
if ~all(strcmp(types{1},types))
   error('HGOBJECT:rhs','Input Handles Not ALL of the Same Object Type.')
end
hgo.pnames=fieldnames(get(h(1)));
hgo.type=types{1};
hgo.handles=h;
hgo=class(hgo,'hgobject');
