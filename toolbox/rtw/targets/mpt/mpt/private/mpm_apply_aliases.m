function mpm_apply_aliases(fileList)
%MPM_APPLY_ALIASES - Applies Alias for all signals via a perl script
%
%   MPM_APPLY_ALIASES(FILELIST)
%   This function applies the aliases for signals and parameters to the
%   generated code via the use of the perl script alias.pl.  This does
%   a word boundry replace using perl regular expressions to determine
%   the word boundies to do an intelligent replacement of complete words.
%
%   INPUTS:  
%             fileList : cell array of file names to apply the aliases to.
%   OUTPUTS:
%             none



%   Copyright 2001-2003 The MathWorks, Inc.
%   $Revision: 1.7.4.2 $  $Date: 2004/04/15 00:28:24 $

for i=1:length(fileList),
    file = fileList(i);
    callperl('alias.pl',char(file),'alias.al');
end

return;
    
