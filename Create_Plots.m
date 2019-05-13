
%% Init the text file
clear
% fileID = fopen('Summed Data.txt','w');
% fprintf(fileID,['Fitmethod expo minparams mass speed mvt_duration torque torque_rsq force '...
%     'force_rsq active_state active_state_rsq neural_drive neural_drive_rsq '...
%     'umber umber_rsq \n']);


excel_file = 'Data_5-9-2019.csv';
fileID=fopen(excel_file,'w');
A={'c'...
    ',subj'...
    ',speed'...
    ',movedur'...
    ',mpowernet'...
    ',minfunc'...
    ',sumtorque'...
    ',sumforceout'...
    ',sumforcemus'...
    ',sumstress'...
    ',sumactstate',...
    ',sumdrive'...
    ',sumumber'};
fprintf(fileID,'%s',A{:});
% fprintf(fileID,A);
fprintf(fileID,'\n');

%%
expo = 1;
fit_methods = {'linear','squared','free'};

minparams = {'umberger','stress','force','act','drive','stress2','force2','act2','drive2'};
% minparams = {'stress','force','act','drive','stress2','force2','act2','drive2'};
% plotting = 'sensitivity';
if exist('plotting','var') & strcmp(plotting,'sensitivity')
    figure(5);clf(5);
    figure(6);clf(6);
    figure(7);clf(7);
    figure(8);clf(8);
    figure(9);clf(9);
end
% 
% main_folder = 'e:\Users\Gary\Google Drive\Muscle modeling\Min_jerk files';
% main_folder = 'C:\Users\Gary\Google Drive\Muscle modeling\Min_jerk files';
% main_folder = 'E:\Documents\Google Drive\Muscle modeling\Min_jerk files';
main_folder = 'D:\Users\Gary\Google Drive\2019 Model';
count = 1;
for p = 1:1%length(fit_methods)
    for expo = 1:1
        for k1 = 1:length(minparams)
%             close all
            clearvars -except main_folder k1 p minparams expo fit_methods ...
                fit_method count plotting RSQ_matrix Comp_matrix fileID excel_file
            fit_method = fit_methods{p};
            fprintf('Processing fit %s, expo %g, minparam %s\n',fit_methods{p},expo,minparams{k1});
            
            cd([main_folder filesep '2019 Data']);
            load(sprintf('aa_%scost_05-09-2019.mat',minparams{k1}));
%             c = 4;
%             for t = 1:8
%                 for s = 1:6
%                     vars{c,s,t}.speeds = [0.4244, 0.5449, 0.7561, 0.9750, 1.1892, 1.3996];
%                 end
%             end

%             titlestr = sprintf('%scost var%g',minparams{k1},expo,fit_methods{p});
            titlestr = sprintf('%scost',minparams{k1});
            graphstr = sprintf('%scost var%g, fit %s.fig',minparams{k1},expo,fit_methods{p});
%             titlestr2 = sprintf('%scost var%g',minparams{k1},expo,fit_methods{p});
            titlestr2 = sprintf('%scost',minparams{k1});
            graphstr2 = sprintf('%scost compare var%g, fit%s.fig',minparams{k1},expo,fit_methods{p});
            
            umbstr = sprintf('%scost var%g, fit %s.fig',minparams{k1},expo,fit_methods{p});


            cd(main_folder);
            Plotting;
%             Fit_to_meta;
            count = count+1;
        end
    end
end

fclose(fileID);

% if exist('RSQ_matrix')
%     save('RSQ_matrix.mat','RSQ_matrix');
%     save('Comp_matrix.mat','Comp_matrix');
% end

[C,I] = max(RSQ_matrix(:));
RSQ_matrix(I);

RSQ_matrix2 = RSQ_matrix(:,1,:,:);
[C,I] = max(RSQ_matrix2(:));
% save('Rsq_matrix','RSQ_matrix');
varfit= {'Drive','Act State','Force','Torque','Umberger'};
[l1,l2,l3,l4]=ind2sub(size(RSQ_matrix2),I);
% [3,2,7,5]
sprintf('The max R^2 is %0.2f \n Fitting: %s \n Expo = %g \n Minparam = %s \n Var = %s',...
    RSQ_matrix2(I),fit_methods{l1},l2,minparams{l3},varfit{l4})
% 

%% Bar plotting
cd(main_folder);
load('Rsq_matrix.mat')
cd([main_folder filesep 'Graphs']);
figure(40);clf(40);
minparams = {'umberger','stress','force','act','drive','stress2','force2','act2','drive2'};
minparams2 = {'force','force2','stress','stress2','act','act2','drive','drive2','umberger'};
varfit= {'Torque','Force','Act State','Drive','Umberger'};
d = reshape(RSQ_matrix(1,2,:,:),[9,5])';
cd(main_folder);
load('Rsq_matrix2.mat')
cd([main_folder filesep 'Graphs']);
d1 = reshape(RSQ_matrix(1,1,:,:),[9,5])';
order = [3,7,2,6,4,8,5,9,1];
% for k = 1:length(order)
%     d_plot(1,k) = d(4,order(k));
%     if d_plot(1,k) ~= d_plot(1,1);
%         d_plot(1,k) = d_plot(1,1);
%     end
%     d_plot(2,k) = d(3,order(k));
%     d_plot(3,k) = d(2,order(k));
%     d_plot(4,k) = d(1,order(k));
%     d_plot(5,k) = d1(5,order(k));
% end
for k = 1:9
    
    d_plot(1,k) = d1(4,order(k));
    d_plot(2,k) = d(4,order(k));
    if d_plot(1,k) ~= d_plot(1,1);
        d_plot(1,k) = d_plot(1,1);
    end
    if d_plot(2,k) ~= d_plot(2,1);
        d_plot(2,k) = d_plot(2,1);
    end
    d_plot(3,k) = d1(3,order(k));
    d_plot(4,k) = d(3,order(k));
    
    d_plot(5,k) = d1(2,order(k));
    d_plot(6,k) = d(2,order(k));
    
    d_plot(7,k) = d1(1,order(k));
    d_plot(8,k) = d(1,order(k));
    
    d_plot(9,k) = d1(5,order(k));
end

h=bar(d_plot);
legend(minparams2,'Location','southeast');
varfit= {'Torque','Torque2','Force','Force2','Act State','Act State2','Drive','Drive2','Umberger'};
set(gca,'XTickLabel',varfit);
ax = gca;
ax.XAxis.FontSize = 13;
ax.YAxis.FontSize = 13;
% xtickangle(45);
ylabel('R-squared Value','FontSize',13);xlabel('Neuromechanical Proxy','FontSize',13);
title('Linear','FontSize',15);

for k = 1:9
    for L = 1:9
        t = text(h(L).XData(k)+h(L).XOffset,h(L).YData(k),num2str(h(L).YData(k).','%.3f'), ...
                          'VerticalAlignment','bottom','horizontalalign','center',...
                          'Rotation',90);
        t.FontSize = 13;
    end
end
ylim([.46 .86]);
beautifyfig;
% savefig('RSQ_linear');
% print('RSQ_linear','-depsc');
% print('RSQ_linear','-dpng');
% 
% figure(42);clf(42);
% h=bar(reshape(RSQ_matrix(3,1,:,:),[9,5]));
% legend(varfit,'Location','southeast');
% set(gca,'XTickLabel',minparams);
% ax = gca;
% ax.XAxis.FontSize = 13;
% ax.YAxis.FontSize = 13;
% xtickangle(45);
% ylabel('R-squared Value','FontSize',13);xlabel('Minimization Parameter','FontSize',13);
% title('Free','FontSize',15);
% for L = 1:5
%     for k = 1:9
%         t = text(h(L).XData(k)+h(L).XOffset,h(L).YData(k),num2str(h(L).YData(k).','%.2f'), ...
%                           'VerticalAlignment','bottom','horizontalalign','center');
%         t.FontSize = 13;
%     end
% end
% % savefig('RSQ_Free');
% % print('RSQ_Free','-depsc');
% % print('RSQ_Free','-dpng');
% 
% 
load('Rsq_matrix.mat')
% load('Rsq_matrix2.mat')
figure(47);clf(47);
minparams = {'umberger','stress','force','act','drive','stress2','force2','act2','drive2'};
varfit= {'Joint Torque','Muscle Force','Active State','Nerual Drive','Umberger'};
% h=bar(reshape(RSQ_matrix(1,1,:,:),[9,5]));
% d_plot = [fliplr(reshape(RSQ_matrix(1,1,8,1:4),[1,4])),RSQ_matrix(1,1,8,5)];
% order = [4,9,3,8,2,7,1,6,5];
% for k = order
%     if k<=5
%         d_plot(k) = squeeze(RSQ_matrix(1,1,8,k));
%     else
%         d_plot(k) = squeeze(RSQ_matrix(1,2,8,k-5));
%     end
% end
d_plot2 = d_plot(:,8);
    
h=bar(d_plot2);
% legend(varfit,'Location','southeast');

varfit= {'Torque','Torque2','Force','Force2','Act State','Act State2','Drive','Drive2','Umberger'};
set(gca,'XTickLabel',varfit);
ax = gca;
ax.XAxis.FontSize = 13;
ax.YAxis.FontSize = 13;
xtickangle(15);
ylabel('R-squared Value','FontSize',13);xlabel('Biomechanical Variable','FontSize',13);
title('Linear','FontSize',15);

for L = 1
    for k = 1:9
        t = text(h(L).XData(k)+h(L).XOffset,h(L).YData(k),num2str(h(L).YData(k).','%.2f'), ...
                          'VerticalAlignment','bottom','horizontalalign','center');
        t.FontSize = 13;
    end
end
ylim([0 1])
beautifyfig