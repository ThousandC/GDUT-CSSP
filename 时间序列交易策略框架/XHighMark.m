function  [ highmark , nhigh ]  =  XHighMark( OHLC , N , hl_c )
%% obtain flexible highmark and new-high flag time series
% hl_c: select highmark type (1(HL) or 2(C))
% highmark (T by 1 vector): recording N-period highmark price
% nhigh (T by 1 vector): indicating N-bar new high (1) or not (0)





%% 回望窗口长度向量
eff  =  pmoveff( OHLC(:,4) , N ); % eff: price movement efficiency
X = round( N*(1.5-eff) );



%%
% flag indicating c or hl
if  hl_c == 1
    flag = 2;
elseif  hl_c == 2
    flag = 4;
end



%%
T = size(OHLC,1);
highmark = nan(T,1);
nhigh = zeros(T,1);
for i = max(X) : T
    highmark(i) = max( OHLC(i-X(i)+1:i, flag) );
    if OHLC(i,4) > highmark(i-1)
        nhigh(i) = 1;
    end
end

