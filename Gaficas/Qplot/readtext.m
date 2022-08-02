function a= readtext(filein)
global leg

fdata= fopen(filein,'rt');
a=[];
count= 0;

while 1
	s = fgetl(fdata);
	if ~ischar(s), break, end
	if count == 0
		legend= s;
		count= 1;
	else
		a= [a,sscanf(s,'%f')];
	end
end
fclose(fdata);

spc= [0,find(legend==',')];
for j= 1:length(spc)-1 leg(j).tex= char(legend(spc(j)+1:spc(j+1)-1)); end
leg(length(spc)).tex= char(legend(spc(j+1)+1:length(legend)));

a= flipud(rot90(a));
return
