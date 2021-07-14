function  equitypfm  =  performmetrics( Capital , inicash , SI )
%% compute performance metrics given equity curve and index benchmark

% applied on daily data
% Inputs: Capital, the total capital at the end of each bar; inicash, initial cash; SI: index close time series
% row vectors
% Output: equity curve metrics (6 measures)



%% equity curve metrics

T = length(Capital); % data length

wrr = Capital(T) / inicash - 1; % 总回报率
% rryear = wrr*(252/T); % 年化回报率
rryear = (1+wrr)^(252/T)-1; % 年化回报率
mdd = maxdrawdown(Capital); % max drawdown in the performance window

rr  =  Capital(2:end) ./ Capital(1:end-1) - 1; % return rate
rr0  =  SI(2:end) ./ SI(1:end-1) - 1; % return rate of the index

ab = regress( rr', [ones(T-1,1)  rr0'] );
alpha = ab(1); % alpha
beta = ab(2); % beta
vola = std(rr); % volatility

% volaR = std(rr-rr0); % relative volatility
% mr = mean(rr); % mean return
% var=quantile(rr,0.05); % 5%VAR
% cvar=mean(rr(rr<var)); % 5% CVAR
% sharpe=mr/std(rr); % sharpe ratio
% inforatio=mean(rr-rr0)/std(rr-rr0); % information ratio

equitypfm = [  rryear  mdd  (1+alpha)^252-1  beta  vola*sqrt(252)  0  ]; % aggregate metrics