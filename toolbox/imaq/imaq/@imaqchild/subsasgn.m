function obj = subsasgn(obj, Struct, Value)
%SUBSASGN Subscripted assignment into image acquisition objects.
%
%    SUBSASGN Subscripted assignment into image acquisition objects. 
%
%    OBJ(I) = B assigns the values of B into the elements of OBJ specifed by
%    the subscript vector I. B must have the same number of elements as I
%    or be a scalar.
% 
%    OBJ(I).PROPERTY = B assigns the value B to the property, PROPERTY, of
%    image acquisition object OBJ.
%
%    Supported syntax for image acquisition objects:
%
%    Dot Notation:                  Equivalent Set Notation:
%    =============                  ========================
%    obj.Tag='sydney';              set(obj, 'Tag', 'sydney');
%    obj(1).Tag='sydney';           set(obj(1), 'Tag', 'sydney');
%    obj(1:4).Tag='sydney';         set(obj(1:4), 'Tag', 'sydney');
%    obj(1)=obj(2);               
%    obj(2)=[];
%
%    See also IMAQCHILD/SET, IMAQCHILD/PROPINFO, IMAQHELP.
%

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:02 $

errID = 'imaq:subsasgn:childMixedTypes';
try
    obj = imaqgate('privateSubsasgn', obj, Struct, Value, errID, 'imaqchild');
catch
    rethrow(lasterror);
end
