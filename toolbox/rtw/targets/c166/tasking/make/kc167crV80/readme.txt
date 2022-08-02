This sub-folder contains a Tasking EDE project that is used by Embedded Target
for Infineon C166 Microcontrollers to provide build settings that are applied to
the build process for automatically generated code.

The instructions for creating the EDE project in this directory are:

- Copy a source file main.c to this directory
- Open the Tasking EDE version 8.0
- Right-click on the root of the project tree and select Add new project
- Scan in the file main.c into the new project
- Set the new project to be the current project
- Project/Project Options/Application/Processor/CPU=C167CR and accept the option
  to set all registers to the default values for C167CR and reset execution 
  environment to simulator.
- Project/Project Options/CrossView Pro/ExecutionEnvironment select manufacturer
  = Phytec, then select kitCON-167; accept the option to set the startup
  registers to the default values for this execution environment
- Project/Project Options/LinkerLocator/Output format/Check generate hex
- To test the configuration so far, build the project and check and use the
  button to launch CrossView; this should allow you to debug the application on
  your kitCON-167

