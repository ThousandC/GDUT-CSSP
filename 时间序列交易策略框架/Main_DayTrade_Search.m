%% 日内交易策略主程序入口





%% 选择策略

strategysn = 1;
strategyname_cell = {  'DT'  'ORB3'  };
strategyname = strategyname_cell{ strategysn }



%% 调用子函数提取策略参数

paramcell  =  parameters_DayTrade( strategyname );




%% 选择时间段

begintime = 20100104; % YYYYMMDD
endtime = 20200611; % YYYYMMDD



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
filename = [ 'Data/Daily/'  pname  '.mat' ];
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
xlabel('交易日')
ylabel('策略净值')
legend( '日内策略' , '做多策略' , '做空策略' , '固定持有' )
title( {  [ 'Strategy - ' strategyname ]; [ pname ': ' num2str(begintime) '--' num2str(endtime) ]  } )


