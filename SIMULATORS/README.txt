This software package contains simulators in Matlab for the following
computer simulation related exercise problems given in the textbook:

Chapter 2 Problem 2-24 (flat Rayleigh fading channel simulator);
Chapter 3 Problem 3-23 (BER performance of pi/4-DQPSK)
Chapter 4 Problem 4-17 (adaptive linear equalizer)
Chapter 4 Problem 4-18 (adaptive decision feedback equalizer)
Chapter 5 Problem 5-14 (outage probability due to random cochannel interference)
Chapter 6 Problem 6-17 (cell capacity of CDMA system)
Chapter 7 Problem 7-17 (mean sojourn time and mean handoff rate)
Chapter 8 Problem 8-19 (probability distribution of mobile location)


The simulators have user-friendly interface and are created using Matlab 
version 6.0. They can be used for demos in classroom.

Note:
====

(1) For the simulators to work properly, the path must be set to the correct
location where the files reside.  To do this, go to File/Set Path and add the
path to which the files are stored locally.

(2) To launch the interface, enter the name of the file without the
extension.  The file names are listed below. For instance, to launch 
chapter 2's interface, enter "chap2" in command prompt.

(3) To run the simulations using other Matlab versions, the interface
window size may need to be adjusted manually so that all the elements in the
interface are properly positioned.

(4) Each simulation may take minutes or even hours, depending on the number 
of samples. Also, when the sample number is very large, the Matlab may
experience a memory shortage problem, depending on the computer hardware.

(5) Details of the simulator implementation can be found in the callback
functions and subroutine functions as listed below. Modification to the 
simulators can be done by properly modifying the callback functions and 
the associate subroutines. 

List of the files:
=================

Chapter2 (Problem 2-24)
interface:         chap2.m
                   chap2.mat
callback function: Plot_Graph.m
other functions:   chan_sim.m
		   find_afd.m
                   find_lcr.m
                   find_pdf.m

Chapter3 (Problem 3-23)
interface:         chap3.m
                   chap3.mat
callback function: chap3_func.m
other functions:   pi4dqpsk_rx.m
		   Rayleigh.m


Chapter4a (Problem 4-17)
interface:         chap4a.m
                   chap4a.mat
callback function: chap4a_func.m
other functions:   Rayleigh.m
		   Rician.m
		   linear_eq.m
 
Chapter4b (Problem 4-18)
interface:         chap4b.m
                   chap4b.mat
callback function: chap4b_func.m
other functions:   Rayleigh.m
		   Rician.m
 		   DFE.m


Chapter5 (Problem 5-14)
interface:         chap5.m
                   chap5.mat
callback function: chap5_func.m


Chapter6 (Problem 6-17)
interface:	   chap6.m
                   chap6.mat
callback function: chap6_func.m


Chapter7a (Problem 7-17a)
interface:         chap7a.m
                   chap7a.mat
callback function: chap7a_func.m
                  
Chapter7b (Problem 7-17b)
interface:         chap7b.m
                   chap7b.mat
callback function: chap7b_func.m
                  
Chapter7c (Problem 7-17c)
interface:         chap7c.m
                   chap7c.mat
callback function: chap7c_func.m


Chapter8 (Problem 8-19)
interface:         chap8.m
                   chap8.mat
callback function: chap8_func.m
