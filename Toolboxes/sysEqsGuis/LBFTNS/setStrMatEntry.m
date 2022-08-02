function str=setStrMatEntry(r,c,newVal,regMat)
%set the mat and get an updated StrMat 
	regMat(r,c)=newVal;
  	str=getMat2BlStr(regMat);
