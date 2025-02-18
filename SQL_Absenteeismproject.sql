select * from Absenteeism_at_work a
left join compensation c 
on a.ID=c.ID
left join Reasons r 
on a.Reason_for_absence=r.Number

--healthiest
select * from Absenteeism_at_work
where Social_drinker=0 and Social_smoker=0 and Body_mass_index<25 
and Absenteeism_time_in_hours < (select AVG(Absenteeism_time_in_hours) from Absenteeism_at_work)

--non-smokers list
select count(*) as non_smokers from Absenteeism_at_work
where Social_smoker=0

--optimizing query
select a.ID,Absenteeism_time_in_hours,
r.Reason, Month_of_absence,
Seasons,
CASE WHEN Month_of_absence IN (12,1,2) then 'Winter'
     WHEN Month_of_absence IN (3,4,5) then 'Spring'
	 WHEN Month_of_absence IN (6,7,8) then 'Summer'
	 WHEN Month_of_absence IN (9,10,11) then 'Fall'
	 Else 'unknown' end as Season_name,
	 Body_mass_index,
CASE WHEN Body_mass_index<18.5 then 'Underweight'
     WHEN Body_mass_index between 18.5 and 25 then 'Healthy weight'
	 WHEN Body_mass_index between 25 and 30 then 'Overweight'
	 WHEN Body_mass_index>30 then 'Obese'
     Else 'unknown' end as BMI_Category,
Day_of_the_week,
Transportation_expense,
Education,
Son,
Pet,
Age,
Disciplinary_failure,
Work_load_Average_day,
CASE WHEN Social_drinker=0 then 'FALSE'
     WHEN Social_drinker=1 then 'TRUE'
	 end as Social_drinker,
CASE WHEN Social_smoker=0 then 'FALSE'
     WHEN Social_smoker=1 then 'TRUE'
	 end as Social_smoker

from Absenteeism_at_work a
left join compensation c 
on a.ID=c.ID
left join Reasons r 
on a.Reason_for_absence=r.Number

