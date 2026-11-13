clc
clear

load('.../mats/Figure2_AB.mat')


%%
data1 = Age_DS;           % age
data2 = Abeta_raw;  % Abeta

age_threshold = 35;              
idx_young = data1 <= age_threshold;
idx_old   = data1 >  age_threshold;

DS_young_color = [255 167  66] / 255; 
DS_old_color   = [179  71   0] / 255;

grey_reg = [0.55 0.55 0.55];   % regression (grey)
msize = 120;

figure; hold on;

% -------------------------
% Younger scatter
% -------------------------
ok_y = isfinite(data1) & isfinite(data2) & idx_young;
x_y = data1(ok_y);
y_y = data2(ok_y);

scatter(x_y, y_y, msize, DS_young_color, 'filled', ...
    'MarkerEdgeColor','k','LineWidth',0.4);

% if numel(x_y) > 2
%     b_y = polyfit(x_y, y_y, 1);
%     xfit_y = linspace(min(x_y), max(x_y), 150);
%     yfit_y = polyval(b_y, xfit_y);
%     plot(xfit_y, yfit_y, '-', 'Color', grey_reg, 'LineWidth', 2);   % GREY DASHED
% end

[rho_y, p_y] = corr(x_y, y_y, 'Type','Spearman');

% -------------------------
% Older scatter
% -------------------------
ok_o = isfinite(data1) & isfinite(data2) & idx_old;
x_o = data1(ok_o);
y_o = data2(ok_o);

scatter(x_o, y_o, msize, DS_old_color, 'filled', ...
    'MarkerEdgeColor','k','LineWidth',0.4);

% if numel(x_o) > 2
%     b_o = polyfit(x_o, y_o, 1);
%     xfit_o = linspace(min(x_o), max(x_o), 150);
%     yfit_o = polyval(b_o, xfit_o);
%     plot(xfit_o, yfit_o, '-', 'Color', grey_reg, 'LineWidth', 2);   % GREY DASHED
% end

[rho_o, p_o] = corr(x_o, y_o, 'Type','Spearman');

fprintf('Younger DS: rho = %.3f, p = %.3g\n', rho_y, p_y);
fprintf('Older   DS: rho = %.3f, p = %.3g\n', rho_o, p_o);

% -------------------------
% BLACK separator line
% -------------------------
yl = ylim;
plot([age_threshold age_threshold], yl, '--', 'Color', [0 0 0], 'LineWidth', 2);
xl = xlim;
plot(xl, [18 18], '--', 'Color', [0 0 0], 'LineWidth', 2);
%   ^^^^^^^^^^^^^^^ BLACK dotted line

% -------------------------
% Figure aesthetics
% -------------------------
xticks(30:10:300);
yticks(0:100:300);

set(gcf, 'Position', [100, 100, 800, 600]);

ax = gca;
ax.XAxis.FontSize   = 25;
ax.YAxis.FontSize   = 25;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth  = 3;
ax.YAxis.LineWidth  = 3;

box off;
hold off;

% 
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);


%%
data1 = DS_NB_young_adj;
data2 = DS_Abeta_young_adj;

% ---- Colors ----
dot_color = [255 167  66] / 255;  
line_color = [0 0 0];           

msize = 120;

figure; hold on;

scatter(data1, data2, msize, dot_color, 'filled', ...
    'MarkerEdgeColor','k', 'LineWidth',0.4);

ok = isfinite(data1) & isfinite(data2);
x_all = data1(ok);
y_all = data2(ok);

b = polyfit(x_all, y_all, 1);
xline_vals = linspace(min(x_all), max(x_all), 200);
yfit = polyval(b, xline_vals);

% -------- 95% CI --------
n  = numel(x_all);
x0 = mean(x_all);
Sxx = sum((x_all - x0).^2);
yhat_all = polyval(b, x_all);
s2 = sum((y_all - yhat_all).^2) / (n-2);

tval = tinv(0.975, n-2);   % 95% CI
SE = sqrt(s2 * (1/n + (xline_vals - x0).^2 / Sxx));
CI_upper = yfit + tval * SE;
CI_lower = yfit - tval * SE;

fill([xline_vals fliplr(xline_vals)], ...
     [CI_upper fliplr(CI_lower)], ...
     dot_color * 0.8, ...     % <-- same family, darker
     'FaceAlpha',0.25, 'EdgeColor','none');

% -------- Regression line --------
plot(xline_vals, yfit, 'Color', line_color, 'LineWidth', 2);

[rho_val, p_val] = corr(x_all, y_all, ...
    'Type','Spearman', 'Rows','complete');

fprintf('Spearman rho = %.3f, p = %.3g\n', rho_val, p_val);

xticks(200:50:4000);
yticks(0:10:300);
set(gcf, 'Position', [100, 100, 800, 600]);

ax = gca;
ax.XAxis.FontSize   = 25;
ax.YAxis.FontSize   = 25;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth  = 3;
ax.YAxis.LineWidth  = 3;

set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);

box off;

% ==============================
% Full inferential statistics
% ==============================
N = length(x_all);

nboot = 10000;
boot_rho = nan(nboot,1);

rng(1);

for bi = 1:nboot

    boot_index = randi(N,N,1);

    boot_rho(bi) = corr( ...
        x_all(boot_index), ...
        y_all(boot_index), ...
        'Type','Spearman', ...
        'Rows','complete');

end

CI_rho = prctile(boot_rho,[2.5 97.5]);

fprintf('\n========== Young DS: NB vs Abeta ==========\n');
fprintf('N = %d\n', N);
fprintf('Spearman rho = %.3f\n', rho_val);
fprintf('95%% CI of rho = [%.3f, %.3f]\n', CI_rho(1), CI_rho(2));
fprintf('p = %.4g\n', p_val);


%%
data1 = DS_NB_old_adj;
data2 = DS_Abeta_old_adj;

% ---- Colors ----
dot_color = [200  80  5] / 255;  
line_color = [0 0 0];           

msize = 120;

figure; hold on;

scatter(data1, data2, msize, dot_color, 'filled', ...
    'MarkerEdgeColor','k', 'LineWidth',0.4);

ok = isfinite(data1) & isfinite(data2);
x_all = data1(ok);
y_all = data2(ok);

b = polyfit(x_all, y_all, 1);
xline_vals = linspace(min(x_all), max(x_all), 200);
yfit = polyval(b, xline_vals);

% -------- 95% CI --------
n  = numel(x_all);
x0 = mean(x_all);
Sxx = sum((x_all - x0).^2);
yhat_all = polyval(b, x_all);
s2 = sum((y_all - yhat_all).^2) / (n-2);

tval = tinv(0.975, n-2);   % 95% CI
SE = sqrt(s2 * (1/n + (xline_vals - x0).^2 / Sxx));
CI_upper = yfit + tval * SE;
CI_lower = yfit - tval * SE;

fill([xline_vals fliplr(xline_vals)], ...
     [CI_upper fliplr(CI_lower)], ...
     dot_color * 0.8, ...     % <-- same family, darker
     'FaceAlpha',0.25, 'EdgeColor','none');

% -------- Regression line --------
plot(xline_vals, yfit, 'Color', line_color, 'LineWidth', 2);

[rho_val, p_val] = corr(x_all, y_all, ...
    'Type','Spearman', 'Rows','complete');

fprintf('Spearman rho = %.3f, p = %.3g\n', rho_val, p_val);

xticks(100:100:4000);
yticks(0:100:300);
set(gcf, 'Position', [100, 100, 800, 600]);

ax = gca;
ax.XAxis.FontSize   = 25;
ax.YAxis.FontSize   = 25;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth  = 3;
ax.YAxis.LineWidth  = 3;

set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);

box off;
% ==============================
% Full inferential statistics
% ==============================
N = length(x_all);

nboot = 10000;
boot_rho = nan(nboot,1);

rng(1);

for bi = 1:nboot

    boot_index = randi(N,N,1);

    boot_rho(bi) = corr( ...
        x_all(boot_index), ...
        y_all(boot_index), ...
        'Type','Spearman', ...
        'Rows','complete');

end

CI_rho = prctile(boot_rho,[2.5 97.5]);

fprintf('\n========== Older DS: NB vs Abeta ==========\n');
fprintf('N = %d\n', N);
fprintf('Spearman rho = %.3f\n', rho_val);
fprintf('95%% CI of rho = [%.3f, %.3f]\n', CI_rho(1), CI_rho(2));
fprintf('p = %.4g\n', p_val);


%% ========================================================================
%
%       Boxplots
%
% =========================================================================
clc
clear

load('.../mats/Figure2_CD.mat')
%%
age_thr = 35;

group_data = {
    DS_NB_adj_noAge(DS_age <= age_thr), ...          % DS-young
    Control_NB_adj_noAge(age_ctrl <= age_thr), ...% Control-young
    DS_NB_adj_noAge(DS_age > age_thr), ...           % DS-old
    Control_NB_adj_noAge(age_ctrl > age_thr) ...  % Control-old
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


%%

group_data = {
    DS_EC_adj_noAge(DS_age <= age_thr), ...          % DS-young
    Control_EC_adj_noAge(age_ctrl <= age_thr), ...% Control-young
    DS_EC_adj_noAge(DS_age > age_thr), ...           % DS-old
    Control_EC_adj_noAge(age_ctrl > age_thr) ...  % Control-old
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
yticks(1800:600:3600);

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


%%

group_data = {
    DS_PSC_adj_noAge(DS_age <= age_thr), ...          % DS-young
    Control_PSC_adj_noAge(age_ctrl <= age_thr), ...% Control-young
    DS_PSC_adj_noAge(DS_age > age_thr), ...           % DS-old
    Control_PSC_adj_noAge(age_ctrl > age_thr) ...  % Control-old
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
yticks(1000:500:2000);

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











