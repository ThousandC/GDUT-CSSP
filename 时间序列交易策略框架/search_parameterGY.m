%% �����Ż�ͼ



%% ѡ�����

strategysn = 1;
strategyname_cell = {  'DT'  };
strategyname = strategyname_cell{ strategysn };

%% ѡ��ʱ���

begintime = 20160608; % YYYYMMDD or YYYYMMDDHHMM
endtime = 20170608; % YYYYMMDD or YYYYMMDDHHMM



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

    filename = [ 'Data/Daily/'  pname  '.mat' ]; % ��Ƶ����

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


SI = TOHLCV(:,5) / TOHLCV(1,5);

R1 = 0.25:0.01:0.35; 
R2 = 0.25:0.01:0.35; 
N=10;
AR = nan( numel(R1) , numel(R2) ); 
Sharpe = nan( numel(R1) , numel(R2) ); 
Calmar = nan( numel(R1) , numel(R2) );

for i = 1 : numel(R1)
    for j = 1 : numel(R2)
        
        %paramcell =  { [R1(i) N ]  [R2(j) N ]  };
        paramcell =  { N [ R1(i) R2(j) ] 0.0001 };
        [ E , Rtn ]  =  feval( [ 'Strategy_' strategyname ] , TOHLCV , paramcell );
        Eqty = E(:,1);
        equitypfm  =  performmetrics( Eqty', 1 , SI' );
        equitypfm0  =  performmetrics( SI' , 1 , SI' );
        [ equitypfm(1)  equitypfm(5)  equitypfm(2) ]' * 100;
        [ equitypfm0(1)  equitypfm0(5)  equitypfm0(2) ]' * 100;
        equitypfm(1) - equitypfm0(1);
        r1=Rtn(Rtn>0);
        r2=Rtn(Rtn<0);
        numel(r1) / (numel(r1)+numel(r2));
        -mean(r1)/mean(r2);
      
        AR(i,j) = equitypfm(1);
        Sharpe(i,j) = equitypfm(1) / equitypfm(5);
        Calmar(i,j) = equitypfm(1) / equitypfm(2);
        
    end
end

[ X , Y ] = meshgrid( R1 , R2 ) ;
Z = AR;
surf(X',Y',Z);
xlabel('R1')
ylabel('R2')
 equitypfm0  =  performmetrics( SI' , 1 , SI' );
