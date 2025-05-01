function hold_position=grip_hold(hold_position,gripGoal,gripAct)
    if hold_position == "open"       
        gripGoal=packGripGoal(open_grip_pos,gripGoal);
    elseif hold_position == "bottle_grip"
        gripGoal=packGripGoal(bottle_grip,gripGoal);
    elseif hold_position == "can_grip"
        gripGoal=packGripGoal(can_grip,gripGoal);
    elseif hold_position == "pouch_grip"
        gripGoal=packGripGoal(pouch_grip,gripGoal);
    else
        gripGoal=packGripGoal(hold_position,gripGoal);
    end
    sendGoal(gripAct,gripGoal);
    run robot_delay.m
end