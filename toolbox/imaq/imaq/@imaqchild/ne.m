function isnoteq=ne(arg1, arg2)
%NE ~=  Not equal for image acquisition objects.
%
%    C = NE(A,B) does element by element comparisons between image
%    acquisition objects A and B and returns a logical indicating 
%    if they refer to different objects. 
%
%    Note: NE is automatically called for the syntax 'A ~= B'.
%
%    See also IMAQCHILD/EQ, IMAQCHILD/ISEQUAL.
%

%    CP 9-02-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:04:58 $

isnoteq = ~eq(arg1,arg2);