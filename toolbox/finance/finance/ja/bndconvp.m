% BNDCONVP   �^����ꂽ���i������̃R���x�N�V�e�B
%
% ���̊֐��́ANUMBONDS �m�藘�t�،��̃R���x�N�V�e�B���A���ꂼ��̍���
% �N���[�����i����v�Z���܂��B���̊֐��́A���̃N�[�|���\�����ŏ��܂���
% �Ō�̊��Ԃ��A�Z���܂��͒����ł���ꍇ�ł��A���̃R���x�N�V�e�B���v�Z
% ���邱�Ƃ��ł��܂�(���Ȃ킿�A�N�[�|���\���������Ɠ������Ă��邩�ǂ�����
% ������炸���̃R���x�N�V�e�B���v�Z�ł��܂�)�B���̊֐��́A�[���N�[�|��
% �̃R���x�N�V�e�B�̌v�Z���\�ɂ��܂��B
%
%   [YearConvexity, PerConvexity] = bndconvp(Price, CouponRate,...
%          Settle, Maturity)
%
%   [YearConvexity, PerConvexity] = bndconvp(Price, CouponRate,...
%          Settle, Maturity, Period, Basis, EndMonthRule, IssueDate,...
%          FirstCouponDate, LastCouponDate, StartDate, Face)
%
% ����: [�K�{]�Ǝw�肳��Ă���S�Ă̈����́ANUMBONDS�s1��A�܂��́A1�s
% NUMBONDS��̃x�N�g���A�܂��́A�X�J�������ł��B�I�v�V�����̈����͑S��
% NUMBONDS�s1��A�܂��́A1�sNUMBONDS��̃x�N�g���A�X�J���A�܂��́A��s��
% �ƂȂ�܂��B����(�I�v�V����)�́A��s��ɂ���ďȗ����邱�Ƃ��ł��܂��B
% ����ɓ���(�I�v�V����)�̒��ŁA�������X�g�̖����Ɉʒu������͂͊�������
% ���Ƃ��ł��܂��B����(�I�v�V����)�̒l���f�t�H���g�l�ɐݒ肷��ɂ́A
% NaN�l����͒l�Ƃ��Đݒ肵�Ă��������B���t�����́A�V���A�����t�ԍ�
% �܂��́A���t������ł��BSIA�m�藘�t���̈����Ɋւ���ڍׂɂ��ẮA
% 'help ftb'�ƃ^�C�v���Ă��������B
% �������̈����Ɋւ���ڍׁA���Ƃ��΁ASettle�́A"help ftbSettle"��
% �^�C�v����ΎQ�Ƃł��܂��B
% 
%  Price (�K�{)      - �N���[�����i
%  CouponRate (�K�{) - 10�i�@�ŕ\�L���ꂽ�N�[�|������
%  Settle (�K�{)     - ���ϓ�
%  Maturity (�K�{)   - ������
%
% ����(�I�v�V����)�F
%  Period          - 1�N�ł̃N�[�|���x����; �f�t�H���g��2(���N����)
%  Basis           - �����̃J�E���g�; �f�t�H���g�� 0 (actual/actual)
%  EndMonthRule    - �����K��; �f�t�H���g��1(�����K���͗L��)
%  IssueDate       - �،��̔��s��
%  FirstCouponDate - �s����A�܂��́A�ʏ�̑�1��N�[�|���x����
%  LastCouponDate  - �s����A�܂��́A�ʏ�̍ŏI�N�[�|���x���� 
%  StartDate       - �x������O�����ăX�^�[�g��������t(�o�[�W����2.0��
%                    �͖�������܂�)
%  Face            - ���̊z�ʉ��l�F�f�t�H���g��100
%         
% �o��:    
%  YearConvexity   - �N�ԃR���x�N�V�e�B
%  PerConvexity    - ����(Periodic)�R���x�N�V�e�B
%         
% �o�͂́ANUMBONDS�s1��̃x�N�g���ł��B
%
% �Q�l : BNDCONVY, BNDDURP, BNDDURY.


%   Author(s): C. Bassignani, M. Reyes-Kattar 07-29-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
