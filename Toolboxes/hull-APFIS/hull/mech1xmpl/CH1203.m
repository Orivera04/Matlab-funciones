DataSet = 1;
ThicknessData=[0.5:0.25:2]; %A matrix from 0.5 to 2 incremented by 0.25
Thickness=ThicknessData(DataSet)% chooses an element from ThicknessData
Area=ibeam(10,16,Thickness,Thickness,'I','area')
Ix=ibeam(10,16,Thickness,Thickness,'I','Ix')
Iy=ibeam(10,16,Thickness,Thickness,'I','Iy')
