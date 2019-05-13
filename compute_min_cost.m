%% compute_min_cost.m
% Created by: Gary Bruening
% Edited:     5-13-2019
% 
% Should probably rename it.
% The main function that iterates through time to simulated the arm
% reaching motion using muscle actuators.
% 
% It will attempt the minimization mutliple times, and if it completely
% fails it will error out. Usually this occurs at the beginning of
% movements when the torque rate is to high for the muscles to achieve. 

%%
function [ muscles , act , u , est , tnew] = compute_min_cost...
    ( shoulder,elbow,theta,upperarm,forearm,vars)
format long
    
failed = 0;
muscle_nums = {'an','bs','br','da','dp','pc','bb','tb'};
[ muscles ] = calc_muscle_initvars(upperarm,forearm,theta,vars);
for ii = 1:length(shoulder.torque)
    
    % Create elbow m_arm*pcsa matrix
    A1(:,ii) = [muscles.an.m_arm_e(ii)*muscles.an.pcsa,...
        muscles.bs.m_arm_e(ii)*muscles.bs.pcsa,...
        muscles.br.m_arm_e(ii)*muscles.br.pcsa,...
        0,0,0,...
        muscles.bb.m_arm_e(ii)*muscles.bb.pcsa,...
        muscles.tb.m_arm_e(ii)*muscles.tb.pcsa];
    % Create shoulder m_arm*pcsa matrix
    A2(:,ii) = [0,0,0,...
        muscles.da.m_arm_s(ii)*muscles.da.pcsa,...
        muscles.dp.m_arm_s(ii)*muscles.dp.pcsa,...
        muscles.pc.m_arm_s(ii)*muscles.pc.pcsa,...
        muscles.bb.m_arm_s(ii)*muscles.bb.pcsa,...
        muscles.tb.m_arm_s(ii)*muscles.tb.pcsa];
    % Merge
    Aeq = [A1(:,ii)';A2(:,ii)'];
    % Create constraint matrix
    beq(:,ii) = [elbow.torque(ii);shoulder.torque(ii)];
    
    % Calculate Passive Torques
    for k = 1:length(muscle_nums)
        norm_l = muscles.(muscle_nums{k}).norm_length(ii);
        muscles.(muscle_nums{k}).p_force(ii) = ...
            68.35*0.0495*log(exp((norm_l-1.55)/(0.0495))+1)*muscles.(muscle_nums{k}).pcsa*vars.norm_force;
        fp(k) = 68.35*0.0495*log(exp((norm_l-1.55)/(0.0495))+1)*muscles.(muscle_nums{k}).pcsa*vars.norm_force;
    end
    e_tor_pas = sum(squeeze(A1(:,ii))'.*fp);
    s_tor_pas = sum(squeeze(A2(:,ii))'.*fp);
    
    % Create constraint matrix
    beq(:,ii) = [elbow.torque(ii)+e_tor_pas;shoulder.torque(ii)+s_tor_pas];
    
    % Flip stresses if needed. Occurs at high activations when minimum
    % force may be higher than maximum because of negatives.
    if ii >1
        for k = 1:length(stress_min(ii-1,:))
            if stress_min(ii-1,k)>stress_max(ii-1,k) &&...
                    stress_min(ii-1,k)<=0 &&...
                    stress_max(ii-1,k)<=0
                s_min = stress_min(ii-1,k);
                s_max = stress_max(ii-1,k);
                stress_min(ii-1,k) = s_max;
                stress_max(ii-1,k) = s_min;
            end
        end
    end
    
    % Define minimum and maximum values.
    if ii>1
        mini = stress_min(ii-1,:);
        maxi = stress_max(ii-1,:);
    else
        mini = [0,0,0,0,0,0,0,0]; maxi = [1,1,1,1,1,1,1,1]*1E10;
    end
    if sum(mini>maxi)>=1
        1;
    end

% Error checks.
if ~(beq(1,ii) > 0 && beq(1,ii) > A1(:,ii)'*[0,maxi(2),maxi(3),0,0,0,maxi(7),0]')...
            && ~(beq(1,ii) < 0 && beq(1,ii) < A1(:,ii)'*[maxi(1),0,0,0,0,0,0,maxi(8)]')...
            && ~(beq(2,ii) > 0 && beq(2,ii) > A2(:,ii)'*[0,0,0,maxi(4),0,maxi(6),maxi(7),0]')...
            && ~(beq(2,ii) < 0 && beq(2,ii) < A2(:,ii)'*[0,0,0,0,maxi(5),0,0,maxi(8)]')     
    stress_check = 0;     
else
    fprintf('Failed at c=%g,subj=%g,s=%g,t=%g,ii=',c,subj,s,t,ii);
    init_guess = maxi*.95;
    stress_check = 1;
end
    
    % Define muscle pcsa matrix
    pcsa = [muscles.an.pcsa,muscles.bs.pcsa,muscles.br.pcsa,...
        muscles.da.pcsa,muscles.dp.pcsa,muscles.pc.pcsa,...
        muscles.bb.pcsa,muscles.tb.pcsa];

    if ii==1
        minfunc2 = @(x) min_func(x,muscles,0,vars,ii,Aeq,beq);
    else
        minfunc2 = @(x) min_func(x,muscles,act,vars,ii,Aeq,beq);
    end
    
    % Find min with constraints
    options = optimoptions('fmincon','Display','off','Algorithm','sqp');%,'MaxIterations',100);
    if ii==1
        init_guess = [1;1;1;1;1;1;1;1];
    else
        init_guess = x(:,ii-1);
    end
    if stress_check == 1
        init_guess = (maxi-(maxi-mini).*rand(1,8)*.15)';
    end
    clear FVAL EXITFLAG
    % You can add to the sim that it does random starts, but it doesn't
    % seem to change the data.
    if isfield(vars,'rnjesus')
        if vars.rnjesus
            if vars.L>=8
                n_mins = 10;
            else
                n_mins = 20;
            end
        else
            n_mins = 1;
        end
    else
        n_mins = 1;
    end
    % You can change n_mins for the random starts.
    for p = 1:n_mins
        if ii == 1
            [x_temp(:,p),FVAL(p),EXITFLAG(p),OUTPUT,LAMBDA]=...
                fmincon(@(x) minfunc2(x),[1,1,1,1,1,1,1,1],[],[],...
                Aeq,beq(:,ii),mini,maxi,[],options);
        else
            % Start the guess near the minimum for each muscle, seems to
            % get pretty close to the minimums from using random starts.
            options = optimoptions('fmincon','Display','off','Algorithm','sqp');
            intg = mini.*1.01;
            if isfield(vars,'rnjesus')
                if vars.rnjesus
                    intg = mini.*(1+betarnd(1,50,[1,8]));
                else
                    intg = mini.*1.01;
                end
            else
                intg = mini.*1.01;
            end
            %Find min
            [x_temp(:,p),FVAL(p),EXITFLAG(p),OUTPUT,LAMBDA]=...
                fmincon(@(x) minfunc2(x),intg,[],[],...
                Aeq,beq(:,ii),mini,maxi,[],options);
            
            count = 1;
            % If it doesn't find a good exit keep guessing
            while EXITFLAG(p) < 1 && count<20 && sum(Aeq*x_temp(:,p)-beq(:,ii)) > 1E-6
                intg = mini.*(1+betarnd(1,50,[1,8]));
                [x_temp(:,p),FVAL(p),EXITFLAG(p),OUTPUT,LAMBDA]=...
                fmincon(@(x) minfunc2(x),intg...
                ,[],[],Aeq,beq(:,ii),mini,maxi,[],options);
                count=count+1;
            end
            
            if EXITFLAG < 1 & sum(Aeq*x_temp(:,p)-beq(:,ii))>1E-2
                %umber, i=72 breaks.
                if failed == 0;
                    fprintf('Failed at c=%g, subj=%g, s=%g, t=%g\n',c,subj,s,t);
                else
                    failed = 1;
                end
                fprintf('Didnt find min\n');
            end
        end    
        n=0;
    end
    
    % Select the minimization with FVAL the lowest.
    [a,b]=min(FVAL);
    min(FVAL);
    x(:,ii) = x_temp(:,b);
    
    % Determine the force of each muscle.
    muscles.an.force(ii,1) = x(1,ii)*muscles.an.pcsa;
    muscles.bs.force(ii,1) = x(2,ii)*muscles.bs.pcsa;
    muscles.br.force(ii,1) = x(3,ii)*muscles.br.pcsa;
    muscles.da.force(ii,1) = x(4,ii)*muscles.da.pcsa; 
    muscles.dp.force(ii,1) = x(5,ii)*muscles.dp.pcsa;
    muscles.pc.force(ii,1) = x(6,ii)*muscles.pc.pcsa;
    muscles.bb.force(ii,1) = x(7,ii)*muscles.bb.pcsa;
    muscles.tb.force(ii,1) = x(8,ii)*muscles.tb.pcsa;
    
    % Legacy Code, if you want to remove negative passive force uncomment
    % this.
%     min_force = 1E-10;
%     for k=1:length(muscle_nums)
%         if muscles.(muscle_nums{k}).force(ii) < min_force
%             muscles.(muscle_nums{k}).force(ii) = 0;
%         end
%     end
    
    % Calculate activation of each muscle.
    norm_force = vars.norm_force; %31.8E4
    for k=1:length(muscle_nums)
        n_f = muscles.(muscle_nums{k}).force(ii)/(norm_force*muscles.(muscle_nums{k}).pcsa);            
        act.(muscle_nums{k})(ii) = Fl_Fv_inv(muscles.(muscle_nums{k}).norm_length(ii)...
            ,muscles.(muscle_nums{k}).v(ii),n_f);
    end
    
    % Calculate the minimum and maximum activation stae for the next time
    % point. This is used to create the constraint matrices.
    if ii < length(shoulder.torque)
        for k=1:length(muscle_nums)
            [ min1(ii,k) , max1(ii,k) ] = find_minmax_state( act.(muscle_nums{k})(ii), vars.time_inc );            

            [ T ] = Fl_Fv_for(muscles.(muscle_nums{k}).norm_length(ii+1)...
                ,muscles.(muscle_nums{k}).v(ii+1),min1(ii,k));            
            stress_min(ii,k) = T * norm_force;        
                        
            [ T ] = Fl_Fv_for(muscles.(muscle_nums{k}).norm_length(ii+1)...
                ,muscles.(muscle_nums{k}).v(ii+1),max1(ii,k));            
            stress_max(ii,k) = T * norm_force;
        end
    end
end

% Calculate nerual drive.
for k=1:length(muscle_nums)
    [u.(muscle_nums{k}),est.(muscle_nums{k}),t,tnew.(muscle_nums{k})] = ...
    calc_drive(act.(muscle_nums{k}),vars.time_inc);
end
