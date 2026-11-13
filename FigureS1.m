clc
clear

load('.../mats/FigureS1.mat')


%%
data1 = EC_AbetaPos_adj;
data2 = Abeta_AbetaPos_adj;

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

xticks(0:500:4000);
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

fprintf('\n========== Aβ+ DS: EC vs Abeta ==========\n');
fprintf('N = %d\n',N);
fprintf('Spearman rho = %.3f\n',rho_val);
fprintf('95%% CI = [%.3f, %.3f]\n',CI_rho(1),CI_rho(2));
fprintf('p = %.4g\n',p_val);


%%
data1 = NB_adj_EC_AbetaPos;
data2 = Abeta_AbetaPos_adj;

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

fprintf('\n========== Aβ+ DS: NB adjusted for EC vs Abeta ==========\n');
fprintf('N = %d\n',N);
fprintf('Spearman rho = %.3f\n',rho_val);
fprintf('95%% CI = [%.3f, %.3f]\n',CI_rho(1),CI_rho(2));
fprintf('p = %.4g\n',p_val);


%%
data1 = NB_EC_ratio;
data2 = Abeta_AbetaPos_adj;

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

xticks(0.04:0.02:4000);
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

fprintf('\n========== Aβ+ DS: NB/EC ratio vs Abeta ==========\n');
fprintf('N = %d\n',N);
fprintf('Spearman rho = %.3f\n',rho_val);
fprintf('95%% CI = [%.3f, %.3f]\n',CI_rho(1),CI_rho(2));
fprintf('p = %.4g\n',p_val);



