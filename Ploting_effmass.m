s=1;
d=2;
figure(1);clf(1);
colorset = parula(4);

max1 = 0;
min1 = 100;
for c=4:-1:1
    for t=1:4
        for d=2:2
            c;
            t;
            
            if max(eff_mass{c,s,t,d})>max1
                max1 = max(eff_mass{c,s,t,d});
            end
            if min(eff_mass{c,s,t,d})<min1
                min1 = min(eff_mass{c,s,t,d});
            end
%             angle = atan2(Data{c,s,t,d}.targetposition(1),Data{c,s,t,d}.targetposition(2)-.4);
%             max(eff_mass{c,s,t,d})-min(eff_mass{c,s,t,d});
%             a(c) = polar(angle,max(eff_mass{c,s,t,d}),'x');%-min(eff_mass{c,s,t,d})
%             set(a(c),'markerfacecolor',colorset(c,:),'color',colorset(c,:),'linewidth',5);
        end
    end
end

subplot(2,2,1);
for c=4:-1:1
    for t=1:4
        for d=2:2
            angle = atan2(Data{c,s,t,d}.targetposition(1)-ro(1),Data{c,s,t,d}.targetposition(2)-ro(2));
            max(eff_mass{c,s,t,d})-min(eff_mass{c,s,t,d});
            a(c) = polarplot(angle,max(eff_mass{c,s,t,d}),'x');%-min(eff_mass{c,s,t,d})
            set(a(c),'markerfacecolor',colorset(c,:),'color',colorset(c,:),'linewidth',5);
            hold on;
        end
    end
end

legend([a(:)],{'0','3','5','8'})
title('Effective mass maximum');

subplot(2,2,2);
for c=4:-1:1
    for t=1:4
        for d=2:2
            angle = atan2(Data{c,s,t,d}.targetposition(1)-ro(1),Data{c,s,t,d}.targetposition(2)-ro(2));
%             max(eff_mass{c,s,t,d})-min(eff_mass{c,s,t,d});
            a(c) = polarplot(angle,min(eff_mass{c,s,t,d}),'x');
            set(a(c),'markerfacecolor',colorset(c,:),'color',colorset(c,:),'linewidth',5);
            hold on;
        end
    end
end

legend([a(:)],{'0','3','5','8'})
title('Effective mass minimum');

subplot(2,2,3);
for c=4:-1:1
    for t=1:4
        for d=2:2
            angle = atan2(Data{c,s,t,d}.targetposition(1)-ro(1),Data{c,s,t,d}.targetposition(2)-ro(2));
            max(eff_mass{c,s,t,d})-min(eff_mass{c,s,t,d});
            a(c) = polarplot(angle,max(eff_mass{c,s,t,d})/min(eff_mass{c,s,t,d}),'x');
            set(a(c),'markerfacecolor',colorset(c,:),'color',colorset(c,:),'linewidth',5);
            hold on;
        end
    end
end
legend([a(:)],{'0','3','5','8'})
title('Effective mass change');

subplot(2,2,4);
for c=4:-1:1
    for t=1:4
        for d=2:2
            angle = atan2(Data{c,s,t,d}.targetposition(1)-ro(1),Data{c,s,t,d}.targetposition(2)-ro(2));
            mean(eff_mass{c,s,t,d});
            a(c) = polarplot(angle,mean(eff_mass{c,s,t,d}),'x');
            set(a(c),'markerfacecolor',colorset(c,:),'color',colorset(c,:),'linewidth',5);
            hold on;
        end
    end
end
legend([a(:)],{'0','3','5','8'})
title('Mean Effective mass');

%% Eff Mass over reach
figure(22);clf(22); hold on
ColorSet = parula(4);
for k = 1:16
    [t,c] = ind2sub([4,4],k);
    subplot(4,4,k);hold on;
    s=3;
    for d = 2:2
        plot(eff_mass{c,s,t,d},'Color',ColorSet(c,:),'linewidth',3);
        text(length(eff_mass{c,s,t,d}),eff_mass{c,s,t,d}(end),...
            sprintf('%.2f',eff_mass{c,s,t,d}(end)));
    end
%     ylim([min(eff_mass{c,s,t,d})*.99,max(eff_mass{c,s,t,d})*1.01]);
    x=gca;
    text(10,x.YTick(3),sprintf('%.2f',eff_mass{c,s,t,d}(1)));
    title(sprintf('Target = %g, C = %g',t,c));
    x=gca;
    set(gca,'XTick',[0,50,100,150,200],'XTicklabel',[0,50,100,150,200]*.005);
    xlabel('Time (s)');
end
        

%% Fitting effective mass using min/max/average

% cd('D:\Users\Gary\OneDrive\Muscle modeling\Min_jerk files');
clear a_hold a b fval


[num,txt,raw] = xlsread('Met_Data.xlsx');
[a,b] = size(num);
for ii=1:a
%     txt{ii+2,1}
    if ~isempty(char(txt{ii+2,1})) && length(char(txt{ii+2,1}))>3
        if strcmp(char(txt{ii+2,1}(2:4)),'mp0')
            c=1;
            for s = 1:6
                met_data(c,s) = num(ii-1,s);
            end
        end
        if strcmp(char(txt{ii+2,1}(2:4)),'mp5')
            c=2;
            for s = 1:6
                met_data(c,s) = num(ii-1,s);
            end
        end
        if strcmp(char(txt{ii+2,1}(2:4)),'mp1')
            c=3;
            for s = 1:6
                met_data(c,s) = num(ii-1,s);
            end
        end
        if strcmp(char(txt{ii+2,1}(2:4)),'mp2')
            c=4;
            for s = 1:6
                met_data(c,s) = num(ii-1,s);
            end
        end
    end
end


c=1;
d=2;

figure(3);
for t=1:4
subplot(2,2,t);
hold on;
    for c = 1:4
    plotted = plot(eff_mass{c,s,t,d},'Color',colorset(c,:));
    end
end

for c = 1:4
for s = 1:6
    summed = 0;
    for t = 1:4
        summed = summed + eff_mass{c,s,t,d}(1);
    end
    fit_data_mean(c,s) = summed/4;
end
end

for c = 1:4
for s = 1:6
    summed = 0;
    for t = 1:4
        summed = summed + max(eff_mass{c,s,t,d});
    end
    fit_data_max(c,s) = summed/4;
end
end

for c = 1:4
for s = 1:6
    summed = 0;
    for t = 1:4
        summed = summed + min(eff_mass{c,s,t,d});
    end
    fit_data_min(c,s) = summed/4;
end
end

for c = 1:4
for s = 1:6
    summed = 0;
    for t = 1:4
        summed = summed + sum(eff_mass{c,s,t,d})*.005/vars{c,s,t,d}.speeds(s);
    end
    fit_data_int(c,s) = summed/4;
end
end


% func = @(a) func_fit(a,fit_data_mean,vars,met_data);
% options = optimset('TolFun',1E-8,'TolX',1E-8,'Display','off');
% for run = 1:20
%     [a_hold(run,:),fval(run),exitflag,output] = ...
%         fmincon(func,[2*rand(1)],...
%         [],[],[],[],[0],[5],[], options);
% end
% [a1,b]=min(fval);
% a=a_hold(b,:);
% fprintf('Meanfit exponent = %.2f\n',a);
% 
% func = @(a) func_fit(a,fit_data_max,vars,met_data);
% options = optimset('TolFun',1E-8,'TolX',1E-8,'Display','off');
% for run = 1:20
%     [a_hold(run,:),fval(run),exitflag,output] = ...
%         fmincon(func,[2*rand(1)],...
%         [],[],[],[],[0],[5],[], options);
% end
% [a1,b]=min(fval);
% a=a_hold(b,:);
% fprintf('Maxfit exponent = %.2f\n',a);
% 
% func = @(a) func_fit(a,fit_data_min,vars,met_data);
% options = optimset('TolFun',1E-8,'TolX',1E-8,'Display','off');
% for run = 1:20
%     [a_hold(run,:),fval(run),exitflag,output] = ...
%         fmincon(func,[2*rand(1)],...
%         [],[],[],[],[0],[5],[], options);
% end
% [a1,b]=min(fval);
% a=a_hold(b,:);
% fprintf('Minfit exponent = %.2f\n',a);

func2 = @(a,x) func_fit2(a,x,vars,met_data);
opts = optimset('Display','off');
[a,~,resid,~,output,~,J] = ...
    lsqcurvefit(func2,1,fit_data_min,met_data,0,2,opts);
bounds = nlparci(a,resid,'Jacobian',J);
fprintf('MinFit  a=%.2f, lb = %.2f, ub = %.2f\n',a,bounds(1),bounds(2));


func2 = @(a,x) func_fit2(a,x,vars,met_data);
opts = optimset('Display','off');
[a,~,resid,~,output,~,J] = ...
    lsqcurvefit(func2,.7,fit_data_mean,met_data,0,2,opts);
bounds = nlparci(a,resid,'Jacobian',J);
fprintf('MeanFit (inital) a=%.2f, lb = %.2f, ub = %.2f\n',a,bounds(1),bounds(2));

% figure(2);clf(2);subplot(2,1,1); hold on
% for c = 1:4
%     plot(vars{c,1,1,2}.speeds,met_data(c,:),'Color',colorset(c,:));
%     fit(c,:) = 31.4+(15.5*(fit_data_mean(c,:).^a).*(.1^1.1))./(vars{c,1,1,2}.speeds.^5);
%     plot(vars{c,1,1,2}.speeds,fit(c,:),'*','Color',colorset(c,:));
% end
% error = sum(sum((met_data-fit).^2))
% 
% 
% figure(2);subplot(2,1,2); hold on
% for c = 1:4
%     plot(vars{c,1,1,2}.speeds,met_data(c,:),'Color',colorset(c,:));
%     fit(c,:) = 31.4+(15.5*(fit_data_mean(c,:).^.7).*(.1^1.1))./(vars{c,1,1,2}.speeds.^5);
%     plot(vars{c,1,1,2}.speeds,fit(c,:),'x','Color',colorset(c,:));
% end
% error = sum(sum((met_data-fit).^2))

func2 = @(a,x) func_fit2(a,x,vars,met_data);
opts = optimset('Display','off');
[a,~,resid,~,output,~,J] = ...
    lsqcurvefit(func2,1,fit_data_max,met_data,0,2,opts);
bounds = nlparci(a,resid,'Jacobian',J);
fprintf('MaxFit  a=%.2f, lb = %.2f, ub = %.2f\n',a,bounds(1),bounds(2));


func2 = @(a,x) func_fit2(a,x,vars,met_data);
opts = optimset('Display','off');
[a,~,resid,~,output,~,J] = ...
    lsqcurvefit(func2,1,fit_data_int,met_data,0,2,opts);
bounds = nlparci(a,resid,'Jacobian',J);
fprintf('IntFit  a=%.2f, lb = %.2f, ub = %.2f\n',a,bounds(1),bounds(2));

fit_data_mean



% function [error] = func_fit(a,x,vars,y)
%     
%     func = @(a,x,s) 31.4+(15.5*(x.^a).*(.1^1.1))./(s.^5);
%     
%     s1=[vars{1,1,1,2}.speeds;vars{1,1,1,2}.speeds];
%     s2=[vars{1,1,1,2}.speeds;vars{4,1,1,2}.speeds];  
%     y_pred1 = func(a,x(1:2,:),s1);
%     y_pred2 = func(a,x(3:4,:),s2);
%     
%     error = sum(sum((y(1:2,:)-y_pred1).^2))+sum(sum((y(3:4,:)-y_pred2).^2));
%     
%     y_pred = [y_pred1;y_pred2];
% end


function [y_pred] = func_fit2(a,x,vars,y)
    
    func = @(a,x,s) 31.4+(15.5*(x.^a).*(.1^1.1))./(s.^5);
    
    s1=[vars{1,1,1,2}.speeds;vars{2,1,1,2}.speeds];
    s2=[vars{3,1,1,2}.speeds;vars{4,1,1,2}.speeds];  
    s = [s1;s2];
    y_pred = func(a,x,s);
    
    error = sum(sum((y-y_pred).^2));
end


function [error] = func_fit3(a,x,vars,y)
    
    func = @(a,x,s) 31.4+(15.5*(x.^a).*(.1^1.1))./(s.^5);
    
    s1=[vars{1,1,1,2}.speeds;vars{2,1,1,2}.speeds];
    s2=[vars{3,1,1,2}.speeds;vars{4,1,1,2}.speeds];  
    s = [s1;s2];
    y_pred = func(a,x,s);
    
    error = sum(sum((y-y_pred).^2));
end











