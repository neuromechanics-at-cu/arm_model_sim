%% Inverse Kinematics Checker
muscle_nums = {'one','two','thr','fou','fiv','six'};

c=3;subj=4;s=7;t=5;d=2;
% trial = 1;
% c=1;
% s=1;
% t=1;
% d=1;
% for s=1:6
%     for t=1:4
%         % trial = 7;
% 
%         x1=upperarm{c,subj,s,t}.length*cos(theta{c,subj,s,t}.S(:)) + ...
%             forearm{c,subj,s,t}.length*cos(theta{c,subj,s,t}.S(:)+theta{c,subj,s,t}.E(:));
%         y1=upperarm{c,subj,s,t}.length*sin(theta{c,subj,s,t}.S(:)) + ...
%             forearm{c,subj,s,t}.length*sin(theta{c,subj,s,t}.S(:)+theta{c,subj,s,t}.E(:));
% 
%         x1=x1(y1>0);
%         y1=y1(y1>0);
% 
%         figure(1);clf(1);
%         hold on
%         plot(Data{c,subj,s,t}.x(:),Data{c,subj,s,t}.y(:),'o','Color','r')
%         plot(x1,y1,'*','Color','g');
% %             viscircles(ro,vars{c,subj,s,t}.distances(d),'color','k');
%         plot(Data{c,subj,s,t}.targetposition(1),Data{c,subj,s,t}.targetposition(2),'x','Linewidth',5);
%     end
% end

%% Forward Dynamics Checker
% function [muscles] = Forward_dynamics_check(muscles,theta,forearm,upperarm,elbow,shoulder)
%[~] = Forward_dynamics_check(muscles{c,subj,s,t},theta{c,subj,s,t},forearm{c,subj,s,t}.,upperarm{c,subj,s,t}.,elbow{c,subj,s,t},shoulder{c,subj,s,t})

muscle_nums = {'an','bs','br','da','dp','pc','bb','tb'};

% if 1
    subj=1;
for c=3:4
    for s=2:5
        for t = 1:1

%     [c,s,t] = ind2sub([4,6,4],i);
% for ii = 1:size(muscles{c,subj,s,t}.one.m_arm,1)
for ii = 1:length(act{c,subj,s,t}.an)
    norm_force = vars{c,subj,s,t}.norm_force;
    for k = 1:length(muscle_nums)
        norm_length(k) = muscles{c,subj,s,t}.(muscle_nums{k}).length(ii)/muscles{c,subj,s,t}.(muscle_nums{k}).l0;
        vel(k) = muscles{c,subj,s,t}.(muscle_nums{k}).v(ii);
%         n_f(k) = muscles{c,subj,s,t}.(muscle_nums{k}).force(ii)/(norm_force*muscles{c,subj,s,t}.(muscle_nums{k}).pcsa);
    
%         a = est{c,subj,s,t}.(muscle_nums{k})(ii);
        a = act{c,subj,s,t}.(muscle_nums{k})(ii);
        
        check.stress(k,ii) = Fl_Fv_for(norm_length(k),vel(k),a)*norm_force;
        check.force(k,ii) = check.stress(k,ii)*muscles{c,subj,s,t}.(muscle_nums{k}).pcsa;
    end
    
    A1 = [muscles{c,subj,s,t}.an.m_arm_e(ii),...
        muscles{c,subj,s,t}.bs.m_arm_e(ii),...
        muscles{c,subj,s,t}.br.m_arm_e(ii),...
        0,...
        0,...
        0,...
        muscles{c,subj,s,t}.bb.m_arm_e(ii),...
        muscles{c,subj,s,t}.tb.m_arm_e(ii)];
    A2 = [0,...
        0,...
        0,...
        muscles{c,subj,s,t}.da.m_arm_s(ii),...
        muscles{c,subj,s,t}.dp.m_arm_s(ii),...
        muscles{c,subj,s,t}.pc.m_arm_s(ii),...
        muscles{c,subj,s,t}.bb.m_arm_s(ii),...
        muscles{c,subj,s,t}.tb.m_arm_s(ii)];
    A=[A1;A2];
    
    x = [check.force(1,ii),check.force(2,ii),check.force(3,ii),...
        check.force(4,ii),check.force(5,ii),check.force(6,ii),...
        check.force(7,ii),check.force(8,ii)]';

    check.elbow{c,subj,s,t}.torque_c(ii) = A1*x;
    check.shoulder{c,subj,s,t}.torque_c(ii) = A2*x;
    
%     a1 = (upperarm{c,subj,s,t}.mass * (upperarm{c,subj,s,t}.centl)^2 + upperarm{c,subj,s,t}.Ic);
%     a2 = (forearm{c,subj,s,t}.mass * (forearm{c,subj,s,t}.centl)^2 + forearm{c,subj,s,t}.Ic);
%     a3 = (forearm{c,subj,s,t}.mass * upperarm{c,subj,s,t}.length * abs(forearm{c,subj,s,t}.centl));
%     a4 = (forearm{c,subj,s,t}.mass * upperarm{c,subj,s,t}.length^2);
%     
%     clear I C qd T
%     I(1,1) = a1+a4+2*a3*cos(theta{c,subj,s,t}.E(ii))+a2;
%     I(1,2) = a2+a3*cos(theta{c,subj,s,t}.E(ii));
%     I(2,1) = a2+a3*cos(theta{c,subj,s,t}.E(ii));
%     I(2,2) = a2;
% 
%     C(1,1) = -a3*theta{c,subj,s,t}.Ed(ii)*sin(theta{c,subj,s,t}.E(ii));
%     C(1,2) = -a3*(theta{c,subj,s,t}.Ed(ii)+theta{c,subj,s,t}.Sd(ii))*sin(theta{c,subj,s,t}.E(ii));
%     C(2,1) = a3*sin(theta{c,subj,s,t}.E(ii))*theta{c,subj,s,t}.Sd(ii);
%     C(2,2) = 0;
% 
%     qd(1,1) = theta{c,subj,s,t}.Sd(ii);
%     qd(2,1) = theta{c,subj,s,t}.Ed(ii);
% 
%     T(1,1) = check.shoulder{c,subj,s,t}.torque_c(ii);
%     T(2,1) = check.elbow{c,subj,s,t}.torque_c(ii);
% 
%     qdd = I \ (T-C*qd);
    
    prm.m1 = upperarm{c,subj,s,t}.mass;
    prm.r1 = upperarm{c,subj,s,t}.centl;
    prm.l1 = upperarm{c,subj,s,t}.length;
    prm.i1 = upperarm{c,subj,s,t}.Ic;
    
    prm.m2 = forearm{c,subj,s,t}.mass;
    prm.r2 = forearm{c,subj,s,t}.l_com;
    prm.r22 = forearm{c,subj,s,t}.centl;
    prm.l2 = forearm{c,subj,s,t}.length;
    prm.i2 = forearm{c,subj,s,t}.Ic;
    
    prm.m = vars{c,subj,s,t}.masses;
    
    M11 = prm.m1*prm.r1^2 + prm.i1 +...
        (prm.m+prm.m2)*(prm.l1^2+prm.r22^2+...
        2*prm.l1*prm.r22*cos(theta{c,subj,s,t}.E(ii))) +...
        prm.i2;

    M12 = (prm.m2+prm.m)*(prm.r22^2+...
        prm.l1*prm.r22*cos(theta{c,subj,s,t}.E(ii))) +...
        prm.i2;

    M21 = M12;

    M22 = prm.m2*prm.r2^2+prm.m*prm.l2^2+prm.i2;
    
    C1 = -forearm{c,subj,s,t}.mass*forearm{c,subj,s,t}.centl*upperarm{c,subj,s,t}.length*(theta{c,subj,s,t}.Ed(ii).^2).*sin(theta{c,subj,s,t}.E(ii))-...
        2*forearm{c,subj,s,t}.mass*forearm{c,subj,s,t}.centl*upperarm{c,subj,s,t}.length*theta{c,subj,s,t}.Sd(ii).*theta{c,subj,s,t}.Ed(ii).*sin(theta{c,subj,s,t}.E(ii));

    C2 = forearm{c,subj,s,t}.mass*forearm{c,subj,s,t}.centl*upperarm{c,subj,s,t}.length*(theta{c,subj,s,t}.Sd(ii).^2).*sin(theta{c,subj,s,t}.E(ii));
    
    qdd = [M11,M12;M21,M22] \([check.shoulder{c,subj,s,t}.torque_c(ii); check.elbow{c,subj,s,t}.torque_c(ii)] - [C1;C2]);
    
%     qdd(1) = I \(check.shoulder{c,subj,s,t}.torque_c(ii) - C1);
%     qdd(1) = I \(check.elbow{c,subj,s,t}.torque_c(ii) - C2);
    
    check.theta{c,subj,s,t}.Sdd(ii) = qdd(1);
    check.theta{c,subj,s,t}.Edd(ii) = qdd(2);
end
vars{c,subj,s,t}.masses
%% Set Init Conditions
check.theta{c,subj,s,t}.S(1,:) = theta{c,subj,s,t}.S(1,:);
check.theta{c,subj,s,t}.E(1,:) = theta{c,subj,s,t}.E(1,:);
check.theta{c,subj,s,t}.Sd(1,1:length(theta{c,subj,s,t}.Sd(1,:))) = theta{c,subj,s,t}.Sd(1,:);
check.theta{c,subj,s,t}.Ed(1,1:length(theta{c,subj,s,t}.Ed(1,:))) = theta{c,subj,s,t}.Ed(1,:);

%% Calulate Kinematics
check.theta{c,subj,s,t}.Sd = (cumsum(check.theta{c,subj,s,t}.Sdd)*vars{c,subj,s,t}.time_inc+check.theta{c,subj,s,t}.Sd(1))';
check.theta{c,subj,s,t}.Ed = (cumsum(check.theta{c,subj,s,t}.Edd)*vars{c,subj,s,t}.time_inc+check.theta{c,subj,s,t}.Ed(1))';

check.theta{c,subj,s,t}.S = (cumsum(check.theta{c,subj,s,t}.Sd)*vars{c,subj,s,t}.time_inc+check.theta{c,subj,s,t}.S(1));
check.theta{c,subj,s,t}.E = (cumsum(check.theta{c,subj,s,t}.Ed)*vars{c,subj,s,t}.time_inc+check.theta{c,subj,s,t}.E(1));

check.theta{c,subj,s,t}.Sdd = check.theta{c,subj,s,t}.Sdd';
check.theta{c,subj,s,t}.Edd = check.theta{c,subj,s,t}.Edd';

check.theta{c,subj,s,t}.S = reshape(check.theta{c,subj,s,t}.S,[length(check.theta{c,subj,s,t}.S),1]);
check.theta{c,subj,s,t}.E = reshape(check.theta{c,subj,s,t}.E,[length(check.theta{c,subj,s,t}.E),1]);

check.theta{c,subj,s,t}.Sd = reshape(check.theta{c,subj,s,t}.Sd,[length(check.theta{c,subj,s,t}.Sd),1]);
check.theta{c,subj,s,t}.Ed = reshape(check.theta{c,subj,s,t}.Ed,[length(check.theta{c,subj,s,t}.Ed),1]);

check.theta{c,subj,s,t}.Sdd = reshape(check.theta{c,subj,s,t}.Sdd,[length(check.theta{c,subj,s,t}.Sdd),1]);
check.theta{c,subj,s,t}.Edd = reshape(check.theta{c,subj,s,t}.Edd,[length(check.theta{c,subj,s,t}.Edd),1]);

check.x{c,subj,s,t} = upperarm{c,subj,s,t}.length*cos(check.theta{c,subj,s,t}.S)+...
    forearm{c,subj,s,t}.length*cos(check.theta{c,subj,s,t}.S+check.theta{c,subj,s,t}.E);
check.y{c,subj,s,t} = sin(check.theta{c,subj,s,t}.S)*upperarm{c,subj,s,t}.length+...
    sin(check.theta{c,subj,s,t}.E+check.theta{c,subj,s,t}.S)*forearm{c,subj,s,t}.length;

check.vx{c,subj,s,t} = diff(check.x{c,subj,s,t})/.0025;
check.vy{c,subj,s,t} = diff(check.y{c,subj,s,t})/.0025;

% check.v(c,s,t) = sqrt(check.vx{c,subj,s,t}.^2+check.vy{c,subj,s,t}.^2)

%% Calc Error

s_error(c,s,t,d) = sum(abs((check.theta{c,subj,s,t}.S - theta{c,subj,s,t}.S)));
e_error(c,s,t,d) = sum(abs((check.theta{c,subj,s,t}.E - theta{c,subj,s,t}.E)));

%% Plot Checking

figure(1);clf(1);subplot(2,2,1);hold on;
plot(Data{c,subj,s,t}.time,check.shoulder{c,subj,s,t}.torque_c(:),'o','Color','b','Linewidth',5);
plot(Data{c,subj,s,t}.time,shoulder{c,subj,s,t}.torque(:),'x','Color','r');
title('Shoulder Torque'); legend({'Calc','Inv Dyn'});

figure(1); subplot(2,2,2); hold on;
plot(Data{c,subj,s,t}.time,check.elbow{c,subj,s,t}.torque_c(:),'o','Color','b','Linewidth',5);
plot(Data{c,subj,s,t}.time,elbow{c,subj,s,t}.torque(:),'x','Color','r');
title('Elbow Torque'); legend({'Calc','Inv Dyn'});

figure(1); subplot(2,2,3);hold on; 
plot(Data{c,subj,s,t}.time,check.theta{c,subj,s,t}.Sdd(:),'o','Color','b','Linewidth',5);
plot(Data{c,subj,s,t}.time,theta{c,subj,s,t}.Sdd(:),'x','Color','r');
title('Shoulder DD');legend({'Calc','actual'});

figure(1); subplot(2,2,4); hold on;
plot(Data{c,subj,s,t}.time,check.theta{c,subj,s,t}.Edd(:),'o','Color','b','Linewidth',5);
plot(Data{c,subj,s,t}.time,theta{c,subj,s,t}.Edd(:),'x','Color','r');
title('Elbow DD');legend({'Calc','actual'});

% figure(1); subplot(2,2,3);hold on; 
% plot(Data{c,subj,s,t}.time,check.theta{c,subj,s,t}.S(:),'o','Color','b','Linewidth',5);
% plot(Data{c,subj,s,t}.time,theta{c,subj,s,t}.S(:),'x','Color','r');
% title('Shoulder Position');legend({'Calc','actual'});
% 
% figure(1); subplot(2,2,4); hold on;
% plot(Data{c,subj,s,t}.time,check.theta{c,subj,s,t}.E(:),'o','Color','b','Linewidth',5);
% plot(Data{c,subj,s,t}.time,theta{c,subj,s,t}.E(:),'x','Color','r');
% title('Elbow Postion');legend({'Calc','actual'});

1;
% figure(1);subplot(3,2,5); hold on;
% plot(check.theta{c,subj,s,t}.Sdd(:),'o','Color','b','Linewidth',5);
% plot(theta{c,subj,s,t}.Sdd(:),'x','Color','r');
% title('Shoulder acceleration'); legend({'Calc','Inv Kine'});
% 
% figure(1); subplot(3,2,6);hold on;
% plot(check.theta{c,subj,s,t}.Edd(:),'o','Color','b','Linewidth',5);
% plot(theta{c,subj,s,t}.Edd(:),'x','Color','r');
% title('Elbow acceleration'); legend({'Calc','Inv Kine'});
c
s
t
d

drawnow;
% Colors
Colors = [...
         0  ,  0.4470  ,  0.7410;...
    0.8500  ,  0.3250  ,  0.0980;...
    0.9290  ,  0.6940  ,  0.1250;...
    0.4940  ,  0.1840  ,  0.5560;...
    0.4660  ,  0.6740  ,  0.1880;...
    0.3010  ,  0.7450  ,  0.9330;...
    0.6350  ,  0.0780  ,  0.1840;...
         0  ,  0.4470  ,  .3000];

figure(6);clf(6);subplot(2,3,1); hold on;
% ha = tight_subplot(2,2,[.01 .03],[.1 .01],[.01 .01]);
for k=1:8
    plot(0.0025*[1:length(muscles{c,subj,s,t}.(muscle_nums{k}).force)],...
        muscles{c,subj,s,t}.(muscle_nums{k}).force,'linewidth',3,'color',Colors(k,:));
end
legend(muscle_nums);
ylabel('Muscle Force (N)');
% pbaspect([1 1 1])
xlabel('Time (s)');

figure(6);subplot(2,3,2); hold on;
% ha = tight_subplot(2,2,[.01 .03],[.1 .01],[.01 .01]);
for k=1:8
    plot(0.0025*[1:length(muscles{c,subj,s,t}.(muscle_nums{k}).force)],...
        muscles{c,subj,s,t}.(muscle_nums{k}).p_force,'linewidth',3,'color',Colors(k,:));
end
legend(muscle_nums);
ylabel('Passive Muscle Force (N)');
% pbaspect([1 1 1])
xlabel('Time (s)');

figure(6);
subplot(2,3,3);hold on;
for k=1:8
%                 plot(.005*[0:length(act{c,subj,s,t}.(muscle_nums{k}))-1],act{c,subj,s,t}.(muscle_nums{k}));
    plot(0.0025*[1:length(muscles{c,subj,s,t}.(muscle_nums{k}).force)],...
        act{c,subj,s,t}.(muscle_nums{k}),'linewidth',3,'color',Colors(k,:));
end
legend(muscle_nums);
ylabel('Active State');
% pbaspect([1 1 1])
xlabel('Time (s)');

figure(6); 
subplot(2,3,4);hold on;
for k=1:8
%                 plot(.0005*[0:length(u{c,subj,s,t}.(muscle_nums{k}))-1],u{c,subj,s,t}.(muscle_nums{k}));
    plot(0.0025*[1:length(u{c,subj,s,t}.(muscle_nums{k}))],u{c,subj,s,t}.(muscle_nums{k}),'linewidth',3,'color',Colors(k,:));
end
legend(muscle_nums);
ylabel('Neural Drive');
% pbaspect([1 1 1])
xlabel('Time (s)');

figure(6); 
subplot(2,3,5);hold on;
for k=1:8
    esum = energy{c,subj,s,t}.(muscle_nums{k}).h_SL+...
        energy{c,subj,s,t}.(muscle_nums{k}).h_AM+...
        energy{c,subj,s,t}.(muscle_nums{k}).w;
%                 plot(.0005*[0:length(u{c,subj,s,t}.(muscle_nums{k}))-1],u{c,subj,s,t}.(muscle_nums{k}));
    plot(0.0025*[1:length(energy{c,subj,s,t}.(muscle_nums{k}).h_SL)],...
        esum,'linewidth',3,'color',Colors(k,:));
end
legend(muscle_nums);
ylabel('Energy Rate (J/s)');
% pbaspect([1 1 1])
xlabel('Time (s)');
% tightfig;
% beautifyfig;
drawnow;
pause(1);
        end
    end
end
% end


%% Neural Drive to active state checker
c=1;
s=1;
t=1;
d=1;
muscle_nums = {'one','two','thr','fou','fiv','six'};
if 0
for c=1:4
    for s=1:1
        for t = 1:1
            for d = 1:4
                figure(1);clf(1); hold on
                for k = 1:length(muscle_nums)
                    subplot(2,3,k);
                    plot(act{c,subj,s,t}.(muscle_nums{k}));
                    plot(est{c,subj,s,t}.(muscle_nums{k}));
                    legend({'Act State','Estimate'});
                end                
            end
        end
    end
end
end


%% Alaa stuff 6/16
muscle_nums = {'one','two','thr','fou','fiv','six'};
% masses = {'Zero','Three','Five','Eight'};
masses = {'Zero','Five','Ten','Twenty'};
t=1;
d=2;
ColorSet = parula(6);

if 0
for c = 1:4
    figure(c);clf(c);
    for k=1:length(muscle_nums)
        subplot(3,2,k);hold on
        for s = 1:6 
            plot((0:.005:.005*(length(muscles{c,subj,s,t}.(muscle_nums{k}).force)-1)),muscles{c,subj,s,t}.(muscle_nums{k}).force,'Color',ColorSet(s,:),'MarkerFaceColor',ColorSet(s,:));
            set(gca,'xtick',[0,50,100,150,200,250],'Xticklabel',[0,50,100,150,200,250]*.005);
        end
        legend({'0.45 s','0.55 s','0.70 s','0.85 s','1.00 s','1.15 s'});
        xlabel('Time');ylabel('Muscle Force');title(sprintf('Muscle # %g, Mass %s',k,masses{c}));
    end
    drawnow;
    cd('d:\Users\Gary\OneDrive\Muscle modeling\Min_jerk files\Graphs\Muscle Forces');
    figure(c);
    saveas(gcf,sprintf('Muscle Forces Mass %s.pdf',masses{c}));
end

for c = 1:4
    figure(4+c);clf(4+c);
    for k=1:length(muscle_nums)
        subplot(3,2,k);hold on
        for s = 1:6 
            plot((0:.005:.005*(length(u{c,subj,s,t}.(muscle_nums{k}))-1)),u{c,subj,s,t}.(muscle_nums{k}),'Color',ColorSet(s,:),'MarkerFaceColor',ColorSet(s,:));
            set(gca,'xtick',[0,50,100,150,200,250]*10,'Xticklabel',[0,50,100,150,200,250]*.005/10);
        end
        legend({'0.45 s','0.55 s','0.70 s','0.85 s','1.00 s','1.15 s'});
        xlabel('Time');ylabel('Neural Drive');title(sprintf('Muscle # %g, Mass %s',k,masses{c}));
    end
    drawnow;
    cd('d:\Users\Gary\OneDrive\Muscle modeling\Min_jerk files\Graphs\Neural Drive');
    saveas(gcf,sprintf('Neural Input Mass %s.pdf',masses{c}));
end
cd('d:\Users\Gary\OneDrive\Muscle modeling\Min_jerk files');



ColorSet = parula(6);
for c = 1:4
    figure(8+c);clf(8+c);
    for k=1:length(muscle_nums)
        subplot(3,2,k);hold on
        for s = 1:6 
            Colors(s) = plot((0:.005:.005*(length(act{c,subj,s,t}.(muscle_nums{k}))-1)),act{c,subj,s,t}.(muscle_nums{k}),'Color',ColorSet(s,:));%,'MarkerFaceColor',ColorSet(s,:));
            plot((0:.005:.005*(length(act{c,subj,s,t}.(muscle_nums{k}))-1)),est{c,subj,s,t}.(muscle_nums{k}),'--','Color',ColorSet(s,:),'MarkerFaceColor',ColorSet(s,:));
        end
        set(gca,'xtick',[0,50,100,150,200,250]*10,'Xticklabel',[0,50,100,150,200,250]*.005/10);
        legend([Colors(:)],{'0.45 s','0.55 s','0.70 s','0.85 s','1.00 s','1.15 s'});
        xlabel('Time');ylabel('Active State');title(sprintf('Muscle # %g, Mass %s, Uncapped',k,masses{c}));
    end
    drawnow;
    cd('d:\Users\Gary\OneDrive\Muscle modeling\Min_jerk files\Graphs\Est Act State');
    saveas(gcf,sprintf('Act_state Mass %s.pdf',masses{c}));
end
cd('d:\Users\Gary\OneDrive\Muscle modeling\Min_jerk files');

end