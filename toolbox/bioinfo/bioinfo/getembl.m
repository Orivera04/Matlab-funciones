function emblout=getembl(accessnum,varargin)
%GETEMBL retrieves sequence information from the EMBL-EBI database.
%
%   GETEMBL(ACCESSNUM) searches for the accession number in the EBI
%   database (http://www.ebi.ac.uk/embl), and returns a structure
%   containing information about the sequence.
%
%   GETEMBL(...,'TOFILE',FILENAME) returns the data as a structure and
%   saves data in the file FILENAME in the EMBL-EBI data format.
%
%   GETEMBL(...,'SEQUENCEONLY',true) returns only the sequence
%   information and none of the metadata.
%
%   For more details about the EMBL database, see
%       http://www.ebi.ac.uk/embl/Documentation/index.html
%
%   Examples:
%
%       % Retrieve the data for rat liver apolipoprotein A-I.
%       emblout = getembl('X00558')
%
%       % Now retrieve just the sequence information for the same protein.
%       seq = getembl('X00558','SequenceOnly',true)
%
%   See also EMBLREAD, GETGENBANK, GETGENPEPT, GETPDB, GETPIR.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.10.4.3 $   $Date: 2004/03/14 15:31:21 $


sequence=false;
savefile=false;
if nargin > 1
    if rem(nargin,2)== 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'tofile','sequenceonly'};
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
                case 1  % save file data
                    filename=pval;
                    savefile=true;
                case 2  % sequence
                    sequence = opttf(pval);
                    if isempty(sequence)
                        error('Bioinfo:InputOptionNotLogical',...
                            '%s must be a logical value, true or false.',...
                            upper(char(okargs(k))));
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


%URL that is used to call database
%see http://www.ebi.ac.uk/cgi-bin/emblfetch for more information
temp=urlread(['http://www.ebi.ac.uk/cgi-bin/dbfetch?' accessnum]);

%search for returned text indicating that the accession number was not
%found in any files
if strfind(temp,'ERROR')
    error('Bioinfo:AccessionNotFound',...
        'The accession number you entered,%s , was not found in the database',...
        accessnum);
end

%make each line a separate row in string array
embldata = char(strread(temp,'%s','delimiter','\n','whitespace',''));

%pass to EMBLREAD to create structure
emblout=emblread(embldata,'sequence',sequence);

%  write out file
if savefile == true
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
            savedata(filename,embldata);
        case 'No',
            disp(sprintf('File %s not written.',filename));
    end

end

function savedata(filename,embltext)

fid=fopen(filename,'wb');

rows = size(embltext,1);

for rcount=1:rows-1,
    fprintf(fid,'%s\n',embltext(rcount,:));
end

fprintf(fid,'%s',embltext(rows,:));
fclose(fid);

