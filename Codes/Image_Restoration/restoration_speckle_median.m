clc; clear; close all;

% Output folder setup
output_folder = fullfile('outputs', 'restored');
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% 🔁 Change this filename to your desired image
img_name = 'hamburg_000000_016447_leftImg8bit.png';

% Load and preprocess
img = imread(img_name);
gray = rgb2gray(img);

% Step 1: Add speckle noise (multiplicative)
noisy_speckle = imnoise(gray, 'speckle', 0.04);  % adjust noise strength here

% Step 2: Restore using Wiener filter
restored_speckle = wiener2(noisy_speckle, [5 5]);

% Step 3: Save outputs
imwrite(noisy_speckle, fullfile(output_folder, 'hamburg_noisy_speckle.png'));
imwrite(restored_speckle, fullfile(output_folder, 'hamburg_restored_speckle.png'));

% Step 4: Display
figure('Name', 'Original Grayscale');
imshow(gray); title('Original (Hamburg)');

figure('Name', 'Speckle Noise');
imshow(noisy_speckle); title('Speckle Noise Added');

figure('Name', 'Restored Image');
imshow(restored_speckle); title('Restored with Wiener Filter');
