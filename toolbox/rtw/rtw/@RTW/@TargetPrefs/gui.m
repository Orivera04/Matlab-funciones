function frame = gui(h, varargin)
%GUI  Show GUI for editing specified target preferences, return gui handler
%to caller.
% The optional varargin will be used as gui title. If it's empty, the gui
% title will be "upper(packageName)+Target Preferences Setup".
% the handler of the gui will be returned to the caller. So caller could
% use dispose(frame) to close the gui without user interaction.

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $
%   $Date: 2004/04/29 03:39:54 $

    % -- import java package --
    import('com.mathworks.ide.inspector.*');
    import('java.awt.*');
    import('javax.swing.*');
    
    % -- load value from disk --
    %h.load;
    
    % -- create main container frame ---
    if isempty(varargin)
        GUITitle = [upper(strtok(h.class, '.')) ' Target Preferences Setup'];  % Use Packagename as GUI title
    else
        GUITitle = varargin{1};
    end
    frame = handle(JFrame(GUITitle));
    frame.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE); 
    frame.getContentPane.setLayout(java.awt.BorderLayout);
%    frame.setIconImage(com.mathworks.ide.desktop.MLDesktop.getMLDesktop.getMainFrame.getIconImage);

    % -- create inspector property view window
    inspector = PropertyView;
    inspector.setShowReadOnly(1);
    editor_panel = JPanel(java.awt.BorderLayout);
    %scroll_panel = JScrollPane(editor_panel, JScrollPane.VERTICAL_SCROLLBAR_ALWAYS, JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
    editor_panel.add(inspector);
    
    
    % -- create action buttons ---
    cancelButton  = handle(JButton('Cancel'),'callbackproperties');
    revertButton  = handle(JButton('Revert'),'callbackproperties');
    acceptButton  = handle(JButton('  OK  '),'callbackproperties');
    defaultButton = handle(JButton('Reset to Default'),'callbackproperties');    
    helpButton    = handle(JButton(' Help '),'callbackproperties');
    % -- Add callbacks to action buttons -- 
    set(cancelButton, 'ActionPerformedCallback', {@cb_action_panel 'cancel' inspector editor_panel frame h});
    set(revertButton, 'ActionPerformedCallback', {@cb_action_panel 'revert' inspector editor_panel frame h});
    set(acceptButton, 'ActionPerformedCallback', {@cb_action_panel 'accept' inspector editor_panel frame h});
    set(defaultButton, 'ActionPerformedCallback', {@cb_action_panel 'default' inspector editor_panel frame h});    
    set(helpButton, 'ActionPerformedCallback', {@cb_action_panel 'help' inspector editor_panel frame h});

    % -- create action panels to hold buttons
    actionPanel = JPanel(FlowLayout(FlowLayout.RIGHT));
      actionPanel.add(java(defaultButton));    
    % empty panel to seperate the 2 panels
    emptyPanel = JPanel;
    actionPanel2 = JPanel(FlowLayout(FlowLayout.RIGHT));
      actionPanel2.add(java(acceptButton));
      %actionPanel2.add(java(revertButton));
      actionPanel2.add(java(cancelButton));
      actionPanel2.add(java(helpButton));
    
    % -- create holder panel to contain action panels
    holder_panel = JPanel;
    holder_panel.add(actionPanel);
    holder_panel.add(emptyPanel);
    holder_panel.add(actionPanel2);
    
    % -- create split pane to contain inspector window and button holder panel
    object_selector_split = JSplitPane(JSplitPane.VERTICAL_SPLIT, editor_panel, holder_panel);
    frame.getContentPane.add(object_selector_split,BorderLayout.CENTER);
%    frame.getContentPane.add(editor_panel,BorderLayout.NORTH);
 %   frame.getContentPane.add(holder_panel,BorderLayout.SOUTH);

    % -- Disable focus on the buttons, so carriage return on editor panel
    % won't trigger action buttons --
    set(acceptButton, 'RequestFocusEnabled', 0);
    set(cancelButton, 'RequestFocusEnabled', 0);
    set(revertButton, 'RequestFocusEnabled', 0);
    set(defaultButton, 'RequestFocusEnabled', 0);
    set(helpButton, 'RequestFocusEnabled', 0);

     % -- Add a callback for the window closing ---    
    l = handle.listener(frame,'WindowClosing',...
        { @cb_action_panel 'cancel' inspector editor_panel frame h} );
    frame.connect(l,'down'); % Make listener persistent


    % -- Layout the dialog in the center of the screen ---
    screen_size = java.awt.Toolkit.getDefaultToolkit.getScreenSize;
    frame.java.pack;
    dialog_size = frame.java.getSize;

    new_pos = Dimension((screen_size.width-dialog_size.width)/2, ...
        (screen_size.height-dialog_size.height)/2);
    frame.java.setLocation(new_pos.width, new_pos.height);
%    frame.setResizable(false);
     
    frame.java.show;
    
    % -- Assoicate the h with the inspector
    i_edit_object(inspector,editor_panel,h);



function cb_action_panel(src, evt, action, inspector,editor_panel, frame, obj)
    % Callback for action button { VALIDATE | CLOSE | FOCUS }

    % Arguments
    %   src             -   src of event
    %   evt             -   event object
    %   action          -   
    %   frame           -   handle to dialog frame
    switch action
        case 'default'
            obj.reset;
            i_edit_object(inspector, editor_panel, obj);
        case 'accept'
            i_edit_object(inspector, editor_panel, obj);
            obj.save;
            i_close(frame);
        case 'revert'
            obj.load;
            i_edit_object(inspector, editor_panel, obj);
        case 'cancel'
            %obj.load;
            % -- Attempt to close the GUI ---
            i_close(frame);
        case 'help'
            packageName = strtok(obj.class, '.');
            if ismethod(obj, 'help')
              obj.help;
            else
              warndlg('No help provided for this topic.');
            end
    end

function i_edit_object(inspector,editor_panel,h)
    inspector.setObject(h);
    customizer = inspector;
    editor_panel.removeAll;
    editor_panel.add(customizer);    
    
function i_close(target)
        import('com.mathworks.toolbox.ecoder.utils.*');
        import('java.lang.*');
        import('javax.swing.*');
        
        frame = target.java;
        rr = RunnableWrapper(frame,'dispose',{});
        SwingUtilities.invokeLater(rr);
