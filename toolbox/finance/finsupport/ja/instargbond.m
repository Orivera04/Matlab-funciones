% INSTARGBOND   'Type','Bond' �����̌��؂��s���T�u���[�`��
%
% ���̊֐��́A�������[�`���̍ŏ��Ɏ��s����܂��B
%
%   [CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, ....
%    IssueDate, FirstCouponDate, LastCouponDate, StartDate, Face] = ...
%          instargbond(ArgList{:})
%
% ����: 
% ArgList{:} �o�͂�1��1�ŏ���������������͂��܂��B
%
% �o��: 
% �o�͂́A�K������ NINST �s1��̃x�N�g���ƂȂ�܂��BSIA �m�藘�t���،���
% �����̏ڍׂɂ��ẮA"help ftb"�ƃ^�C�v���Ă��������B
%
%       CouponRate        - 10�i�@�\�L�ł̃N�[�|�����[�g
%       Settle            - ���ϓ�
%       Maturity          - ������
%       Period            - �N������̃N�[�|���x������(�f�t�H���g��2)
%       Basis             - �����J�E���g��B�f�t�H���g��0 
%                           (actual/actual)
%       EndMonthRule      - �������[���B�f�t�H���g��1(�������[���͗L��)
%       IssueDate         - ���̔��s��
%       FirstCouponDate   - �s����A�܂��́A�ʏ�̑���N�[�|���x����
%       LastCouponDate    - �s����A�܂��́A�ʏ�̍ŏI�N�[�|���x����
%       StartDate         - �x���������炩���߃X�^�[�g��������t
%  �@�@�@�@�@�@�@�@�@       (2.0�ł͂��̈����̓��͖͂�������܂�)�B
%       Face              - ���̊z�ʉ��l�B�f�t�H���g��100�ł��B
%   
% �Q�l : INSTBOND.


%   Author(s): J. Akao 19-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
