function approxPts=approxRK4(strFtn,h,ICXY,numGeneration)

t=(0:h:numGeneration)';
totPts=length(t);
[f xExpr]=strTok(strFtn(1,:),'=');
xExpr=xExpr(1,2:end);
[f yExpr]=strTok(strFtn(2,:),'=');
yExpr=yExpr(1,2:end);
strExpression=strvcat(xExpr,yExpr);
currXYVal=ICXY;
approxPts(1,:)=currXYVal;
for(ithPt=1:totPts)
    currXYVal=myXYRK4(strExpression,h,t(ithPt),currXYVal);
    approxPts(ithPt+1,:)=currXYVal;
end