function [tuesday_indices, thursday_indices] = tues_thurs_session_keys()

sessions_days_key = dlmread('sessions-days-of-week.csv',',');

tuesday_session_numbers = sessions_days_key(sessions_days_key(:,2) == 3,1);
thursday_session_numbers = sessions_days_key(sessions_days_key(:,2) == 5,1);

tuesday_indices = find(ismember( sessions_days_key(:,1), tuesday_session_numbers));
thursday_indices = find(ismember( sessions_days_key(:,1), thursday_session_numbers));