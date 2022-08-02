%      Ejemplos de uso de arrow3 
%
      % 2D vectors
      Arrow3([0 0],[1 3])
      Arrow3([0 0],[1 2],'-.e')
      Arrow3([0 0],[10 10],'--x2',1)
      Arrow3(zeros(10,2),50*rand(10,2),'x',1,3)
      Arrow3(zeros(10,2),[10*rand(10,1),500*rand(10,1)],'u')
      Arrow3(10*rand(10,2),50*rand(10,2),'x',1,[],1)
      pause(3);
      % 3D vectors
      Arrow3([0 0 0],[1 1 1])
      Arrow3(zeros(20,3),50*rand(20,3),'--x1.5',2)
      Arrow3(zeros(100,3),50*rand(100,3),'x',1,3)
      Arrow3(zeros(10,3),[10*rand(10,1),500*rand(10,1),50*rand(10,1)],'a')
      Arrow3(10*rand(10,3),50*rand(10,3),'x',[],[],0)
      pause(3); 
      % Just for fun
      Arrow3(zeros(100,3),50*rand(100,3),'x',10,3,[],0.95)
      light('Position',[-10 -10 -10],'Style','local')
      light('Position',[60,60,60]), lighting gouraud
      pause(3);
      % ColorOrder variable, color code prefixes, and Beta
      global ColorOrder, ColorOrder='^ui^e_hq^v';
      theta=[0:pi/22:pi/2]';
      Arrow3(zeros(12,2),[cos(theta),sin(theta)],'1.5o',0.1,[],[],[],0.5)
      pause(3);
      % ColorOrder property, LineStyleOrder, and LineWidthOrder
      global ColorOrder, ColorOrder=[];
      set(gca,'ColorOrder',[1,0,0;0,0,1;0.25,0.75,0.25;0,0,0])
      set(gca,'LineStyleOrder',{'-','--','-.',':'})
      global LineWidthOrder, LineWidthOrder=[1,2,4,8];
      w=[5,10,15,20]; h=[20,40,30,40];
      Arrow3(zeros(4,2),[10*rand(4,1),500*rand(4,1)],'o*/',w,h,10)
      pause(3);
      % Magnitude coloring
      colormap spring
      Arrow3(20*randn(20,3),50*randn(20,3),'|',[],[],0)
      set(gca,'color',0.7*[1,1,1])
      set(gcf,'color',0.5*[1,1,1]), grid on, colorbar
      % change the colormap and update colors
      %colormap hot
      %Arrow3('update','colors')
      pause(3);
      % LogLog plot
      set(gca,'xscale','log','yscale','log');
      axis([1e2,1e8,1e-2,1e-1]); hold on
      p1=repmat([1e3,2e-2],15,1);
      q1=[1e7,1e6,1e5,1e4,1e3,1e7,1e7,1e7,1e7,1e7,1e7,1e6,1e5,1e4,1e3];
      q2=1e-2*[9,9,9,9,9,7,5,4,3,2,1,1,1,1,1]; p2=[q1',q2'];
      global ColorOrder, ColorOrder=[];
      set(gca,'ColorOrder',rand(15,3))
      Arrow3(p1,p2,'o'), grid on, hold off
      pause(3);
      % SemiLogX plot
      set(gca,'xscale','log','yscale','linear');
      axis([1e2,1e8,1e-2,1e-1]); hold on
      p1=repmat([1e3,0.05],15,1);
      q1=[1e7,1e6,1e5,1e4,1e3,1e7,1e7,1e7,1e7,1e7,1e7,1e6,1e5,1e4,1e3];
      q2=1e-2*[9,9,9,9,9,7,5,4,3,2,1,1,1,1,1]; p2=[q1',q2'];
      Arrow3(p1,p2,'x'), grid on, hold off
      pause(3);
      % SemiLogY plot
      set(gca,'xscale','linear','yscale','log');
      axis([2,8,1e-2,1e-1]); hold on
      p1=repmat([3,2e-2],17,1);
      q1=[7,6,5,4,3,7,7,7,7,7,7,7,7,6,5,4,3];
      q2=1e-2*[9,9,9,9,9,8,7,6,5,4,3,2,1,1,1,1,1]; p2=[q1',q2'];
      set(gca,'LineStyleOrder',{'-','--','-.',':'})
      Arrow3(p1,p2,'*',1,[],0), grid on, hold off
      pause(3);
      % Color tables
      Arrow3('colors')           % default color table
      Arrow3('colors',0.3)       % low contrast color table
      Arrow3('colors',0.5)       % high contrast color table
    
