function display( m )
%DISPLAY   Display command for XREGLOLIMOT objects

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:50:32 $



s = char( m );
disp( ' ' )
disp( [ inputname(1), ' = ' ] )
disp( ' ' )
for i = 1:size(s,1);
    disp( [ '   ', s(i,:) ] )
end
disp( ' ' )

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
