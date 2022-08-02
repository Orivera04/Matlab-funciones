% test cellstr

tmp=get(gca);
c=char(fieldnames(get(gca)));
cc=repmat(c,10,1);

cs=cellstr(cc);

csm=mmcellstr(cc);