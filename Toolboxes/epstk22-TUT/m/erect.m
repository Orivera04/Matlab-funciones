%erect ( epsFile , x , y , width , height , lineWidth, color, dash, rotation)
% written by stefan.mueller@fgan.de (C) 2007

function erect(epsFile,x,y,width,height,lineWidth,color,dash,rotation)
  if (nargin~=9)
    eusage('erect(epsFile,x,y,width,height,lineWidth,color,dash,rotation)');
  end
  eglobpar
  if (size(dash,1)==1) && ~isstr(dash)
    dash=dash*eFac;
    width=width-lineWidth;
    height=height-lineWidth;
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
    fprintf(epsFile,'gsave\n');
    fprintf(epsFile,'%1.2f %1.2f %1.2f setrgbcolor\n',...
                     color(1),color(2),color(3));
    fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
    fprintf(epsFile,'%1.2f rotate\n',rotation);
    for i=1:nDash
      if dash(1)>0
        fprintf(epsFile,'[%1.2f %1.2f] %1.2f setdash\n',...
	  dashList(i,1),dashList(i,2),dashList(i,3));
      end
      fprintf(epsFile,'newpath %1.2f dup moveto\n',lineWidth/2);
      fprintf(epsFile,'%1.2f 0 rlineto\n',width);
      fprintf(epsFile,'0 %1.2f rlineto\n',height);
      fprintf(epsFile,'%1.2f 0 rlineto\n',-width);
      fprintf(epsFile,'0 %1.2f rlineto\n',-height);
      fprintf(epsFile,'closepath\n');
      fprintf(epsFile,'%1.2f setlinewidth\n',lineWidth);
      if dash(1)<0
        fprintf(epsFile,'fill\n');
      else
        fprintf(epsFile,'stroke\n');
      end
    end
    fprintf(epsFile,'grestore\n');
  else
    width=width-2*lineWidth;
    height=height-2*lineWidth;
    fprintf(epsFile,'gsave\n');
    fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
    fprintf(epsFile,'%1.2f rotate\n',rotation);
    eimagexy(epsFile,dash,color,lineWidth,lineWidth,...
      width,height);
    fprintf(epsFile,'grestore\n');
  end
