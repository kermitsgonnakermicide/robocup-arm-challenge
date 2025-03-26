% Initialize figures for display
colorFig = figure('Name', 'Color Image');
region = [50, 100, 275, 375];
%region = [375, 425, 300, 350];


try
    % Receive the color image
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

    % Set ticks, ensure non-negative and within limits
    xTicks = xTicks(xTicks >= xLim(1) & xTicks <= xLim(2));
    yTicks = yTicks(yTicks >= yLim(1) & yTicks <= yLim(2));

    set(gca, 'XTick', xTicks, 'YTick', yTicks);
    grid on;

    xlabel('X');
    ylabel('Y');

    % Extract the region of interest
    regionColor = colorImage(region(1):region(2), region(3):region(4), :);

    % Separate the color channels
    redChannel = regionColor(:, :, 1);
    greenChannel = regionColor(:, :, 2);
    blueChannel = regionColor(:, :, 3);

    % Calculate the total counts of each color
    redCount = sum(redChannel(:));
    greenCount = sum(greenChannel(:));
    blueCount = sum(blueChannel(:));

    % Calculate the count for yellow (red + green)
    yellowCount = sum(redChannel(:) & greenChannel(:));

    % Store the counts in an array
    colorCounts = [redCount, greenCount, blueCount, yellowCount];

    % Find the maximum count and its index
    [maxCount, maxIndex] = max(colorCounts);

    % Define the color names
    colors = {'Red', 'Green', 'Blue', 'Yellow'};

    % Determine the most visible color
    mostVisibleColor = colors{maxIndex};

    % Display the result on the figure
    text(10, 30, ['Color of object: ', mostVisibleColor], 'Color', 'black', 'FontSize', 20, 'FontWeight', 'bold');

    % Print the result
    fprintf('Color of object: %s\n', mostVisibleColor);

catch ME
    disp('Error receiving or displaying RGB image:');
    disp(ME.message);
end
