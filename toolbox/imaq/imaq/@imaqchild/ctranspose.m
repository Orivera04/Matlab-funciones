function obj = ctranspose(obj)
% ' Complex conjugate transpose.   
% 
%    B = CTRANSPOSE(OBJ) is called for the syntax OBJ' (complex conjugate
%    transpose) when OBJ is an image acquisition object array.
%
%    See also VIDEOINPUT.

%    CP 2-1-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:04:44 $

% Extract and transpose the UDD object.
uddobj = imaqgate('privateGetField', obj, 'uddobject');
obj = isetfield(obj, 'uddobject', uddobj');
