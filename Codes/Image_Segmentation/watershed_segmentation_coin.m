clc; clear; close all;

% Output folder
output_folder = fullfile('outputs', 'simple_demo');
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Load built-in image
img = imread('coins.png');

% Step 1: Adaptive threshold
bw = imbinarize(img, adaptthresh(img, 0.5));
bw = imfill(bw, 'holes');
bw = bwareaopen(bw, 30);

% Step 2: Watershed segmentation
D = -bwdist(~bw);
D(~bw) = -Inf;
markers = imextendedmin(D, 2);
L = watershed(imimposemin(D, markers));
L_rgb = label2rgb(L, 'jet', 'w');

% Step 3: Show all in one figure
figure('Name', 'Watershed Comparison – Coins', 'Position', [100, 100, 1200, 400]);

subplot(1, 3, 1);
imshow(img); title('Original Grayscale');

subplot(1, 3, 2);
imshow(bw); title('Adaptive Threshold Mask');

subplot(1, 3, 3);
imshow(L_rgb); title('Watershed Result');

% Save comparison figure
exportgraphics(gcf, fullfile(output_folder, 'coins_watershed_comparison.png'));
