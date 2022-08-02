function [geoStruct,str] =getgeodata(accessnum,varargin)
% GETGEODATA retrieves Gene Expression Omnibus (GEO) data. 
%
%   GEOSTRUCT = GETGEODATA(ACCESSNUM) searches for the accession number in
%   the Gene Expression Omnibus (GEO) database, and returns a structure
%   containing information for the object. 
%
%   GEOSTRUCT = GETGEODATA(...,'TOFILE',FILENAME) saves the data returned
%   from the database in the file FILENAME.
%
%   Example:
%   
%        geoStruct = getgeodata('GSM1768')
%
%   See http://www.ncbi.nlm.nih.gov/About/disclaimer.html for information
%   about using the GEO database.
%
%   See also GEOSOFTREAD, GETGENBANK, GETGENPEPT.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.6.4.2 $   $Date: 2004/01/24 09:18:22 $

if ~usejava('jvm')
    error('Bioinfo:NeedJVM','%s requires Java.',mfilename);
end
tofile = false;


if nargin > 1
    if rem(nargin,2) == 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'tofile',''};
    for j=1:2:nargin-2
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs);
        if isempty(k)
            error('Bioinfo:UnknownParameterName',...
                'Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:AmbiguousParameterName',...
                'Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case  1  % tofile
                    if ischar(pval)
                        tofile = true;
                        filename = pval;
                    end
            end
        end
    end
end 

% convert accessnum to a string if it is a number
if isnumeric(accessnum)
    accessnum = num2str(accessnum);
end

% error if accessnum isn't a string
if ~ischar(accessnum)
    error('Bioinfo:NotString','Access Number is not a string.')
end

% create the url that is used
% see 
%    http://www.ncbi.nlm.nih.gov/entrez/query/static/linking.html 
% for more information
searchurl = sprintf('http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?form=text&acc=%s&view=full',accessnum);

% get the html file that is returned as a string
try
    str=urlread(searchurl);
catch
    error('Bioinfo:URLProblem','Could not access data. Check Accession number.')
end

% search for text indicating that there weren't any files found
notfound=strfind(str,'No items found');

% string was found, meaning no results were found
if ~isempty(notfound),    
    error('Bioinfo:BadAccessionNumber',...
        'The number you were searching for,%s , was not found in the database.',accessnum) ;
end

geoStruct = geosoftread(str);

%  write out file?
if tofile == true
    writefile = 'Yes';
    % check to see if file already exists
    if exist(filename,'file')
        % use dialog box to display options
        writefile=questdlg(sprintf('The file %s already exists. Do you want to overwrite it?',filename), ...
            '', ...
            'Yes','No','Yes');
    end   
    
    switch writefile,
        case 'Yes',      
            if exist(filename,'file')
                disp(sprintf('File %s overwritten.',filename));
            end
            savedata(filename,str);
        case 'No',
            disp(sprintf('File %s not written.',filename));
    end
    
end

function savedata(filename,str)

fid=fopen(filename,'w');

rows = size(str,1);

for rcount=1:rows-1  
    fprintf(fid,'%s\n',str(rcount,:));
end
fprintf(fid,'%s',str(rows,:));

fclose(fid);










