% YLDMAT   �������������̗L���،��̗������o��
%
% YLDMAT(SD,MD,ID,RV,PRICE,CPN,BASIS) �́A�������������̗L���،��̗����
% ���o�͂��܂��BSD �͌��ϓ��AMD �͖������AID �͔��s���ARV �͊z�ʉ��i�A
% PRICE �͉��i�ACPN �̓N�[�|�������ABASIS �́A0 = actual/actual (�f�t�H
% ���g)�A1 = 30/360�A2 = actual/360�A3 = actual/365�̂����ꂩ��ݒ肵��
% ���B���t�́A�V���A�����t�ԍ��A�܂��́A���t������œ��͂��܂��B
% 
% ���F
% ���̃f�[�^���g�p����ƁA
% 
%              SD = '02/07/1992'
%              MD = '04/13/1992'
%              ID = '10/11/1991'
%              RV = 100
%              PRICE = 99.98
%              CPN = 0.0608
%              BASIS = 1
%       
%              y = yldmat(sd,md,id,rv,price,cpn,basis)
%       
% �́Ay = 0.0607 ���Ȃ킿 6.07%���o�͂��܂��B
% 
% �Q�l : PRBOND, YLDBOND, YLDDISC, PRMAT.
%
% �Q�l����: Mayle, Standard Securities Calculation Methods, Volumes
%          I-II, 3rd edition.  Formula 3. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
