function pirinfo = getpir(PIRID,varargin)
%GETPIR retrieves sequence information from the PIR database.
%
%   GETPIR(PIRID) searches the Protein Information Resource (PIR)
%   database for PIR Unique ID ACCESSNUM and returns a structure containing
%   information for the protein.
%
%   GETPIR(...,'SequenceOnly',true) returns only the sequence information
%   for the protein as a string.
%
%   GETPIR(...,'ToFile',FILENAME) saves the data retrieved from
%   the PIR database to the file FILENAME.
%
%   Example:
%
%       pirdata = getpir('cchu')
%
%       % Creates a structure, pirdata, that holds the result of a
%       % query into the PIR database using 'cchu' as the search
%       % string.
%
%       pirdata = getpir('cchu','SequenceOnly',true)
%
%       % Returns a string, pirdata, that holds the sequence information
%       % for the query 'cchu' into the PIR database.
%
%       pirdata = getpir('cchu','ToFile','cchu.pir')
%
%       % Returns a structure, pirdata, that holds the result of a query
%       % into the PIR database using 'cchu' as the search string. It also
%       % creates a text file 'cchu.pir' in the current folder that holds
%       % the data retrieved from the PIR database. Note that the entire
%       % data retrieved from the database is stored in FILENAME even if
%       % the SequenceOnly option is used.
%
%   See also GETEMBL, GETGENBANK, GETGENPEPT, GETPDB, PIRREAD.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.7.4.3 $   $Date: 2004/03/14 15:31:26 $

if ~usejava('jvm')
    error('Bioinfo:NeedJVM','%s requires Java.',mfilename);
end

SeqOnlyFlag   = false;
WriteFileFlag = false;
RetData = [];

if nargin > 1
    if rem(nargin,2) == 0
        error('Bioinfo:InvalidInputs',...
            'Incorrect number of arguments for %s',mfilename);
    end
    okargs = {'sequenceonly','tofile'};
    for j=1:2:nargin-2
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname),okargs);
        if isempty(k)
            error('Bioinfo:UnknownParameter',...
                'Unknown parameter name: %s',pname);
        elseif length(k)>1
            error('Bioinfo:InvalidParameter',...
                'Ambiguous parameter name: %s',pname);
        else
            switch(k)
                case 1    %SequenceOnly
                    SeqOnlyFlag = opttf(pval);
                    if isempty(SeqOnlyFlag)
                        error('Bioinfo:InputOptionNotLogical','%s must be a logical value, true or false.',...
                            upper(char(okargs(k))));
                    end
                case 2    %ToFile
                    if ischar(pval)
                        filename = pval;
                        if exist(filename,'file')
                            reply = questdlg([filename ' already exists. Do you wish '...
                                'to over write file?'],...
                                'Warning!', 'Yes','No','No');
                            if strcmpi(reply,'yes')
                                WriteFileFlag = true;
                            else
                                WriteFileFlag = false;
                            end
                        else
                            WriteFileFlag = true;
                        end
                        if ~WriteFileFlag
                            warning('Bioinfo:notoverwriting',...
                                'Not writing data to file %s',pval);
                        end
                    else
                        error('Bioinfo:invalidfilename','File name must be string');
                    end
            end
        end
    end
end

if SeqOnlyFlag
    urldata = urlread(sprintf(...
        'http://pir.georgetown.edu/cgi-bin/pirwww/nbrfget?uid=%s&fmt=F',PIRID));

    if strfind(lower(urldata),lower('Entry cannot be found'))
        error('pirinfo:accessid','Invalid access ID');
    end

    %Remove the first line by splitting on char(10) (newline)
    [junk,RetData] = strtok(urldata,char(10));
    RetData        = strrep(RetData,char(10),'');
else
    urldata = urlread(sprintf(...
        'http://pir.georgetown.edu/cgi-bin/pirwww/nbrfget?uid=%s&fmt=T',PIRID));

    if strfind(lower(urldata),lower('Entry cannot be found'))
        error('pirinfo:accessid','Invalid access ID');
    end
end

if WriteFileFlag
    fid = fopen(filename,'wt');
    if fid == -1
        error('Bioinfo:CouldNotOpenFile','Could not open file %s.', filename);
    end
    if SeqOnlyFlag
        urldata = urlread(sprintf(...
            'http://pir.georgetown.edu/cgi-bin/pirwww/nbrfget?uid=%s&fmt=T',PIRID));
        fprintf(fid,'%c',urldata);
        fclose(fid);
    else
        fprintf(fid,'%c',urldata);
        fclose(fid);
        RetData = pirread(urldata);
    end
end

if ~SeqOnlyFlag && ~WriteFileFlag
    RetData = pirread(urldata);
end

pirinfo = RetData;
