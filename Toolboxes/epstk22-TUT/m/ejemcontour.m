    x=-2:.1:2;
    y=-2:.1:2;
    [X,Y]=meshgrid(x,y);
    matrix=X.*exp(-X.^2-Y.^2);

    eopen('demo5a.eps',0,180,140);
    eglobpar;
    ePlotTitleText='Contour Plot';
    ePlotTitleDistance=15;
    ePlotAreaPos=[20 20];
    eXAxisSouthLabelText='x - Axis';
    eYAxisWestLabelText='y - Axis';
    eImageLegendLabelText='z - Color Legend';
    eContourValueVisible=1;
    eaxes([-2 0 2],[-2 0 2]);
    eimagesc(matrix,ecolors(3),'e');
    etext('        (1. value)',eImageLegendValuePos(1,1),...
      eImageLegendValuePos(1,2),4,4,2);
    econtour(matrix,[-0.5 0.05 0.5],0,[1 1 1;0 0 0;0 0 0]);
    eclose(1,0);


    % quiver plot
    eopen('demo5b.eps',0,180,140);
    eglobpar;
    ePlotTitleText='Quiver Plot';
    ePlotTitleDistance=15;
    ePlotAreaPos=[20 20];
    eXAxisSouthLabelText='x - Axis';
    eYAxisWestLabelText='y - Axis';
    eImageLegendLabelText='z - Color Legend';
    eaxes([-2 0 2],[-2 0 2]);
    eimagesc(matrix,ecolors(3),'e');

    % sw
    x=-2.1:.2:-0.1;
    y=-2.1:.2:-0.1;
    [X,Y]=meshgrid(x,y);
    qmatrix=X.*exp(-X.^2-Y.^2);
    [dx dy]=egradient(qmatrix,.2,.2);
    equiver(X,Y,dx,dy,[1 1 1]);

    % nw
    x=-2.1:.2:-0.1;
    y=0.1:.2:2.1;
    [X,Y]=meshgrid(x,y);
    qmatrix=X.*exp(-X.^2-Y.^2);
    [dx dy]=egradient(qmatrix,.2,.2);
    edsymbol('spire','spire.psd');
    equiver(X,Y,dx,dy,[1 1 1],'spire');

    % ne
    x=0.1:.2:2.1;
    y=0.1:.2:2.1;
    [X,Y]=meshgrid(x,y);
    qmatrix=X.*exp(-X.^2-Y.^2);
    [dx dy]=egradient(qmatrix,.2,.2);
    edsymbol('needle','needle.psd');
    equiver(X,Y,dx,dy,[0 0 0],'needle');

    % se
    x=0.1:.2:2.1;
    y=-2.1:.2:-0.1;
    [X,Y]=meshgrid(x,y);
    qmatrix=X.*exp(-X.^2-Y.^2);
    [dx dy]=egradient(qmatrix,.2,.2);
    edsymbol('ftria','ftria.psd',1,0.4);
    equiver(X,Y,dx,dy,[0 0 0],'ftria');

    eclose(1,0);

    % quiver and contour
    eopen('demo5.eps')
    esubeps(2,1,1,1,'demo5a.eps');
    esubeps(2,1,2,1,'demo5b.eps');
    eclose
    if ~exist('noDemoShow')
      eview                                   % start ghostview with eps-file
    end
