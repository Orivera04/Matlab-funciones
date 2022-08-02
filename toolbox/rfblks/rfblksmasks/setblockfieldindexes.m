function setblockfieldindexes(block)
%SETBLOCKFIELDINDEXES Set index numbers in the callers workspace.
%
%   The field numbers will have the same name (and case) as the mask variable 
%   names, BUT they will have their first initial capitalized and preceded 
%   by 'idx'. For example a Dialog variable 'fooBar' creates an index                    
%   called 'idxFooBar'                                                         

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:40:26 $

    evalStr1 = '';
   
    MN = get_param(block,'MaskNames');

    for n=1:length(MN)
        varName  = [upper(MN{n}(1)) MN{n}(2:end)];
        evalStr1 = [evalStr1 sprintf('idx%s = %d;', varName, n)];
    end;
    
    evalin('caller',evalStr1);

return;
