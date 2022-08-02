% INSTARGOPTBND   'Type','Bond' �����̌��؂��s���T�u���[�`��
%
% ���̊֐��́A�������[�`���̍ŏ��Ŏ��s����܂��B
%
%   [OptSpec, Strike, ExerciseDates, AmericanOpt, CouponRate, ....
%        Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
%           FirstCouponDate, LastCouponDate, StartD, Face] = ....
%              instargoptbnd(ArgList{:})
%
% ����: 
%   ArgList{:} �o�͂�1��1�ŏ���������������͂��܂��B
%
% �o��: 
%  OptSpec           - ������ 'call'�A�܂��́A'put' ����Ȃ� NINST �s1��
%                      �̃Z���z��
%  Strike            - �����s�g���i�̒l����Ȃ� NINST �s NSTRIKES ���
%                      �Z���z��
%  ExerciseDates     - �����s�g���t������NINST �s NSTRIKES ��A�܂��́A
%                      NINST �s 2 ��̃Z���z��
%  AmericanOpt       - �t���O0�A�܂��́A1������ NINST �s1��̃Z���z��
%  CouponRate        - 10�i�@�\�L�ł̃N�[�|�����[�g
%  Settle            - ���ϓ�
%  Maturity          - ������
%  Period            - �N������̃N�[�|���x������(�f�t�H���g��2)
%  Basis             - �����J�E���g��B�f�t�H���g��0 (actual/actual)
%  EndMonthRule      - �������[���B�f�t�H���g��1(�������[���͗L��)
%  IssueDate         - ���̔��s��
%  FirstCouponDate   - �s����A�܂��́A�ʏ�̑���N�[�|���x����
%  LastCouponDate    - �s����A�܂��́A�ʏ�̍ŏI�N�[�|���x����
%  StartDate         - �x�����̐�X�^�[�g��(2.0�ł͂��̈����̓��͖͂���
%                      ����܂�)�B
%  Face              - ���̊z�ʉ��l�B�f�t�H���g��100�ł��B
% 
% �Q�l : INSTBOND, INSTOPTBND.


%   Author(s): J. Akao 04-May-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
