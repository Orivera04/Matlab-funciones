function output=dec2bin2(a)

% This function converts an array in binary format to an array in decimal format.
%     Class of both variables- output and a are "double".

empt=[];
for(i=1:length(a))
    empt=[empt 0];
end
d=[];
j=1;
while(j<=9)
[b c]=div2(a);
d=[d c];
a=b;
if(b==empt)
    ,break
end
end
output=fliplr(d);








