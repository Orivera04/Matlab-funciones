function [A, C, G, T, prob_A, prob_C, prob_G, prob_T,comments] = scfread(filename)
%SCFREAD reads files in SCF trace format.
%
%   [SAMPLE, PROB, COMMENTS] = SCFREAD(FILENAME) reads the SCF format
%   file FILENAME and returns the sample data in structure SAMPLE with
%   fields A,C,T,G, probability data in structure PROB, and comment
%   information from the file in COMMENTS.
%
%   [A,C,T,G,PROBA,PROBC,PROBG,PROBT,COMMENTS] = SCFREAD(FILENAME)
%   reads the SCF format file FILENAME and returns the sample data and
%   probabilities for nucleotides in separate variables.
%
%   SCFREAD currently only reads SCF version 3.0 format files.
%
%   Example:
%        tstruct = scfread('sample.scf')
%        traceplot(tstruct)
%
%   For more information on SCF files, see
%   http://www.mrc-lmb.cam.ac.uk/pubseq/manual/formats_unix_2.html .
%
%   Sample SCF files can be found in
%   ftp://ftp.ncbi.nih.gov/pub/TraceDB/example/ .
%
%   See also GENBANKREAD, TRACEPLOT.

% Reference:
%   Dear, S and Staden, R. "A standard file format for data from DNA
%   sequencing instruments", DNA Sequence 3, 107-110, (1992).
%
%   http://www.mrc-lmb.cam.ac.uk/pubseq/manual/formats_unix_2.html

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.5.4.6 $   $Date: 2004/03/14 15:31:39 $



% File structure.

% Versions 1 and 2
%
% (Note Samples1 can be replaced by Samples2 as appropriate.)
%
% Length in bytes                        Data
% ---------------------------------------------------------------------
% 128                                    header
% Number of samples * 4 * sample size    Samples1 or Samples2 structure
% Number of bases * 12                   Base structure
% Comments size                          Comments
% Private data size                      private data
%
% Version 3
%
% Length in bytes                        Data
% ---------------------------------------------------------------------------
% 128                                    header
% Number of samples * sample size        Samples for A trace
% Number of samples * sample size        Samples for C trace
% Number of samples * sample size        Samples for G trace
% Number of samples * sample size        Samples for T trace
% Number of bases * 4                    Offset into peak index for each base
% Number of bases                        Accuracy estimate bases being 'A'
% Number of bases                        Accuracy estimate bases being 'C'
% Number of bases                        Accuracy estimate bases being 'G'
% Number of bases                        Accuracy estimate bases being 'T'
% Number of bases                        The called bases
% Number of bases * 3                    Reserved for future use
% Comments size                          Comments
% Private data size                      Private data
% ---------------------------------------------------------------------------

%----------------------------
% HEADER
%----------------------------

DELTA_IT = 1;
job =1;

machineformat = 'n';

checkForByteSwapping = 0;

while checkForByteSwapping < 2
    fid = fopen(filename, 'rb',machineformat);
    % Windows seems to want to hide .scf extensions. If the open fails, try
    % adding a .scf extension and see what happens.
    if fid <= 0
        fid = fopen(sprintf('%s.scf',filename), 'rb',machineformat);
    end
    % make sure file opened OK

    if fid > 0
        magic_number = fread (fid, 1, 'uint32');
    else
        error('Bioinfo:CouldNotOpenFile','Could not open file %s.', filename);
    end

    num_samples = fread (fid, 1, 'uint32');         % Number of elements in Samples matrix
    samples_offset = fread (fid, 1, 'uint32');      % Byte offset from start of file
    num_bases = fread (fid, 1, 'uint32');           % Number of bases in Bases matrix
    bases_left_clip = fread(fid, 1, 'uint32');      % OBSOLETE: No. bases in left clip (vector)
    bases_right_clip = fread (fid, 1, 'uint32');    % OBSOLETE: No. bases in right clip (qual)
    bases_offset = fread (fid, 1, 'uint32');        % Byte offset from start of file
    comments_size = fread (fid, 1, 'uint32');       % Number of bytes in Comment section
    comments_offset = fread (fid, 1, 'uint32');     % Byte offset from start of file
    version = fread(fid, 4, '*char')';                % "version.revision", eg '3' '.' '0' '0'
    sample_size = fread (fid, 1, 'uint32');         % Size of samples in bytes 1=8bits, 2=16bits
    code_set = fread (fid, 1, 'uint32');            % code set used (but ignored!)
    private_size = fread (fid, 1, 'uint32');        % No. of bytes of Private data, 0 if none
    private_offset = fread (fid, 1, 'uint32');      % Byte offset from start of file
    spare = fread(fid, 18, 'uint32');               % Unused

    if sample_size == 1 || sample_size == 2
        break;
    end
    checkForByteSwapping = checkForByteSwapping + 1;
    fclose(fid);
    machineformat = swapendian;

    if checkForByteSwapping > 1
        error('Bioinfo:CannotReadSCFFile','Problems reading the file. Sample size is not 1 or 2.');
    end
end

%----------------------------
% TRACES
%----------------------------
%
% The trace information is stored at byte offset samples_offset from the start of the file. For each sample point there are values
% for each of the four bases. sample_size holds the precision of the sample values.
%

% move cursor to beginning of trace information
% pos1 = ftell(fid);
fseek (fid, samples_offset, 'bof');
% pos2 = ftell(fid);

% make sure that we are really at the beginning of the trace data
% try
%     pos1 == pos2;
% catch
%     error('Moving cursor from end of header to begining of Traces moved the cursor');
% end


% The precision must be one of "1"  byte and "2"  short.

switch sample_size
    case 1
        sample_type = 'int8';
    case 2
        sample_type = 'int16';
    otherwise
        % should never get here
        error('Bioinfo:SCFREADBadSampleSize','Sample size is not 1 or 2.');
end

A = fread (fid, num_samples, sample_type); % Samples for A trace
C = fread (fid, num_samples, sample_type); % Samples for C trace
G = fread (fid, num_samples, sample_type); % Samples for G trace
T = fread (fid, num_samples, sample_type); % Samples for T trace

A = cumsum(cumsum(A));
C = cumsum(cumsum(C));
G = cumsum(cumsum(G));
T = cumsum(cumsum(T));


%----------------------------
% PROBABILITY
%----------------------------
%

% move cursor to beginning of probability information
% pos1 = ftell(fid);
fseek (fid, bases_offset, 'bof');
% % pos2 = ftell(fid);

% make sure that we are really at the beginning of the probability data
% try
%     pos1 == pos2;
% catch
%     error('Moving cursor from end of trace info to begining of probabliity info moved the cursor');
% end


peak_index = fread (fid, 1, 'uint32');               %  Index into Samples matrix for base posn
prob_A = fread(fid, num_bases, 'uint8');             %  Probability of it being an A
prob_C = fread(fid, num_bases, 'uint8');             %  Probability of it being an C
prob_G = fread(fid, num_bases, 'uint8');             %  Probability of it being an G
prob_T = fread(fid, num_bases, 'uint8');             %  Probability of it being an T
base = fread(fid, 1, 'char');                        %  Called base character
spare = fread(fid, 3, 'uint8');                      %  Spare

%------------------------
% Comments
%------------------------
%
% Comments are stored at offset comments_offset from the start of the file. Lines in this section are of the format:

% move cursor to beginning of comments information
% pos1 = ftell(fid);
fseek (fid, comments_offset, 'bof');
% pos2 = ftell(fid);

% % make sure that we are really at the beginning of the comment data
% try
%     pos1 == pos2;
% catch
%     error('Moving cursor from end of probablity info to begining of comments moved the cursor');
% end

comments = fread(fid, comments_size, '*char')';

% Currently don't do anything with comment data other than populate a char


%------------------------
% Private data
%------------------------
% Don't do anything with Private Data at the moment.

fclose(fid);


if nargout < 4

    out.A = A;
    out.C = C;
    out.G = G;
    out.T = T;

    probout.prob_A = prob_A;
    probout.prob_C = prob_C;
    probout.prob_G = prob_G;
    probout.prob_T = prob_T;
    A = out;
    C = probout;
    G = comments;
end

function e = swapendian
%SWAPENDIAN returns the inverse endian flag for a platform
switch computer
    case {'PCWIN','ALPHA','GLNX86','GLNXI64'} % little endian machines
        e = 'b';
    otherwise       % big endian machines
        e = 'l';
end 

