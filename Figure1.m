%% Load Figure 1 data

clc
clear

load('../mats/Figure_1_ABC.mat')

%%
group1 = DS_NB_adj;
group2 = Control_NB_adj;
group_data = {group1, group2};
num_groups = 2;

figureWidth = 800;
figureHeight = 600;
screenSize = get(0, 'ScreenSize');
figureLeft = (screenSize(3) - figureWidth) / 2;
figureBottom = (screenSize(4) - figureHeight) / 2;
figure('Position', [figureLeft, figureBottom, figureWidth, figureHeight]);
hold on;

% Colors
DS_all_color  = [214 138  64] / 255;   % muted orange
CTL_all_color = [ 76 123 175] / 255;   % muted blue
colors = [DS_all_color; CTL_all_color];

% ==============================
% Adjustable parameters
violin_width = 0.6;   % <--- adjust violin width (0.5 = narrow, 1.5 = wide)
box_width    = 3;     % <--- adjust box width (1 = thin, 5 = thick)
% ==============================

daviolinplot(group_data, ...
             'violin','half','colors',colors, ...
             'box',2,'boxwidth',box_width,'boxcolors','same','boxalpha',1, ...
             'violinalpha',0.5,'violinwidth',violin_width, ...
             'scatter',2,'jitter',1,'scatteralpha',1,'scattercolors','same','scattersize',30, ...
             'outliers',0,'linkline',0);   % NOTE: no linkline here

% Draw black line connecting medians of two groups
medians = cellfun(@median, group_data);
plot([1 2], medians, 'k-', 'LineWidth', 2);   % <--- LINK LINE = BLACK


yticks(0:100:300);


ax = gca;

% 1) Leave only bottom/left ticks
ax.Box = 'off';
ax.TickDir = 'out';
ax.TickLength = [0.015 0.015];
ax.XMinorTick = 'off';
ax.YMinorTick = 'off';

ax.LineWidth = 3;
ax.XAxis.LineWidth = 3;
ax.YAxis.LineWidth = 3;
ax.Layer = 'top';

% 2) Add headroom for significance bar
yl = ylim;
ylim([yl(1), yl(2) + 0.15*range(yl)]);

% 3) Draw top/right borders manually (NO ticks possible)
xl = xlim; yl = ylim;
hold on;
line([xl(1) xl(2)], [yl(2) yl(2)], 'Color','k', 'LineWidth', ax.LineWidth, 'Clipping','off'); % top
line([xl(2) xl(2)], [yl(1) yl(2)], 'Color','k', 'LineWidth', ax.LineWidth, 'Clipping','off'); % right
hold off;

% Remove x-axis numerical labels
set(gca, 'XTickLabel', []);

% Remove y-axis numerical labels
set(gca, 'YTickLabel', []);

hold off;

x = group1(:);
y = group2(:);

% Mean difference, 95% CI, and p-value
mean_diff = mean(x) - mean(y);
[~, p, CI] = ttest2(x, y, 'Alpha', 0.05);

fprintf('Mean difference (DS - Control): %.2f\n', mean_diff);
fprintf('95%% CI: [%.2f, %.2f]\n', CI(1), CI(2));
fprintf('p = %.4g\n', p);

%%
group1 = DS_EC_adj;
group2 = Control_EC_adj;
group_data = {group1, group2};
num_groups = 2;

figureWidth = 800;
figureHeight = 600;
screenSize = get(0, 'ScreenSize');
figureLeft = (screenSize(3) - figureWidth) / 2;
figureBottom = (screenSize(4) - figureHeight) / 2;
figure('Position', [figureLeft, figureBottom, figureWidth, figureHeight]);
hold on;

% Colors
DS_all_color  = [214 138  64] / 255;   % muted orange
CTL_all_color = [ 76 123 175] / 255;   % muted blue
colors = [DS_all_color; CTL_all_color];

% ==============================
% Adjustable parameters
violin_width = 0.6;   % <--- adjust violin width (0.5 = narrow, 1.5 = wide)
box_width    = 3;     % <--- adjust box width (1 = thin, 5 = thick)
% ==============================

daviolinplot(group_data, ...
             'violin','half','colors',colors, ...
             'box',2,'boxwidth',box_width,'boxcolors','same','boxalpha',1, ...
             'violinalpha',0.5,'violinwidth',violin_width, ...
             'scatter',2,'jitter',1,'scatteralpha',1,'scattercolors','same','scattersize',30, ...
             'outliers',0,'linkline',0);   % NOTE: no linkline here

% Draw black line connecting medians of two groups
medians = cellfun(@median, group_data);
plot([1 2], medians, 'k-', 'LineWidth', 2);   % <--- LINK LINE = BLACK


yticks(1200:600:4000);


ax = gca;
% 1) Leave only bottom/left ticks
ax.Box = 'off';
ax.TickDir = 'out';
ax.TickLength = [0.015 0.015];
ax.XMinorTick = 'off';
ax.YMinorTick = 'off';

ax.LineWidth = 3;
ax.XAxis.LineWidth = 3;
ax.YAxis.LineWidth = 3;
ax.Layer = 'top';

% 2) Add headroom for significance bar
yl = ylim;
ylim([yl(1), yl(2) + 0.15*range(yl)]);

% 3) Draw top/right borders manually (NO ticks possible)
xl = xlim; yl = ylim;
hold on;
line([xl(1) xl(2)], [yl(2) yl(2)], 'Color','k', 'LineWidth', ax.LineWidth, 'Clipping','off'); % top
line([xl(2) xl(2)], [yl(1) yl(2)], 'Color','k', 'LineWidth', ax.LineWidth, 'Clipping','off'); % right
hold off;

% Remove x-axis numerical labels
set(gca, 'XTickLabel', []);

% Remove y-axis numerical labels
set(gca, 'YTickLabel', []);

hold off;

x = group1(:);
y = group2(:);

% Mean difference, 95% CI, and p-value
mean_diff = mean(x) - mean(y);
[~, p, CI] = ttest2(x, y, 'Alpha', 0.05);

fprintf('Mean difference (DS - Control): %.2f\n', mean_diff);
fprintf('95%% CI: [%.2f, %.2f]\n', CI(1), CI(2));
fprintf('p = %.4g\n', p);

%%
% exportgraphics(gcf, '/home/yzm5278/DS_paper/Figure1/PSC_DS_Control.png', 'Resolution', 300);

group1 = DS_PSC_adj;
group2 = Control_PSC_adj;
group_data = {group1, group2};
num_groups = 2;

figureWidth = 800;
figureHeight = 600;
screenSize = get(0, 'ScreenSize');
figureLeft = (screenSize(3) - figureWidth) / 2;
figureBottom = (screenSize(4) - figureHeight) / 2;
figure('Position', [figureLeft, figureBottom, figureWidth, figureHeight]);
hold on;

% Colors
DS_all_color  = [214 138  64] / 255;   % muted orange
CTL_all_color = [ 76 123 175] / 255;   % muted blue
colors = [DS_all_color; CTL_all_color];

% ==============================
% Adjustable parameters
violin_width = 0.6;   % <--- adjust violin width (0.5 = narrow, 1.5 = wide)
box_width    = 3;     % <--- adjust box width (1 = thin, 5 = thick)
% ==============================

daviolinplot(group_data, ...
             'violin','half','colors',colors, ...
             'box',2,'boxwidth',box_width,'boxcolors','same','boxalpha',1, ...
             'violinalpha',0.5,'violinwidth',violin_width, ...
             'scatter',2,'jitter',1,'scatteralpha',1,'scattercolors','same','scattersize',30, ...
             'outliers',0,'linkline',0);   % NOTE: no linkline here

% Draw black line connecting medians of two groups
medians = cellfun(@median, group_data);
plot([1 2], medians, 'k-', 'LineWidth', 2);   % <--- LINK LINE = BLACK


yticks(1000:500:4000);

ax = gca;
% 1) Leave only bottom/left ticks
ax.Box = 'off';
ax.TickDir = 'out';
ax.TickLength = [0.015 0.015];
ax.XMinorTick = 'off';
ax.YMinorTick = 'off';

ax.LineWidth = 3;
ax.XAxis.LineWidth = 3;
ax.YAxis.LineWidth = 3;
ax.Layer = 'top';

% 2) Add headroom for significance bar
yl = ylim;
ylim([yl(1), yl(2) + 0.15*range(yl)]);

% 3) Draw top/right borders manually (NO ticks possible)
xl = xlim; yl = ylim;
hold on;
line([xl(1) xl(2)], [yl(2) yl(2)], 'Color','k', 'LineWidth', ax.LineWidth, 'Clipping','off'); % top
line([xl(2) xl(2)], [yl(1) yl(2)], 'Color','k', 'LineWidth', ax.LineWidth, 'Clipping','off'); % right
hold off;

% Remove x-axis numerical labels
set(gca, 'XTickLabel', []);

% Remove y-axis numerical labels
set(gca, 'YTickLabel', []);

hold off;

x = group1(:);
y = group2(:);

% Mean difference, 95% CI, and p-value
mean_diff = mean(x) - mean(y);
[~, p, CI] = ttest2(x, y, 'Alpha', 0.05);

fprintf('Mean difference (DS - Control): %.2f\n', mean_diff);
fprintf('95%% CI: [%.2f, %.2f]\n', CI(1), CI(2));
fprintf('p = %.4g\n', p);


%% ========================================================================
%
%       Figure 1 NB vs. Abeta
%
% =========================================================================
clc
clear
load('.../mats/Figure1_D.mat')

%%
data1 = DS_AbetaPos_NB_adjwithgroup;
data2 = DS_AbetaPos_Abeta_adjwithgroup;

% ---- Colors ----
dot_color = [80 80 80] / 255;
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

plot(xline_vals, yfit, 'Color', line_color, 'LineWidth', 3);

[rho_val, p_val] = corr(x_all, y_all, ...
    'Type','Spearman', 'Rows','complete');

fprintf('Spearman rho = %.3f, p = %.3g\n', rho_val, p_val);

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

fprintf('\n========== Aβ+ DS: NB vs Abeta ==========\n');
fprintf('N = %d\n',N);
fprintf('Spearman rho = %.3f\n',rho_val);
fprintf('95%% CI = [%.3f, %.3f]\n',CI_rho(1),CI_rho(2));
fprintf('p = %.4g\n',p_val);

%%
data1 = Control_NB_adjwithinCtrl;
data2 = Control_Abeta_adjwithinCtrl;

% ---- Colors ----
dot_color = [80 80 80] / 255;
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

plot(xline_vals, yfit, 'Color', line_color, 'LineWidth', 3);

[rho_val, p_val] = corr(x_all, y_all, ...
    'Type','Spearman', 'Rows','complete');

fprintf('Spearman rho = %.3f, p = %.3g\n', rho_val, p_val);

xticks(200:50:300);
yticks(0:20:300);

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

fprintf('\n========== Control: NB vs Abeta ==========\n');
fprintf('N = %d\n',N);
fprintf('Spearman rho = %.3f\n',rho_val);
fprintf('95%% CI = [%.3f, %.3f]\n',CI_rho(1),CI_rho(2));
fprintf('p = %.4g\n',p_val);











