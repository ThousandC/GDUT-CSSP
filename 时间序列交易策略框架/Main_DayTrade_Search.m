%% ���ڽ��ײ������������





%% ѡ�����

strategysn = 1;
strategyname_cell = {  'DT'  'ORB3'  };
strategyname = strategyname_cell{ strategysn }



%% �����Ӻ�����ȡ���Բ���

paramcell  =  parameters_DayTrade( strategyname );




%% ѡ��ʱ���

begintime = 20100104; % YYYYMMDD
endtime = 20200611; % YYYYMMDD



%% ��ȡ���ݣ�ȷ����ʼʱ�������ʱ���Ӧ����

% ѡ����Ʒ��
sn = 3; % ѡ��Ʒ�����к�
Codescell  =  { 
    '000001.SH'; '000016.SH'; '000300.SH'; '000905.SH'; '399005.SZ'; '399006.SZ';
    'RBFI.WI'; 'HCFI.WI'; 'JFI.WI'; 'JMFI.WI'; 'IFI.WI'; 'ZCFI.WI';
    'RUFI.WI'; 'SPFI.WI'; 'FGFI.WI';
    'CUFI.WI'; 'NIFI.WI'; 'ALFI.WI'; 'ZNFI.WI';
    'FUFI.WI'; 'BUFI.WI'; 'SCFI.WI';
    'AUFI.WI'; 'AGFI.WI';
    'APFI.WI'; 'SRFI.WI'; 'CFFI.WI'; 'JDFI.WI'; 'PFI.WI'; 'MFI.WI'; 'RMFI.WI'; 'YFI.WI'; 'OIFI.WI';
    'MAFI.WI'; 'PPFI.WI'; 'LFI.WI'; 'VFI.WI';  'TAFI.WI'; 'EGFI.WI' }; % Ʒ�ִ����������ݿ⣩
code = Codescell{sn,:}    % �������кŲ��õ�Ʒ�ִ���
pname = code(1:end-3);

% ��ȡ�����ļ�
filename = [ 'Data/Daily/'  pname  '.mat' ];
load( filename );

% �˶�ʱ���ᣬ�ҵ�������ʼʱ�������ʱ���Ӧ������
beginidx = find( TOHLCV(:,1) == begintime );
endidx = find( TOHLCV(:,1) == endtime );



%% �ز����

% ��ʾƷ��
disp(  [  'Product Name: '  pname  ]  );

% ���ݿ�ʼ�����ʱ��Ķ�Ӧ�����ȡ����
TOHLCV = TOHLCV( beginidx : endidx , : );
innan = find( ~isnan(TOHLCV(:,5)) ,1 );
TOHLCV = TOHLCV( innan : end , : );
begintime = TOHLCV(1,1); % update begintime

% ģ�⽻��
[ E , Rtn ]  =  feval( [ 'Strategy_' strategyname ] , TOHLCV , paramcell );
Eqty = E(:,1);

SI = TOHLCV(:,5) / TOHLCV(1,5);
equitypfm  =  performmetrics( Eqty', 1 , SI' );
equitypfm0  =  performmetrics( SI' , 1 , SI' );
[ equitypfm(1)  equitypfm(5)  equitypfm(2) ]' * 100
[ equitypfm0(1)  equitypfm0(5)  equitypfm0(2) ]' * 100
equitypfm(1) - equitypfm0(1)

R1=Rtn(Rtn>0);
R2=Rtn(Rtn<0);
numel(R1) / (numel(R1)+numel(R2))
-mean(R1)/mean(R2)

plot( E )
hold on
plot( SI,':' )
hold off
xlabel('������')
ylabel('���Ծ�ֵ')
legend( '���ڲ���' , '�������' , '���ղ���' , '�̶�����' )
title( {  [ 'Strategy - ' strategyname ]; [ pname ': ' num2str(begintime) '--' num2str(endtime) ]  } )


