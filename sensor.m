% Define region of interest
region = [250, 350, 300, 400]; % [y_start, y_end, x_start, x_end]

% Subscribe to the color and depth image topics
colorImageSub = rossubscriber('/camera/rgb/image_raw');
depthImageSub = rossubscriber('/camera/depth/image_raw');

% Initialize figures for display
colorFig = figure('Name', 'Color Image');
depthFig = figure('Name', '3D Depth Visualization');

% Receive the color image
try
    colorMsg = receive(colorImageSub, 10); % Timeout after 10 seconds
    colorImage = readImage(colorMsg);

    % Display the color image
    figure(colorFig);
    imshow(colorImage);
    title('Color Image');

    % Add dynamic axis with variable tick spacing
    axis on;
    [height, width, ~] = size(colorImage);
    xlim([0.5, width + 0.5]);
    ylim([0.5, height + 0.5]);

    % Determine tick spacing based on default tickStep
    tickStep = 50;
    xLim = get(gca, 'XLim');
    yLim = get(gca, 'YLim');
    xTickSpacing = tickStep * diff(xLim) / width;
    yTickSpacing = tickStep * diff(yLim) / height;

    % Set dynamic ticks
    xTicks = round(xLim(1)):xTickSpacing:round(xLim(2));
    yTicks = round(yLim(1)):yTickSpacing:round(yLim(2));
    set(gca, 'XTick', xTicks, 'YTick', yTicks);
    grid on;

    xlabel('X');
    ylabel('Y');

    % Find the most visible color in the specified region
    regionColor = colorImage(region(1):region(2), region(3):region(4), :);
    colorCounts = sum(sum(regionColor, 1), 2);
    totalPixels = numel(regionColor) / 3; % Divide by 3 for RGB channels
    [maxCount, maxIndex] = max(colorCounts);
    colors = {'Red', 'Green', 'Blue'};
    mostVisibleColor = colors{maxIndex};

    % Display the result on the figure
    text(10, 30, ['Object of interest color: ', mostVisibleColor], 'Color', 'black', 'FontSize', 20, 'FontWeight', 'bold');

catch ME
    disp('Error receiving or displaying RGB image:');
    disp(ME.message);
end

% Receive the depth image
try
    depthMsg = receive(depthImageSub, 10); % Timeout after 10 seconds
    depthImage = readImage(depthMsg);

    % Convert the depth image to double for visualization
    depthData = double(depthImage);

    % Negate the depth data for correct axis display
    depthData = -depthData;
    
    % % depthData = round(depthData, 3); % Round to 3 decimal places

    % Display the 3D depth visualization with RGB texture
    figure(depthFig);
    [X, Y] = meshgrid(1:size(depthData, 2), 1:size(depthData, 1));
    Y = -Y; % Flip Y axis
    surf(X, Y, depthData, 'FaceColor', 'texturemap', 'CData', colorImage, 'EdgeColor', 'none');
    colormap('jet'); % Apply color map
    colorbar; % Display color bar
    title('3D Depth Visualization with RGB Texturing');
    xlabel('X');
    ylabel('Y');
    zlabel('Depth');
    view(3); % Set the view to 3D
    axis tight;
    shading interp; % Interpolate shading for smoother visualization

    % Calculate and display the maximum depth in the region
    regionDepth = depthData(region(1):region(2), region(3):region(4));
    maxDepth = max(regionDepth(:));
    fprintf('Maximum depth in the region of interest: %.2f meters\n', maxDepth);

catch ME
    disp('Error receiving or displaying Depth image:');
    disp(ME.message);
end
