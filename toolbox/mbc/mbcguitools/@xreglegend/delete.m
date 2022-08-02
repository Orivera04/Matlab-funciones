function delete(obj)
%xreglegend/DELETE   Delete function for xreglegend object.
%   DELETE(obj) deletes the xreglegend object obj.  This will
%   remove all graphical objects that are part of the object
%   and hence make obj unusable.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:31:41 $


%  Written by: Mungo Stacy
%  Date: 14/5/01

delete([obj.axes]);
