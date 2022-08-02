function browser(htmlfile)

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:12 $

persistent hb;
persistent ib;
persistent sf;

Browser = HTMLattic('AtticData', 'Browser'); 
model=HTMLattic('AtticData', 'model');
javaPatchDir = [matlabroot filesep 'java' filesep 'patch' filesep 'com' filesep...
        'mathworks' filesep 'mlwidgets' filesep 'html']; 

%if ~exist(javaPatchDir)
%    Browser = 'helpbrowser'; % auto switch to help  browser if no java pacth exists.
%end

switch Browser
    case 'java'  % use java browser provided with Search and Configure Tool
        if isempty(hb)
            hb = com.mathworks.mlwidgets.html.HTMLRenderer;
        end
        if isempty(ib)
            ib = hb.getICEWrapper;
        end
        ib.setComponentToolkitName('swing')
        hb.setCurrentLocation(htmlfile)
        if isempty(sf)
            sf = javax.swing.JFrame;
            sf.setIconImage(com.mathworks.ide.desktop.MLDesktop.getMLDesktop.getMainFrame.getIconImage);
            sfTk=sf.getToolkit;
            screenSize=sfTk.getScreenSize;
            height = screenSize.getHeight;
            width = screenSize.getWidth;
            height = floor(height/1.5);
            width = floor(width/1.5);
            sf.setSize(width, height);
        end
        model = strrep(model, sprintf('\n'), ' ');
        sf.setTitle(['Model Assistant: ' model]);
        sf.getContentPane.add(hb);
        sf.toFront;
        sf.setVisible(1);
    case 'helpbrowser'   % use default help browser
        helpview(htmlfile);
    otherwise
        helpview(htmlfile);
end
