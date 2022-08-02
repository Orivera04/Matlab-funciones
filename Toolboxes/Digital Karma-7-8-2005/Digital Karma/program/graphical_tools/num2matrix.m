function array=num2matrix(number,columns)
% num2matrix('number') or
% num2matrix('number',columns)
% Enter number of columns if you wish to limit.
% The characters will wrap to the next row.
% The number is inputed as a string so you can
% convert digits like 0010.
array=0;
numberlength=length(number);
if nargin==1;
    for character=1:numberlength;
        array(character)=str2num(number(character));
    end;
elseif nargin==2;
    rows=ceil(numberlength/columns);
    for currentrow=1:rows
        if currentrow>1; number(1:columns)=[]; end;
        if length(number)>=columns; currentcolumn=columns; else currentcolumn=length(number); end;
        for character=1:currentcolumn;
            array(currentrow,character)=str2num(number(character));
        end;
    end;
end;
