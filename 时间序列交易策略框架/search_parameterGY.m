%% 参数优化图



%% 选择策略

strategysn = 1;
strategyname_cell = {  'DT'  };
strategyname = strategyname_cell{ strategysn };

%% 选择时间段

begintime = 20160608; % YYYYMMDD or YYYYMMDDHHMM
endtime = 20170608; % YYYYMMDD or YYYYMMDDHHMM



%% 读取数据；确定开始时间与结束时间对应坐标

% 选择交易品种
sn = 3; % 选择品种序列号
Codescell  =  { 
    '000001.SH'; '000016.SH'; '000300.SH'; '000905.SH'; '399005.SZ'; '399006.SZ';
    'RBFI.WI'; 'HCFI.WI'; 'JFI.WI'; 'JMFI.WI'; 'IFI.WI'; 'ZCFI.WI';
    'RUFI.WI'; 'SPFI.WI'; 'FGFI.WI';
    'CUFI.WI'; 'NIFI.WI'; 'ALFI.WI'; 'ZNFI.WI';
    'FUFI.WI'; 'BUFI.WI'; 'SCFI.WI';
    'AUFI.WI'; 'AGFI.WI';
    'APFI.WI'; 'SRFI.WI'; 'CFFI.WI'; 'JDFI.WI'; 'PFI.WI'; 'MFI.WI'; 'RMFI.WI'; 'YFI.WI'; 'OIFI.WI';
    'MAFI.WI'; 'PPFI.WI'; 'LFI.WI'; 'VFI.WI';  'TAFI.WI'; 'EGFI.WI' }; % 品种代码表（万德数据库）
code = Codescell{sn,:}    % 根据序列号查表得到品种代码
pname = code(1:end-3);

% 读取数据文件

    filename = [ 'Data/Daily/'  pname  '.mat' ]; % 日频数据

load( filename );

% 核对时间轴，找到给定开始时间与结束时间对应的坐标
beginidx = find( TOHLCV(:,1) == begintime );
endidx = find( TOHLCV(:,1) == endtime );



%% 回测策略

% 显示品种
disp(  [  'Product Name: '  pname  ]  );

% 根据开始与结束时间的对应坐标截取矩阵
TOHLCV = TOHLCV( beginidx : endidx , : );
innan = find( ~isnan(TOHLCV(:,5)) ,1 );
TOHLCV = TOHLCV( innan : end , : );
begintime = TOHLCV(1,1); % update begintime

% 模拟交易


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
