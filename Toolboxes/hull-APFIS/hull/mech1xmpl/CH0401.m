af=[-45 0 12 10; 0 -55 24 0];
unknowns=[DR(45) 0 0; 0 0 20; DR(90) 0 20];
restrain=threevector(af,unknowns);
external=[af;restrain];

point1=twovector(external(2,:) ,[atan2(10,-12) DR(180)]);
fDp1=point1(1,:);
fFp1=point1(2,:);

fEp2=opp(move(fFp1,[0,0]));

point2=twovector([fEp2; external(3,:)],[atan2(10,12) DR(90)]);
fBp2=point2(1,:);
fGp2=point2(2,:);
fGp3=opp(move(fGp2,[0,20]));

fAp3=onevector([external(4:5,:);fGp3]);

fAp4=opp(move(fAp3,[12,10]));
fBp4=opp(move(fBp2,[12,10]));
fDp4=opp(move(fDp1,[12,10]));

internal=[fDp1;fFp1;fBp2;fEp2;fGp2;fGp3;fAp3;fAp4;fBp4;fDp4]
