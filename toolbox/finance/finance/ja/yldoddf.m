% YLDODDF   �ŏ��̊��Ԃ��[���̗L���،��̗������o��
%
% YLD = YLDODDF(SD,MD,ID,FD,RV,PRICE,CPN,PER,BASIS,MAXITER) �́A�ŏ���
% ���Ԃ��[���ōŏ��̊��ԂɌ��ς���L���،��̗������o�͂��܂��BSD ��
% ���ϓ��AMD �͖������AID �͔��s���AFD �͍ŏ��̃N�[�|���x�����ARV �͊z��
% ���i�APRICE �͗L���،��̉��i CPN �̓N�[�|�����[�g�APER �͔N�Ԃ̃N�[�|��
% ���Ԑ�(�f�t�H���g=2)�ABASIS �́A0 = actual/actual (�f�t�H���g)�A
% 1 = 30/360�A2 = actual/360�A3 = actual/365 �̂����ꂩ��ݒ肵�܂��B
% MAXITER �́AYLD �����߂邽�߂ɁANewton �@�Ŏg�p���锽���񐔂��w�肵
% �܂��B�f�t�H���g��MAXITER = 50�ł��B ���t�́A�V���A�����t�ԍ��A�܂��́A
% ���t������œ��͂��܂��B
% 
% ���F
% ���̃f�[�^���g�p����ƁA
% 
%              SD = '11/11/1992'
%              MD = '03/01/2005'
%              ID = '10/15/1992'
%              FD = '03/01/1993'
%              RV = 100
%              PRICE = 113.60
%              CPN = 0.0785
%              PER = 2
%              BASIS = 0
%       
% yld = yldoddf(sd,md,id,fd,rv,price,cpn,per,basis) �́Ayld = 0.0625�A
% ���Ȃ킿�A6.25%���o�͂��܂��B
% 
% �Q�l : YLDODDL, YLDBOND, YLDODDFL.
%
% �Q�l����: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formulas 8, 9. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
