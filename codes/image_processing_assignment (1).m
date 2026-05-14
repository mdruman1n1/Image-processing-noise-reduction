image = imread('noisy_image.jpg'); 

conservative_filtered = conservative_smoothing(image);

median_filtered = median_smoothing(image);

mean_filtered = mean_smoothing(image);

figure;
subplot(2, 2, 1), imshow(image), title('Original Image');
subplot(2, 2, 2), imshow(conservative_filtered), title('Conservative Smoothing');
subplot(2, 2, 3), imshow(median_filtered), title('Median Smoothing');
subplot(2, 2, 4), imshow(mean_filtered), title('Mean Smoothing');

imwrite(conservative_filtered, 'conservative_filtered.jpg');
imwrite(median_filtered, 'median_filtered.jpg');
imwrite(mean_filtered, 'mean_filtered.jpg');