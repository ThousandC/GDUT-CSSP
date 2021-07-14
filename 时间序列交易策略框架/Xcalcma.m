function  XMA = Xcalcma( S , N )
%% calculate flexible moving average for time series





%% 回望窗口长度向量
eff  =  pmoveff( S , N ); % eff: price movement efficiency
X = round( N*(1.5-eff) );



%% compute XMA
T = numel(S); % length of time series
XMA = nan(T,1);
for i = max(X) : T
    XMA(i)  =  mean(  S( i-X(i)+1 : i )  );
end


