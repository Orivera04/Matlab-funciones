function pdbstruct=getpdb(pdbID,varargin)
%GETPDB retrieves sequence information from the Protein Data Bank.
%
%   PDBSTRUCT = GETPDB(PDBID) searches for the ID in the Protein Data Bank
%   (PDB) database and returns a structure containing information for the
%   protein.
%
%   PDBSTRUCT = GETPDB(...,'TOFILE',FILENAME) saves the data returned from
%   the database in the file FILENAME.
%
%   PDBSTRUCT = GETPDB(...,'SEQUENCEONLY',true) returns just the protein
%   sequence. If the PDB file contains only one sequence then this will be
%   returned as a character array. If more than one sequence is found, then
%   these will be returned in a cell array.
%
%   PDBSTRUCT = GETPDB(...,'MIRRORSITE',MIRROR) allows you to choose a
%   mirror site for the PDB database. The default site is the San Diego
%   Supercomputer Center, http://www.rcsb.org/pdb. Set MIRROR to
%   http://rutgers.rcsb.org/pdb to use the Rutgers University Site or
%   http://nist.rcsb.org/pdb for the National Institute of Standards and
%   Technology site. See http://www.rcsb.org/pdb/mirrors.html for a full
%   list of PDB mirror sites.
%
%   Example:
%
%       pdbstruct = getpdb('2DHB')
%
%   This retrieves the structure information for horse deoxyhemoglobin
%   (PDB ID 2DHB).
%
%   See also GETEMBL, GETGENBANK, GETGENPEPT, GETPIR, PDBREAD.

%   Reference:
%   H.M. Berman, J. Westbrook, Z. Feng, G. Gilliland, T.N. Bhat, H.
%   Weissig, I.N. Shindyalov, P.E. Bourne: The Protein Data Bank. Nucleic
%   Acids Research, 28 pp. 235-242 (2000)

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.9.4.5 $   $Date: 2004/03/14 15:31:25 $

if ~usejava('jvm')
    error('Bioinfo:NeedJVM','%s requires Java.',mfilename);
end

tofile = false;
seqonly = false;
mirrorsite = 'http://www.rcsb.org/pdb';

if nargin > 1
    if rem(nargin,2) == 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'tofile','mirror','sequenceonly'};
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
                case 1    % tofile
                    if ischar(pval)
                        tofile = true;
                        filename = pval;
                    end
                case 2    % mirrorsite
                    if ischar(pval)
                        mirrorsite = pval;
                        if ~strfind(mirrorsite,'/pdb')
                            error('Bioinfo:BadMirrorSite',...
                                'MIRROR string does not appear to be a PDB mirror site.');
                        end
                    end
                case 3  % sequenceonly
                    seqonly = opttf(pval);
                    if isempty(seqonly)
                        error('Bioinfo:InputOptionNotLogical','%s must be a logical value, true or false.',...
                            upper(char(okargs(k))));
                    end
            end
        end
    end
end


% error if ID isn't a string
if ~ischar(pdbID)
    error('Bioinfo:NotString','Access Number is not a string.')
end

% get sequence from pdb.fasta if SEQUENCEONLY is true, otherwise full pdb
if seqonly == true
    searchurl = [mirrorsite '/cgi/getSequence.cgi/' pdbID '.fasta?chId=' pdbID '&format=fasta'];
    [header, pdb] = fastaread(searchurl);
else
    searchurl = [mirrorsite '/cgi/explore.cgi?job=download&pdbId=' pdbID '&opt=show&format=PDB&pre=1'];

    % get the html file that is returned as a string
    s=urlread(searchurl);

    % replace the html version of &
    s=strrep(s,'&amp;','&');

    % Find first line of the actual data
    start = regexp(s,'\nHEADER');

    if isempty(start)
        % search for text indicating that there weren't any files found
        notfound=regexp(s,'Your query found .*NO.* structures');

        % string was found, meaning no results were found
        if ~isempty(notfound),
            error('Bioinfo:PDBIDNotFound','The ID you were searching for, %s, was not found in the PDB database.',pdbID) ;
        end
        error('Bioinfo:PDBIDAccessProblem','Unknown problem accessing entry %s in the PDB database.',pdbID);
    end

    [dummy, endOfFile] = regexp(s,'\nEND.*?\n');


    % shorten string, to search for uid info
    s=s(start+1:endOfFile);

    %make each line a separate row in string array
    pdbdata = char(strread(s,'%s','delimiter','\n','whitespace',''));

    %pass to PDBREAD to create structure
    pdb=pdbread(pdbdata);
    

end

if nargout
    pdbstruct = pdb;
    if ~seqonly
        % add URL
        pdbstruct.SearchURL = searchurl;
    end
else
    if seqonly || ~usejava('desktop')
        disp(pdb);
    else
        disp(pdb);        
        disp([char(9) 'SearchURL: <a href="' searchurl '"> ' pdbID ' </a>']);                
    end
    
end

%  write out file
if tofile == true
    writefile = 'Yes';
    % check to see if file already exists
    if exist(filename,'file')
        % use dialog box to display options
        writefile=questdlg(sprintf('The file %s already exists.  Do you want to overwrite it?',filename), ...
            '', ...
            'Yes','No','Yes');
    end

    switch writefile,
        case 'Yes',
            if exist(filename,'file')
                disp(['File ' filename ' overwritten.']);
            end
            savedata(filename,pdbdata);
        case 'No',
            disp(['File ' filename ' not written.']);
    end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savedata(filename,pdbtext)

fid=fopen(filename,'wb');

rows = size(pdbtext,1);

for rcount=1:rows-1,
    fprintf(fid,'%s\n',pdbtext(rcount,:));
end
fprintf(fid,'%s',pdbtext(rows,:));
fclose(fid);
