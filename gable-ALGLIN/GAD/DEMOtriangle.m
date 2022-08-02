     disp('>> % |');
     % |
     disp('>> % |   A TRIANGLE AND SOME SPECIAL LINES');
     % |   A TRIANGLE AND SOME SPECIAL LINES
     disp('>> % |   USING THE AFFINE MODEL');
     % |   USING THE AFFINE MODEL
     disp('>> % |');
     % |
         e = e3; %/
         IP = {e+e1+e2,e+e1-e2,e-e1-e2,e-e1+e2}; %/
     disp('>> % | ');
     % | 
     disp('>> % |   The triangle:');
     % |   The triangle:
     disp('>> % |');
     % |
     disp('>>     P = e+ e1/4+e2/2; ');
         P = e+ e1/4+e2/2; 
     disp('>>     Q = e- e1/2+e2/4; ');
         Q = e- e1/2+e2/4; 
     disp('>>     R = e+ e1/3-4*e2/5; ');
         R = e+ e1/3-4*e2/5; 
     disp('>>     clf; ');
         clf; 
         DrawHomogeneous(e,P,'n','b'); GAtext(1.1*P,'P'); %/
         DrawHomogeneous(e,Q,'n','b'); GAtext(1.1*Q,'Q'); %/
         DrawHomogeneous(e,R,'n','b'); GAtext(1.1*R,'R'); %/
     disp('>>     PQ = join(P,Q);');
         PQ = join(P,Q);
     disp('>>     QR = join(Q,R);');
         QR = join(Q,R);
     disp('>>     RP = join(R,P);');
         RP = join(R,P);
     disp('>>     PtoQ = connection(e,P,Q);');
         PtoQ = connection(e,P,Q);
     disp('>>     QtoR = connection(e,Q,R);');
         QtoR = connection(e,Q,R);
     disp('>>     RtoP = connection(e,R,P);');
         RtoP = connection(e,R,P);
         DrawSimplex({P,P+PtoQ},'n','r'); %/
         DrawSimplex({Q,Q+QtoR},'n','r'); %/
         DrawSimplex({R,R+RtoP},'n','r'); %/
         axis([-0.9 0.7 -0.9 0.6]);  %/
         GAview([0 90]); axis off; %/
     GAprompt; %/
     disp('>> % | ');
     % | 
     disp('>> % |   Its altitude lines.');
     % |   Its altitude lines.
     disp('>> % |');
     % |
     disp('>>     PtoQR = connection(e,P,QR);');
         PtoQR = connection(e,P,QR);
     disp('>>     QtoRP = connection(e,Q,RP);');
         QtoRP = connection(e,Q,RP);
     disp('>>     RtoPQ = connection(e,R,PQ);');
         RtoPQ = connection(e,R,PQ);
         DrawSimplex({P,P+PtoQR},'n','g'); %/
         DrawSimplex({Q,Q+QtoRP},'n','g'); %/
         DrawSimplex({R,R+RtoPQ},'n','g'); %/
     disp('>>     PmeetQalt = meet(P^PtoQR,Q^QtoRP);');
         PmeetQalt = meet(P^PtoQR,Q^QtoRP);
     disp('>>     QmeetRalt = meet(Q^QtoRP,R^RtoPQ);');
         QmeetRalt = meet(Q^QtoRP,R^RtoPQ);
     disp('>>     RmeetPalt = meet(R^RtoPQ,P^PtoQR);');
         RmeetPalt = meet(R^RtoPQ,P^PtoQR);
         altitudepoint = GAZ(join(join(PmeetQalt,QmeetRalt),RmeetPalt)); %/
     disp('>> %   A = join( join( PmeetQalt,QmeetRalt), RmeetPalt) );');
     %   A = join( join( PmeetQalt,QmeetRalt), RmeetPalt) );
         altitudepoint = altitudepoint/inner(e,altitudepoint); %/
         DrawHomogeneous(e,altitudepoint,'n','g'); GAtext(1.1*altitudepoint,'A'); %/
         axis([-0.9 0.7 -0.9 0.6]);  %/
     GAprompt; %/
     disp('>> % | ');
     % | 
     disp('>> % |   Its midlines.');
     % |   Its midlines.
     disp('>> % |');
     % |
     disp('>>     PQmid = (P+Q)/2;');
         PQmid = (P+Q)/2;
     disp('>>     QRmid = (Q+R)/2;');
         QRmid = (Q+R)/2;
     disp('>>     RPmid = (R+P)/2;');
         RPmid = (R+P)/2;
         DrawHomogeneous(e,P,'n','b'); %/
         DrawHomogeneous(e,Q,'n','b'); %/
         DrawHomogeneous(e,R,'n','b'); %/
     disp('>>     PtoQRmid = connection(e,P,QRmid);');
         PtoQRmid = connection(e,P,QRmid);
     disp('>>     QtoRPmid = connection(e,Q,RPmid);');
         QtoRPmid = connection(e,Q,RPmid);
     disp('>>     RtoPQmid = connection(e,R,PQmid);');
         RtoPQmid = connection(e,R,PQmid);
         DrawSimplex({P,P+PtoQRmid},'n','m'); %/
         DrawSimplex({Q,Q+QtoRPmid},'n','m'); %/
         DrawSimplex({R,R+RtoPQmid},'n','m'); %/
     disp('>>     PmeetQmid = meet(P^PtoQRmid,Q^QtoRPmid);');
         PmeetQmid = meet(P^PtoQRmid,Q^QtoRPmid);
     disp('>>     QmeetRmid = meet(Q^QtoRPmid,R^RtoPQmid);');
         QmeetRmid = meet(Q^QtoRPmid,R^RtoPQmid);
     disp('>>     RmeetPmid = meet(R^RtoPQmid,P^PtoQRmid);');
         RmeetPmid = meet(R^RtoPQmid,P^PtoQRmid);
         midpoint = GAZ(join(join(PmeetQmid,QmeetRmid),RmeetPmid)); %/
     disp('>> %   M = join( join( PmeetQmid,QmeetRmid), RmeetPmid) )');
     %   M = join( join( PmeetQmid,QmeetRmid), RmeetPmid) )
         midpoint = midpoint/inner(e,midpoint); %/
         DrawHomogeneous(e,midpoint,'n','m'); GAtext(1.1*midpoint,'M'); %/
         axis([-0.9 0.7 -0.9 0.6]);  %/
     GAprompt; %/
     disp('>> % | ');
     % | 
     disp('>> % |   Its perpendicular bisectors.');
     % |   Its perpendicular bisectors.
     disp('>> % |');
     % |
         DrawSimplex({PQmid,PQmid-RtoPQ},'n','c'); %/
         DrawSimplex({QRmid,QRmid-PtoQR},'n','c'); %/
         DrawSimplex({RPmid,RPmid-QtoRP},'n','c'); %/
     disp('>>     linePQ = PQmid^RtoPQ; ');
         linePQ = PQmid^RtoPQ; 
     disp('>>     lineQR = QRmid^PtoQR;');
         lineQR = QRmid^PtoQR;
     disp('>>     lineRP = RPmid^QtoRP;');
         lineRP = RPmid^QtoRP;
     disp('>>     PmeetQperp = meet(linePQ,lineQR);');
         PmeetQperp = meet(linePQ,lineQR);
     disp('>>     QmeetRperp = meet(lineQR,lineRP);');
         QmeetRperp = meet(lineQR,lineRP);
     disp('>>     RmeetPperp = meet(lineRP,linePQ);');
         RmeetPperp = meet(lineRP,linePQ);
         perppoint = GAZ(join(join(PmeetQperp,QmeetRperp),RmeetPperp)); %/
     disp('>> %   B = join( join(PmeetQperp,QmeetRperp), RmeetPperp)');
     %   B = join( join(PmeetQperp,QmeetRperp), RmeetPperp)
         perppoint = perppoint/inner(e,perppoint); %/
         DrawHomogeneous(e,perppoint,'n','c'); GAtext(1.1*perppoint,'B'); %/
         axis([-0.9 0.7 -0.9 0.6]);  %/
     GAprompt; %/
     disp('>> % |');
     % |
     disp('>> % |   These points should be in line, so test their trivector.');
     % |   These points should be in line, so test their trivector.
     disp('>> % |');
     % |
         ptom = connection(e,perppoint,midpoint); %/
         ptoa = connection(e,perppoint,altitudepoint); %/
         DrawSimplex({perppoint, perppoint+ptoa},'n','k'); %/
         DrawSimplex({perppoint, perppoint+ptom},'n','k'); %/
         axis([-0.9 0.7 -0.9 0.6]);  %/
         tri = (perppoint ^ midpoint ^ altitudepoint)/I3; %/
     title(['(A \wedge M \wedge B)^* = ' num2str(tri)]); %/
