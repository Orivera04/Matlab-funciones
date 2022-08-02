% PYLD2ZERO   �^����ꂽ�z�ʗ����Ȑ�����[���Ȑ����o��
%
% [ZeroRates, CurveDates] = ....
%       pyld2zero(ParRates, CurveDates, Settle, OutputCompounding, ....
%       OutputBasis,InputCompounding,InputBasis)
%
% �ڍׁF 
% �z�ʗ����Ȑ��Ɩ���������͂Ƃ��ė^����ƁA���̊֐��͓��͂��ꂽ������
% �ɂ���āA������鏊�L���Ԃɑ΂��ă[���Ȑ����o�͂��܂��B
%
% ����:
%         ParRates          - (�K�{)�N�����Z���ꂽ�z�ʗ����(= �N�[�|��
%                             ���[�g)��10�i���\�L�Ŏ��� N �s1��̃x�N�g
%                             ���B�����ŁAN �͖����z�ʔ������̐��ł��B
%         CurveDates        - (�K�{)���͂��ꂽ�z�ʗ����ɑΉ����閞����
%                             ���V���A�����t�Ŏ��� N �s1��̃x�N�g��
%         Settle            - (�K�{)���̌��ϓ����V���A�����t�`���ŕ\��
%                             ����X�J���l
%         OutputCompounding - (�I�v�V����)�o�͂����[��������N���Ɋ��Z
%                             ����Ƃ��ɂǂ̂��炢�̊����ŕ����v�Z���s��
%                             ���������X�J���l�B���͂ł���l�́A���̒�
%                             ��ł��B
%              OutputCompounding = 1   - ��N�����v�Z
%              OutputCompounding = 2   - (�f�t�H���g)���N�����v�Z
%              OutputCompounding = 3   - �N3�񕡗��v�Z
%              OutputCompounding = 4   - �N4�񕡗��v�Z
%              OutputCompounding = 6   - �u�������v�Z
%              OutputCompounding = 12  - ��1�񕡗��v�Z
%              OutputCompounding = 365 - ���������v�Z
%              OutputCompounding = -1  - �A�������v�Z
%
%         OutputBasis       - (�I�v�V����)�o�͂����[��������N���Ɋ��Z
%                             ����Ƃ��ɁA�ǂ̓����J�E���g���p���邩
%                             �������X�J���l�B���͂ł���l�͂��̒ʂ��
%                             ���B
%              1)Basis = 0 - actual/actual(�f�t�H���g)
%              2)Basis = 1 - 30/360
%              3)Basis = 2 - actual/360
%              4)Basis = 3 - actual/365
%
%         InputCompounding  - (�I�v�V����)���͂����z�ʗ�����N���Ɋ��Z
%                             ����Ƃ��ɂǂ̂��炢�̊����ŕ����v�Z���s��
%                             ���������X�J���l�B�f�t�H���g�ł́A
%                             OutputCompounding �Ɠ����l�ƂȂ��Ă��܂��B
%         InputBasis        - (�I�v�V����)���͂����z�ʗ�����N���Ɋ��Z
%                             ����Ƃ��ɁA�ǂ̓����J�E���g���p���邩
%                             �������X�J���l�B�f�t�H���g�ł́A
%                             OutputBasis �Ɠ����l�ɂȂ��Ă��܂��B
% �o��:    
%         ZeroRates         - 10�i�@�\�L�̃[���������܂� N �s1��̗�x�N
%                             �g��
%         CurveDates        - ZeroRates �Ɋ܂܂��e�[�������̖��������V
%                             ���A�����t�`���Ŏ������������̓��t�ō\����
%                             ��� N �s1��x�N�g��
%
% �Q�l : ZERO2PYLD, ZBTPRICE, ZBTYIELD, TERMFIT, ZERO2FWD, FWD2ZERO, 
%        ZERO2DISC, DISC2ZERO.


%Author: J. Akao and C. Bassignani, 11-19-97
%   Copyright 1995-2002 The MathWorks, Inc. 
