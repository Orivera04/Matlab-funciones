%The Marine Visualization Toolbox
%Version 1.0 (R13), 28-Nov-2003
%
%Requires: Virtual Reality Toolbox, Version 3.0 (R13)
%
%Installation files
%  MVTinstall   - Install or uninstall the MVT
%
%VRML vessel models
%  auv          - Autonomous Underwater Vehicle
%  cybership    - Model of a supply vessel, scale 1:70
%  semi         - A semi-submersible rig
%  supply       - General purpose supply vessel
%  tanker       - Gas tanker
%  rov          - Remotely Operated Vehicle
%
%VRML scenes
%  basin        - Small basin for scala experiments
%  empty        - Empty
%  flat         - Flat ocean surface
%  subsea       - Simple ocean floor
%
%MATLAB interface functions
%  createvrml   - Generate VRML files for a given scenario
%  director     - Create 3d animations by integrating VRML files and user data
%  euler2p      - Convert an euler rotation to a principal rotation
%  mvtguide     - From 6 DOF data to animations, step-by-step execution
%  new_avi      - Open new AVI file for recording
%  typedef      - Define simulation scenario
%  verifydata   - Verify structure of input data
%  vrdraw       - Update the displayed VR world
%  vrplay       - Play an animation sequence
%  vrrecord     - Save an animation sequence to file
%
%Private functions
%  dirlist      - List files in directory
%