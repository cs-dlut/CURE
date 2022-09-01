
%%% Statistical analysis %%%


global fontname fontsize_small fontsize_medium fontsize_big col_noerror col_error 
global le3 bo3 wi3 he3 bo4 dxFit dyFit

load('ExperimentalData.mat'); 
colors=[0.00,0.45,0.74;
    0.85,0.33,0.10;
    0.93,0.69,0.13;
    0.49,0.18,0.56;
    0.47,0.67,0.19;
    0.30,0.75,0.93;
    0.64,0.08,0.18];
le1=0.09; bo1=0.78; wi1=0.36; he1=0.19; 
le2=0.61; bo2=bo1; wi2=wi1; he2=he1; 
le3=0.08; bo3=0.385; wi3=0.18; he3=0.12; 
bo4 = 0.06; 

fontname='Arial'; fontsize_small=11; fontsize_medium=13; fontsize_big=17;
col_noerror=colors(5,:); col_error=colors(4,:); 
lw_box=3; lw_time=3; marksize_scatter=2; 


%% NUMBER OF OBSERVATIONS PER TREATMENT %%
disp('RECORDING THE NUMBER OF PLAYERS IN EACH TREATMENT')
n_individuals = size(Decisions_noerror,1); 
n_groups = n_individuals/2 
n_rounds = 20; 

%% SANITY CHECK %%
disp('SANITY CHECK: HOW MANY ERRORS DID OCCUR IN THE ERROR TREATMENT?')
% (This number should be approximately 10%) %
Instances_of_errors = abs(Decisions_error_observed - Decisions_error_true); 
Frequency_of_errors = sum(sum(Instances_of_errors))/(n_individuals*n_rounds)

%% COMPUTING OVERALL AVERAGES FOR THE TWO TREAMENTS
disp('COMPARING OVERALL COOPERATION RATES ACROSS TWO TREATMENTS')
meancooperation_individuallevel_noerror = mean(Decisions_noerror,2);
meancooperation_individuallevel_error_true = mean(Decisions_error_true,2);
meancooperation_individuallevel_error_observed = mean(Decisions_error_observed,2);
meancooperation_grouplevel_noerror = zeros(n_groups,1); 
meancooperation_grouplevel_error_true = zeros(n_groups,1); 
meancooperation_grouplevel_error_observed = zeros(n_groups,1); 
for i=1:n_groups; 
    meancooperation_grouplevel_noerror(i)= mean(meancooperation_individuallevel_noerror(2*i-1:2*i));
    meancooperation_grouplevel_error_true(i)= mean(meancooperation_individuallevel_error_true(2*i-1:2*i));
    meancooperation_grouplevel_error_observed(i)= mean(meancooperation_individuallevel_error_observed(2*i-1:2*i));
end
clear i meancooperation_individuallevel_noerror meancooperation_individuallevel_error_true meancooperation_individuallevel_error_observed 

meancooperation_noerror = mean(meancooperation_grouplevel_noerror)
meancooperation_error_true = mean(meancooperation_grouplevel_error_true)
meancooperation_error_observed = mean(meancooperation_grouplevel_error_observed)
cooperation_stderror_noerror = std(meancooperation_grouplevel_noerror)/sqrt(n_groups);
cooperation_stderror_true = std(meancooperation_grouplevel_error_true)/sqrt(n_groups);
cooperation_stderror_observed = std(meancooperation_grouplevel_error_observed)/sqrt(n_groups);

%% Testing differences between treatments %% 
[p_AvgCoop_noerror_true,h_true,stats_true] = ranksum(meancooperation_grouplevel_noerror,meancooperation_grouplevel_error_true); p_AvgCoop_noerror_true
[p_AvgCoop_noerror_observed,h_observed,stats_observed] = ranksum(meancooperation_grouplevel_noerror,meancooperation_grouplevel_error_observed); p_AvgCoop_noerror_observed
Z_AvgCoop_noerror_true = getfield(stats_true,'zval'); Z_AvgCoop_noerror_observed = getfield(stats_observed,'zval'); 
clear h_true h_observed stats_true stats_observed 

%{
figure('Position',[100,300,400,400]); 
bar([meancooperation_noerror,meancooperation_error_true,meancooperation_error_observed])
axis([0 4 0 1])
%}

%% COMPUTING THE TIME SERIES %% 
disp('EXPLORING TIME TRENDS')
Decisions_group_noerror = zeros(n_groups,20); 
Decisions_group_error_true = zeros(n_groups,20);
Decisions_group_error_observed = zeros(n_groups,20); 
for i=1:n_groups
    Decisions_group_noerror(i,:)= mean(Decisions_noerror(2*i-1:2*i,:));
    Decisions_group_error_true(i,:) = mean(Decisions_error_true(2*i-1:2*i,:));
    Decisions_group_error_observed(i,:) = mean(Decisions_error_observed(2*i-1:2*i,:));
end
timeseries_noerror = mean(Decisions_group_noerror); 
timeseries_error_true = mean(Decisions_group_error_true); 
timeseries_error_observed = mean(Decisions_group_error_observed); 
standarderror_noerror = std(Decisions_group_noerror)/sqrt(n_groups);
standarderror_error_true = std(Decisions_group_error_true)/sqrt(n_groups);
standarderror_error_observed = std(Decisions_group_error_observed)/sqrt(n_groups);
clear i

% Testing for significant time trends %
kRounds=10; % Number of rounds to define the beginning/end of the experiment

Decisions_group_noerror_beginning = mean(Decisions_group_noerror(:,1:kRounds),2);
Decisions_group_noerror_end = mean(Decisions_group_noerror(:,20-kRounds+1:20),2);
timeaverage_noerror = [mean(Decisions_group_noerror_beginning), mean(Decisions_group_noerror_end)] 
[p_timetrend_noerror,h_timetrend_noerror,stats_timetrend_noerror] = signrank(Decisions_group_noerror_beginning,Decisions_group_noerror_end);
p_timetrend_noerror
Z_timetrend_noerror = getfield(stats_timetrend_noerror,'zval');
clear h_timetrend_noerror stats_timetrend_noerror 

Decisions_group_error_true_beginning = mean(Decisions_group_error_true(:,1:kRounds),2);
Decisions_group_error_true_end = mean(Decisions_group_error_true(:,20-kRounds+1:20),2);
timeaverage_error_true = [mean(Decisions_group_error_true_beginning), mean(Decisions_group_error_true_end)] 
[p_timetrend_error_true,h_timetrend_error_true,stats_timetrend_error_true] = signrank(Decisions_group_error_true_beginning,Decisions_group_error_true_end);
p_timetrend_error_true
Z_timetrend_error_true = getfield(stats_timetrend_error_true,'zval');
clear h_timetrend_error_true stats_timetrend_error_true 

Decisions_group_error_observed_beginning = mean(Decisions_group_error_observed(:,1:kRounds),2);
Decisions_group_error_observed_end = mean(Decisions_group_error_observed(:,20-kRounds+1:20),2);
timeaverage_error_observed = [mean(Decisions_group_error_observed_beginning), mean(Decisions_group_error_observed_end)] 
[p_timetrend_error_observed,h_timetrend_error_observed,stats_timetrend_error_observed] = signrank(Decisions_group_error_observed_beginning,Decisions_group_error_observed_end);
p_timetrend_error_observed
Z_timetrend_error_observed = getfield(stats_timetrend_error_observed,'zval');
clear h_timetrend_error_observed stats_timetrend_error_observed



%% CALCULATING SIMILARITY TO SELECT STRATEGIES %%
disp('CALCULATING SIMILARITY TO SELECT STRATEGIES'); 


% Similarity to CURE % 
threshold = 2; 
PredictedDecisions_noerror =PredictDecisionsCURE(Decisions_noerror,threshold);
PredictedDecisions_error =PredictDecisionsCURE(Decisions_error_observed,threshold);
Difference_noerror = abs(PredictedDecisions_noerror - Decisions_noerror); 
Difference_error = abs(PredictedDecisions_error - Decisions_error_true);
Distance_noerror_CURE = sum(Difference_noerror,2)';
Distance_error_CURE = sum(Difference_error,2)';
NumberOfPlayersExplainedByCure_noerror = length(find(Distance_noerror_CURE == 0))
NumberOfPlayersExplainedByCure_error = length(find(Distance_error_CURE == 0))
clear PredictedDecisions_noerror PredictedDecsions_error Difference_noerror Difference_error

% Similarity to selected Memory-1 strategies % 
M1Strategies = [1 1 0 0 0; 1 1 0 1 0; 1 1 0 1 1; 1 1 0 0 1], %Grim, TFT, FBF, WSLS

for j=1:size(M1Strategies,1); 
    FocalStrategy = M1Strategies(j,:); 
    PredictedDecisions_noerror =PredictDecisionsM1(Decisions_noerror,FocalStrategy);
    PredictedDecisions_error =PredictDecisionsM1(Decisions_error_observed,FocalStrategy);
    Difference_noerror = abs(PredictedDecisions_noerror - Decisions_noerror); 
    Difference_error = abs(PredictedDecisions_error - Decisions_error_true);
    Distance_noerror_M1(j,:) = sum(Difference_noerror,2)';
    Distance_error_M1(j,:) = sum(Difference_error,2)';
    NumberOfPlayersExplainedByM1_noerror(j,:) = length(find(Distance_noerror_M1(j,:) == 0));
    NumberOfPlayersExplainedByM1_error(j,:) = length(find(Distance_error_M1(j,:) == 0));
end
NumberOfPlayersExplainedByM1_noerror
NumberOfPlayersExplainedByM1_error
clear j FocalStrategy PredictedDecisions_noerror PredictedDecsions_error Difference_noerror Difference_error

% Similarity to AON_k, k=2 %
k=2; 
PredictedDecisions_noerror = PredictDecisionsAON(Decisions_noerror,k); 
PredictedDecisions_error = PredictDecisionsAON(Decisions_error_observed,k);
Difference_noerror = abs(PredictedDecisions_noerror - Decisions_noerror); 
Difference_error = abs(PredictedDecisions_error - Decisions_error_true);
Distance_noerror_AON = sum(Difference_noerror,2)';
Distance_error_AON = sum(Difference_error,2)';
NumberOfPlayersExplainedByAON_noerror = length(find(Distance_noerror_AON == 0))
NumberOfPlayersExplainedByAON_error = length(find(Distance_error_AON == 0))


% Similarity to TFT-ATFT % 
PredictedDecisions_noerror = PredictDecisionsTFTATFT(Decisions_noerror); 
PredictedDecisions_error = PredictDecisionsTFTATFT(Decisions_error_observed);
Difference_noerror = abs(PredictedDecisions_noerror - Decisions_noerror); 
Difference_error = abs(PredictedDecisions_error - Decisions_error_true);
Distance_noerror_TFTATFT = sum(Difference_noerror,2)';
Distance_error_TFTATFT = sum(Difference_error,2)';
NumberOfPlayersExplainedByTFTATFT_noerror = length(find(Distance_noerror_TFTATFT == 0))
NumberOfPlayersExplainedByTFTATFT_error = length(find(Distance_error_TFTATFT == 0))


% Similarity to CAPRI % 
PredictedDecisions_noerror = PredictDecisionsCAPRI(Decisions_noerror);
PredictedDecisions_error = PredictDecisionsCAPRI(Decisions_error_observed);
Difference_noerror = abs(PredictedDecisions_noerror - Decisions_noerror); 
Difference_error = abs(PredictedDecisions_error - Decisions_error_true);
Distance_noerror_CAPRI = sum(Difference_noerror,2)';
Distance_error_CAPRI = sum(Difference_error,2)';
NumberOfPlayersExplainedByCAPRI_noerror = length(find(Distance_noerror_CAPRI == 0))
NumberOfPlayersExplainedByCAPRI_error = length(find(Distance_error_CAPRI == 0))




%% DOING THE PLOTTING %% 
figure('Position',[200,200,500,600]); 

% Cooperation rates across groups %
ax1=axes('Position',[le1 bo1 wi1 he1],'FontName',fontname,'FontSize',fontsize_small,...
    'xTick',0:2,'xTickLabel',{},'yTick',0:0.2:1,'yTickLabel',{'0.0','0.2','0.4','0.6','0.8','1.0'},...
    'yMinorTick','on','TickLength',[0.035 0.035]); 
box(ax1,'off'); hold on
axis([0 2 0 1.1])
ylabel('Cooperation rate','FontSize',fontsize_medium,'FontName',fontname); 
text(1,1.18,{'Overall cooperation'},'FontName',fontname,'FontSize',fontsize_medium,...
    'HorizontalAlignment','center'); 

dx_scatter=0.2; ddx_scatter=dx_scatter*2/n_groups;
dx_box=0.3; dy=0.18; 
fill(0.5+dx_box*[-1 -1 1 1],meancooperation_noerror*[0 1 1 0],0.1*col_noerror+0.9*[1 1 1],...
    'LineStyle','none'); 
plot(0.5+dx_box*[-1 -1 1 1],meancooperation_noerror*[0 1 1 0],'Color',col_noerror,'LineWidth',lw_box);
plot(0.5-dx_scatter+ddx_scatter/2:ddx_scatter:0.5+dx_scatter-ddx_scatter/2,...
    meancooperation_grouplevel_noerror,'o','MarkerSize',marksize_scatter,'Color',col_noerror);
plot(0.5*[1 1],meancooperation_noerror+cooperation_stderror_noerror*[1 -1],'k','LineWidth',2); 
text(0.75,0.82,[num2str(meancooperation_noerror*100,'%2.1f'),'%'],...
    'FontSize',fontsize_small,'FontName',fontname,'HorizontalAlignment','center','Color',col_noerror); 
text(0.5,-dy,{'Without','errors'},'FontName',fontname,'FontSize',fontsize_medium,'Color',col_noerror,...
    'HorizontalAlignment','center'); 

fill(1.5+dx_box*[-1 -1 1 1],meancooperation_error_observed*[0 1 1 0],0.1*col_error+0.9*[1 1 1],...
    'LineStyle','none');
plot(1.5+dx_box*[-1 -1 1 1],meancooperation_error_observed*[0 1 1 0],'Color',col_error,'LineWidth',lw_box);
plot(1.5-dx_scatter+ddx_scatter/2:ddx_scatter:1.5+dx_scatter-ddx_scatter/2,...
    meancooperation_grouplevel_error_observed,'o','MarkerSize',marksize_scatter,'Color',col_error);
plot(1.5*[1 1],meancooperation_error_observed+cooperation_stderror_observed*[1 -1],'k','LineWidth',2); 
text(1.85,0.72,[num2str(meancooperation_error_observed*100,'%2.1f'),'%'],...
    'FontSize',fontsize_small,'FontName',fontname,'HorizontalAlignment','center','Color',col_error); 
text(1.5,-dy,{'With','errors'},'FontName',fontname,'FontSize',fontsize_medium,'Color',col_error,...
    'HorizontalAlignment','center');

plot([0 5],[0 0],'k'); 
plot([0.75 1.25],1.01*[1 1],'k','LineWidth',1); 
text(1,1.03,'*','FontName',fontname,'FontSize',fontsize_medium,'FontWeight','bold','HorizontalAlignment','center'); 


% Time trend %
ax2=axes('Position',[le2 bo2 wi2 he2],'FontName',fontname,'FontSize',fontsize_small,...
    'xTick',0:5:20,'xMinorTick','on','yTick',0:0.2:1,'yTickLabel',{'0.0','0.2','0.4','0.6','0.8','1.0'},...
    'yMinorTick','on','TickLength',[0.035 0.035]); 
box(ax1,'off'); hold on
axis([0 21 0 1.1])
xlabel('Round number','FontSize',fontsize_medium,'FontName',fontname); 
%ylabel('Cooperation rate','FontSize',fontsize_medium,'FontName',fontname); 
text(10.5,1.18,{'Time trend'},'FontName',fontname,'FontSize',fontsize_medium,...
    'HorizontalAlignment','center'); 

plot(1:20,timeseries_noerror+standarderror_noerror,'Color',0.3*col_noerror+0.7*[1 1 1]);
plot(1:20,timeseries_noerror-standarderror_noerror,'Color',0.3*col_noerror+0.7*[1 1 1]);
plot(1:20,timeseries_error_observed+standarderror_error_observed,'Color',0.3*col_error+0.7*[1 1 1]);
plot(1:20,timeseries_error_observed-standarderror_error_observed,'Color',0.3*col_error+0.7*[1 1 1]);

plot(1:20,timeseries_noerror,'Color',col_noerror,'LineWidth',lw_time); 
text(10,0.86,'Without errors','Color',col_noerror,'FontName',fontname,'FontSize',fontsize_medium); 
plot(1:20,timeseries_error_observed,'Color',col_error,'LineWidth',lw_time); 
text(4,0.48,'With errors','Color',col_error,'FontName',fontname,'FontSize',fontsize_medium);

% Fit by strategy %

ShowFit(Distance_noerror_CURE,Distance_error_CURE,1,'CURE'); 
ShowFit(Distance_noerror_M1(1,:),Distance_error_M1(1,:),2,'GRIM'); 
ShowFit(Distance_noerror_M1(2,:),Distance_error_M1(2,:),3,'TFT');
ShowFit(Distance_noerror_M1(3,:),Distance_error_M1(3,:),4,'FBF');
ShowFit(Distance_noerror_M1(4,:),Distance_error_M1(4,:),5,'WSLS (AON_1)');  
ShowFit(Distance_noerror_AON,Distance_error_AON,6,'AON_2'); 
ShowFit(Distance_noerror_TFTATFT,Distance_error_TFTATFT,7,'TFT-ATFT'); 
ShowFit(Distance_noerror_CAPRI,Distance_error_CAPRI,8,'CAPRI'); 

% Doing the labels%

ax0=axes('Position',[0.001 0.001 0.998 0.998]); 
text(le1-0.04,bo1+he1+0.015,'a','FontName',fontname,'FontWeight','bold','FontSize',fontsize_big);
text(le2-0.04,bo2+he2+0.015,'b','FontName',fontname,'FontWeight','bold','FontSize',fontsize_big);
text(le3-0.04,bo3+2*he3+0.02,'c','FontName',fontname,'FontWeight','bold','FontSize',fontsize_big);

text(le3+1.5*dxFit+2*wi3,bo3+2*he3+0.05,'Fitting different strategies to observed behavior','FontSize',fontsize_medium,...
        'FontName',fontname,'HorizontalAlignment','center'); 
text(le3-0.06,bo3-0.035,'Number of participants','FontSize',fontsize_medium,...
    'FontName',fontname,'HorizontalAlignment','center','Rotation',90);
text(le3+1.5*dxFit+2*wi3,bo4-0.045,'Number of rounds correctly predicted','FontSize',fontsize_medium,...
    'FontName',fontname,'HorizontalAlignment','center'); 

axis off



function ShowFit(Data_noerror,Data_error,nr,strategyname); 

global fontname fontsize_small fontsize_medium fontsize_big col_noerror col_error 
global le3 bo3 wi3 he3 bo4 dyFit dxFit

dyFit=0.13; dxFit=0.23-wi3; 
if mod(nr,4)==1, yticklab={'0','10','20','30'}; else yticklab={''}; end

%% UPPER GRAPH %%

ax1a=axes('Position',[le3+mod((nr-1),4)*(dxFit+wi3) (nr<5)*bo3+(nr>=5)*bo4+dyFit wi3 he3],'FontSize',fontsize_small,'FontName',fontname,...
    'xTick',0:5:20,'xMinorTick','off','yTick',0:10:30,'yMinorTick','off','TickLength',[0.04 0.04],...
    'yTickLabel',yticklab,'xTickLabel',{''}); 
hold on
axis([-2 22 0 38]); box(ax1a,'off'); 
for j=0:20
    index=find(Data_noerror == 20-j); 
    fill(j+0.45*[-1 1 1 -1],length(index)*[0 0 1 1],col_noerror,'LineStyle','none');
end
text(10,37,strategyname,'FontSize',fontsize_small,'FontName',fontname,'HorizontalAlignment','center'); 
text(0,28,'Correct: ','FontName',fontname,'FontSize',fontsize_small); 
text(13,28,int2str(length(index)),'FontName',fontname,'FontSize',fontsize_small,...
    'FontWeight','bold','Color',col_noerror); 
if mod(nr,4)==0
text(25,19,'Without error','FontName',fontname,'FontSize',fontsize_small,'Rotation',270,...
    'HorizontalAlignment','center','Color',col_noerror); 
end

%% LOWER GRAPH %%

ax1b=axes('Position',[le3+mod((nr-1),4)*(dxFit+wi3) (nr<5)*bo3+(nr>=5)*bo4 wi3 he3],'FontSize',fontsize_small,'FontName',fontname,...
    'xTick',0:5:20,'xMinorTick','off','yTick',0:10:30,'yMinorTick','off','TickLength',[0.05 0.05],...
    'yTickLabel',yticklab); 
hold on
axis([-2 22 0 38]); box(ax1b,'off'); 
for j=0:20
    index=find(Data_error == 20-j); 
    fill(j+0.45*[-1 1 1 -1],length(index)*[0 0 1 1],col_error,'LineStyle','none');
end
text(0,26,'Correct: ','FontName',fontname,'FontSize',fontsize_small); 
text(13,26,int2str(length(index)),'FontName',fontname,'FontSize',fontsize_small,...
    'FontWeight','bold','Color',col_error); 

if mod(nr,4)==0
text(25,19,'With error','FontName',fontname,'FontSize',fontsize_small,'Rotation',270,...
    'HorizontalAlignment','center','Color',col_error); 
end

end





function PredictedDecision = PredictDecisionsCAPRI(ObservedDecisions); 
numberofplayers = size(ObservedDecisions,1);
PredictedDecision = zeros(numberofplayers,20); 

for player=1:numberofplayers
    coplayer=player+(-1)^(player-1);
    decisions_player = ObservedDecisions(player,:);
    decisions_coplayer = ObservedDecisions(coplayer,:);
    
    % All other rounds %
    CAPRI_decisions = ...
        [1 0 0 0 1 0 0 0;
        1 0 1 0 0 0 0 0;
        0 1 0 0 1 0 0 0;
        0 0 0 0 0 0 0 0;
        1 0 1 0 1 0 1 0; 
        0 0 0 0 0 0 0 0;
        0 0 0 0 1 0 1 1;
        0 0 0 0 0 0 1 0];
    for round =1:20
        if round == 1
            playerstate = [1,1,1]; coplayerstate = [1,1,1]; 
        elseif round == 2
            playerstate = [1,1,decisions_player(round-1)]; coplayerstate = [1,1,decisions_coplayer(round-1)];
        elseif round == 3
             playerstate = [1, decisions_player(round-2), decisions_player(round-1)];
             coplayerstate = [1, decisions_coplayer(round-2), decisions_coplayer(round-1)];
        else
            playerstate = [decisions_player(round-3), decisions_player(round-2), decisions_player(round-1)];
            coplayerstate = [decisions_coplayer(round-3), decisions_coplayer(round-2), decisions_coplayer(round-1)];
        end
        inverseplayerstate = ones(1,3) - playerstate;
        inversecoplayerstate = ones(1,3) - coplayerstate; 
        player_casenumber = inverseplayerstate(1)*2^2 + inverseplayerstate(2)*2+inverseplayerstate(3)+1;
        coplayer_casenumber = inversecoplayerstate(1)*2^2+ inversecoplayerstate(2)*2+inversecoplayerstate(3)+1;
        PredictedDecision(player,round) = CAPRI_decisions(player_casenumber,coplayer_casenumber);
    end
end 
end




function PredictedDecision = PredictDecisionsTFTATFT(ObservedDecisions); 
numberofplayers = size(ObservedDecisions,1);
PredictedDecision = zeros(numberofplayers,20); 

for player=1:numberofplayers
    coplayer=player+(-1)^(player-1);
    decisions_player = ObservedDecisions(player,:);
    decisions_coplayer = ObservedDecisions(coplayer,:);
    
    % All other rounds %
    TFTATFT_decisions = [1 0 1 0 0 1 1 0 1 0 1 1 0 1 1 0];
    for round =1:20
        if round == 1, State = [1 1, 1 1]; 
        elseif round ==2, State = [1, decisions_player(round-1), 1, decisions_coplayer(round-1)]; 
        else State = [decisions_player(round-2), decisions_player(round-1), decisions_coplayer(round-2), decisions_coplayer(round-1)];
        end
        InverseState = ones(1,4) - State;
        casenumber = InverseState(1)*2^3 + InverseState(2)*2^2 + InverseState(3)*2 + InverseState(4) + 1; 
        PredictedDecision(player,round) = TFTATFT_decisions(casenumber);
    end
end 
end


function PredictedDecision = PredictDecisionsAON(ObservedDecisions,k); 
numberofplayers = size(ObservedDecisions,1);
PredictedDecision = zeros(numberofplayers,20); 

for player=1:numberofplayers
    coplayer=player+(-1)^(player-1);
    decisions_player = ObservedDecisions(player,:);
    decisions_coplayer = ObservedDecisions(coplayer,:);
    
    PredictedDecision(player,1) = 1; 
    for round =2:20
       decision=1; 
       for pastround = round-1:-1:round-k
           if pastround > 0
               if decisions_player(pastround)~=decisions_coplayer(pastround)
                decision=0; 
               end
           end
       end
       PredictedDecision(player,round) = decision;     
    end
end
end


function PredictedDecision=PredictDecisionsCURE(ObservedDecisions,Threshold); 
numberofplayers = size(ObservedDecisions,1);
PredictedDecision = zeros(numberofplayers,20); 

for player = 1:numberofplayers; 
    coplayer=player+(-1)^(player-1);
    decisions_player = ObservedDecisions(player,:);
    decisions_coplayer = ObservedDecisions(coplayer,:); 
    cumulative_player = cumsum(decisions_player);
    cumulative_coplayer = cumsum(decisions_coplayer);
    cumulativedifference = cumulative_player - cumulative_coplayer;
    cumulativedifference(end) = []; cumulativedifference=[0 cumulativedifference]; 
    prediction = (cumulativedifference<=Threshold);
    PredictedDecision(player,:) = prediction;
end
end


function PredictedDecision =PredictDecisionsM1(TrueDecisions,FocalStrategy);
numberofplayers = size(TrueDecisions,1);
PredictedDecision = zeros(numberofplayers,20); 

for player = 1:numberofplayers; 
    coplayer=player+(-1)^(player-1);
    decisions_player = TrueDecisions(player,:);
    decisions_coplayer = TrueDecisions(coplayer,:); 
    % Round 1 %
    PredictedDecision(player,1) = FocalStrategy(1); 
    for round=2:20
        if decisions_player(round-1) == 1 & decisions_coplayer(round-1) == 1
            PredictedDecision(player,round) = FocalStrategy(2); 
        elseif decisions_player(round-1) == 1 & decisions_coplayer(round-1) == 0
            PredictedDecision(player,round) = FocalStrategy(3);
        elseif decisions_player(round-1) == 0 & decisions_coplayer(round-1) == 1
            PredictedDecision(player,round) = FocalStrategy(4);
        elseif decisions_player(round-1) == 0 & decisions_coplayer(round-1) == 0
            PredictedDecision(player,round) = FocalStrategy(5);
        end
    end
end
end