clc
clear

load('.../mats/Figure3.mat')

%%
rho_NB_gBOLD_early = rho_NB_gBOLD_young(early_stage);
rho_NB_gBOLD_middle = rho_NB_gBOLD_young(middle_stage);
rho_NB_gBOLD_late = rho_NB_gBOLD_young(late_stage);

rho_Abeta_gBOLD_early = rho_Abeta_gBOLD_old(early_stage);
rho_Abeta_gBOLD_middle = rho_Abeta_gBOLD_old(middle_stage);
rho_Abeta_gBOLD_late = rho_Abeta_gBOLD_old(late_stage);

%%
group1 = rho_NB_gBOLD_early;
group2 = rho_NB_gBOLD_middle;
group3 = rho_NB_gBOLD_late;

group_data = {group1, group2, group3};
num_groups = 3;

% ----------------------------------------
% Figure
% ----------------------------------------
figureWidth  = 1000;
figureHeight = 600;
screenSize   = get(0, 'ScreenSize');
figureLeft   = (screenSize(3) - figureWidth) / 2;
figureBottom = (screenSize(4) - figureHeight) / 2;

figure('Position', [figureLeft, figureBottom, figureWidth, figureHeight]);
hold on;

% ----------------------------------------
% Colors (your 3-group palette)
% ----------------------------------------
c1 = [120 200 100] / 255;   % early
c2 = [190 150 220] / 255;   % middle
c3 = [ 60  20  90] / 255;   % late
colors = [c1; c2; c3];

% ==============================
% Adjustable parameters
% ==============================
violin_width = 0.6;   % violin width
box_width    = 3;     % box outline width
% ==============================

daviolinplot(group_data, ...
             'violin','half','colors',colors, ...
             'box',2,'boxwidth',box_width,'boxcolors','same','boxalpha',1, ...
             'violinalpha',0.5,'violinwidth',violin_width, ...
             'scatter',2,'jitter',1,'scatteralpha',1,'scattercolors','same','scattersize',30, ...
             'outliers',0,'linkline',0);   % still no built-in linkline

% ----------------------------------------
% Black line connecting group medians
% ----------------------------------------
medians = cellfun(@(x) median(x,'omitnan'), group_data);
plot(1:num_groups, medians, 'k-', 'LineWidth', 2);
yline(0, '--k', 'LineWidth', 1.5);

% ----------------------------------------
% Axes style (tweak as you like)
% ----------------------------------------
yticks(0:0.4:0.4);

ax = gca;
ax.XAxis.LineWidth = 3;
ax.YAxis.LineWidth = 3;

% Example: remove numeric x labels (keep ticks at 1:3)
set(gca, 'XTick', 1:3, 'XTickLabel', []);   

% For rho, you can set your own y-ticks, e.g.:
% yticks(-0.6:0.2:0.6);

% Remove y-axis labels if you want it super clean:
set(gca, 'YTickLabel', []);

hold off;


% ======================================
% Full inferential statistics
% ======================================

group_names = {'Early','Middle','Late'};
num_groups = numel(group_data);

fprintf('\n================ GROUP DESCRIPTIVE STATISTICS ================\n');

for i = 1:num_groups

    g = group_data{i};
    g = g(isfinite(g));

    fprintf('%s: N = %d, mean = %.3f, SD = %.3f, median = %.3f\n', ...
        group_names{i}, ...
        length(g), ...
        mean(g), ...
        std(g), ...
        median(g));

end

fprintf('===============================================================\n\n');


fprintf('\n================ PAIRWISE t-tests =============================\n');

for i = 1:num_groups

    for j = i+1:num_groups

        g1 = group_data{i};
        g2 = group_data{j};

        g1 = g1(isfinite(g1));
        g2 = g2(isfinite(g2));

        N1 = length(g1);
        N2 = length(g2);

        mean1 = mean(g1);
        mean2 = mean(g2);

        sd1 = std(g1);
        sd2 = std(g2);

        median1 = median(g1);
        median2 = median(g2);

        % Point estimate
        mean_difference = mean1 - mean2;

        % Standard independent two-sample t-test
        [~, p_val, CI_mean_difference, stats] = ttest2(g1, g2);

        fprintf('\n---------------------------------------------------------------\n');
        fprintf('%s vs %s\n', group_names{i}, group_names{j});

        fprintf('%s: N = %d, mean = %.3f, SD = %.3f, median = %.3f\n', ...
            group_names{i}, N1, mean1, sd1, median1);

        fprintf('%s: N = %d, mean = %.3f, SD = %.3f, median = %.3f\n', ...
            group_names{j}, N2, mean2, sd2, median2);

        fprintf('Mean difference (%s - %s) = %.3f\n', ...
            group_names{i}, group_names{j}, mean_difference);

        fprintf('95%% CI of mean difference = [%.3f, %.3f]\n', ...
            CI_mean_difference(1), CI_mean_difference(2));

        fprintf('t(%d) = %.3f\n', stats.df, stats.tstat);

        fprintf('p = %.4g\n', p_val);

    end

end

fprintf('\n===============================================================\n\n');


%%
group1 = rho_Abeta_gBOLD_early;
group2 = rho_Abeta_gBOLD_middle;
group3 = rho_Abeta_gBOLD_late;

group_data = {group1, group2, group3};
num_groups = 3;

% ----------------------------------------
% Figure
% ----------------------------------------
figureWidth  = 1000;
figureHeight = 600;
screenSize   = get(0, 'ScreenSize');
figureLeft   = (screenSize(3) - figureWidth) / 2;
figureBottom = (screenSize(4) - figureHeight) / 2;

figure('Position', [figureLeft, figureBottom, figureWidth, figureHeight]);
hold on;

% ----------------------------------------
% Colors (your 3-group palette)
% ----------------------------------------
c1 = [120 200 100] / 255;   % early
c2 = [190 150 220] / 255;   % middle
c3 = [ 60  20  90] / 255;   % late
colors = [c1; c2; c3];

% ==============================
% Adjustable parameters
% ==============================
violin_width = 0.6;   % violin width
box_width    = 3;     % box outline width
% ==============================

daviolinplot(group_data, ...
             'violin','half','colors',colors, ...
             'box',2,'boxwidth',box_width,'boxcolors','same','boxalpha',1, ...
             'violinalpha',0.5,'violinwidth',violin_width, ...
             'scatter',2,'jitter',1,'scatteralpha',1,'scattercolors','same','scattersize',30, ...
             'outliers',0,'linkline',0);   % still no built-in linkline

% ----------------------------------------
% Black line connecting group medians
% ----------------------------------------
medians = cellfun(@(x) median(x,'omitnan'), group_data);
plot(1:num_groups, medians, 'k-', 'LineWidth', 2);
yline(0, '--k', 'LineWidth', 1.5);

% ----------------------------------------
% Axes style (tweak as you like)
% ----------------------------------------
yticks(-0.4:0.4:0.4);

ax = gca;
ax.XAxis.LineWidth = 3;
ax.YAxis.LineWidth = 3;

% Example: remove numeric x labels (keep ticks at 1:3)
set(gca, 'XTick', 1:3, 'XTickLabel', []);   

% For rho, you can set your own y-ticks, e.g.:
% yticks(-0.6:0.2:0.6);

% Remove y-axis labels if you want it super clean:
set(gca, 'YTickLabel', []);

hold off;



% ======================================
% Full inferential statistics
% ======================================

group_names = {'Early','Middle','Late'};
num_groups = numel(group_data);

fprintf('\n================ GROUP DESCRIPTIVE STATISTICS ================\n');

for i = 1:num_groups

    g = group_data{i};
    g = g(isfinite(g));

    fprintf('%s: N = %d, mean = %.3f, SD = %.3f, median = %.3f\n', ...
        group_names{i}, ...
        length(g), ...
        mean(g), ...
        std(g), ...
        median(g));

end

fprintf('===============================================================\n\n');


fprintf('\n================ PAIRWISE t-tests =============================\n');

for i = 1:num_groups

    for j = i+1:num_groups

        g1 = group_data{i};
        g2 = group_data{j};

        g1 = g1(isfinite(g1));
        g2 = g2(isfinite(g2));

        N1 = length(g1);
        N2 = length(g2);

        mean1 = mean(g1);
        mean2 = mean(g2);

        sd1 = std(g1);
        sd2 = std(g2);

        median1 = median(g1);
        median2 = median(g2);

        % Point estimate
        mean_difference = mean1 - mean2;

        % Standard independent two-sample t-test
        [~, p_val, CI_mean_difference, stats] = ttest2(g1, g2);

        fprintf('\n---------------------------------------------------------------\n');
        fprintf('%s vs %s\n', group_names{i}, group_names{j});

        fprintf('%s: N = %d, mean = %.3f, SD = %.3f, median = %.3f\n', ...
            group_names{i}, N1, mean1, sd1, median1);

        fprintf('%s: N = %d, mean = %.3f, SD = %.3f, median = %.3f\n', ...
            group_names{j}, N2, mean2, sd2, median2);

        fprintf('Mean difference (%s - %s) = %.3f\n', ...
            group_names{i}, group_names{j}, mean_difference);

        fprintf('95%% CI of mean difference = [%.3f, %.3f]\n', ...
            CI_mean_difference(1), CI_mean_difference(2));

        fprintf('t(%d) = %.3f\n', stats.df, stats.tstat);

        fprintf('p = %.4g\n', p_val);

    end

end

fprintf('\n===============================================================\n\n');








