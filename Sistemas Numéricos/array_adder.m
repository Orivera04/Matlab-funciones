function output=array_adder(array1,array2)

% This function adds 2 arrays, after making them of equal lengths by appending with reqd number of zeros.
%     Class of all variables- array1, array2 and output are "double".

a=array1;
b=array2;

if(length(a)>length(b))
    for(i=1:length(a)-length(b))
        b=[0 b];
    end
end
if(length(b)>length(a))
    for(i=1:length(b)-length(a))
        a=[0 a];
    end
end

c=a+b;

c=fliplr(c);
c=[c 0];
for(i=2:length(c))
c(i)=c(i)+floor(c(i-1)/10);
end
for(i=1:length(c))
    if(c(i)>9)
        c(i)=c(i)-10;
    end
end
output=fliplr(c);


