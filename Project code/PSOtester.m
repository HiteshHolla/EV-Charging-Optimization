clc;
clear;
close all;

%% Problem Definition

CostFunction=@(x) obj2(x);        % Cost Function

nVar=24;            % Number of Decision Variables

VarSize=[1 nVar];   % Size of Decision Variables Matrix

VarMin= -3.5;         % Lower Bound of Variables
VarMax=  5.5;         % Upper Bound of Variables


%% PSO Parameters

MaxIt=100;      % Maximum Number of Iterations

nPop=50;        % Population Size (Swarm Size)

% PSO Parameters
w=1;            % Inertia Weight
wdamp=0.97;     % Inertia Weight Damping Ratio
c1=1.5;         % Personal Learning Coefficient
c2=2.0;         % Global Learning Coefficient

% Velocity Limits
VelMax=0.2*(VarMax-VarMin);
VelMin=-VelMax;

%% Initialization

empty_particle.Position=[];
empty_particle.Cost=[];
empty_particle.Velocity=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];

particle=repmat(empty_particle,nPop,1);

GlobalBest.Cost=inf;

for i=1:nPop
    
    x=1;
    while x==1
        x=0;
    % Initialize Position
    particle(i).Position=unifrnd(VarMin,VarMax,VarSize);
    
    soc=zeros(1, nVar);
    
    % State of charge calculation
    for a=1:nVar 
                if(a==1)
                    soc(a)=0.4+((particle(i).Position(a))/54);
                else
                    soc(a)=soc(a-1)+((particle(i).Position(a))/54);
                end
    end
    % State of charge limitation        
    for a=1:nVar
            if(soc(a)>0.8)
                x=1;
                break;
            end
    end
    for a=1:13
            if(soc(a)<0.3)
                x=1;
                break;
            end        
    end
    for a=14:nVar
            if(soc(a)<0.6)
                x=1;
                break;
            end        
    end
end
    
    
       
    % Initialize Velocity
    particle(i).Velocity=zeros(VarSize);
    
    % Evaluation
    particle(i).Cost=CostFunction(particle(i).Position);
    
    % Update Personal Best
    particle(i).Best.Position=particle(i).Position;
    particle(i).Best.Cost=particle(i).Cost;
    
    % Update Global Best
    if particle(i).Best.Cost<GlobalBest.Cost
        
        GlobalBest=particle(i).Best;
        
    end
end

BestCost=zeros(MaxIt,1);                                                                                                                                       

%% PSO Main Loop

for it=1:MaxIt
    
    for i=1:nPop
        
        x=1;
        while x==1;
            x=0;
        % Update Velocity
        particle(i).Velocity = w*particle(i).Velocity ...
            +c1*rand(VarSize).*(particle(i).Best.Position-particle(i).Position) ...
            +c2*rand(VarSize).*(GlobalBest.Position-particle(i).Position);
        
        % Apply Velocity Limits
        particle(i).Velocity = max(particle(i).Velocity,VelMin);
        particle(i).Velocity = min(particle(i).Velocity,VelMax);
        
        % Update Position
        particle(i).Position = particle(i).Position + particle(i).Velocity;
        
        % Velocity Mirror Effect
        IsOutside=(particle(i).Position<VarMin | particle(i).Position>VarMax);
        particle(i).Velocity(IsOutside)=-particle(i).Velocity(IsOutside);
        
        % Apply Position Limits
        particle(i).Position = max(particle(i).Position,VarMin);
        particle(i).Position = min(particle(i).Position,VarMax);
       
        for a=1:nVar 
                if(a==1)
                    soc(a)=0.4+((particle(i).Position(a))/54);
                    
                else
                    soc(a)=soc(a-1)+((particle(i).Position(a))/54);
                     
                end
        end
        for a=1:nVar
            if(soc(a)>0.8)
                x=1;
                break;
            end
    end
    for a=1:13
            if(soc(a)<0.3)
                x=1;
                break;
            end        
    end
    
    for a=14:nVar
            if(soc(a)<0.6)
                x=1;
                break;
            end        
    end
      
        end
                   
        % Evaluation
        particle(i).Cost = CostFunction(particle(i).Position);
        
        % Update Personal Best
        if particle(i).Cost<particle(i).Best.Cost
            
            particle(i).Best.Position=particle(i).Position;
            particle(i).Best.Cost=particle(i).Cost;
            
            % Update Global Best
            if particle(i).Best.Cost<GlobalBest.Cost
             
                GlobalBest=particle(i).Best;
                
            end
       
        end
        
        
        
    end
   
       
    BestCost(it)=GlobalBest.Cost;
    
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it)/48)]);
   
    
    w=w*wdamp;
    
end

BestSol = GlobalBest;


%% Results

figure;
%plot(BestCost,'LineWidth',2)
semilogy(BestCost/48,'LineWidth',2)
xlabel('Iteration');
ylabel('Best Cost');
grid on;

for b=1:nPop
for a=1:nVar 
                if(a==1)
                    soc(a)=0.4+((particle(i).Position(a))/54);
                else
                    soc(a)=soc(a-1)+((particle(i).Position(a))/54);
                end
end

end
