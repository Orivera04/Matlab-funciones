function data=blastread(blasttext)
%BLASTREAD reads NCBI BLAST format report files.
%
%   DATA = BLASTREAD(FILE) reads in a NCBI formatted BLAST report from
%   FILE and creates a structure, DATA, containing fields corresponding to
%   the BLAST keywords.
%
%   DATA contains these fields:
%       RID
%       Algorithm
%       Query
%       Database
%       Hit.Name
%       Hit.Length
%       Hit.HSP.Score
%       Hit.HSP.Expect
%       Hit.HSP.Identities
%       Hit.HSP.Positives  (peptide sequences)
%       Hit.HSP.Gaps
%       Hit.HSP.Frame      (translated searches)
%       Hit.HSP.Strand     (nucleotide sequences)
%       Hit.HSP.Sequence
%
%   FILE can also be a URL or a MATLAB character array that contains the
%   text output of a NCBI BLAST report.
%
%   Examples:
%
%       % Create a BLAST request with a GenPept accession number.
%       RID = blastncbi('AAA59174', 'blastp', 'expect', 1e-10)
%
%       % Then pass the RID to GETBLAST to download the report and save it
%       % to a text file.
%       getblast(RID,'TOFILE','AAA59174_BLAST.rpt')
%
%       % Using the saved file, read the results into a MATLAB structure.
%       results = blastread('AAA59174_BLAST.rpt')
%
%   See also BLASTNCBI, GETBLAST.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $   $Date: 2004/04/04 03:23:45 $


if ~ischar(blasttext) && ~iscellstr(blasttext)
    error('Bioinfo:InvalidInput','The input is not an array of characters or a cell array of strings.');
end

if iscellstr(blasttext)
    blasttext=char(blasttext);
else %it is char, check if it has a url address or a file name
    if isvector(blasttext) && ~isempty(strfind(blasttext(1:min(10,end)), '://'))
        % must be a URL
        if (~usejava('jvm'))
            error('Bioinfo:NoJava','Reading from a URL requires Java.')
        end
        try
            blasttext = urlread(blasttext);
        catch
            error('Bioinfo:CannotReadURL','Cannot read URL "%s".',blasttext);
        end
        % clean up any &amp s
        blasttext=strrep(blasttext,'&amp;','&');
    elseif isvector(blasttext) && exist(blasttext,'file')
        % the file exists
        fid = fopen(blasttext);
        blasttext = fread(fid,'*char')';
        fclose(fid);
    end
end

% If the input is a string of BLAST data then a score section must be present
if isempty(regexpi(blasttext,'Score =.*?','once'));
    error('Bioinfo:NoValidData','File does not contain valid BLAST results.')
end

% Get the header info and cleanup
blastheader = blasttext(strfind(blasttext,'InfoEnd'):strfind(blasttext,'total letters'));
blastheader = regexprep(blastheader,'<.*?>',''); %remove html tags
blastheader = regexprep(blastheader,'\s+',' '); %remove extra white space
% Extract search information
data.RID = regexpi(blastheader,'\d+-\d+-\d+\.BLASTQ\d','match','once');
data.Algorithm = regexpi(blastheader,'BLAST.*?\[\w{3}-\d{2}-\d{4}\]','match','once');
data.Query = regexpi(blastheader,'(?<=Query= ).*?(?= Database)','match','once');
data.Database = regexpi(blastheader,'(?<=Database: ).*?(?= [\d,]*? sequences)','match','once');
% Get the Alignments section and cleanup
align_start = strfind(lower(blasttext),'alignments');
blasttext = blasttext(align_start(2):size(blasttext,2));
clean = '';
chunk = 10000;
filesize = size(blasttext,2);
for i = 1:chunk:filesize
    nohtml = regexprep(blasttext(i:min(i+chunk-1,filesize)),'<.*?>',''); %remove html tags
    noseq = regexprep(nohtml,'Query:.*?(?=(>|Score)',''); %remove sequence alignments
    clean = [clean regexprep(noseq,'\s+',' ')]; %remove extra white space
end
clean = regexprep(clean,' (e[-+])',' 1$1'); %correct abbreviated e-scores

use_frame = false;
use_positives = false;
use_strand = false;
% Frame is included in translated searches
if strfind(clean,'Frame =')
    use_frame = true;
end
% Positives are included with peptide sequences
if strfind(clean,'Positives =')
    use_positives = true;
end
% Strand is included with nucleotide sequences
if strfind(clean,'Strand =')
    use_strand = true;
end

hit_lines = regexp(clean,'>.*?(?=(>|Database))','match');
names_lengths = regexp(hit_lines,'>.*?(?= Score)','match')';
num_hits = size(hit_lines,2);
for i=1:num_hits
    name = regexp(names_lengths{i},'(?<=>).*?(?= Length)','match');
    length = regexp(names_lengths{i},'(?<=Length = )\d*?(?= Score)','match');
    data.Hits(i).Name = char(name{1});
    data.Hits(i).Length = str2double(char(length{1}));
    hsp_lines = regexp(hit_lines{i},'Score.*?(?=( Score|.$))','match');
    num_hsps = size(hsp_lines,2);
    gaps_match = {NaN(num_hsps,1)};
    gaps_possible = {NaN(num_hsps,1)};
    gaps_percent = {NaN(num_hsps,1)};
    scores = regexp(hsp_lines,'(?<=Score = )[e+\d\.]*?(?= bits)','match');
    expects = regexp(hsp_lines,'(?<=Expect = )[e-\d\.]*?(?= Identities)','match');
    id_match = regexp(hsp_lines,'(?<=Identities = )\d*(?=/\d* \(\d*?%\))','match');
    id_possible = regexp(hsp_lines,'(?<=Identities = \d*/)\d*(?= \(\d*?%\))','match');
    id_percent = regexp(hsp_lines,'(?<=Identities = \d*/\d* \()\d*?(?=%\))','match');
    if use_positives
        % Get the 3 values for positives
        pos_match = regexp(hsp_lines,'(?<=Positives = )\d*(?=/\d* \(\d*?%\))','match');
        pos_possible = regexp(hsp_lines,'(?<=Positives = \d*/)\d*(?= \(\d*?%\))','match');
        pos_percent = regexp(hsp_lines,'(?<=Positives = \d*/\d* \()\d*?(?=%\))','match');
    end
    if use_frame
        frames = regexp(hsp_lines,'(?<=Frame = )[+-]\d( / [+-]\d)?','match');
    end
    if use_strand
        % Get the strand orientation
        strands = regexp(hsp_lines,'(?<=Strand = )(Plus|Minus) / (Plus|Minus)','match');
    end
    sequences = regexp(hsp_lines,'(?<=Sbjct: \d+ )[a-zA-Z\-]+(?= \d+)','match');
    for j=1:num_hsps
        data.Hits(i).HSPs(j).Score = str2double(char(scores{j}));
        data.Hits(i).HSPs(j).Expect = str2double(char(expects{j}));
        data.Hits(i).HSPs(j).Identities.Match = str2double(char(id_match{j}));
        data.Hits(i).HSPs(j).Identities.Possible = str2double(char(id_possible{j}));
        data.Hits(i).HSPs(j).Identities.Percent = str2double(char(id_percent{j}));
        if use_positives
            data.Hits(i).HSPs(j).Positives.Match = str2double(char(pos_match{j}));
            data.Hits(i).HSPs(j).Positives.Possible = str2double(char(pos_possible{j}));
            data.Hits(i).HSPs(j).Positives.Percent = str2double(char(pos_percent{j}));
        end
        if strfind(hsp_lines{j},'Gaps =')
            gaps_match{j} = regexp(hsp_lines{j},'(?<=Gaps = )\d*(?=/\d* \(\d*?%\))','match');
            gaps_possible{j} = regexp(hsp_lines{j},'(?<=Gaps = \d*/)\d*(?= \(\d*?%\))','match');
            gaps_percent{j} = regexp(hsp_lines{j},'(?<=Gaps = \d*/\d* \()\d*?(?=%\))','match');
            data.Hits(i).HSPs(j).Gaps.Match = str2double(gaps_match{j});
            data.Hits(i).HSPs(j).Gaps.Possible = str2double(gaps_possible{j});
            data.Hits(i).HSPs(j).Gaps.Percent = str2double(gaps_percent{j});
        end
        if use_frame
            data.Hits(i).Frame = char(frames{j});
        end
        if use_strand
            data.Hits(i).Strand = char(strands{j});
        end
        data.Hits(i).HSPs(j).Sequence = cell2mat(sequences{j});
    end
end
