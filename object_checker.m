%%This function checks if the object is a bottle or a can based on the
%%image

function obj_type = object_checker(cap_region)
    %We will look for the cap in the specified region and output if it is a
    %bottle or a can

    % Receive the color image
    colorImageSub = rossubscriber('/camera/rgb/image_raw');
    colorMsg = receive(colorImageSub, 10); % Timeout after 10 seconds
    colorImage = readImage(colorMsg);

    % % Display the color image
    % colorFig = figure('Name', 'Color Image');
    % figure(colorFig);
    % imshow(colorImage);
    % title('Color Image');
    % 
    % % Add dynamic axis with variable tick spacing
    % axis on;
    % [height, width, ~] = size(colorImage);
    % xlim([0.5, width + 0.5]);
    % ylim([0.5, height + 0.5]);
    % 
    % % Determine tick spacing based on default tickStep
    % tickStep = 50;
    % xLim = get(gca, 'XLim');
    % yLim = get(gca, 'YLim');
    % xTickSpacing = tickStep * diff(xLim) / width;
    % yTickSpacing = tickStep * diff(yLim) / height;
    % 
    % % Set dynamic ticks
    % xTicks = round(xLim(1)):xTickSpacing:round(xLim(2));
    % yTicks = round(yLim(1)):yTickSpacing:round(yLim(2));
    % set(gca, 'XTick', xTicks, 'YTick', yTicks);
    % grid on;
    % 
    % xlabel('X');
    % ylabel('Y');

    % Find the most visible color in the specified region
    regionColor = colorImage(cap_region(1):cap_region(2), cap_region(3):cap_region(4), :);
    colorCounts = sum(sum(regionColor, 1), 2);
    % totalPixels = numel(regionColor) / 3; % Divide by 3 for RGB channels
    [~, maxIndex] = max(colorCounts);
    colors = {'Red', 'Green', 'Blue'};
    mostVisibleColor = colors{maxIndex};

    %if the most visible color in the region is blue, that means there is a
    %cap, which implies that the object is a bottle

    if strcmp(mostVisibleColor, 'Blue') 
        obj_type = 'bottle_grip';
        fprintf("Object is bottle")
    else
        obj_type = 'can_grip';
        fprintf("Object is can")
    end
end