clc
clear

load('.../mats/FigureS3.mat')

%%
age_thr = 35;

group_data = {
    DS_NB_adj_EC_noAge_young, ...          % DS-young
    Control_NB_adj_EC_noAge_young, ...% Control-young
    DS_NB_adj_EC_noAge_old, ...           % DS-old
    Control_NB_adj_EC_noAge_old ...  % Control-old
};

num_groups = numel(group_data);

% --- Figure setup ---
figureWidth = 900;
figureHeight = 500;
screenSize = get(0, 'ScreenSize');
figureLeft = (screenSize(3) - figureWidth) / 2;
figureBottom = (screenSize(4) - figureHeight) / 2;
figure('Position', [figureLeft, figureBottom, figureWidth, figureHeight]);
hold on;

% --- Color palette (our final palette) ---
DS_young_color  = [255 167  66] / 255;   % vibrant orange
CTL_young_color = [103 169 207] / 255;   % light blue
DS_old_color    = [179  71   0] / 255;   % burnt orange
CTL_old_color   = [ 33 102 172] / 255;   % dark blue

colors = [
    DS_young_color;
    CTL_young_color;
    DS_old_color;
    CTL_old_color
];

% Adjustable widths
violin_width = 0.6;
box_width = 3;

% --- Violin plot ---
daviolinplot(group_data, ...
    'violin','half','colors',colors, ...
    'box',2,'boxwidth',box_width,'boxcolors','same','boxalpha',1, ...
    'violinalpha',0.5,'violinwidth',violin_width, ...
    'scatter',2,'jitter',1,'scatteralpha',1,'scattercolors','same','scattersize',30, ...
    'outliers',0,'linkline',0);

% --- Median line across groups ---
% medians = cellfun(@median, group_data);
% plot(1:num_groups, medians, 'k-', 'LineWidth', 2);

% --- Axis labels ---
yticks(0:100:300);

ax = gca;
ax.XAxis.LineWidth = 3;
ax.YAxis.LineWidth = 3;
ax.XAxis.FontSize  = 20;
ax.YAxis.FontSize  = 20;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';


box off;
hold off;

set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
% ======================================
% Pairwise t-tests and full inferential statistics
% ======================================

group_names = {'DS-young','Control-young','DS-old','Control-old'};
num_groups = numel(group_data);

p_mat = nan(num_groups);

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

        % Remove non-finite values
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
        [~, p_val, CI_mean_difference, stats] = ttest2(g1, g2,'Vartype','unequal');

        p_mat(i,j) = p_val;

        fprintf('\n---------------------------------------------------------------\n');
        fprintf('%s  vs  %s\n', group_names{i}, group_names{j});

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
age_thr = 35;

group_data = {
    DS_NBEC_ratio_young, ...          % DS-young
    Control_NBEC_ratio_young, ...% Control-young
    DS_NBEC_ratio_old, ...           % DS-old
    Control_NBEC_ratio_old, ...  % Control-old
};

num_groups = numel(group_data);

% --- Figure setup ---
figureWidth = 900;
figureHeight = 500;
screenSize = get(0, 'ScreenSize');
figureLeft = (screenSize(3) - figureWidth) / 2;
figureBottom = (screenSize(4) - figureHeight) / 2;
figure('Position', [figureLeft, figureBottom, figureWidth, figureHeight]);
hold on;

% --- Color palette (our final palette) ---
DS_young_color  = [255 167  66] / 255;   % vibrant orange
CTL_young_color = [103 169 207] / 255;   % light blue
DS_old_color    = [179  71   0] / 255;   % burnt orange
CTL_old_color   = [ 33 102 172] / 255;   % dark blue

colors = [
    DS_young_color;
    CTL_young_color;
    DS_old_color;
    CTL_old_color
];

% Adjustable widths
violin_width = 0.6;
box_width = 3;

% --- Violin plot ---
daviolinplot(group_data, ...
    'violin','half','colors',colors, ...
    'box',2,'boxwidth',box_width,'boxcolors','same','boxalpha',1, ...
    'violinalpha',0.5,'violinwidth',violin_width, ...
    'scatter',2,'jitter',1,'scatteralpha',1,'scattercolors','same','scattersize',30, ...
    'outliers',0,'linkline',0);

% --- Median line across groups ---
% medians = cellfun(@median, group_data);
% plot(1:num_groups, medians, 'k-', 'LineWidth', 2);

% --- Axis labels ---
yticks(0.06:0.04:0.14);

ax = gca;
ax.XAxis.LineWidth = 3;
ax.YAxis.LineWidth = 3;
ax.XAxis.FontSize  = 20;
ax.YAxis.FontSize  = 20;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';


box off;
hold off;


% ======================================
% Pairwise t-tests and full inferential statistics
% ======================================

group_names = {'DS-young','Control-young','DS-old','Control-old'};
num_groups = numel(group_data);

p_mat = nan(num_groups);

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

        % Remove non-finite values
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
        [~, p_val, CI_mean_difference, stats] = ttest2(g1, g2,'Vartype','unequal');

        p_mat(i,j) = p_val;

        fprintf('\n---------------------------------------------------------------\n');
        fprintf('%s  vs  %s\n', group_names{i}, group_names{j});

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

set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);