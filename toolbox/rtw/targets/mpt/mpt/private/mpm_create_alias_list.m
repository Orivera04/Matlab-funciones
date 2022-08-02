function mpm_create_alias_list()
%MPM_CREATE_ALIAS_LIST - Create the alias signals list from the data objects.
% 
%   MPM_CREATE_ALIAS_LIST()
%   This function creates a file of two columns, the first column is the
%   signal/parameter to be replaced. The second column is the alias it will
%   be replaced with in the generated code.  This is a temporary file and
%   is ment to be deleted once it is used. The file name is "alias.al".
%
%   INPUTS:
%             none
%   OUTPUTS: 
%             none
%


%   Copyright 2001-2003 The MathWorks, Inc.
%   $Revision: 1.11.4.2 $  $Date: 2004/04/15 00:28:26 $

cr = sprintf('\n');
fid = fopen('alias.al','w'); 
dolist = evalin('base','whos');
mpt_add_seq_subs(fid);
for i=1:length(dolist)

    if ~isempty(findstr(dolist(i).class,'.Signal'))
        try
            alias = evalin('base',[dolist(i).name,'.RTWinfo.Alias']);
            if ~isempty(deblank(alias))
                fprintf(fid,'%s',[dolist(i).name,' ',alias,cr]);
            end 
        catch
        end
    elseif ~isempty(findstr(dolist(i).class,'.Parameter'))
        try
            alias = evalin('base',[dolist(i).name,'.RTWInfo.Alias']);
            if ~isempty(deblank(alias))
                fprintf(fid,'%s',[dolist(i).name,' ',alias,cr]);
            end
        catch
        end
    end
end

fclose(fid);
       
