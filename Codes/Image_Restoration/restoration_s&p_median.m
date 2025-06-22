clc; clear; close all;

% Set output folder
output_folder = fullfile('outputs', 'restored');
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Image file (already in root folder)
img_name = 'bremen_000007_000019_leftImg8bit.png';

% Step 1: Load and preprocess
img = imread(img_name);
gray = rgb2gray(img);

% Step 2: Add Salt & Pepper noise (density = 0.03)
noisy_sp = imnoise(gray, 'salt & pepper', 0.03);

% Step 3: Restore using median filter
restored_sp = medfilt2(noisy_sp, [3 3]);

% Step 4: Save results
imwrite(noisy_sp, fullfile(output_folder, 'bremen_noisy_sp.png'));
imwrite(restored_sp, fullfile(output_folder, 'bremen_restored_sp.png'));

% Step 5: Display results in separate figures
figure('Name', 'Original Grayscale');
imshow(gray); title('Original');

figure('Name', 'Salt & Pepper Noise');
imshow(noisy_sp); title('Salt & Pepper Noise (density = 0.03)');

figure('Name', 'Restored Image');
imshow(restored_sp); title('Restored (Median Filter)');
