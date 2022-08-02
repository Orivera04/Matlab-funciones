function output=bin_2_dec(input)

% This function converts an binary number into corresponding decimal number.
%  Class of both variables-output and input are "char".

a=str2num(input);
a=fliplr(a);
b(1)=a(1);
for(i=2:length(a))
gopi=str2num(powr2(i-1))*a(i);
gopi2=array_adder(b,gopi);
b=gopi2;
end
for(i=1:length(gopi2))
    if(gopi2(i)~=0)
        got=i;
        ,break
    end
end
for(i=1:length(gopi2)-got+1)
    gopi3(i)=gopi2(i+got-1);
end

for(i=1:length(gopi3))
output(i)=int2str(gopi3(i));
end