data ={'H2O',0,100,'eau'};
labels ={'corps','pc','pe','nom'};
s=cell2struct(data,labels,2)
s=setfield(s, 'pe',getfield(s,'pe')+1)
s=rmfield(s,'pe')
