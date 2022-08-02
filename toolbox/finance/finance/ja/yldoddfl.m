% YLDODDFL   �ŏ��ƍŌ�̊��Ԃ��[���ōŏ��̊��ԂɌ��ς���L���،��̗����
%            ���o��
%
% YLD = YLDODDFL(SD,MD,ID,FD,LCD,RV,PRICE,CPN,PER,BASIS,MAXITER) �́A�ŏ�
% �ƍŌ�̊��Ԃ��[���ōŏ��̊��ԂɌ��ς���L���،��̗������o�͂��܂��B
% SD �͌��ϓ��AMD �͖������AID �͔��s���AFD �͍ŏ��̃N�[�|���x�����ALCD 
% �͍Ō�̃N�[�|���x�����ARV �͊z�ʉ��i�APRICE �͗L���،��̉��i�ACPN ��
% �N�[�|�����[�g�APER �͔N�Ԃ̃N�[�|�����Ԑ�(�f�t�H���g=2)�A BASIS �́A
% 0 = actual/actual (�f�t�H���g)�A1 = 30/360�A2 = actual/360�A
% 3 = actual/365 �̂����ꂩ��ݒ肵�܂��BMAXITER �́AYLD �����߂邽�߂ɁA
% Newton �@�Ŏg�p���锽���񐔂��w�肵�܂��B�f�t�H���g�́AMAXITER = 50
% �ł��B���t�̓V���A�����t�ԍ��A�܂��́A���t������œ��͂��܂��B
% 
% ���F
% ���̃f�[�^���g�p����ƁA
%   
%              SD = '03/15/1993'
%              MD = '03/01/2020'
%              ID = '03/01/1993'
%              FD = '07/01/1993'
%              LCD = '01/01/2020'
%              RV = 100
%              PRICE = 95.71
%              CPN = 0.04
%              PER = 2
%              BASIS = 1
%       
%              yld = yldoddfl(sd,md,id,fd,lcd,rv,price,cpn,per,basis)
%       
% �́Ayld = 0.0427 ���Ȃ킿 4.27%���o�͂��܂��B
% 
% �Q�l : YLDODDF, YLDODDL, YLDBOND, PRODDFL.
%
% �Q�l����: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formulas 16, 17, 18, 19. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
