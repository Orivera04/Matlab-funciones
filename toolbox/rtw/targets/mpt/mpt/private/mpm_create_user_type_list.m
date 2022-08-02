function mpm_create_user_type_list()
%MPM_CREATE_USER_TYPE_LIST - Creates the user type list for replacement.
%
%   MPM_CREATE_USER_TYTPE_LIST()
%   This function creates the user type replacement file that is used in
%   the replacement of the base mathworks data types in the generated 
%   code file with the equivalent customer registered data types.  This
%   file is two columns of corresponding data types, the first column is
%   the mathworks data types while the second column is the corresponding 
%   user registered data types.
%
%   INPUTS: none
%   OUTPUTS: none
%




%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.8.4.6 $  $Date: 2004/04/15 00:28:27 $

userTypes = rtwprivate('rtwattic', 'AtticData', 'userTypes');
crlf = sprintf('\n');
fid =fopen('usertypes.typ','w');
fprintf(fid,'%s',['float real32_T',crlf]);
for i=1:length(userTypes),
    if strcmp(lower(userTypes{i}.primaryUserName),'primary')==1,
        fprintf(fid,'%s',[userTypes{i}.tmwName,' ',userTypes{i}.userName,' ',crlf]);
        fprintf(fid,'%s',[lower(userTypes{i}.tmwName),' ',userTypes{i}.userName,' ',crlf]);     
    end
end
fclose(fid);
