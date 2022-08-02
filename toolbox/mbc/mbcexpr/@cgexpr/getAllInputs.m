function ptrs= getAllInputs(E)
%getAllInputs Return all input pointers to expression
%
%  PTRS = getAllInputs(OBJ) returns a,l the input pointers to the
%  expression OBJ. This recurses down the expression tree,

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:08:39 $ 



inp= getinputs(E); 
if ~isempty(inp)
    Inputs= infoarray(inp);
    ptrs= inp;
    for i=1:length(Inputs)
        ptrs= [ptrs getAllInputs(Inputs{i})];
    end
else
    ptrs= null(xregpointer,1,0);
end