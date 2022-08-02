function state = getsplitable( Tree, panel )
%XREGFITTREE/GETSPLITABLE Get the splitable state of the a panel. 
%  GETSPLITABLE(T,PANEL) returns the splitable state, true or false, of the 
%  given PANEL. 
%  GETSPLITABLE(T) returns a list of all splitable panels.
%
%  See also XREGFITTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

if nargin == 1,
    state = find( Tree.Splitable );
else,
    state = Tree.Splitable(panel);
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

