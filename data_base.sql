
select * from dbo.patients;
select * from dbo.labs 
select * from dbo.outcomes;
select * from dbo.diagnoses;

-- Retrieve Patients data with dignosis and outcomes
SELECT
	p.patientid,
	p.name,
	p.age,
	-- p.admissiondate,
	-- p.dischargedate,
	-- p.treatmentcost,
	l.testname,
	round(l.result,2,1) as RESULTS ,
	l.normalrange,
	d.diagnosisname,
	o.outcomename
from patients p
join labs l on l.PatientID=p.PatientID
join diagnoses d on d.DiagnosisID=p.DiagnosisID
join outcomes o on o.OutcomeID=p.OutcomeID


-- Average lab results by diagnosis

SELECT
	d.diagnosisname,
	l.testname,
	round(avg(l.result),2,1) as avg_result 
from patients p
join labs l on l.PatientID=p.PatientID
join diagnoses d on d.DiagnosisID=p.DiagnosisID
join outcomes o on o.OutcomeID=p.OutcomeID
group by l.testname, d.diagnosisname

-- counting Abnormal test result patients test result history
select
	p.patientid,
	p.name,
	count(*) as Abnormal_count
from patients p
join labs l on l.PatientID=p.PatientID
where (l.testname='blood pressure' and l.result>150) or
		(l.TestName='blood sugar' and l.result>120) or
			(l.TestName='cholesterol' and l.Result>200) or
				(l.TestName='hemoglobin' and l.Result<13)
group by p.patientid,p.name
order by Abnormal_count desc

-- Total Treatment cost by patients
SELECT
	p.patientid,
	p.name,
	p.age,
	sum(p.treatmentcost)  as Total_cost
from patients p
--join labs l on l.PatientID=p.PatientID
--join diagnoses d on d.DiagnosisID=p.DiagnosisID
--join outcomes o on o.OutcomeID=p.OutcomeID
group by p.patientid,p.name,p.age
order by Total_cost desc

-- Dignoses with Higest treatment cost
select
		d.Diagnosisname, sum(p.treatmentcost) as Higest_cost
from patients p
join diagnoses d on d.DiagnosisID=p.DiagnosisID
group by d.Diagnosisname
order by Higest_cost desc

-- Patient at risk by age and gender
select 
	p.gender,
	p.age,
	d.diagnosisname,
	o.outcomename
--	l.testname,
--	l.result,
--	l.NormalRange
from patients p
join diagnoses d on d.DiagnosisID=p.DiagnosisID
join outcomes o on o.OutcomeID=p.OutcomeID
join labs l on l.PatientID=p.PatientID
where o.outcomename != 'recovered'
group by p.age,p.gender, d.DiagnosisName, o.OutcomeName

-- distribution of outcomes by diagnosis

select 
	d.diagnosisname,
	o.outcomename,
	count(*) as Patiants_number
from patients p
join diagnoses d on d.DiagnosisID=p.DiagnosisID
join outcomes o on o.OutcomeID=p.OutcomeID
group by d.diagnosisname,o.outcomename
order by d.diagnosisname,o.outcomename desc
