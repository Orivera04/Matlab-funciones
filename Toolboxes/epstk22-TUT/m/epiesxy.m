%epiesxy (epsFile,x,y,minRadius,maxRadius,angleStart,sliceSize,color,dash,lineWidth,offset)
% written by stefan.mueller@fgan.de (C) 2007

function epiesxy(epsFile,x,y,minRadius,maxRadius,angleStart,sliceSize,color,dash,lineWidth,offset)
  if nargin~=11
    eusage('epiesxy(epsFile,x,y,minRadius,maxRadius,angleStart,sliceSize,color,dash,lineWidth)');
  end
  angleEnd=angleStart+sliceSize;
  fprintf(epsFile,'/W2 %1.2f 2 div def\n',lineWidth);
  fprintf(epsFile,'/Rmin %1.2f W2 add def\n',minRadius);
  fprintf(epsFile,'/Rmax %1.2f W2 sub def\n',maxRadius);
  fprintf(epsFile,'Rmin Rmax gt {/Rmax Rmin def}if\n');
  fprintf(epsFile,'gsave %1.2f %1.2f translate\n',x,y);
  if offset>0
    fprintf(epsFile,...
      '%1.2f %1.2f 2 copy cos mul 3 1 roll sin mul translate\n',...
      offset,angleStart+sliceSize/2);
  end
  if size(dash,1)==1
    nDash=1;
    if dash(1)>0 
      if length(dash)>1
        nDash=length(dash)-1;
	dashSpace=dash(1);
	dashSum=sum(dash(2:nDash+1));
	dashL=dashSpace*nDash+dashSum;
	dashList=zeros(nDash,3);
	for i=1:nDash
          dashList(i,1)=dash(i+1);  	  
          dashList(i,2)=dashL-dash(i+1);  	  
	  dashList(i,3)=dashL-(dashSpace*(i-1)+sum(dash(2:i)));
        end
      else
        nDash=1;
        dashList=[dash(1) dash(1) 0]; 
      end
    end
    fprintf(epsFile,'%1.2f %1.2f %1.2f setrgbcolor\n',...
            color(1),color(2),color(3));
    for i=1:nDash
      if dash(1)>0
        fprintf(epsFile,'[%1.2f %1.2f] %1.2f setdash\n',...
	  dashList(i,1),dashList(i,2),dashList(i,3));
      end
      fprintf(epsFile,'newpath\n');
      fprintf(epsFile,...
        'Rmin %1.2f 2 copy cos mul 3 1 roll sin mul moveto\n',angleStart);
      fprintf(epsFile,'0 0 Rmax %1.2f %1.2f arc\n',angleStart,angleEnd);
      fprintf(epsFile,'0 0 Rmin %1.2f %1.2f arcn\n',angleEnd,angleStart);
      fprintf(epsFile,'closepath\n');
      if dash(1)<0
        fprintf(epsFile,'fill\n');
      else
        fprintf(epsFile,'%1.2f setlinewidth\n',lineWidth);
        fprintf(epsFile,'stroke\n');
      end
    end
    fprintf(epsFile,'grestore\n');
  else
    fprintf(epsFile,'newpath\n');
    fprintf(epsFile,...
      'Rmin %1.2f 2 copy cos mul 3 1 roll sin mul moveto\n',angleStart);
    fprintf(epsFile,'0 0 Rmax %1.2f %1.2f arc\n',angleStart,angleEnd);
    fprintf(epsFile,'0 0 Rmin %1.2f %1.2f arcn\n',angleEnd,angleStart);
    fprintf(epsFile,'closepath clip\n');
    rot=(angleStart+angleEnd)/2-90;
    alpha=pi*(angleEnd-angleStart)/360;
    if alpha>pi/2
      width=2*maxRadius;
      y=maxRadius*cos(alpha);
      height=maxRadius-y-minRadius*cos(alpha);
    else
      width=2*maxRadius*sin(alpha);
      height=maxRadius-minRadius*cos(alpha);
      y=0;
    end
    x=-width/2;
    fprintf(epsFile,'%1.2f rotate\n',rot);
    fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
    eimagexy(epsFile,dash,color,0,0,width,height);
    fprintf(epsFile,'grestore\n');
  end
