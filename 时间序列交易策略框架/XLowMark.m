function  [ lowmark , nlow ]  =  XLowMark( OHLC , N , hl_c )
%% obtain flexible lowmark and new-low flag time series
% hl_c: select lowmark type (1(HL) or 2(C))
% lowmark (T by 1 vector): recording N-period lowmark price
% nlow (T by 1 vector): indicating N-bar new low (1) or not (0)





%% 回望窗口长度向量
eff  =  pmoveff( OHLC(:,4) , N ); % eff: price movement efficiency
X = round( N*(1.5-eff) );



%%
% flag indicating c or hl
if  hl_c == 1
    flag = 3;
elseif  hl_c == 2
    flag = 4;
end



%%
T = size(OHLC,1);
lowmark = nan(T,1);
nlow = zeros(T,1);
for i = max(X) : T
    lowmark(i) = min( OHLC(i-X(i)+1:i, flag) );
    if OHLC(i,4) < lowmark(i-1)
        nlow(i) = 1;
    end
end

