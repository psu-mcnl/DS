
clc
clear

load('.../mats/FigureS2.mat')




%%

data1 = DS_EC_old_adj;
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

xticks(1600:400:2400);
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

fprintf('\n========== Older DS: EC vs Abeta ==========\n');
fprintf('N = %d\n', N);
fprintf('Spearman rho = %.3f\n', rho_val);
fprintf('95%% CI of rho = [%.3f, %.3f]\n', CI_rho(1), CI_rho(2));
fprintf('p = %.4g\n', p_val);


%%
data1 = DS_NB_adj_EC_old;
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

fprintf('\n========== Older DS: NB(adjust EC) vs Abeta ==========\n');
fprintf('N = %d\n', N);
fprintf('Spearman rho = %.3f\n', rho_val);
fprintf('95%% CI of rho = [%.3f, %.3f]\n', CI_rho(1), CI_rho(2));
fprintf('p = %.4g\n', p_val);


%%

data1 = DS_NB_EC_ratio_old;
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

xticks(0.06:0.02:0.1);
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

fprintf('\n========== Older DS: NBEC Ratio vs Abeta ==========\n');
fprintf('N = %d\n', N);
fprintf('Spearman rho = %.3f\n', rho_val);
fprintf('95%% CI of rho = [%.3f, %.3f]\n', CI_rho(1), CI_rho(2));
fprintf('p = %.4g\n', p_val);















