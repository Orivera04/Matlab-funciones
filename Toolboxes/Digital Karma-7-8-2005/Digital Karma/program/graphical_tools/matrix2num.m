function newvalue=matrix2num(matrix,newbase,safety)
% matrix2num([1,0,0]) yields 100, assumes base 10.
% matrix2num([1,0,0],2) yields 4 using base 2.
%   bases 2-10 only, otherwise outputs NaN.
% matrix2num([1,0,0],2,'on')
% Activates rounding safety.
%   Because of the floating point rounding error
%   numbers w/more than 16 digits will output as
%   NaN with this feature on. Default is off.
%
% Each number is a place so matrix2num([20,1,30]) means
%   30 ones, 1 ten & 20 hundreds yielding 2040.
% There is also purposely no requirement that all
% values be inside th base range, so
% matrix2num([4,0],2) yields 8 since the 2nd place in
% base 2 is that digit times 2.

[rows,columns,planes]=size(matrix);
% Transposes all the layers
for currentplane=1:planes;
    transposematrix=matrix(:,:,currentplane);
    matrix2(:,:,currentplane)=transposematrix';
end;

newvalue=matrix2(end); %sets the ones place of the number from last digit
if nargin==1; newbase=10; end; % Sets base if not entered

% Calculates number
for currentvalue=1:length(matrix2(:))-1; %Calculates as a number
    newvalue = ((matrix2(end-currentvalue)) * newbase^currentvalue) + newvalue;
end;

if nargin==3 & isnan(newvalue)==0;
    %here is the basic num2matrix code
    array=0; newvalue2=int2str(newvalue); numberlength=length(newvalue2);
    for character=1:numberlength;
        array(character)=str2num(newvalue2(character));
    end;
    if length(array)>16; newvalue=NaN; end;
end;


if newbase>10; newvalue=NaN; end; % Outputs NaN if over base 10