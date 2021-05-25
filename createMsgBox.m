% This function creates msgbox with the detected code and approved or 
% not approved icon & message to the user
% srtCode: the detected code in string format
% message: one of 'approved'/'rejected' 
% icon: one of approved.jpg/rejected.jpg
function createMsgBox(strCode, message, icon)
    codeMessage = msgbox({strCode, message}, 'Detected Code - 2 digits rounded', 'custom', icon);
    % Get handle to txt
    txt = findall(codeMessage, 'Type', 'Text');  
    % Change fontsize
    set(txt, 'FontSize', 8);  
    % Message appears for 3 seconds, or until pressed Esc/OK
%     pause(3);
%     if exist('codeMessage', 'var')
%         delete(codeMessage);
%         clear('codeMessage');
%     end
end