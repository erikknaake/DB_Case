USE FLETNIX_DOCENT
go

declare @startYear date = '01-01-2000'
declare @endYear date = '01-01-2017'
select *
	from Customer
	where (subscription_end >= @startYear AND subscription_end < @endYear) OR 
		(subscription_start >= @startYear AND subscription_start < @endYear AND 
			(subscription_end < @endYear OR subscription_end IS NULL))
go