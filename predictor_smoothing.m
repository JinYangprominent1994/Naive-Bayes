function [] = predictor_smoothing(weekday,weather,time,actions,temperature)

train_data = readtable('data.csv');

total_number = height(train_data);

% Apply Laplace smoothing
% Calculate prior probability
probability_caught = (sum(strcmp(train_data.Caught,'Yes')) + 1) / (total_number + 2);
probability_not_caught = (sum(strcmp(train_data.Caught,'No')) + 1) / (total_number + 2);

total_number_not_caught = sum(strcmp(train_data.Caught,'No'));
total_number_caught = sum(strcmp(train_data.Caught,'Yes'));


% Calculate posterior probability about feature weekday
probability_not_caught_weekday_yes = (sum((strcmp(train_data.Caught,'No') + strcmp(train_data.Weekday,'Yes')) == 2) + 1)/(total_number_not_caught + 2);
probability_not_caught_weekday_no = (sum((strcmp(train_data.Caught,'No') + strcmp(train_data.Weekday,'No')) == 2) + 1)/(total_number_not_caught + 2);

probability_caught_weekday_yes = (sum((strcmp(train_data.Caught,'Yes') + strcmp(train_data.Weekday,'Yes')) == 2) + 1)/(total_number_caught + 2);
probability_caught_weekday_no = (sum((strcmp(train_data.Caught,'Yes') + strcmp(train_data.Weekday,'No')) == 2) + 1)/(total_number_caught + 2);


% Calculate posterior probability about feature weather
probability_not_caught_weather_rain = (sum((strcmp(train_data.Caught,'No') + strcmp(train_data.Weather,'Rain')) == 2) + 1)/(total_number_not_caught + 2);
probability_not_caught_weather_sunny = (sum((strcmp(train_data.Caught,'No') + strcmp(train_data.Weather,'Sunny')) == 2) + 1)/(total_number_not_caught + 2);

probability_caught_weather_rain = (sum((strcmp(train_data.Caught,'Yes') + strcmp(train_data.Weather,'Rain')) == 2) + 1)/(total_number_caught + 2);
probability_caught_weather_sunny = (sum((strcmp(train_data.Caught,'Yes') + strcmp(train_data.Weather,'Sunny')) == 2) + 1)/(total_number_caught + 2);


% Calcualte posterior probability about feature Time
probability_not_caught_time_morning = (sum((strcmp(train_data.Caught,'No') + strcmp(train_data.Time,'Morning')) == 2) + 1)/(total_number_not_caught + 3);
probability_not_caught_time_afternoon = (sum((strcmp(train_data.Caught,'No') + strcmp(train_data.Time,'Afternoon')) == 2) + 1)/(total_number_not_caught + 3);
probability_not_caught_time_midnight = (sum((strcmp(train_data.Caught,'No') + strcmp(train_data.Time,'Midnight')) == 2) + 1)/(total_number_not_caught + 3);

probability_caught_time_morning = (sum((strcmp(train_data.Caught,'Yes') + strcmp(train_data.Time,'Morning')) == 2) + 1)/(total_number_caught + 3);
probability_caught_time_afternoon = (sum((strcmp(train_data.Caught,'Yes') + strcmp(train_data.Time,'Afternoon')) == 2) + 1)/(total_number_caught + 3);
probability_caught_time_midnight = (sum((strcmp(train_data.Caught,'Yes') + strcmp(train_data.Time,'Midnight')) == 2) + 1)/(total_number_caught + 3);


% Calcaulte posterior probability about feature Actions
probability_not_caught_actions_stop = (sum((strcmp(train_data.Caught,'No') + strcmp(train_data.Actions,'Stop Sign Violation')) == 2) + 1)/(total_number_not_caught + 2);
probability_not_caught_actions_speeding = (sum((strcmp(train_data.Caught,'No') + strcmp(train_data.Actions,'Speeding')) == 2) + 1)/(total_number_not_caught + 2);

probability_caught_actions_stop = (sum((strcmp(train_data.Caught,'Yes') + strcmp(train_data.Actions,'Stop Sign Violation')) == 2) + 1)/(total_number_caught + 2);
probability_caught_actions_speeding = (sum((strcmp(train_data.Caught,'Yes') + strcmp(train_data.Actions,'Speeding')) == 2) + 1)/(total_number_caught + 2);


% Calcaculate posterior probability about feature Temperature
probability_not_caught_temperature_low = (sum((strcmp(train_data.Caught,'No') + strcmp(train_data.Temperature,'Low')) == 2) + 1)/(total_number_not_caught + 2);
probability_not_caught_temperature_high = (sum((strcmp(train_data.Caught,'No') + strcmp(train_data.Temperature,'High')) == 2) + 1)/(total_number_not_caught + 2);

probability_caught_temperature_low = (sum((strcmp(train_data.Caught,'Yes') + strcmp(train_data.Temperature,'Low')) == 2) + 1)/(total_number_caught + 2);
probability_caught_temperature_high = (sum((strcmp(train_data.Caught,'Yes') + strcmp(train_data.Temperature,'High')) == 2) + 1)/(total_number_caught + 2);

probability_not_caught_result = 1;
probability_caught_result = 1;


% Condition Weekday
if strcmp(weekday, 'Null')
    probability_not_caught_result = probability_not_caught_result * 1;
    probability_caught_result = probability_caught_result * 1;
elseif strcmp(weekday, 'Yes')
    probability_not_caught_result = probability_not_caught_result * probability_not_caught_weekday_yes;
    probability_caught_result = probability_caught_result * probability_caught_weekday_yes;
elseif strcmp(weekday, 'No')
    probability_not_caught_result = probability_not_caught_result * probability_not_caught_weekday_no;
    probability_caught_result = probability_caught_result * probability_caught_weekday_no;
else
    disp('wrong input');
    return
end

% Condition Weather
if strcmp(weather, 'Null')
    probability_not_caught_result = probability_not_caught_result * 1;
    probability_caught_result = probability_caught_result * 1;
elseif strcmp(weather, 'Rain')
    probability_not_caught_result = probability_not_caught_result * probability_not_caught_weather_rain;
    probability_caught_result = probability_caught_result * probability_caught_weather_rain;
elseif strcmp(weather, 'Sunny')
    probability_not_caught_result = probability_not_caught_result * probability_not_caught_weather_sunny;
    probability_caught_result = probability_caught_result * probability_caught_weather_sunny;
else
    disp('wrong input');
    return
end

% Condition Time
if strcmp(time, 'Null')
    probability_not_caught_result = probability_not_caught_result * 1;
    probability_caught_result = probability_caught_result * 1;
elseif strcmp(time, 'Morning')
    probability_not_caught_result = probability_not_caught_result * probability_not_caught_time_morning;
    probability_caught_result = probability_caught_result * probability_caught_time_morning;
elseif strcmp(time, 'Afternoon')
    probability_not_caught_result = probability_not_caught_result * probability_not_caught_time_afternoon;
    probability_caught_result = probability_caught_result * probability_caught_time_afternoon;
elseif strcmp(time, 'Midnight')
    probability_not_caught_result = probability_not_caught_result * probability_not_caught_time_midnight;
    probability_caught_result = probability_caught_result * probability_caught_time_midnight;
else
    disp('wrong input');
    return
end

% Condition Actions
if strcmp(actions, 'Null')
    probability_not_caught_result = probability_not_caught_result * 1;
    probability_caught_result = probability_caught_result * 1;
elseif strcmp(actions, 'Stop Sign Violation')
    probability_not_caught_result = probability_not_caught_result * probability_not_caught_actions_stop;
    probability_caught_result = probability_caught_result * probability_caught_actions_stop;
elseif strcmp(actions, 'Speeding')
    probability_not_caught_result = probability_not_caught_result * probability_not_caught_actions_speeding;
    probability_caught_result = probability_caught_result * probability_caught_actions_speeding;
else 
    disp('wrong input');
    return
end

% Condtion Temperature
if strcmp(temperature, 'Null')
    probability_not_caught_result = probability_not_caught_result * 1;
    probability_caught_result = probability_caught_result * 1;
elseif strcmp(temperature, 'Low')
    probability_not_caught_result = probability_not_caught_result * probability_not_caught_temperature_low;
    probability_caught_result = probability_caught_result * probability_caught_temperature_low;
elseif strcmp(temperature, 'High')
    probability_not_caught_result = probability_not_caught_result * probability_not_caught_temperature_high;
    probability_caught_result = probability_caught_result * probability_caught_temperature_high;
else
    disp('wrong input');
    return
end

probability_not_caught_result = probability_not_caught_result * probability_not_caught;
probability_caught_result = probability_caught_result * probability_caught;

% Compare the final probability and make prediction
if probability_caught_result > probability_not_caught_result
    disp('The prediction result: Will be caught by police');
elseif probability_caught_result < probability_not_caught_result
    disp('The prediction result: Will not be caught by police');
else
    disp('Cannot predict the result');
end