partD(1,:)=[tbeam(5,8,3,1,'w','comp'),0,0,1];
partD(2,:)=[quartercircle(2,'sw','comp'),5,5,-1];
partD(3,:)=[quartercircle(2,'nw','comp'),5,0,-1];
centXD=comp(partD,'centX')
IyD=comp(partD,'Iy')
