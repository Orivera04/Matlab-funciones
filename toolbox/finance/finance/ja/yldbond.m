% YLDBOND   ���̖����܂ł̗������o��
%
% Yield = yldbond(Settle, Maturity, Face, Price, CouponRate, .....
%             Period, Basis, MaxIterations, EndMonthRule)
% �ڍׁF
% �W���̍��p�����[�^�����͂Ƃ��ė^������ƁA���̊֐��́A
% Newton-Ralphson �����@��p���ăN�[�|���y�у[���N�[�|���̑o����
% ���Ė����܂ł̗������v�Z���܂��B
%
% ����:
%    Settle (�K�{)  - ���Y���̌��ϓ����V���A�����t�ԍ��Ŏ��� N �s1��A
%                     �܂��́A1�s N ��̃x�N�g��
%    Maturity (�K�{)- ���Y���̖��������V���A�����t�ԍ��Ŏ��� N �s1��A
%                     �܂��́A1�s N ��̃x�N�g��
%    Face  (�K�{)   - ���Y���̊z�ʉ��l�������l�� N �s1��A�܂��́A1�s 
%                     N ��̃x�N�g��
%    Price          - (�K�{)���Y���̉��i�������l�� N �s1��A�܂��́A1
%                     �s N ��̃x�N�g��
%    CouponRate     - (�I�v�V����)���Y���̃N�[�|�����[�g�������l�� N 
%                     �s1��A�܂��́A1�s N ��̃x�N�g���B�f�t�H���g��0��
%                     ���B
%    Period         - (�I�v�V����)���Y���̃N�[�|���x�����̕p�x�������l
%                     �� N �s1��A�܂��́A1�s N ��̃x�N�g���B��蓾��l
%                     �́A���̒ʂ�ł��B
%              Period =  0 - �[���N�[�|����
%              Period =  1 - �N�����N�[�|��
%              Period =  2 - ���N�����N�[�|�� (�f�t�H���g)
%              Period =  3 - �N3�񕥂��N�[�|��
%              Period =  4 - �N4�񕥂��N�[�|��
%              Period =  6 - �u�������N�[�|��
%              Period = 12 - �������N�[�|��
%     Basis          - ���Y���ɑ΂��ēK�p���������J�E���g������� 
%                      N �s1��A�܂��́A1�s N ��̃x�N�g����蓾��l�́A
%                      ���̒ʂ�ł��B
%              1)Basis = 0 - actual/actual(�f�t�H���g)
%              2)Basis = 1 - 30/360
%              3)Basis = 2 - actual/360
%              4)Basis = 3 - actual/365
%     MaxIterations  - ���Y���̖����܂ł̗����𓱏o����ۂɁANewton 
%                      �@�Ŏg�p���锽���񐔂������X�J���l�ł��B�f�t�H��
%                      �g��5�ł�(���ӁF�f�t�H���g�l���g�p���������A����
%                      �K���̃t���O�����̊֐��Ɏ󂯓n��������s��������
%                      �����P�[�X�ł́A���� MaxIteration �̓��͂���s��
%                      ����͂��邱�Ƃɂ���ďȗ��ł��܂�)�B
%     EndMonthRule   - ���Y���ɂ��Č����K����K�p���邩���Ȃ������w
%                      �肷�� N �s1��A�܂��́A1�s N ��̃x�N�g���A�܂�
%                      �́A�X�J���l�B��蓾��l�́A���̒ʂ�ł��B
%               1)EndMonthRule = 1(�f�t�H���g)���ɑ΂��錎���K���͗L��
%                                �ł�(���Ȃ킿�A���̖����ɃN�[�|��������
%                                ���s�����́A��Ɍ��̖����Ɏx������
%                                �s���܂�)�B
%               2)EndMonthRule = 0 
%                           �����K���͍��ɑ΂��Ė����ƂȂ��Ă��܂��B
% ���: 
%       Settle = '01-Jan-1960';
%       Maturity = '01-Jan-1990';
%       Face = 1000;
%       Price = 1276.76;
%       CouponRate = 0.08;
%       Period = 2;
%       Basis = 0;
%       EndMonthRule = 1;
%       Yield = yldbond(Settle, Maturity, Face, Price, ...
%                   CouponRate, Period, Basis)
%       
% ���̌��ʁA���̒l���o�͂���܂��B
%
%       Yield = 0.0599
%
% �Q�l : PRBOND, YLDDISC, YLDMAT.


%	Author: C. Garvin, J. Akao, and C. Bassignani, 11/25/97 
%   Copyright 1995-2002 The MathWorks, Inc. 
