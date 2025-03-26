%%Opening gripper
function hold_position=grip_hold(hold_position,gripGoal,gripAct)
    if hold_position == "open"
        %open the gripper
        gripGoal=packGripGoal(open_grip_pos,gripGoal);
    elseif hold_position == "bottle_grip"
        %close the gripper
        gripGoal=packGripGoal(bottle_grip,gripGoal);
    elseif hold_position == "can_grip"
        %close the gripper
        gripGoal=packGripGoal(can_grip,gripGoal);
    elseif hold_position == "pouch_grip"
        gripGoal=packGripGoal(pouch_grip,gripGoal);
    else
        %if the user gives a position, we will hold the gripper at that position
        %hold the gripper at the given position
        gripGoal=packGripGoal(hold_position,gripGoal);
    end
    sendGoal(gripAct,gripGoal);
    run robot_delay.m
end