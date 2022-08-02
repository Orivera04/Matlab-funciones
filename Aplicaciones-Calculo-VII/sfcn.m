function varargout=sfcn(varargin)
% SFCN calculates the binary switching function for the outputs of a given system as functions of their inputs.
%           !!XOR opperation is not supported 
%
% Written by Gus Lott (c)2002.  YarCom Inc.  guslott@yarcom.com 
% 
% usage: b=switchfcn(A,n)
%        b=switchfcn(A,n,'raw')  %supress simplification
%
% A is a matrix corresponding to the right side (output) of your binary system truth table.  The rows correspond to
% each possible binary input to your system.  Column 1 of A is the MSB while column "end" of A is the LSB.
% n is the number of inputs to your system.
%
%                   in          out
%       example:   0 0          1 1 1
%                  0 1          1 0 1
%                  1 0          1 0 0
%                  1 1          1 1 1
% If you put in the out matrix as the "A" input, this function would return 3 strings of functions in a
% cell array corresponding to the inputs.  Apply the function to the inputs and you will get the corresponding
% output columns.
%
% A must have 2^n rows
%
% Output is a Cell vector containing the MSB->LSB switching functions as strings.  Format is a->z for MSB->LSB of input.
%
% Try eval(b) to evaluate the switching function after you've assigned your input values to the correct variable names.
%
% This function invokes the Maple logic package and the bsimp function.  The symbolic math toolbox is required.
% If the symbolic math toolbox is not present, then insert 'raw' as a third argument to the function and a generic
% sum of products equation will output.
%
% An example:       a+b=c  (2 inputs, 1 output)
%    in:   A=[0;1;1;1];        n=2;
%               b=sfcn(A,n)
%    out:  b{1}=' a|b ';
%
% Another example:
%    in:   A=[0,0; 0,1; 0,1; 1,1];     n=2;
%               b=sfcn(A,n);
%    out:  b{1}='a&b'   b{2}='a|b'


switch nargin
    case 2
        A=varargin{1};
        n=varargin{2};
        simp=1;
        temp=size(A);
        widthA=temp(2);
    case 3
        A=varargin{1};
        n=varargin{2};
        temp=size(A);
        widthA=temp(2);
        if strcmp(varargin{3},'raw')
            simp=0;
        else error('Wrong Input, for usage: >>help switchfcn')
        end
    otherwise
        error('Wrong Input, for usage: >>help switchfcn')
end

% init left side of tt
for i=1:2^n
    left(i,:)=dec2binvec(i-1,n);
end

% find locations of 1s in output to build sum of products form from corresponding inputs
for i=1:widthA
f{i}=left(find(A(:,i)==1),:);
end


% BUILD SUM OF PRODUCTS BOOLEAN FUNCTIONS
for j=1:widthA
siz=size(f{j});
ftemp=f{j};


if isempty(f{j})
    codestr='0';
else
    codestr='(1';
end 

for i=1:siz(1)
    for ii=1:n
        if ftemp(i,ii)
            codestr=[codestr,['&',char(96+ii)]];
        else
            codestr=[codestr,['&~',char(96+ii)]];
        end 
    end
    
    if i~=siz(1)
        codestr=[codestr,')|(1'];
    else
        codestr=[codestr,')'];
    end
end 

allcode{j}=codestr;
end

% Now allcode contains all the codes for the outputs as functions of the n inputs

if simp
    allcode=callbsimp(allcode,n,widthA);
else
    varargout{1}=allcode;
    return
end

varargout{1}=allcode;

%-----------------------------------------------------------------------------------------------------------------
% CALLBSIMP converts Matlab logical operators into Maple syntax, simplifies with maple bsimp function and converts
% maple boolean function output back to Matlab logical operators like ~,|,&.
%
function varargout=callbsimp(varargin)

allcode=varargin{1};
n=varargin{2};
widthA=varargin{3};

maple('with(logic)');



% this loop converts the matlab logic code into maple boolean algebra code
for i=1:widthA
    codestr=allcode{i};
    endcode=' ';
for p=1:length(codestr)%
    newcode{p}=codestr(p);
    switch codestr(p)
    case '&'
        newcode{p}=' &and ';
    case '|'
        newcode{p}=' &or ';
    case '~'
        newcode{p}=' &not ';
    end %switch
    endcode=[endcode,newcode{p}];
end %for

% convert the simplified maple expression into matlab boolean algebra evaluate-able string
%allcode{j}=codestr;
if length(endcode)>2
simpcode{i}=mapba2matba([' ',maple('bsimp',endcode),' ']);
end
if strcmp(codestr,'0')
    simpcode{i}='0';
end
end %for
varargout{1}=simpcode;


%************************************************************************************************************
% MAPBA2MATBA is designed to take a string input containing a maple boolean algebra statement and convert it
% into a simple mathematical logical expression usable by matlab.  Only recognizes AND, OR, and NOT statements.
% This should greatly reduce the necessary compute time for your generalized sum of products switching function.
%
% example: b=mapba2matba('`&and`(b,f,d,`&not`(e))')
%          b='(b&f&d&~e)';
%
function varargout=mapba2matba(varargin)

s=varargin{1};

% start looking for NOTs.  NOT looks like `&not`(a), replace the entire thing with ~a.

notind=strfind(s,'`&not`');

for i=1:length(notind)
    s=[s(1:(notind(i)-1-7*(i-1))),'~',s(notind(i)+7-7*(i-1)),s((notind(i)+9-7*(i-1)):end)];
end
% next find AND.. `&and`( then find the next ).  replace all commas between these two things with &. remove `&and`

andind=strfind(s,'`&and`');
pind=strfind(s,')');

for i=1:length(andind)                  %replace commas in and statements with &
    closep=find(pind>andind(i));
    closep=pind(closep(1));
    cind=find(s==',');
    temps=s(andind(i):closep);
    temps(find(temps==','))='&';
    s(andind(i):closep)=temps;
end

for i=1:length(andind)                  %get rid of the `&and` strings in the code
    s=[s(1:(andind(i)-1-6*(i-1))),s((andind(i)+6-6*(i-1)):end)];
end

% finally, OR.  Replace any remaining commas with |. remove `&or`
s(strfind(s,','))='|';
orind=strfind(s,'`&or`');
for i=1:length(orind)
    s=[s(1:(orind(i)-1-6*(i-1))),s((orind(i)+5-6*(i-1)):end)];
end

varargout{1}=s;


function out = dec2binvec(dec,n)
%DEC2BINVEC Convert decimal number to a binary vector.
% modified from MATLAB DAQ TOOLBOX.  MSB is in first position now.

% Convert the decimal number to a binary string.
switch nargin
case 1
   out = dec2bin(dec);
case 2
   out = dec2bin(dec,n);
end

% Convert the binary string, '1011', to a binvec, [1 1 0 1].
pre = logical(str2num([fliplr(out);blanks(length(out))]')');
out = pre(end:-1:1);