function outData=mpm_apply_user_type(fileList)
%MPM_APPLY_USER_TYPES - Apply custom user types to the generated code.
%  
%   [OUTDATA]=MPM_APPLY_USER_TYPES(FILELIST)
%   This function applies the replacement user types to the generated code
%   file via a prel script "replace.pl" that used perl regular expressions
%   to do an intellegent find and replace of the base mathworks data type
%   with a registered user data type.
%
%   INPUTS:  
%             fileList : cell array of files to apply the data types to
%  
%   OUTPUTS:    
%            outData : Data structure containing the filenames and all the
%                      dependencies beacuse of user data types used.


%   Copyright 2001-2003 The MathWorks, Inc.
%   $Revision: 1.9.4.2 $  $Date: 2004/04/15 00:28:25 $

outData = [];
for i=1:length(fileList),
    
    outDataDepend = [];    
    outDataDependFinal =[];
    outDataTemp =[];
    outDataType =[];
    
    file = fileList{i};
    try,
        [outList]=callperl('replace.pl',file,'usertypes.typ','user');
    catch
        disp('Error: Error with callperl for replace.pl script, user data type replacement functions.');
        return;
    end
    
    %
    %  Check the for case where no substitutions were done and an empty is returned 
    % 
    
    if  isempty(outList) == 0, 
        len = findstr(outList,' ');
        
        for ix=1:length(len),
            if ix==1 ,    
                outDataTemp{ix} = outList(1:len(ix)-1);    
            else 
                outDataTemp{ix} = outList(len(ix-1)+1:len(ix)-1);
            end
        end
        
        %
        %   Get rid of duplicate data types 
        %
        
        outDataType = unique(outDataTemp);
        
        %
        %  Get the dependencies from the registry for the unique data types 
        %
        
        for itx=1:length(outDataType),
            outDataDepend{itx}= ac_get_type(outDataType{itx},'userName','userName','depend');   
        end
        
        %
        %  Sort and get rid of any duplicate dependencies
        %
        
        outDataDependFinal = unique(outDataDepend);
        
        %
        %  Make the file name correct 
        %
    end      
    [pathstr,fname,ext,ver]=fileparts(file);
    cFileName =[fname,ext];
    
    %
    % Assign filename and dependencies to the output structure
    %
    
    outData(i).fileName  = cFileName;
    outData(i).depends = outDataDependFinal; 
end
