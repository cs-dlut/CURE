function [SGpay,SGcoop]=SGpayoff();
%% input the payoff of the repeated PD game
PayM1 =csvread('C:\payoff\payoff_IPDG_001n_1.8b.csv');%重复博弈b1
PayM2 =csvread('C:\payoff\payoff_IPDG_001n_1.01b.csv');%重复博弈b2
Coop1 =csvread('C:\payoff\CoopeRate_IPDG_001n_1.8b.csv');%重复博弈b1
Coop2 =csvread('C:\payoff\CoopeRate_IPDG_001n_1.01b.csv');%重复博弈b2
eps=0.01;deltaT=1;
%% Setting up the random number generator
C=clock;
rng(C(5)*60+C(6));
%% main
round=10000000;
Str=[0 0 0 0; 0 0 0 1; 0 0 1 0; 0 0 1 1; 0 1 0 0; 0 1 0 1; 0 1 1 0; 0 1 1 1;...
      1 0 0 0; 1 0 0 1; 1 0 1 0; 1 0 1 1; 1 1 0 0; 1 1 0 1; 1 1 1 0; 1 1 1 1;0.5 0.5 0.5 0.5];
SGpay=zeros(17,17);
SGcoop=zeros(17,17);
Str=(1-eps)*Str+eps*(1-Str);
for i = 1:17
    for j = i:17
        actA=randi([0,1]);actB=randi([0,1]);diff=0;diff1=0;
        for t=1:round
            if actA+actB==2
                SGpay(i,j)=SGpay(i,j)*(t-1)/t+PayM1(i,j)/t;
                SGpay(j,i)=SGpay(j,i)*(t-1)/t+PayM1(j,i)/t;
                SGcoop(i,j)=SGcoop(i,j)*(t-1)/t+Coop1(i,j)/t;
                SGcoop(j,i)=SGcoop(j,i)*(t-1)/t+Coop1(j,i)/t;
            else
                SGpay(i,j)=SGpay(i,j)*(t-1)/t+PayM2(i,j)/t;
                SGpay(j,i)=SGpay(j,i)*(t-1)/t+PayM2(j,i)/t;
                SGcoop(i,j)=SGcoop(i,j)*(t-1)/t+Coop2(i,j)/t;
                SGcoop(j,i)=SGcoop(j,i)*(t-1)/t+Coop2(j,i)/t;
            end
            if i<17 && j==17 %mem-cure
                if actA==1 && actB==1
                    if rand(1)<Str(i,1),actA=1; else,actA=0;end  
                elseif  actA==1 && actB==0
                    diff=diff-1;
                    if rand(1)<Str(i,2),actA=1;else,actA=0;end 
                elseif actA==0 && actB==1
                    diff=diff+1;
                    if rand(1)<Str(i,3), actA=1; else,actA=0;end  
                else
                    if rand(1)<Str(i,4), actA=1;else, actA=0;end
                end
                
                if diff<=deltaT && rand(1)<1-eps || diff>deltaT && rand(1)<eps,actB=1;else,actB=0;end
                
            elseif i==17 && j==17 %cure-cure
                if actA==1 && actB==0, diff1=diff1+1;diff=diff-1; end
                if actA==0 && actB==1, diff1=diff1-1;diff=diff+1; end
                 
                if diff1<=deltaT && rand(1)<1-eps || diff1>deltaT && rand(1)<eps,actA=1;else,actA=0;end
                if diff<=deltaT && rand(1)<1-eps || diff>deltaT && rand(1)<eps,actB=1;else,actB=0;end
                
            else
                if actA==1 && actB==1
                    if rand(1)<Str(i,1),actA=1; else,actA=0;end
                    if rand(1)<Str(j,1),actB=1;else,actB=0;end
                    
                elseif  actA==1 && actB==0
                    if rand(1)<Str(i,2),actA=1;else,actA=0;end
                    if rand(1)<Str(j,3),actB=1;else,actB=0;end
                    
                elseif actA==0 && actB==1
                    if rand(1)<Str(i,3), actA=1; else,actA=0;end
                    if rand(1)<Str(j,2),actB=1;else,actB=0;end
                else
                    if rand(1)<Str(i,4), actA=1;else, actA=0;end
                    if rand(1)<Str(j,4),actB=1;else,actB=0;end
                end
            end
                
        end
        
    end
end
%% output the payoff of stochastic PD games
dlmwrite('SPDG_payoff_001noise_b1=1.8_b2=1.01.csv', SGpay);
dlmwrite('SPDG_cooperate_001noise_b1=1.8_b2=1.01.csv', SGcoop);
end

