translation_matrix = [0.03 0.32 0.15;
                        0.23 0.3 0.15;
                        -0.15 0.405 0.3;
                        -0.23 0.175 0.3];
rotation_matrix = [pi/2 -pi 0;
                    pi -pi 0;
                    pi/2 -pi 0;
                    pi -pi 0];
% [y_start, y_end, x_start, x_end]
obj_regions = struct();
obj_regions(1).values = [1, 50, 275, 375];
obj_regions(2).values = [50, 100, 275, 375];
obj_regions(3).values = [375, 425, 300, 350];
obj_regions(4).values = [375, 425, 300, 350];
