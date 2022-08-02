% |
% |   A TRIANGLE AND SOME SPECIAL LINES
% |   USING THE AFFINE MODEL
% |
    e = e3; %/
    IP = {e+e1+e2,e+e1-e2,e-e1-e2,e-e1+e2}; %/
% | 
% |   The triangle:
% |
    P = e+ e1/4+e2/2; 
    Q = e- e1/2+e2/4; 
    R = e+ e1/3-4*e2/5; 
    clf; 
    DrawHomogeneous(e,P,'n','b'); GAtext(1.1*P,'P'); %/
    DrawHomogeneous(e,Q,'n','b'); GAtext(1.1*Q,'Q'); %/
    DrawHomogeneous(e,R,'n','b'); GAtext(1.1*R,'R'); %/
%% DRAWING A TRIANGLE
    PQ = join(P,Q);
    QR = join(Q,R);
    RP = join(R,P);
    PtoQ = connection(e,P,Q);
    QtoR = connection(e,Q,R);
    RtoP = connection(e,R,P);
    DrawSimplex({P,P+PtoQ},'n','r'); %/
    DrawSimplex({Q,Q+QtoR},'n','r'); %/
    DrawSimplex({R,R+RtoP},'n','r'); %/
    axis([-0.9 0.7 -0.9 0.6]);  %/
    GAview([0 90]); axis off; %/
GAprompt; %/
% | 
% |   Its altitude lines.
% |
    PtoQR = connection(e,P,QR);
    QtoRP = connection(e,Q,RP);
    RtoPQ = connection(e,R,PQ);
    DrawSimplex({P,P+PtoQR},'n','g'); %/
    DrawSimplex({Q,Q+QtoRP},'n','g'); %/
    DrawSimplex({R,R+RtoPQ},'n','g'); %/
    PmeetQalt = meet(P^PtoQR,Q^QtoRP);
    QmeetRalt = meet(Q^QtoRP,R^RtoPQ);
    RmeetPalt = meet(R^RtoPQ,P^PtoQR);
    altitudepoint = GAZ(join(join(PmeetQalt,QmeetRalt),RmeetPalt)); %/
%   A = join( join( PmeetQalt,QmeetRalt), RmeetPalt) );
    altitudepoint = altitudepoint/inner(e,altitudepoint); %/
    DrawHomogeneous(e,altitudepoint,'n','g'); GAtext(1.1*altitudepoint,'A'); %/
    axis([-0.9 0.7 -0.9 0.6]);  %/
GAprompt; %/
% | 
% |   Its midlines.
% |
    PQmid = (P+Q)/2;
    QRmid = (Q+R)/2;
    RPmid = (R+P)/2;
    DrawHomogeneous(e,P,'n','b'); %/
    DrawHomogeneous(e,Q,'n','b'); %/
    DrawHomogeneous(e,R,'n','b'); %/
    PtoQRmid = connection(e,P,QRmid);
    QtoRPmid = connection(e,Q,RPmid);
    RtoPQmid = connection(e,R,PQmid);
    DrawSimplex({P,P+PtoQRmid},'n','m'); %/
    DrawSimplex({Q,Q+QtoRPmid},'n','m'); %/
    DrawSimplex({R,R+RtoPQmid},'n','m'); %/
    PmeetQmid = meet(P^PtoQRmid,Q^QtoRPmid);
    QmeetRmid = meet(Q^QtoRPmid,R^RtoPQmid);
    RmeetPmid = meet(R^RtoPQmid,P^PtoQRmid);
    midpoint = GAZ(join(join(PmeetQmid,QmeetRmid),RmeetPmid)); %/
%   M = join( join( PmeetQmid,QmeetRmid), RmeetPmid) )
    midpoint = midpoint/inner(e,midpoint); %/
    DrawHomogeneous(e,midpoint,'n','m'); GAtext(1.1*midpoint,'M'); %/
    axis([-0.9 0.7 -0.9 0.6]);  %/
GAprompt; %/
% | 
% |   Its perpendicular bisectors.
% |
    DrawSimplex({PQmid,PQmid-RtoPQ},'n','c'); %/
    DrawSimplex({QRmid,QRmid-PtoQR},'n','c'); %/
    DrawSimplex({RPmid,RPmid-QtoRP},'n','c'); %/
    linePQ = PQmid^RtoPQ; 
    lineQR = QRmid^PtoQR;
    lineRP = RPmid^QtoRP;
    PmeetQperp = meet(linePQ,lineQR);
    QmeetRperp = meet(lineQR,lineRP);
    RmeetPperp = meet(lineRP,linePQ);
    perppoint = GAZ(join(join(PmeetQperp,QmeetRperp),RmeetPperp)); %/
%   B = join( join(PmeetQperp,QmeetRperp), RmeetPperp)
    perppoint = perppoint/inner(e,perppoint); %/
    DrawHomogeneous(e,perppoint,'n','c'); GAtext(1.1*perppoint,'B'); %/
    axis([-0.9 0.7 -0.9 0.6]);  %/
GAprompt; %/
% |
% |   These points should be in line, so test their trivector.
% |
%% ALL IN LINE?
    ptom = connection(e,perppoint,midpoint); %/
    ptoa = connection(e,perppoint,altitudepoint); %/
    DrawSimplex({perppoint, perppoint+ptoa},'n','k'); %/
    DrawSimplex({perppoint, perppoint+ptom},'n','k'); %/
    axis([-0.9 0.7 -0.9 0.6]);  %/
    tri = (perppoint ^ midpoint ^ altitudepoint)/I3; %/
title(['(A \wedge M \wedge B)^* = ' num2str(tri)]); %/
