% Financial Toolbox
% Version 2.4 (R14) 05-May-2004
%
% �w���v�ƃ}�j���A��
%   Readme      - Financial Toolbox �̃����[�X�m�[�g
%   ftb         - �����̃w���v���Q�Ƃ��邽�߂̃w�b�_
%   calendar    - ���Z�J�����_�֐��̓��e 
%
% �ʉݏ���
%   cur2frac    - 10�i���̒ʉ݉��l�𕪐��̒ʉ݉��l�ɕϊ�
%   cur2str     - �ʉ݉��l�� Financial Toolbox �̋�s�����ɕϊ�
%   frac2cur    - �����̒ʉ݉��l��10�i���̒ʉ݉��l�ɕϊ�
%   
% �`���[�g
%   bolling     - Bollinger �o���h�`���[�g
%   candle      - Candlestick�`���[�g
%   dateaxis    - �V���A�����t�̎����x������t�����x���ɕϊ�
%   pointfig    - �_�}�`�`���[�g
%   highlow     - ���l-���l-�n�l-�I�l�`���[�g
%   movavg      - ���[�h�^���O�ړ����σ`���[�g
%   
% ���݉��l�Ə������l
%   pvfix       - ��z����x���z�̌������l
%   pvvar       - �ϓ��L���b�V���t���[�̌��݉��l
%   fvfix       - ��z����x���z�̏������l
%   fvvar       - �ϓ��L���b�V���t���[�̏������l
%   fvdisc      - �����L���،��̏������l
%   
% �N��
%   annurate    - �N���̒������
%   annuterm    - ���l������������Ԑ�
%   
% �o�ߗ��q
%   acrubond    - ����I�������̗L���،��̌o�ߗ��q
%   acrudisc    - �������Ҋ����L���،��̌o�ߗ��q
%   
% ���i
%   bndprice    - SIA�W���m�藘�t�،��̉��i
%   prbond      - ����I�������̗L���،��̉��i
%   prmat       - �������������̗L���،��̉��i
%   proddf      - �ŏ��̊��Ԃ��[���̗L���،��̉��i
%   proddfl     - �ŏ��ƍŌ�̊��Ԃ��[���ōŏ��̊��ԂɌ��ς���L���،���
%                 ���i
%   proddl      - �Ō�̊��Ԃ��[���̗L���،��̉��i
%   prtbill     - �����ȏ،��̉��i
%   prdisc      - �����L���،��̉��i
%   
% �����̎��ԍ\��
%   disc2zero   - �����Ȑ�����[���Ȑ��𓱏o
%   fwd2zero    - �t�H���[�h�Ȑ�����[���Ȑ��𓱏o
%   prbyzero    - �[���Ȑ���������i�𓱏o
%   pyld2zero   - �z�ʗ����Ȑ�����[���Ȑ��𓱏o
%   termfit     - Spline Toolbox ���g���āA���ԍ\���̃t�B�b�e���O
%   tbl2bond    - �����ȏ،��f�[�^�����������Ȓ����̃f�[�^�����ɕϊ�
%   tr2bonds    - �č������Ȓ����̃f�[�^��ϊ�
%   zbtprice    - �s������i����u�[�g�X�g���b�v�[�������Ȑ����o��
%   zbtyield    - �s�������肩��u�[�g�X�g���b�v�[�������Ȑ����o��
%   zero2disc   - �^����ꂽ�[���Ȑ��������Ȑ��ɕϊ�
%   zero2fwd    - �^����ꂽ�[���Ȑ����t�H���[�h�Ȑ��ɕϊ�
%   zero2pyld   - �^����ꂽ�[���Ȑ����z�ʗ����Ȑ��ɕϊ�
% 
% �����
%   bndyield    - SIA �W���m�藘�t�،��̗����
%   beytbill    - �����ȏ،��̍����Z�����
%   discrate    - �L���،��̊�����
%   yldbond     - ����I�����̗L���،��̗����
%   yldmat      - �������������̗L���،��̗����
%   yldoddf     - �ŏ��̊��Ԃ��[���̗L���،��̗����
%   yldoddfl    - �ŏ��ƍŌ�̊��Ԃ��[���ŁA�ŏ��̊��ԂɌ��ς���L���،�
%                 �̗����
%   yldoddl     - �Ō�̊��Ԃ��[���̗L���،��̗����
%   yldtbill    - �����ȏ،��̗����
%   ylddisc     - �����L���،��̗����
%   
% ���v��
%   effrr       - �������v��
%   irr         - �������v��
%   mirr        - �C���������v��
%   nomrr       - ���ڎ��v��
%   taxedrr     - �ň�������v��
%   xirr        - �����I�L���b�V���t���[�̓������v��
%   
% �x�����̌v�Z
%   payadv      - �w��̉񐔂̑O�����̒���x���z
%   payodd      - �ŏ��̊��Ԃ��[���̊��Ԃ̔N���̎x���z
%   payper      - �ݕt�A�܂��́A�N���̒���x���z
%   payuni      - �ϓ��L���b�V���t���[�ɓ����ȓ���x���z
%   
% �����̊����x
%   bnddurp     - ���i���� SIA �W���L���،��̃f�����[�V�������v�Z
%   bnddury     - ����肩�� SIA �W���L���،��̃f�����[�V�������v�Z
%   bndconvp    - ���i���� SIA �W���L���،��̃R���x�N�V�e�B���v�Z
%   bndconvy    - ����肩�� SIA �W���L���،��̃R���x�N�V�e�B���v�Z
%   bondconv    - �R���x�N�V�e�B
%   bonddur     - Macauley �y�яC���f�����[�V����
%   cfconv      - �L���b�V���t���[�R���x�N�V�e�B�y�у{���e�B���e�B
%   cfdur       - �L���b�V���t���[�f�����[�V�����y�яC���f�����[�V����
%   
% ���p�ƌ������p
%   amortize    - ���p
%   depfixdb    - �Œ�����c���������p
%   depgendb    - ��ʒ����c���������p
%   deprdv      - �c���������p�\���l
%   depsoyd     - �N���������p�̑��a
%   depstln     - ��z�������p
%     
% �I�v�V�����̕]���Ɗ����x
%   binprice    - �񍀃��f���̃v�b�g�ƃR�[���̉��i����
%   blkprice    - Black �̃I�v�V�������i����
%   blsdelta    - ��b���i�̕ω��ɑ΂� Black-Scholes �̊����x
%   blsgamma    - ��b�f���^�̕ω��ɑ΂��� Black-Scholes �̊����x
%   blsimpv     - Black-Scholes �C���v���C�h�E�{���e�B���e�B
%   blslambda   - Black-Scholes �̒e���l
%   blsprice    - Black-Scholes ���f���̃v�b�g�ƃR�[���̉��i����
%   blsrho      - �����̕ω��ɑ΂��� Black-Scholes �̊����x
%   blstheta    - �����܂ł̎��Ԃ̕ω��ɑ΂��� Black-Scholes �̊����x
%   blsvega     - ��b���i�{���e�B���e�B�̕ω��ɑ΂��� Black-Scholes ��
%                 �����x
%   opprofit    - �I�v�V�����̎��v
%   
% �{���e�B���e�B���� (ARCH/GARCH)
%   ugarch      - ��ϗ� ARCH/GARCH �p�����[�^����
%   ugarchllf   - ��ϗ� GARCH �p�����[�^�� �ΐ��ޓx�֐�
%   ugarchpred  - ��ϗ� GARCH �v���Z�X�ɂ��{���e�B���e�B�̗\��
%   ugarchsim   - ��ϗ� GARCH �v���Z�X�̃V�~�����[�V����
%
% �|�[�g�t�H���I����
%   cov2corr    - �����U��W���΍��y�ё��ւɕϊ�
%   corr2cov    - �W���΍��y�ё��ւ������U�ɕϊ�
%   ewstats     - ���Y���v�y�ы����U����
%   portsim     - �������Y���v���n��̃V�~�����[�V����
%   ret2tick    - ���Y���v���n������i���n��ɕϊ�
%   tick2ret    - ���Y���i���n������v���n��ɕϊ�
%   frontcon    - ��{�I����̉��̗L���t�����e�B�A
%   portalloc   - ���{�z��
%   portopt     - �C�ӂ̐���Q�̉��ł̗L���t�����e�B�A
%   portcons    - �|�[�g�t�H���I��̐���̐ݒ�
%   pcalims     - �|�[�g�t�H���I���Y�z���͈̔�
%   pcglims     - �|�[�g�t�H���I���Y�W���z���͈̔�
%   pcgcomp     - �|�[�g�t�H���I�W�����W���\����͈̔͂ɕϊ�
%   pcpval      - �|�[�g�t�H���I�̑����l
%   portrand    - �����_�������ꂽ�|�[�g�t�H���I�̃��X�N�A���v�A���d�l
%   portstats   - �|�[�g�t�H���I�̃��X�N�y�ъ��Ҏ��v��
%   portvrisk   - ���X�N�̉��ł̃|�[�g�t�H���I�̉��l
%
% ============== ���Z���t�֐� (help calendar)==============
%
% ���s�̎��ԂƓ��t
%   today       - ���s�̓��t
%   
% ���t�Ǝ��Ԃ̍\���v�f�y�я���
%   datedisp    - �f�[�g�ԍ����͂��܂ލs���\��
%   datefind    - �s����̓��t�ԍ��̃C���f�b�N�X
%   day         - ���̏o��
%   eomdate     - ���̖���
%   hour        - ���Ԃ̏o��
%   lweekdate   - ���̍Ō�̕����̓��t
%   minute      - �b�̏o��
%   month       - ��
%   months      - �w�肳�ꂽ���t�Ԃɑ��݂���S�Ă̌��̐�
%   m2xdate     - MATLAB ���t�� EXCEL ���t�ɕϊ�
%   nweekdate   - ���̎w�肳�ꂽ�����̓��t
%   second      - �w�肵�����t�A�܂��́A���Ԃ̕b
%   x2mdate     - EXCEL ���t�� MATLAB ���t�ɕϊ�
%   year        - �w�肵�����t�̔N
%   yeardays    - �N���\��������t�̐�
%   
% ���Z���t
%   busdate     - ���̉c�Ɠ��A�܂��́A�O�̉c�Ɠ�
%   datemnth    - �����̌��A�܂��́A�ߋ��̌��ɂ�������̓��t
%   datewrkdy   - �����A�܂��́A�ߋ��̉c�Ɠ��̓��t
%   days360     - 1�N��360���Ƃ��Čv�Z���ꂽ���t�Ԃ̓���
%   days365     - 1�N��365���Ƃ��Čv�Z���ꂽ���t�Ԃ̓���
%   daysdif     - �ݒ肵�����t�J�E���g��Ōv�Z���ꂽ���t�Ԃ̓���
%   daysact     - �����̔N�Ɋ�Â��Čv�Z���ꂽ���t�Ԃ̓���
%   fbusdate    - ���̍ŏ��̉c�Ɠ�
%   holidays    - �x���y�ыx�Ɠ�
%   isbusday    - �w�肳�ꂽ���t���c�Ɠ��̏ꍇ�A�^���o��
%   lbusdate    - ���̍Ō�̉c�Ɠ�
%   wrkdydif    - �w�肵�����t�Ԃ̉c�Ɠ���
%   yearfrac    - �w�肵�����t�Ԃ̔N�̒[��
%   
% �N�[�|�����t
%   accrfrac    - �o�ߗ��q�N�[�|�����Ԃ̒[��
%   cfamounts   - �L���،��ɑ΂���L���b�V���t���[�̊z
%   cfdates     - �L���،��ɑ΂���L���b�V���t���[�̓��t
%   cftimes     - �L���،��ɑ΂���L���b�V���t���[�̎��ԌW��
%   cfport      - �L���b�V���t���[�z�̃|�[�g�t�H���I�`��
%   cpncount    - �w�肵�����t�Ԃł̃N�[�|���x������
%   cpndaten    - �w�肵�����t����ɓ������鎟��N�[�|���x����
%   cpndatenq   - �w�肵�����t����ɓ������鏀(quasi)�N�[�|���x����
%   cpndatep    - �w�肵�����t���O�ɓ��������O��N�[�|���x����
%   cpndatepq   - �w�肵�����t���O�ɓ����������N�[�|���x����
%   cpndaysn    - �w�肵�����t�Ǝ���N�[�|���x�����Ԃ̓���
%   cpndaysp    - �w�肵�����t�ƑO��N�[�|���x�����Ԃ̓���
%   cpnpersz    - �w�肵�����t���܂ފ��Ԃ̓����̒���
%
% �e�L�X�g�̑O�̕������X�N���[���ɂ���ăX�N���[������݂͂����ď�����
% ���܂��ꍇ�A���̃R�}���h�������Ă݂Ă��������B
% 
%    more on, help finance, more off


% Copyright 1995-2003 The MathWorks, Inc. 