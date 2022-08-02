function [headers, mAlign] = multialignread(filename)
%MULTIALIGNREAD read a multiple sequence alignment file.
%
%   S = MULTIALIGNREAD(FILENAME) reads a multiple sequence alignment file
%   in which the sequences are determined by blocks with interleaved lines.
%   Common multiple alignment file types, such as ClustalW (.aln) and GCG
%   (.msf), can be read with MULTIALIGNREAD. Every line should start with
%   the sequence header followed by a number (optional, not used by
%   MULTIALIGNREAD) and the space formatted section of the multiple
%   sequence alignment. Sequences are divided into several blocks, same
%   number of blocks must appear for every sequence. The output S is a
%   structure array; where S.Header contains the header information and
%   S.Sequence the amino acid or nucleotide sequences. FILENAME can also be
%   a URL or MATLAB character array that contains the text of the data
%   file.
%   
%   [HEADER, SEQS] = MULTIALIGNREAD(FILENAME) reads the file into separate
%   variables HEADER and SEQS. 
%
%   Example:
%
%       % Reads the a multiple alignment of the gag polyprotein of several
%       % HIV strains.
%       gagaa = multialignread('aagag.aln')
%
%   See also FASTAREAD, GETHMMALIGNMENT, SEQDISP.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.4.2 $  $Date: 2004/04/01 15:58:05 $

% check input is char
% in a future version we may accept also cells
if ~ischar(filename)
    error('Bioinfo:InvalidInput','Input must be a character array')
end

if size(filename,1)>1  % is padded string
    for i=1:size(filename,1)
        ftext(i,1)=strread(filename(i,:),'%s','whitespace','','delimiter','\n');
        ftext{i}(find(~isspace(ftext{i}),1,'last')+1:end)=[];
    end    
    % try then if it is an url
elseif (strfind(filename(1:min(10,end)), '://'))
    if (~usejava('jvm'))
        error('Bioinfo:NoJava','Reading from a URL requires Java.')
    end
    try
        ftext = urlread(filename);
    catch
        error('Bioinfo:CannotReadURL','Cannot read URL "%s".', filename);
    end
    ftext = strread(filename,'%s','delimiter','\n','whitespace','');

    % try then if it is a valid filename
elseif  (exist(filename) == 2 || exist(fullfile(cd,filename)) == 2)
    ftext = textread(filename,'%s','delimiter','\n','whitespace','');

else  % must be a string with '\n', convert to cell
    ftext = strread(filename,'%s','delimiter','\n','whitespace','');
end

try % safety error-catch block

%erase empty lines from ftext
ftext(strcmp('',ftext))=[]; 

% get the preamble of every line (which should be the header)    
preamble = regexp(ftext,'\S+','once','match');

% get a unique set of keys and indexes to keys for every entry in preamble
[keys,i,h] = unique(preamble);

% frequency of header ocurrences (this gives a pattern of the potential
% number of blocks)
freqh = accumarray(h,1); 

% try to guess what is the potential number of blocks by detecting the mode
% again, but ignoring all the headers which freqh==1 (i.e. appeared once)

if all(freqh==1)
    modeFreqh = 1;
else
    freqFreqh = accumarray(freqh(freqh~=1),1);
    [dummy,modeFreqh]=max(freqFreqh);
end

% logical index to the selected keys 
g = (modeFreqh == freqh);

% h -> key index for every line in ftext (or every preamble)
% i -> preamble index for every key
% g -> logical index indicating the valid keys
% g(h) -> logical index indicating the valid lines
% i(g) -> index to preamble for the valid keys

numSeqs = sum(g);
numLines = sum(g(h));
numBlocks = numLines/numSeqs;

% if there are two or more valid keys (ie sequences) AND two or more blocks
% AND the number of valid lines is a multiple of the number of blocks (or
% valid keys) AND lines are ordered one after the other for every block
% THEN we can assume it is a multiple alignment with several blocks 
if (numSeqs>1)  &&  (numBlocks>1)  &&  (rem(numBlocks,1)==0) && ...
   all(all(diff(reshape(find(g(h)),numSeqs,numBlocks))==1))
       recognizedFormat = true;
       ftext = ftext(g(h));
       headers = preamble(sort(i(g)));
else
       recognizedFormat = false;
end

% if format has not been recognized, then try one block with several
% sequences, the lines of interest will be those that have the same length
if ~recognizedFormat

   lengths = cellfun('length',ftext);
   freqLengths = accumarray(lengths,1);
   [dummy,modeFreqLengths] = max(freqLengths);
   g = (lengths==modeFreqLengths);
   
   % the selected lines must be contiguous, select the largest region of g
   % with ones
   cg = double(g);
   for j = 2:numel(cg)
       cg(j) = (cg(j-1)+cg(j))*cg(j);
   end
   [ma,lo]=max(cg);
   
   numSeqs = ma;
   numLines = ma;
   numBlocks = 1;
   
   % clean input data accordongly with the selected valid lines 
   ftext = ftext(lo-ma+1:lo);
   headers = preamble(lo-ma+1:lo);
   
   % in one block formats the top line with number can mess-up the
   % identification of valid lines, since it will also have the same length
   
   toKeep = cellfun('isempty',regexp(headers,'^\s*[0-9]+'));
   
   if any(~toKeep)
      ftext = ftext(toKeep);
      headers = headers(toKeep);
      numSeqs = sum(toKeep);
      numLines = sum(toKeep);
   end
   
end   

% remove the maximum width of the headers to every line at the beggining
le = max(cellfun('length',headers));
for j = 1:numLines
   ftext{j} = ftext{j}(le+1:end);
end

% remove all common spaces at the beginning
le = min(cellfun('length',regexp(ftext,'\s*','match','once')));
for j = 1:numLines
   ftext{j} = ftext{j}(le+1:end);
end

% some formats have a number here, remove it also
le = max(cellfun('length',regexp(ftext,'\(*\s*[0-9]+\)*','match','once')));
for j = 1:numLines
   ftext{j} = ftext{j}(le+1:end);
end

% concatenate every sequence into a single line
for j = 1:numSeqs
    mAlign{j} = cat(2,ftext{j:numSeqs:numLines});
end

% remove all common spaces in every column and fill with trailing spaces
temp = char(mAlign); 
mAlign = cellstr(temp(:,~all(temp==' ')));

% check that all sequences at least have one symbol (this will catch the
% conservation markup line)
toKeep = ~cellfun('isempty',regexp(mAlign,'[A-Za-z]','once'));
mAlign = mAlign(toKeep);
headers = headers(toKeep);
numSeqs = sum(toKeep);

% in case of one ouput put everything into one structure (in headers)
if nargout ~= 2
    [H(1:numSeqs).Header] = deal(headers{:});
    [H(1:numSeqs).Sequence] = deal(mAlign{:});
    headers = H;
end
    
catch
    error('Bioinfo:IncorrectDataFormat','An error occurred while trying to interpret the data,\ninput string may not be a supported Multiple Alignment format.')
end

if numel(headers) == 0  
    error('Bioinfo:FoundZeroSequences','An error occurred while trying to interpret the data,\ninput string may not be a supported Multiple Alignment format.')
end
