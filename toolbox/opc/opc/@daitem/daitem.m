function this = daitem(varargin)
% DAITEM Constructor for the daitem class.
%   To add items to a dagroup object, DAGROUP/ADDITEM must be used. If
%   daGrp is a dagroup object ADDITEM(daGrp,'Item.Name.1') adds an item
%   called Item.Name.1 to the dagroup daGrp.
%
%   See also DAGROUP/ADDITEM

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.6 $  $Date: 2004/03/24 20:43:02 $

if (nargin == 1) && ...
        (strcmp(class(varargin{1}),'opc.daitem') || ...
        strcmp(class(varargin{1}),'struct'))
	this = struct; 
    this = class(this,'daitem',opcroot(varargin{1}));
else
    rethrow(mkerrstruct('opc:daitem:arginvalid','Create daitem objects by calling the additem method on a valid dagroup object'));
end