clc; clear; close all;

% Ensure output folder exists
output_folder = fullfile('outputs', 'restored');
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Image filename (in root folder)
img_name = 'cologne_000073_000019_leftImg8bit.png';

% Step 1: Load and preprocess image
img = imread(img_name);
gray = rgb2gray(img);            % Convert to grayscale

% Step 2: Add Gaussian noise
noisy_img = imnoise(gray, 'gaussian', 0, 0.01);  % mean = 0, var = 0.01

% Step 3: Apply Wiener filter for restoration
restored_img = wiener2(noisy_img, [5 5]);

% Step 4: Save outputs
imwrite(noisy_img, fullfile(output_folder, 'cologne_noisy.png'));
imwrite(restored_img, fullfile(output_folder, 'cologne_restored.png'));

% Step 5: Display results (3 separate figures for MATLAB Online)
figure('Name', 'Original Grayscale');
imshow(gray); title('Original');

figure('Name', 'Noisy Image');
imshow(noisy_img); title('Gaussian Noise (var = 0.01)');

figure('Name', 'Restored Image');
imshow(restored_img); title('Restored (Wiener Filter)');
