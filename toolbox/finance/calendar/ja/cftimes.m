% CFTIMES   �[���N�[�|�����Ԃɂ�����L���b�V���t���[�܂ł̎���
%
% ���̊֐��́ANUMBONDS �������݂���m�藘�t�ɂ��Ď��ԌW��(timefactor)
% ���o�͂��܂��B�u���ԌW��(time factor)�v�Ƃ́A�[�����N�N�[�|�����Ԃ�
% ������L���b�V���t���[�܂ł̎��Ԃ��Ӗ����Ă��܂��B
%
%   TFactors = cftimes(Settle, Maturity)
%
%   TFactors = cftimes(Settle, Maturity, Period, Basis, EndMonthRule,...
%          IssueDate, FirstCouponDate, LastCouponDate, StartDate)
%
% ����: [�K�{]�Ǝw�肳��Ă���S�Ă̈����́A NUMBONDS �s1��A�܂��́A
%   1�sNUMBONDS��̃x�N�g���܂��̓X�J�������ł��B�I�v�V�����̈����͑S��
%   NUMBONDS�s1��A�܂��́A1�sNUMBONDS��̃x�N�g���A�X�J���܂��͋�s��
%   �ƂȂ�܂��B����(�I�v�V����)�́A��s��ɂ���ďȗ����邱�Ƃ��ł�
%   �܂��B����ɓ���(�I�v�V����)�̒��ŁA�������X�g�̖����Ɉʒu������͂�
%   �������邱�Ƃ��ł��܂��B����(�I�v�V����)�̒l���f�t�H���g�l�ɐݒ肷��
%   �ɂ́ANaN�l����͒l�Ƃ��Đݒ肵�Ă��������B���t�����́A�V���A�����t
%   �ԍ��܂��͓��t������ł��BSIA�m�藘�t�̈����Ɋւ���ڍׂɂ��ẮA
%   'help ftb' �ƃ^�C�v���Ă��������B�������̈����Ɋւ���ڍׁA
%   ���Ƃ��΁ASettle �Ɋւ���w���v�́A�R�}���h���C����� "help ftbSettle"
%   �ƃ^�C�v����ΎQ�Ƃł��܂��B
% 
%   Settle (�K�{)   - ���ϓ�
%   Maturity (�K�{) - ������
%
%����(�I�v�V����)�F
%   Period          - 1�N�ł̃N�[�|���x����; �f�t�H���g��2(���N����)
%   Basis           - �����̃J�E���g�; �f�t�H���g�� 0 (actual/actual)
%   EndMonthRule    - �����K��; �f�t�H���g��1(�����K���͗L��)
%   IssueDate       - ���̔��s��
%   FirstCouponDate - �s����܂��͒ʏ�̑�1��N�[�|���x����
%   LastCouponDate  - �s����܂��͒ʏ�̍ŏI�N�[�|���x���� 
%   StartDate       - �x������O�����ăX�^�[�g��������t(�o�[�W����2.0��
%                     �͖�������܂�)
%         
% �o��: 
%  TFactors - �L���b�V���t���[�܂ł̎��ԁ@TFactors�s��̍s�̐��́A
%    NUMBONDS �ŁA��̐��́A���|�[�g�t�H���I��ۗL���邱�Ƃɂ��v��
%    �����L���b�V���t���[�x���������̍ő�l�ɂ���Č��肳��܂��B
%    �L���b�V���t���[�x�����̐����ATFactor�s��̍s���ɂ���Ď������
%    �ő�l��菭�Ȃ����ɂ��ẮANaN�l�ɂ���Č��������s���܂��B
%
% �Q�l : CPNDAYSN, CPNDAYSP, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, 
%        CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CPNPERSZ.


%   Author(s): C. Bassignani, M. Reyes-Kattar 07-31-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
