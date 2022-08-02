function libraries = pGetFeatureLibraries
%PGETFEATURELIBRARIES Return information about Simulink libraries
%
%  LIB_INFO = PGETFEATURELIBRARIES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:24:03 $ 

persistent library_store;

% return the persistent copy
if ~isempty(library_store)
    libraries = library_store;
    return;
end

% the default libraries
libraries(1,1:3) = {'&Simulink Calibration Library', {@i_SLLibOpen, @i_SLLibClose, @i_SLLibIsOpen} , {'separator','on'}};
libraries(2,1:3) = {'&Project Library', {@i_BranchLibOpen,@i_BranchLibClose, @i_BranchLibIsOpen}, {}};

% get the extensions
ext=cgtools.extensions;
exlibraries = ext.cgFeatureLibraries;

% exlibraries is a {nx3} cell array
% {LibraryLabel, {functions}, {otherargs}}
% LibraryLabel - the label to appear on the menu
% {functions} - cell array of callbacks {@open, @close, @isopen}
%               open - function called to open the library
%               close - function called to close the library
%               isopen - function called to determine whether the library is open or not
%                        (returns 1/0)
%               All these function should accept 1 argument - the CurrentNode.
% otherargs = a cellarray of property/value pairs to pass to uimenu e.g. {'separator','on'}

libraries = [libraries; exlibraries];
library_store = libraries;

%---------------------------------------------------------------------------------------
function i_SLLibOpen(node)
%---------------------------------------------------------------------------------------
% shows the calibration library
sys = 'cgeqlib';
[slPos, calLibWidth] = pcalcSLPosition;
libleft = slPos(3) + 10;
libright = libleft + calLibWidth;
load_system(sys);
set_param(sys,'lock','off');
set_param(sys,'location',[libleft, slPos(2), libright ,slPos(4)]);
open_system(sys)

%---------------------------------------------------------------------------------------
function i_SLLibClose(node)
%---------------------------------------------------------------------------------------
% hides the calibration library
sys = 'cgeqlib';
if i_SLLibIsOpen
    bdclose( sys );
end

%---------------------------------------------------------------------------------------
function isopen = i_SLLibIsOpen(node)
%---------------------------------------------------------------------------------------
% ask if the calibration library is currently open
isopen = ~isempty(find_system('type','block_diagram','name','cgeqlib'));


%---------------------------------------------------------------------------------------
function i_BranchLibOpen(node)
%---------------------------------------------------------------------------------------
% shows the Project library
makeProjectLibrary( node );

%---------------------------------------------------------------------------------------
function i_BranchLibClose(node)
%---------------------------------------------------------------------------------------
% hides the Project library

if i_BranchLibIsOpen(node)
    bdclose('CAGE_Project');
end
%---------------------------------------------------------------------------------------
function isopen = i_BranchLibIsOpen(node)
%---------------------------------------------------------------------------------------
isopen = ~isempty(find_system('name', 'CAGE_Project', 'type','block_diagram'));
