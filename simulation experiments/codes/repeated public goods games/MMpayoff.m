function [payoff,cooperate]=MMpayoff(n,r,c,eps);

r1=r; r2=r;
qvec=ones(1,n+1);

%% Setting up the random number generator
C=clock;
rng(C(5)*60+C(6));

%% Setting up all objects
%n=length(qvec)-1; % Number of players
%binom=CalcBinom(N,n); % Pre-calculating all possible binomial coefficients that will be needed，从N个个体中不分次序选择n个的所有组合
Str=zeros(2^(2*n),2*n); ns=2^(2*n); % Constructing a list of all possible strategies  Strategies have the form (pC,n-1),...p(C,0),p(D,n-1),...p(D,0))共2^2n种单步记忆策略
for i=1:ns, Str(i,:)=sscanf(dec2bin(i-1,2*n), '%1d' )'; end  %将2^2n个策略转换成二进制，即从0（0000 0000）到255（1111 1111）.
PayH=zeros(ns,ns); CoopH=zeros(ns,ns); % Initializing a vector that contains all payoffs and cooperation rates in homogeneous populations。在同质群体中存放ns个策略的收益PayH和合作率CoopH向量

for i=1:ns % Calculating the values of PayH and CoopH
    %StrH=zeros(n,2*n);
    i
    for j=i:ns
        st1=Str(i,:);st2=Str(j,:);
        if i==j
            StrH=[st1;st1;st1;st1];%一个n-group中，四个个体都使用策略i
            [pivec,cvec]=calcPay(StrH,qvec,r1,r2,c,eps); %得到该策略i的平均收益和合作率。
            PayH(i,j)=pivec(1); CoopH(i,j)=cvec(1);%组内都是策略strH时，该策略的收益。
        else
            pi=zeros(1,n);co=zeros(1,n);
            for num=1:n-1 %组内st1的数量。
                StrH=[repmat(st1,num,1);repmat(st2,n-num,1)];%一个n-group中，四个个体都使用策略i
                [pivec,cvec]=calcPay(StrH,qvec,r1,r2,c,eps);
                pi=pi*(num-1)/num+pivec/num;
                co=co*(num-1)/num+cvec/num;
            end
            PayH(i,j)=pi(1);PayH(j,i)=pi(end);
            CoopH(i,j)=co(1);CoopH(j,i)=co(end);
        end
    end
end

% PayMC =csvread('C:\QuarkMao\PGGcure\payoff_DATA\MCpayoff\MCpayoff_2.0.csv');%CURE-MEM1,CURE-CURE的收益
% CooMC =csvread('C:\QuarkMao\PGGcure\payoff_DATA\MCpayoff\MCcoopeRate_2.0.csv');%CURE-MEM1,CURE-CURE的合作率
payoff=PayH;
cooperate=CoopH;

%dlmwrite('str.csv', Str);
% dlmwrite('payoff_0.001n_2.0r-test.csv', payoff);
% dlmwrite('cooperate_0.001n_2.0r-test.csv', cooperate);
end

function [pivec,cvec]=calcPay(Str,QVec,r1,r2,c,eps); 
% Calculates the payoff and cooperation rates in a stochastic game with
% deterministic transitions, playing a PGG in each state
% Str ... Matrix with n rows, each row contains the strategy of a player
% Strategies have the form (pC,n-1,...pC,0,pD,n-1,...pD,0) where the letter
n=size(Str,1); %返回Str的行n，(n,2*n);4个策略,(pC,n-1,...pC,0,pD,n-1,...pD,0)
PossState=zeros(2^(n+1),n+1); % Matrix where each row corresponds to a possible state,(s1,D,D,D,D),...,(S2,C,C,C,C)
for i=1:2^(n+1)%每个可能的状态
    PossState(i,:)=sscanf( dec2bin(i-1,n+1), '%1d' )';%0-31的二进制数相当于个体行为和状态的从（0，0，0，0，0）到（1，1，1，1，1）的遍历。
end
piRound=zeros(2^(n+1),n); % Matrix where each row gives the payoff of all players in a given state。每个可能状态下，组内每个个体的收益。
for i=1:2^(n+1)
    State=PossState(i,:); nrCoop=sum(State(2:end)); Mult=State(1)*r2+(1-State(1))*r1; %State(s1,D,D,D,D),...,(S2,C,C,C,C);D=0,C=1。nrCoop计算group中合作者的数量。Mult确定是博弈1还是博弈2
    for j=1:n
        piRound(i,j)=nrCoop*Mult/n-State(j+1)*c;%i状态下，个体1，2，3，4分别获得的收益。
    end
end
% PART II -- CREATING THE TRANSITION MATRIX BETWEEN STATES
M=zeros(2^(n+1),2^(n+1)); %
Str=(1-eps)*Str+eps*(1-Str);
for row=1:2^(n+1)
    StOld=PossState(row,:); % PreviousState。,(s1,D,D,D,D),...,(S2,C,C,C,C)
    nrCoop=sum(StOld(2:end)); EnvNext=QVec(n+1-nrCoop);%nrCoop=上一状态下的合作数量；%每一种状态下，group中合作者的个数存储在nrCoop中。 相应的概率（下一轮返回状态1的概率）EnvNext=QVec（q(n),q(n-1),..., q2, q1,q0）=(合作者个数n，n-1,...,2,1,0)
    for col=1:2^(n+1) %第row种状态转移到第col种状态的概率
        StNew=PossState(col,:); %NextState，(s1,D,D,D,D),...,(S2,C,C,C,C)
        if StNew(1)==1-EnvNext
            trpr=1; % TransitionProbability
            for i=1:n
                iCoopOld=StOld(1+i);%第i个个体的行为，1=C,0=D
                pval=Str(i,2*n-nrCoop-(n-1)*iCoopOld); %策略i下一轮合作概率；
                iCoopNext=StNew(1+i);%策略i下一轮的合作行为；
                trpr=trpr*(pval*iCoopNext+(1-pval)*(1-iCoopNext));
            end
        else
            trpr=0;
        end
        M(row,col)=trpr;
    end
end        
v=null(M'-eye(2^(n+1))); freq=v'/sum(v);
pivec=freq*piRound;%pivec(1,2,3,4)
%cvec=sum(freq*PossState(:,2:end))/n;
cvec=freq*PossState(:,2:end);%cvec(1,2,3,4)
end

