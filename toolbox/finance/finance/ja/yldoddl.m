% YLDODDL   �Ō�̊��Ԃ��[���̗L���،��̗������o��
%
% YLD = YLDODDL(SD,MD,LCD,RV,PRICE,CPN,PER,BASIS,MAXITER) �́A�Ō�̊���
% ���[���̗L���،��̗������o�͂��܂��BSD �͌��ϓ��AMD �͖������ALCD ��
% �Ō�̃N�[�|���x�����ARV �͊z�ʉ��i�APRICE �͗L���،��̉��i�ACPN �̓N
% �[�|�����[�g�APER �͔N�Ԃ̃N�[�|�����Ԑ�(�f�t�H���g=2)�ABASIS �́A
% 0 = actual/actual (�f�t�H���g)�A1 = 30/360�A2 = actual/360�A
% 3 = actual/365 �̂����ꂩ��ݒ肵�܂��BMAXITER �́AYLD �����߂邽�߂ɁA
% Newton �@�Ŏg�p���锽���񐔂��w�肵�܂��B�f�t�H���g�́AMAXITER = 50
% �ł��B���t�́A�V���A�����t�ԍ��A�܂��́A���t������œ��͂��܂��B
% 
% ���F
% �ȉ��̃f�[�^���g�p����ƁA
%  
%              SD = '02/07/1993'
%              MD = '06/15/1993'
%              LCD = '10/15/1992'
%              RV = 100
%              PRICE = 99.878
%              CPN = 0.0375
%              PER = 2
%              BASIS = 1
%       
% yld = yldoddl(sd,md,lcd,rv,price,cpn,per,basis) �́Ayld = 0.0405�A
% ���Ȃ킿�A4.05%���o�͂��܂��B
% 
% �Q�l : YLDODDF, YLDBOND, YLDODDFL, PRODDL.
%
% �Q�l����: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formulas 10, 12, 14, 15. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
