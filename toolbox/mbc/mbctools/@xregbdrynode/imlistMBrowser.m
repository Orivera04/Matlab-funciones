function IL = imlistMBrowser( bdry )
%IMLISTMBROWSER Image List manger for boundary node tree views
%
%  IL = IMLISTMBROWSER(BDRY) is the image list manager for the tree view of
%  constraint boundaries.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:13:16 $ 

bmpfiles= { 'bdrynode', 'bdrynode_sel', 'bdrynode_best', 'bdrynode_best_sel',  };

ilm = xregGui.ILmanager;

for i = 1:length( bmpfiles )
	ind = bmp2ind( ilm, [ bmpfiles{i}, '.bmp' ] );
end

% Magenta is the transparent color	 
ilm.IL.MaskColor = uint32( 256*256*255 + 255 ); 

% 
IL = ilm.IL;
