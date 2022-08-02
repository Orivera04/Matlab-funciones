function GAblock(GAn)
%GAblock: run sample code in tutorial.

try
if ( GAn == 1 ) 
  GAps = 'GAblock >> ';
     disp('>>      % ORTHOGONALIZATION');
     % ORTHOGONALIZATION
     disp('>>      clf;');
     clf;
     disp('>>      u = e1+e2;');
     u = e1+e2;
     disp('>>      v = 0.3*e1 + 0.6*e2 - 0.8*e3;');
     v = 0.3*e1 + 0.6*e2 - 0.8*e3;
     disp('>>      w = e1 -0.2*e2 + 0.5*e3;');
     w = e1 -0.2*e2 + 0.5*e3;
     disp('>>      up = u;');
     up = u;
     disp('>>      vp = (v^up)/up;');
     vp = (v^up)/up;
     disp('>>      wp = (w^up^vp)/(up^vp);');
     wp = (w^up^vp)/(up^vp);
     disp('>>      draw(u); draw(v); draw(w);                 %% The original vectors ...');
     draw(u); draw(v); draw(w);                 %% The original vectors ...
  GAprompt;
     disp('>>      draw(up,''r''); draw(vp,''r''); draw(wp,''r'');  %% ... and orthognalized');
     draw(up,'r'); draw(vp,'r'); draw(wp,'r');  %% ... and orthognalized
  GAprompt;
     disp('>>      GAorbiter');
     GAorbiter
  disp(' ');    disp('End of GAblock sequence.  Returning to Matlab.');
elseif ( GAn == 2 ) 
  GAps = 'GAblock >> ';
     disp('>>      % ROTATION EXERCISE');
     % ROTATION EXERCISE
     disp('>>      clf;');
     clf;
     disp('>>      R1 = gexp(-I3*e1*pi/2/2);');
     R1 = gexp(-I3*e1*pi/2/2);
     disp('>>      R2 = gexp(-I3*e2*pi/2/2);');
     R2 = gexp(-I3*e2*pi/2/2);
     disp('>>      R =  R2*R1;');
     R =  R2*R1;
     disp('>>      a = e1+e2;');
     a = e1+e2;
     disp('>>      Ra = R*a/R;');
     Ra = R*a/R;
     disp('>>      RRa = R*Ra/R;');
     RRa = R*Ra/R;
     disp('>>      draw(a); draw(Ra,''m''); draw(RRa,''r''); %% Draw the objects');
     draw(a); draw(Ra,'m'); draw(RRa,'r'); %% Draw the objects
  GAprompt;
     disp('>>      axisR = unit( -GAZ(sLog(R))/I3 );');
     axisR = unit( -GAZ(sLog(R))/I3 );
     disp('>>      draw(axisR,''g''); % Draw the axis of rotation');
     draw(axisR,'g'); % Draw the axis of rotation
  GAps = 'Refer to the tutorial before continuing >> ';
  disp(' ');  GAprompt;
  GAps = 'GAblock >> ';
     disp('>>      draw(dual(axisR),''g'');');
     draw(dual(axisR),'g');
  disp(' ');    disp('End of GAblock sequence.  Returning to Matlab.');
elseif ( GAn == 3 ) 
  GAps = 'GAblock >> ';
     disp('>>      % INTERPOLATION OF ORIENTATIONS');
     % INTERPOLATION OF ORIENTATIONS
     disp('>>      clf;');
     clf;
     disp('>>      RA = gexp(-I3*e1*pi/2/2);');
     RA = gexp(-I3*e1*pi/2/2);
     disp('>>      RB = gexp(-I3*e2*pi/2/2);');
     RB = gexp(-I3*e2*pi/2/2);
     disp('>>      Rtot =  RB/RA');
     Rtot =  RB/RA
     disp('>>      n = 8;                          % we rotate in 8 steps');
     n = 8;                          % we rotate in 8 steps
     disp('>>      R = gexp(sLog(Rtot)/n);');
     R = gexp(sLog(Rtot)/n);
  GAps = 'Refer to the tutorial before continuing >> ';
  disp(' ');  GAprompt;
  GAps = 'GAblock >> ';
     disp('>>      u = e1+e2-e3;');
     u = e1+e2-e3;
     disp('>>      v = e1+e3;');
     v = e1+e3;
     disp('>>      view = [-0.6  2.5  -1    1.16  -2  1.1];  % select the view');
     view = [-0.6  2.5  -1    1.16  -2  1.1];  % select the view
     disp('>>            % === initial orientation:');
           % === initial orientation:
     disp('>>      DrawBivector(RA*u/RA,RA*v/RA,''b'');  axis(view); GAview([30 30]); %%');
     DrawBivector(RA*u/RA,RA*v/RA,'b');  axis(view); GAview([30 30]); %%
  GAprompt;
     disp('>>            % === final orientation:');
           % === final orientation:
     disp('>>      DrawBivector(RB*u/RB,RB*v/RB,''g'');  axis(view);                  %%');
     DrawBivector(RB*u/RB,RB*v/RB,'g');  axis(view);                  %%
  GAprompt;
     disp('>>      axisR = unit(GAZ(-sLog(R)/I3));   % reorientation axis: ');
     axisR = unit(GAZ(-sLog(R)/I3));   % reorientation axis: 
     disp('>>      draw(axisR,''r'');                 %% displayed for visualization ');
     draw(axisR,'r');                 %% displayed for visualization 
  GAprompt;
     disp('>>            % === display of the 7 intermediate orientations ');
           % === display of the 7 intermediate orientations 
     disp('>>      Ri = RA;');
     Ri = RA;
     for i=1:n-1
     disp('>>      for i=1:n-1');
     disp(['i = ', num2str(i)])
     disp('>>          Ri = R*Ri;');
         Ri = R*Ri;
     disp('>>          ui = Ri*u/Ri;');
         ui = Ri*u/Ri;
     disp('>>          vi = Ri*v/Ri;');
         vi = Ri*v/Ri;
     disp('>>          DrawBivector(ui,vi);');
         DrawBivector(ui,vi);
     disp('>>          drawnow;');
         drawnow;
     disp('>>      end');
     end
     disp('>>      GAorbiter(125);');
     GAorbiter(125);
  disp(' ');    disp('End of GAblock sequence.  Returning to Matlab.');
elseif ( GAn == 4 ) 
  GAps = 'GAblock >> ';
     disp('>>      % LINE INTERSECTS LINE');
     % LINE INTERSECTS LINE
     disp('>>      p = e2; u = 0.2*e2 + e1;');
     p = e2; u = 0.2*e2 + e1;
     disp('>>      q = e1; v = e2-2*e1;');
     q = e1; v = e2-2*e1;
     disp('>>      clf; ');
     clf; 
     disp('>>      draw(p); GAview([0 90]);');
     draw(p); GAview([0 90]);
     disp('>>      DrawPolyline({p-2*u,p+2*u});');
     DrawPolyline({p-2*u,p+2*u});
     disp('>>      draw(q,''g''); DrawPolyline({q-v,q+2*v},''g'');');
     draw(q,'g'); DrawPolyline({q-v,q+2*v},'g');
  GAps = 'Refer to the tutorial before continuing >> ';
  disp(' ');  GAprompt;
  GAps = 'GAblock >> ';
     disp('>>      U = (q^v/(u^v)) * u');
     U = (q^v/(u^v)) * u
     disp('>>      V = (p^u/(v^u)) * v');
     V = (p^u/(v^u)) * v
     disp('>>      draw(U,''m'')          %% Draw U');
     draw(U,'m')          %% Draw U
  GAprompt;
     disp('>>      draw(V, ''m'')         %% Draw V');
     draw(V, 'm')         %% Draw V
  GAprompt;
     disp('>>      draw(U+V, ''r'' )      % Draw U+V');
     draw(U+V, 'r' )      % Draw U+V
  disp(' ');    disp('End of GAblock sequence.  Returning to Matlab.');
elseif ( GAn == 5 ) 
  GAps = 'GAblock >> ';
     disp('>>      % PROJECTION, REJECTION');
     % PROJECTION, REJECTION
     disp('>>      x = e1 + e2/2+e3;');
     x = e1 + e2/2+e3;
     disp('>>      A = e2 + e3/3;   % a linear subspace');
     A = e2 + e3/3;   % a linear subspace
     disp('>>      xA = geoall(x,A);');
     xA = geoall(x,A);
     disp('>>      clf; draw(x,''b''); draw(A,''g'');       %% Draw A and x');
     clf; draw(x,'b'); draw(A,'g');       %% Draw A and x
  GAprompt;
     disp('>>      DrawPolyline({xA.rej,xA.rej+xA.proj,xA.proj},''k'');');
     DrawPolyline({xA.rej,xA.rej+xA.proj,xA.proj},'k');
     disp('>>      draw(xA.rej,''m''); draw(xA.proj,''m''); %% Draw rej and proj');
     draw(xA.rej,'m'); draw(xA.proj,'m'); %% Draw rej and proj
  GAprompt;
     disp('>>      distxA = norm(xA.rej)');
     distxA = norm(xA.rej)
     disp('>>      tanglexA = xA.rej/xA.proj');
     tanglexA = xA.rej/xA.proj
     disp('>>      anglexA = atan(norm(tanglexA))*180/pi %%');
     anglexA = atan(norm(tanglexA))*180/pi %%
  GAprompt;
     disp('>>      B = e1^A;             % A planar subspace (containing A)');
     B = e1^A;             % A planar subspace (containing A)
     disp('>>      xB = geoall(x,B);		    ');
     xB = geoall(x,B);		    
     disp('>>      draw(B,''y'');          %%');
     draw(B,'y');          %%
  GAprompt;
     disp('>>      DrawPolyline({xB.rej,xB.rej+xB.proj,xB.proj},''k'');');
     DrawPolyline({xB.rej,xB.rej+xB.proj,xB.proj},'k');
     disp('>>      draw(xB.rej,''r''); draw(xB.proj,''r''); %% rej and proj for B');
     draw(xB.rej,'r'); draw(xB.proj,'r'); %% rej and proj for B
  GAprompt;
     disp('>>      distxB = norm(xB.rej)');
     distxB = norm(xB.rej)
     disp('>>      tanglexB = xB.rej/xB.proj');
     tanglexB = xB.rej/xB.proj
     disp('>>      anglexB = atan(norm(tanglexB))*180/pi');
     anglexB = atan(norm(tanglexB))*180/pi
     disp('>>      side = sign((x^B)/I3)');
     side = sign((x^B)/I3)
  disp(' ');    disp('End of GAblock sequence.  Returning to Matlab.');
elseif ( GAn == 6 ) 
  GAps = 'GAblock >> ';
     disp('>>      % MEET, JOIN ');
     % MEET, JOIN 
     disp('>>      A = e2^(e1+e3);');
     A = e2^(e1+e3);
     disp('>>      B = e1^(e2+e3/2);');
     B = e1^(e2+e3/2);
     disp('>>      cAB = inner(A,B);  pAB = cAB/B; rAB = A - pAB;');
     cAB = inner(A,B);  pAB = cAB/B; rAB = A - pAB;
     disp('>>      clf; draw(A,''b''); draw(B,''g''); %%');
     clf; draw(A,'b'); draw(B,'g'); %%
  GAprompt;
     disp('>>      draw(cAB,''r''); draw(pAB,''c''); draw(rAB,''m'');');
     draw(cAB,'r'); draw(pAB,'c'); draw(rAB,'m');
  GAps = 'Refer to the tutorial before continuing >> ';
  disp(' ');  GAprompt;
  GAps = 'GAblock >> ';
     disp('>>      mAB = meet(A,B)');
     mAB = meet(A,B)
     disp('>>      clf; draw(A,''b''); draw(B,''g''); draw(mAB,''y'');');
     clf; draw(A,'b'); draw(B,'g'); draw(mAB,'y');
  GAps = 'Refer to the tutorial before continuing >> ';
  disp(' ');  GAprompt;
  GAps = 'GAblock >> ';
     disp('>>       jAB = join(A,B)');
      jAB = join(A,B)
     disp('>>       draw(jAB,''k'');');
      draw(jAB,'k');
  disp(' ');    disp('End of GAblock sequence.  Returning to Matlab.');
elseif ( GAn == 7 ) 
  GAps = 'GAblock >> ';
     disp('>>      % MEET AND JOIN DECOMPOSED');
     % MEET AND JOIN DECOMPOSED
     disp('>>      A = e2^(e1+e3);');
     A = e2^(e1+e3);
     disp('>>      B = e1^(e2+e3/2);');
     B = e1^(e2+e3/2);
     disp('>>      aAB = geoall(A,B);');
     aAB = geoall(A,B);
     disp('>>      M = aAB.meet;');
     M = aAB.meet;
     disp('>>      clf;');
     clf;
     disp('>>      DrawBivector(A/M,M,''b'');          % draw A, decomposed');
     DrawBivector(A/M,M,'b');          % draw A, decomposed
     disp('>>      DrawBivector(M,1/M*B,''g'');        %% draw B, decomposed');
     DrawBivector(M,1/M*B,'g');        %% draw B, decomposed
  GAprompt;
     disp('>>      DrawBivector(aAB.proj/M,M,''c'');   % draw proj, decomposed');
     DrawBivector(aAB.proj/M,M,'c');   % draw proj, decomposed
     disp('>>      DrawBivector(aAB.rej/M,M,''m'');    %% draw rej, decomposed');
     DrawBivector(aAB.rej/M,M,'m');    %% draw rej, decomposed
  GAprompt;
     disp('>>      draw(aAB.comp,''r'');');
     draw(aAB.comp,'r');
     disp('>>      draw(aAB.meet,''k'');');
     draw(aAB.meet,'k');
     disp('>>      draw(aAB.join,''y'');');
     draw(aAB.join,'y');
  disp(' ');    disp('End of GAblock sequence.  Returning to Matlab.');
elseif ( GAn == 8 ) 
  GAps = 'GAblock >> ';
     disp('>>      % PINHOLE IMAGING');
     % PINHOLE IMAGING
     disp('>>      clf;');
     clf;
     disp('>>      e = e1;');
     e = e1;
     disp('>>      %==== indicate focal point and image plane:');
     %==== indicate focal point and image plane:
     disp('>>      draw(e,''k'');');
     draw(e,'k');
     disp('>>      IP = {e1+e3+e2,e1+e3-e2,e1-e3-e2,e1-e3+e2,e1+e3+e2}; % image plane rectangle');
     IP = {e1+e3+e2,e1+e3-e2,e1-e3-e2,e1-e3+e2,e1+e3+e2}; % image plane rectangle
     disp('>>      DrawPolygon(IP,''y'')         %% The image plane');
     DrawPolygon(IP,'y')         %% The image plane
  GAprompt;
     disp('>>      %==== vector x and its projection');
     %==== vector x and its projection
     disp('>>      x = 3*e1 - 1.5*e2 + 2*e3;');
     x = 3*e1 - 1.5*e2 + 2*e3;
     disp('>>      px = x/inner(x,e);');
     px = x/inner(x,e);
     disp('>>      draw(x,''b'');                %% Draw x');
     draw(x,'b');                %% Draw x
  GAprompt;
     disp('>>      DrawSimplex({px},''r'',''r'');');
     DrawSimplex({px},'r','r');
  GAps = 'Refer to the tutorial before continuing >> ';
  disp(' ');  GAprompt;
  GAps = 'GAblock >> ';
     disp('>>      y = 1.8*e1 + 1.5*e2 + e3;');
     y = 1.8*e1 + 1.5*e2 + e3;
     disp('>>      u = y-x;');
     u = y-x;
     disp('>>      U = x^y;');
     U = x^y;
     disp('>>      d = U/u;');
     d = U/u;
     disp('>>      clf; draw(e1,''k''); DrawPolygon(IP,''w''); % Redraw e and the image plane');
     clf; draw(e1,'k'); DrawPolygon(IP,'w'); % Redraw e and the image plane
     disp('>>      DrawPolygon({GA(0),x,y},''y'');           % Draw Polygon');
     DrawPolygon({GA(0),x,y},'y');           % Draw Polygon
     disp('>>      draw(d,''g''); draw(x); draw(y);          %% Draw x and y and support');
     draw(d,'g'); draw(x); draw(y);          %% Draw x and y and support
  GAprompt;
     disp('>>      DrawSimplex({x,y},''n'',''g'');             %% Draw line');
     DrawSimplex({x,y},'n','g');             %% Draw line
  GAprompt;
     disp('>>      uprime = inner(e1,U);');
     uprime = inner(e1,U);
     disp('>>      dprime = U/uprime;');
     dprime = U/uprime;
     disp('>>      draw(dprime,''r'');                    %% Draw proj support');
     draw(dprime,'r');                    %% Draw proj support
  GAprompt;
     disp('>>      DrawSimplex({px,px+unit(uprime)},''n'',''r''); %% Projected line');
     DrawSimplex({px,px+unit(uprime)},'n','r'); %% Projected line
  GAprompt;
     disp('>>      DrawSimplex({e1,dprime},''n'',''m'');    %% Perpendicular support in plane');
     DrawSimplex({e1,dprime},'n','m');    %% Perpendicular support in plane
  GAprompt;
     disp('>>      GAview([-30 10])');
     GAview([-30 10])
  disp(' ');    disp('End of GAblock sequence.  Returning to Matlab.');
elseif ( GAn == 9 ) 
  GAps = 'GAblock >> ';
     disp('>>      % HOMOGENEOUS REPRESENTATION');
     % HOMOGENEOUS REPRESENTATION
     disp('>>      e = e3;                               % direction of extra dimension');
     e = e3;                               % direction of extra dimension
     disp('>>      clf; draw(e,''k'')');
     clf; draw(e,'k')
     disp('>>      p = e1+e2/2;');
     p = e1+e2/2;
     disp('>>      P = e+p;             % point representation');
     P = e+p;             % point representation
     disp('>>      U = 1;');
     U = 1;
     disp('>>      DrawHomogeneous(e,P^U,''y'',''b'')   %% point');
     DrawHomogeneous(e,P^U,'y','b')   %% point
  GAprompt;
     disp('>>      V = e2-e1/3;');
     V = e2-e1/3;
     disp('>>      DrawHomogeneous(e,P^V,''y'',''r'')   %% line segment');
     DrawHomogeneous(e,P^V,'y','r')   %% line segment
  GAprompt;
     disp('>>      W = e1^e2;');
     W = e1^e2;
     disp('>>      DrawHomogeneous(e,P^W,''y'',''g'')   % plane segment');
     DrawHomogeneous(e,P^W,'y','g')   % plane segment
  disp(' ');    disp('End of GAblock sequence.  Returning to Matlab.');
elseif ( GAn == 10 ) 
  GAps = 'GAblock >> ';
     disp('>>      % HOMOGENEOUS BIVECTOR REPRESENTATION OF A LINE');
     % HOMOGENEOUS BIVECTOR REPRESENTATION OF A LINE
     disp('>>      clf;');
     clf;
     disp('>>      e = e3;         % the extra dimension of the homogeneous embedding');
     e = e3;         % the extra dimension of the homogeneous embedding
     disp('>>      p = e1/3+e2;    % position of point P');
     p = e1/3+e2;    % position of point P
     disp('>>      q = e1+e2/2;    % position of point Q');
     q = e1+e2/2;    % position of point Q
     disp('>>      P = e+p;        % homogeneous representation of P');
     P = e+p;        % homogeneous representation of P
     disp('>>      Q = e+q;        % homogeneous representation of Q');
     Q = e+q;        % homogeneous representation of Q
  GAps = 'Refer to the tutorial before continuing >> ';
  disp(' ');  GAprompt;
  GAps = 'GAblock >> ';
     disp('>>      PQ = join(P,Q);       % homogeneous representation of the line join(P,Q)');
     PQ = join(P,Q);       % homogeneous representation of the line join(P,Q)
     disp('>>      DrawSimplex({P},''y'',''b''); DrawSimplex({Q},''y'',''b'');');
     DrawSimplex({P},'y','b'); DrawSimplex({Q},'y','b');
     disp('>>      draw(PQ,''g'')          %% the 2-blade PQ drawn as a planar tangent');
     draw(PQ,'g')          %% the 2-blade PQ drawn as a planar tangent
  GAprompt;
     disp('>>      DrawBivector(P,Q,''y'')                   %% the 2-blade redrawn');
     DrawBivector(P,Q,'y')                   %% the 2-blade redrawn
  GAprompt;
     disp('>>      DrawSimplex({P,Q},''n'',''r'');             %  the line segment PQ');
     DrawSimplex({P,Q},'n','r');             %  the line segment PQ
     disp('>>      DrawSimplex({e,e+2*e1,e+2*e2},''n'',''w''); %% the plane of 2-space');
     DrawSimplex({e,e+2*e1,e+2*e2},'n','w'); %% the plane of 2-space
  GAprompt;
  disp(' ');    disp('End of GAblock sequence.  Returning to Matlab.');
elseif ( GAn == 11 ) 
  GAps = 'GAblock >> ';
     disp('>>      % HOMOGENEOUS REPRESENTATION OF OFFSET SUBSPACES ');
     % HOMOGENEOUS REPRESENTATION OF OFFSET SUBSPACES 
     disp('>>      e = e3;         % the extra dimension of the homogeneous embedding');
     e = e3;         % the extra dimension of the homogeneous embedding
     disp('>>      p = e1/3+e2;    % position of point P');
     p = e1/3+e2;    % position of point P
     disp('>>      q = e1+e2/2;    % position of point Q');
     q = e1+e2/2;    % position of point Q
     disp('>>      P = e+p;        % homogeneous representation of P');
     P = e+p;        % homogeneous representation of P
     disp('>>      Q = e+q;        % homogeneous representation of Q');
     Q = e+q;        % homogeneous representation of Q
     disp('>>      PQ = join(P,Q);       % homogeneous representation of the line join(P,Q)');
     PQ = join(P,Q);       % homogeneous representation of the line join(P,Q)
     disp('>>      clf;  draw(e,''k'');');
     clf;  draw(e,'k');
     disp('>>      DrawHomogeneous(e,P,''y'',''b''); GAtext(1.07*P,''P''); % Draw P');
     DrawHomogeneous(e,P,'y','b'); GAtext(1.07*P,'P'); % Draw P
     disp('>>      DrawHomogeneous(e,Q,''y'',''g''); GAtext(1.07*Q,''Q'') %% Draw Q');
     DrawHomogeneous(e,Q,'y','g'); GAtext(1.07*Q,'Q') %% Draw Q
  GAprompt;
     disp('>>      DrawHomogeneous(e,PQ,''y'',''r'');');
     DrawHomogeneous(e,PQ,'y','r');
     disp('>>      GAorbiter(30,2);');
     GAorbiter(30,2);
  GAps = 'Refer to the tutorial before continuing >> ';
  disp(' ');  GAprompt;
  GAps = 'GAblock >> ';
     disp('>>      IP = {e-e1/2-e2/2,e+3/2*e1-e2/2,e+3/2*e1+3/2*e2,e-e1/2+3/2*e2};');
     IP = {e-e1/2-e2/2,e+3/2*e1-e2/2,e+3/2*e1+3/2*e2,e-e1/2+3/2*e2};
     disp('>>      DrawPolygon(IP,''w'');');
     DrawPolygon(IP,'w');
     disp('>>      GAview([0 90]);');
     GAview([0 90]);
  GAps = 'Refer to the tutorial before continuing >> ';
  disp(' ');  GAprompt;
  GAps = 'GAblock >> ';
     disp('>>      DrawHomogeneous(e,join(P,P),''n'',''b'');');
     DrawHomogeneous(e,join(P,P),'n','b');
  GAps = 'Refer to the tutorial before continuing >> ';
  disp(' ');  GAprompt;
  GAps = 'GAblock >> ';
     disp('>>      r = e1/2-e2/4;');
     r = e1/2-e2/4;
     disp('>>      R = e+r;');
     R = e+r;
     disp('>>      DrawHomogeneous(e,join(join(P,Q),R),''n'',''g'');');
     DrawHomogeneous(e,join(join(P,Q),R),'n','g');
  disp(' ');    disp('End of GAblock sequence.  Returning to Matlab.');
elseif ( GAn == 12 ) 
  GAps = 'GAblock >> ';
     disp('>>      % LINE INTERSECTION AS MEET OF HOMOGENEOUS BIVECTORS');
     % LINE INTERSECTION AS MEET OF HOMOGENEOUS BIVECTORS
     disp('>>      clf;');
     clf;
     disp('>>      e = e3;            % extra dimension of the homogeneous embedding');
     e = e3;            % extra dimension of the homogeneous embedding
     disp('>>      P = e+ e1/3+e2;    % point P');
     P = e+ e1/3+e2;    % point P
     disp('>>      Q = e+ e1+e2/2;    % point Q');
     Q = e+ e1+e2/2;    % point Q
     disp('>>      R = e+ e1/2-e2/4;  % point R');
     R = e+ e1/2-e2/4;  % point R
     disp('>>      PQ = join(P,Q);    % line PQ');
     PQ = join(P,Q);    % line PQ
     disp('>>      QR = join(Q,R);    % line QR');
     QR = join(Q,R);    % line QR
     disp('>>      meet(PQ,QR)        % intersection of those lines');
     meet(PQ,QR)        % intersection of those lines
  GAps = 'Refer to the tutorial before continuing >> ';
  disp(' ');  GAprompt;
  GAps = 'GAblock >> ';
     disp('>>      clf;');
     clf;
     disp('>>      draw(e,''k'');');
     draw(e,'k');
     disp('>>      GAview([0 90]);');
     GAview([0 90]);
     disp('>>      DrawHomogeneous(e,P,''n'',''b''); GAtext(1.07*P,''P''); %  P');
     DrawHomogeneous(e,P,'n','b'); GAtext(1.07*P,'P'); %  P
     disp('>>      DrawHomogeneous(e,Q,''n'',''b''); GAtext(1.07*Q,''Q''); %  Q');
     DrawHomogeneous(e,Q,'n','b'); GAtext(1.07*Q,'Q'); %  Q
     disp('>>      DrawHomogeneous(e,R,''n'',''b''); GAtext(1.07*R,''R''); %% R');
     DrawHomogeneous(e,R,'n','b'); GAtext(1.07*R,'R'); %% R
  GAprompt;
     disp('>>      DrawHomogeneous(e,PQ,''n'',''c''); %% PQ');
     DrawHomogeneous(e,PQ,'n','c'); %% PQ
  GAprompt;
     disp('>>      DrawHomogeneous(e,QR,''n'',''g''); %% QR');
     DrawHomogeneous(e,QR,'n','g'); %% QR
  GAprompt;
     disp('>>      DrawHomogeneous(e,meet(PQ,QR),''n'',''m''); % Meet of PQ, QR');
     DrawHomogeneous(e,meet(PQ,QR),'n','m'); % Meet of PQ, QR
  GAps = 'Refer to the tutorial before continuing >> ';
  disp(' ');  GAprompt;
  GAps = 'GAblock >> ';
     disp('>>      GAview([30 15]);');
     GAview([30 15]);
     disp('>>      DrawHomogeneous(e,P,''y'',''b''); %  P');
     DrawHomogeneous(e,P,'y','b'); %  P
     disp('>>      DrawHomogeneous(e,Q,''y'',''b''); %  Q');
     DrawHomogeneous(e,Q,'y','b'); %  Q
     disp('>>      DrawHomogeneous(e,R,''y'',''b''); % R');
     DrawHomogeneous(e,R,'y','b'); % R
     disp('>>      DrawHomogeneous(e,meet(PQ,QR),''n'',''m''); %% Meet of PQ, QR');
     DrawHomogeneous(e,meet(PQ,QR),'n','m'); %% Meet of PQ, QR
  GAprompt;
     disp('>>      draw(PQ,''c''); draw(QR,''g''); draw(meet(PQ,QR),''m''); %%');
     draw(PQ,'c'); draw(QR,'g'); draw(meet(PQ,QR),'m'); %%
  GAprompt;
     disp('>>      IP = {e-e1-e2,e-e1+2*e2,e+2*e1+2*e2,e+2*e1-e2};');
     IP = {e-e1-e2,e-e1+2*e2,e+2*e1+2*e2,e+2*e1-e2};
     disp('>>      DrawPolygon(IP,''w'');');
     DrawPolygon(IP,'w');
  disp(' ');    disp('End of GAblock sequence.  Returning to Matlab.');
elseif ( GAn == 13 ) 
  GAps = 'GAblock >> ';
     disp('>>      % CONNECTIONS OF LINES AND POINTS');
     % CONNECTIONS OF LINES AND POINTS
     disp('>>      clf;');
     clf;
     disp('>>      e = e3;');
     e = e3;
     disp('>>      P = e+ e1/4+e2/2;');
     P = e+ e1/4+e2/2;
     disp('>>      Q = e- e1/2+e2/4;');
     Q = e- e1/2+e2/4;
     disp('>>      R = e+ e1/3-e2/5;');
     R = e+ e1/3-e2/5;
     disp('>>      PQ = P^Q;');
     PQ = P^Q;
     disp('>>      PtoQ  = connection(e,P,Q);');
     PtoQ  = connection(e,P,Q);
     disp('>>      RtoPQ = connection(e,R,PQ)   % a vector!');
     RtoPQ = connection(e,R,PQ)   % a vector!
     disp('>>      PQtoR = connection(e,PQ,R)   %% a bivector!');
     PQtoR = connection(e,PQ,R)   %% a bivector!
  GAprompt;
     disp('>>      draw(e,''k'');');
     draw(e,'k');
     disp('>>      DrawHomogeneous(e,P,''y'',''b''); GAtext(1.07*P,''P''); % P');
     DrawHomogeneous(e,P,'y','b'); GAtext(1.07*P,'P'); % P
     disp('>>      DrawHomogeneous(e,Q,''y'',''b''); GAtext(1.07*Q,''Q''); % Q');
     DrawHomogeneous(e,Q,'y','b'); GAtext(1.07*Q,'Q'); % Q
     disp('>>      DrawHomogeneous(e,R,''y'',''b''); GAtext(1.07*R,''R''); %% R');
     DrawHomogeneous(e,R,'y','b'); GAtext(1.07*R,'R'); %% R
  GAprompt;
     disp('>>      DrawHomogeneous(e,PQ,''n'',''g'');           %% PQ');
     DrawHomogeneous(e,PQ,'n','g');           %% PQ
  GAprompt;
     disp('>>      DrawSimplex({P,P+PtoQ},''y'',''r'');         %% segment P to Q');
     DrawSimplex({P,P+PtoQ},'y','r');         %% segment P to Q
  GAprompt;
     disp('>>      DrawSimplex({R,R+RtoPQ},''y'',''m'');        %% segment R to PQ');
     DrawSimplex({R,R+RtoPQ},'y','m');        %% segment R to PQ
  GAprompt;
     disp('>>      DrawHomogeneous(e,R+RtoPQ,''n'',''k'');      %% closest point on PQ');
     DrawHomogeneous(e,R+RtoPQ,'n','k');      %% closest point on PQ
  GAprompt;
     disp('>>      DrawHomogeneous(e,PQ+PQtoR,''n'',''k'');     %% closest line through R');
     DrawHomogeneous(e,PQ+PQtoR,'n','k');     %% closest line through R
  GAprompt;
     disp('>>      IP = {e-e1-e2,e-e1+e2,e+e1+e2,e+e1-e2};');
     IP = {e-e1-e2,e-e1+e2,e+e1+e2,e+e1-e2};
     disp('>>      DrawPolygon(IP,''w'');');
     DrawPolygon(IP,'w');
  GAps = 'Refer to the tutorial before continuing >> ';
  disp(' ');  GAprompt;
  GAps = 'GAblock >> ';
     disp('>>      Pline = P^PtoQ;    % the line PQ: at P, tangent PtoQ');
     Pline = P^PtoQ;    % the line PQ: at P, tangent PtoQ
     disp('>>      Rline = R^PtoQ;    % the line at R parallel to PQ');
     Rline = R^PtoQ;    % the line at R parallel to PQ
     disp('>>      DrawHomogeneous(e,Rline,''n'',''c'');         %% Rline drawn');
     DrawHomogeneous(e,Rline,'n','c');         %% Rline drawn
  GAprompt;
     disp('>>      linecon = connection(e,Pline,Rline);');
     linecon = connection(e,Pline,Rline);
     disp('>>      DrawHomogeneous(e,Pline+linecon,''n'',''m''); %% translated Pline');
     DrawHomogeneous(e,Pline+linecon,'n','m'); %% translated Pline
  GAprompt;
  GAps = 'Refer to the tutorial before continuing >> ';
  disp(' ');  GAprompt;
  GAps = 'GAblock >> ';
     disp('>>      QR = join(Q,R);');
     QR = join(Q,R);
     disp('>>      intersect = meet(PQ,QR)/inner(e,meet(PQ,QR));');
     intersect = meet(PQ,QR)/inner(e,meet(PQ,QR));
     disp('>>      linecon = connection(e,PQ,QR);');
     linecon = connection(e,PQ,QR);
     disp('>>      DrawSimplex({intersect,intersect+linecon},''y'',''k'');');
     DrawSimplex({intersect,intersect+linecon},'y','k');
  disp(' ');    disp('End of GAblock sequence.  Returning to Matlab.');
elseif ( GAn == 14 ) 
  GAps = 'GAblock >> ';
     disp('>>      % NAPOLEAN''S THEOREM');
     % NAPOLEAN'S THEOREM
     disp('>>      clf;');
     clf;
     disp('>>      P1 = e3; P2 = e3+e1; P3 = e3+e2;');
     P1 = e3; P2 = e3+e1; P3 = e3+e2;
     disp('>>      DrawPolyline({P1,P2,P3,P1}, ''k''); GAview([0,90]);');
     DrawPolyline({P1,P2,P3,P1}, 'k'); GAview([0,90]);
  GAps = 'Refer to the tutorial before continuing >> ';
  disp(' ');  GAprompt;
  GAps = 'GAblock >> ';
     disp('>>      i = e1^e2; RR = gexp(i*2*pi/3);');
     i = e1^e2; RR = gexp(i*2*pi/3);
  GAps = 'Refer to the tutorial before continuing >> ';
  disp(' ');  GAprompt;
  GAps = 'GAblock >> ';
     disp('>>      S12 = (P1-P2)*RR+P1; DrawPolyline({P1,S12,P2}, ''b'');');
     S12 = (P1-P2)*RR+P1; DrawPolyline({P1,S12,P2}, 'b');
     disp('>>      S23 = (P2-P3)*RR+P2; DrawPolyline({P2,S23,P3}, ''b'');');
     S23 = (P2-P3)*RR+P2; DrawPolyline({P2,S23,P3}, 'b');
     disp('>>      S31 = (P3-P1)*RR+P3; DrawPolyline({P3,S31,P1}, ''b'');');
     S31 = (P3-P1)*RR+P3; DrawPolyline({P3,S31,P1}, 'b');
  GAps = 'Refer to the tutorial before continuing >> ';
  disp(' ');  GAprompt;
  GAps = 'GAblock >> ';
     disp('>>      C1 = (P1+S12+P2)/3;');
     C1 = (P1+S12+P2)/3;
     disp('>>      C2 = (P2+S23+P3)/3;');
     C2 = (P2+S23+P3)/3;
     disp('>>      C3 = (P3+S31+P1)/3;');
     C3 = (P3+S31+P1)/3;
     disp('>>      DrawPolyline({C1,C2,C3,C1},''r'');');
     DrawPolyline({C1,C2,C3,C1},'r');
  disp(' ');    disp('End of GAblock sequence.  Returning to Matlab.');
elseif ( GAn == 15 ) 
  GAps = 'GAblock >> ';
     disp('>>      %PAPPUS''S THEOREM');
     %PAPPUS'S THEOREM
     disp('>>      clf');
     clf
     disp('>>      P1 = e3+e1; P2 = e3+2*e1; P3 = e3+4*e1;');
     P1 = e3+e1; P2 = e3+2*e1; P3 = e3+4*e1;
     disp('>>      Q1 = e3+e2; Q2 = e3+e1+2*e2; Q3 = e3+2*e1+3*e2;');
     Q1 = e3+e2; Q2 = e3+e1+2*e2; Q3 = e3+2*e1+3*e2;
     disp('>>      DrawPolyline({P1,P3},''r''); DrawPolyline({Q1,Q3},''r'');');
     DrawPolyline({P1,P3},'r'); DrawPolyline({Q1,Q3},'r');
     disp('>>      DrawPolyline({P1,Q2},''k''); DrawPolyline({P1,Q3},''k'');');
     DrawPolyline({P1,Q2},'k'); DrawPolyline({P1,Q3},'k');
     disp('>>      DrawPolyline({P2,Q1},''k''); DrawPolyline({P2,Q3},''k'');');
     DrawPolyline({P2,Q1},'k'); DrawPolyline({P2,Q3},'k');
     disp('>>      DrawPolyline({P3,Q1},''k''); DrawPolyline({P3,Q2},''k'');');
     DrawPolyline({P3,Q1},'k'); DrawPolyline({P3,Q2},'k');
     disp('>>      GAview([0,90]);');
     GAview([0,90]);
  GAps = 'Refer to the tutorial before continuing >> ';
  disp(' ');  GAprompt;
  GAps = 'GAblock >> ';
     disp('>>      H3 = meet(join(P1,Q2),join(P2,Q1)); A3 = H3/inner(H3,e3);');
     H3 = meet(join(P1,Q2),join(P2,Q1)); A3 = H3/inner(H3,e3);
     disp('>>      H2 = meet(join(P1,Q3),join(P3,Q1)); A2 = H2/inner(H2,e3);');
     H2 = meet(join(P1,Q3),join(P3,Q1)); A2 = H2/inner(H2,e3);
     disp('>>      H1 = meet(join(P2,Q3),join(P3,Q2)); A1 = H1/inner(H1,e3);');
     H1 = meet(join(P2,Q3),join(P3,Q2)); A1 = H1/inner(H1,e3);
     disp('>>      DrawHomogeneous(e3,H1,''n'',''g'');');
     DrawHomogeneous(e3,H1,'n','g');
     disp('>>      DrawHomogeneous(e3,H2,''n'',''g'');');
     DrawHomogeneous(e3,H2,'n','g');
     disp('>>      DrawHomogeneous(e3,H3,''n'',''g'');');
     DrawHomogeneous(e3,H3,'n','g');
     disp('>>      DrawPolyline({A1,A3},''b'')');
     DrawPolyline({A1,A3},'b')
  disp(' ');    disp('End of GAblock sequence.  Returning to Matlab.');
elseif ( GAn == 16 ) 
  GAps = 'GAblock >> ';
     disp('>>      %MORLEY''S TRIANGLE');
     %MORLEY'S TRIANGLE
     disp('>>      clf;');
     clf;
     disp('>>      P1 = e3; P2 = e3+e1; P3 = e3+e2;');
     P1 = e3; P2 = e3+e1; P3 = e3+e2;
     disp('>>      DrawPolyline({P1,P2,P3,P1}, ''k''); GAview([0,90]);');
     DrawPolyline({P1,P2,P3,P1}, 'k'); GAview([0,90]);
     disp('>>      R1 = (P3-P1)*(P2-P1); R13 = gexp(sLog(R1)/3);');
     R1 = (P3-P1)*(P2-P1); R13 = gexp(sLog(R1)/3);
     disp('>>      R2 = (P1-P2)*(P3-P2); R23 = gexp(sLog(R2)/3);');
     R2 = (P1-P2)*(P3-P2); R23 = gexp(sLog(R2)/3);
     disp('>>      R3 = (P2-P3)*(P1-P3); R33 = gexp(sLog(R3)/3);');
     R3 = (P2-P3)*(P1-P3); R33 = gexp(sLog(R3)/3);
  GAps = 'Refer to the tutorial before continuing >> ';
  disp(' ');  GAprompt;
  GAps = 'GAblock >> ';
     disp('>>      L12 = P1^(R13*(P2-P1)); L13 = P1^((P3-P1)*R13);');
     L12 = P1^(R13*(P2-P1)); L13 = P1^((P3-P1)*R13);
     disp('>>      L23 = P2^(R23*(P3-P2)); L21 = P2^((P1-P2)*R23);');
     L23 = P2^(R23*(P3-P2)); L21 = P2^((P1-P2)*R23);
     disp('>>      L31 = P3^(R33*(P1-P3)); L32 = P3^((P2-P3)*R33);');
     L31 = P3^(R33*(P1-P3)); L32 = P3^((P2-P3)*R33);
  GAps = 'Refer to the tutorial before continuing >> ';
  disp(' ');  GAprompt;
  GAps = 'GAblock >> ';
     disp('>>      H1 = meet(L12,L21); C1 = H1/inner(H1,e3); DrawHomogeneous(e3,H1,''n'',''y'')');
     H1 = meet(L12,L21); C1 = H1/inner(H1,e3); DrawHomogeneous(e3,H1,'n','y')
     disp('>>      H2 = meet(L23,L32); C2 = H2/inner(H2,e3); DrawHomogeneous(e3,H2,''n'',''y'')');
     H2 = meet(L23,L32); C2 = H2/inner(H2,e3); DrawHomogeneous(e3,H2,'n','y')
     disp('>>      H3 = meet(L31,L13); C3 = H3/inner(H3,e3); DrawHomogeneous(e3,H3,''n'',''y'')');
     H3 = meet(L31,L13); C3 = H3/inner(H3,e3); DrawHomogeneous(e3,H3,'n','y')
     disp('>>      DrawPolyline({P1,C1,P2},''g'')');
     DrawPolyline({P1,C1,P2},'g')
     disp('>>      DrawPolyline({P2,C2,P3},''g'')');
     DrawPolyline({P2,C2,P3},'g')
     disp('>>      DrawPolyline({P3,C3,P1},''g'')');
     DrawPolyline({P3,C3,P1},'g')
     disp('>>      DrawPolyline({C1,C2,C3,C1},''r'')');
     DrawPolyline({C1,C2,C3,C1},'r')
  disp(' ');    disp('End of GAblock sequence.  Returning to Matlab.');
end
catch ; end
