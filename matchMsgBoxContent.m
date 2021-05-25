% This function matches the msgbox content up to approved
% Input approved: '1' = detected approved code. '0' = detected rejected code.
% icon & message match the approved value
function [icon, message] = matchMsgBoxContent(approved)
    approvedImg = imread("moreImages\approved.jpg");
    approvedIcon = imresize(approvedImg, [128, 256]);
    rejectedImg = imread("moreImages\rejected.jpg");
    rejectedIcon = imresize(rejectedImg, [128, 256]);
    if approved
        message = 'Approved!';
        icon = approvedIcon;
    else
        message = 'Rejected!';
        icon = rejectedIcon;
    end
end