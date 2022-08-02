function [namelist, handlelist] = getproteinpropfcns

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.5.4.3 $  $Date: 2004/01/24 09:20:16 $

% determine locations for function files:
% 1 : shipping with toolbox
% 2 : user created functions -> home/work directory

namelist = {};
handlelist = [];

% 1 : should store a list of the shipping property functions

installedlist = {'aaa_a_composition';
                 'aaaccessibleresidues';
                 'aaalpha_helixfasman';
                 'aaalpha_helixlevitt';
                 'aaalpha_helixroux';
                 'aaantiparallelbeta_strand';
                 'aaaverageburied';
                 'aaaverageflexibility';
                 'aabeta_sheetfasman';
                 'aabeta_sheetlevitt';
                 'aabeta_sheetroux';
                 'aabeta_turnfasman';
                 'aabeta_turnlevitt';
                 'aabeta_turnroux';
                 'aabulkiness';
                 'aaburiedresidues';
                 'aacoilroux';
                 'aahphob_argos';
                 'aahphob_black';
                 'aahphob_breese';
                 'aahphob_chothia';
                 'aahphob_doolittle';
                 'aahphob_eisenberg';
                 'aahphob_fauchere';
                 'aahphob_guy';
                 'aahphob_janin';
                 'aahphob_leo';
                 'aahphob_manavalan';
                 'aahphob_miyazawa';
                 'aahphob_mobility';
                 'aahphob_parker';
                 'aahphob_ph3_4';
                 'aahphob_ph7_5';
                 'aahphob_rose';
                 'aahphob_roseman';
                 'aahphob_sweet';
                 'aahphob_welling';
                 'aahphob_wilson';
                 'aahphob_wolfenden';
                 'aahphob_woods';
                 'aahplc2_1';
                 'aahplc7_4';
                 'aahplchfba';
                 'aahplctfa';
                 'aamolecularweight';
                 'aanumbercodons';
                 'aaparallelbeta_strand';
                 'aapolaritygrantham';
                 'aapolarityzimmerman';
                 'aaratioside';
                 'aarecognitionfactors';
                 'aarefractivity';
                 'aarelativemutability';
                 'aatotalbeta_strand'
                 };

for n = 1:numel(installedlist),
    fcnoutput = feval(installedlist{n});
    namelist = [namelist; {strtrim(fcnoutput(9:end))}]; 
    handlelist = [handlelist; {str2func(installedlist{n})}];
end
    
% 2 : use the files from the current directory

file_pwd = dir;
file_names = {file_pwd(:).name}';

% look for functions named 'aa****.m
s = regexp(file_names,'^aa[a-zA-Z_](\w)+\.m$');

for n = 1:size(file_names,1),
    if ~cellfun('isempty',s(n)),
        fname = char(file_names(n));
    else 
        % go to next name
        continue
    end
    
    % try file, see if the output is a string

    try
        fcnoutput = feval(fname(1:end-2));
    catch
        lasterr('')
        continue
    end
    
    % see if it matches the standard output for the property functions
    if ~ischar(fcnoutput) || ~strncmp(fcnoutput,'AAProp_',7)
        continue
    else
        namelist = [namelist; {strtrim(fcnoutput(9:end))}]; 
        handlelist = [handlelist; {str2func(fname(1:end-2))}];
    end
end

[namelist,ind] = unique(namelist);

handlelist = handlelist(ind);

