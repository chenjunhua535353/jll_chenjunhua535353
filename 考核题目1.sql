
--drop table if exists #tp

--select a.年份,a.[品牌],a.汽车类别,a.子车系,a.子车系编码,a.燃料类型,round(sum([tp*mix]),-2) as 加权tp 
--into #tp

--from 
--(
--	select  left(a.[年月],4) as [年份],c.[品牌],c.[汽车类别],c.[子车系],c.[子车系编码],c.[燃料类型] ,	
--		(
--			CONVERT(decimal,a.[tp])*(CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )/
--			sum((CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )) over( partition by left(a.[年月],4),c.[品牌],c.汽车类别,c.子车系,c.子车系编码,c.燃料类型 )
--		) as [tp*mix]
--	from 
--		(
--		SELECT [年月],[型号编码],round(avg(cast(nullif(tp,N'无车') as decimal(18,0))),-2) as tp
--		  FROM [LandRoadsGZ].[dbo].[fact_JLL-终端价格-分城市]  
--		  where [年月]>='2023-01' and [年月]<'2023-11' and [周期]='7'
--		  group by [年月],[型号编码] 
--		)a

--	left join 
--		(
--		  SELECT [年月],[型号编码],[销量]
--		  FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数]  
--		  where  [年月]>='2023-01' and [年月]<'2023-11'
--		)b on a.[年月]=b.[年月] and a.[型号编码]=b.[型号编码]

--	left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] c on a.型号编码 =c.车型编码 
--)a

-- group by a.年份,a.[品牌],a.汽车类别,a.子车系,a.子车系编码,a.燃料类型





-- select  *  from  #tp


--select a.年份,a.[品牌],a.汽车类别,a.子车系,a.子车系编码,a.燃料类型,a.[价格段],sum([销量]) as [销量]

--from 
--(

--		select a.年份,a.[品牌],a.汽车类别,a.子车系,a.子车系编码,a.燃料类型,a.加权tp,

--		(case when a.加权tp <200000 then '20万以下'
--			when a.加权tp >=200000 and a.加权tp <210000 then '20-21万'
--			when a.加权tp >=210000 and a.加权tp <220000 then '21-22万'
--			when a.加权tp >=220000 and a.加权tp <230000 then '22-23万'
--			when a.加权tp >=230000 and a.加权tp <240000 then '23-24万'
--			when a.加权tp >=240000 and a.加权tp <250000 then '24-25万'
--			when a.加权tp >=250000 and a.加权tp <260000 then '25-26万'
--			when a.加权tp >=260000 and a.加权tp <260000 then '26-27万'
--			when a.加权tp >=270000 and a.加权tp <280000 then '27-28万'
--			when a.加权tp >=280000 and a.加权tp <290000 then '28-29万'
--			when a.加权tp >=290000 and a.加权tp <300000 then '29-30万'
--			else '30万以上' end ) as [价格段],

--			b.销量

--		FROM  #tp a

--		left join 
--			(
--					select 年份,[品牌],汽车类别,子车系,子车系编码,燃料类型,sum(cast([销量] as decimal(18,0))) as [销量]

--					from
--					[LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数] where concat(年份,'-',月份)>'2023-01' and concat(年份,'-',月份)<'2023-11' 

--					group by  年份,[品牌],汽车类别,子车系,子车系编码,燃料类型
--			)  b  

--			on a.年份=b.年份 and a.子车系编码=b.子车系编码 and a.[品牌]=b.[品牌] and a.汽车类别=b.汽车类别 and a.燃料类型=b.燃料类型 and a.子车系=b.子车系

--) a

--group by a.年份,a.[品牌],a.汽车类别,a.子车系,a.子车系编码,a.燃料类型,a.[价格段]




------------------------------------------------------------------------------------------------------------------------修正题目1

drop table if exists #mix

	select  a.型号编码,a.年月,left(a.[年月],4) as [年份],c.[品牌],c.[汽车类别],c.[子车系],c.[子车系编码],c.[燃料类型],a.tp,b.[销量],
		(
			(CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )/
			sum((CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )) over( partition by a.[年月],c.[品牌],c.汽车类别,c.子车系,c.子车系编码,c.燃料类型 )
		) as [mix],

		(case when a.tp <200000 then '20万以下'
				when a.tp >=300000 then '30万以上' 
				when ((a.tp-200000)/10000)>=FLOOR((a.tp-200000)/10000) and ((a.tp-200000)/10000)< ceiling((a.tp-200000)/10000)  
											then concat( cast( ceiling( (a.tp-200000)/10000)+20-1 as varchar(10)),'-',cast(ceiling((a.tp-200000)/10000)+20 as varchar(10)) ,'万')
		end)as [价格段]

		--(case when a.tp <200000 then '20万以下'
		--	when a.tp >=200000 and a.tp <210000 then '20-21万'
		--	when a.tp >=210000 and a.tp <220000 then '21-22万'
		--	when a.tp >=220000 and a.tp <230000 then '22-23万'
		--	when a.tp >=230000 and a.tp <240000 then '23-24万'
		--	when a.tp >=240000 and a.tp <250000 then '24-25万'
		--	when a.tp >=250000 and a.tp <260000 then '25-26万'
		--	when a.tp >=260000 and a.tp <260000 then '26-27万'
		--	when a.tp >=270000 and a.tp <280000 then '27-28万'
		--	when a.tp >=280000 and a.tp <290000 then '28-29万'
		--	when a.tp >=290000 and a.tp <300000 then '29-30万'
		--	else '30万以上' end ) as [价格段]

    into #mix
	from 
		(
		SELECT [年月],[型号编码],round(avg(cast(nullif(tp,N'无车') as decimal(18,0))),-2) as tp
		  FROM [LandRoadsGZ].[dbo].[fact_JLL-终端价格-分城市]  
		  where [年月]>='2023-01' and [年月]<'2023-11' and [周期]='7'
		  group by [年月],[型号编码] 
		)a

	left join 
		(
		  SELECT [年月],[型号编码],[销量]
		  FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数]  
		  where  [年月]>='2023-01' and [年月]<'2023-11'
		)b on a.[年月]=b.[年月] and a.[型号编码]=b.[型号编码]

	left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] c on a.型号编码 =c.车型编码 

--select *  from #mix



drop table if exists #车型销量

select [年月],[年份],[品牌],[汽车类别],[子车系],[子车系编码],[燃料类型],sum(cast([销量] as decimal(18,0))) as [销量]

into #车型销量

from [LandRoadsGZ].[dbo].[fact_JLL-车型上险数]

where  [年月]>='2023-01' and [年月]<'2023-11'

group  by [年月],[年份],[品牌],[汽车类别],[子车系],[子车系编码],[燃料类型]

--select *  from #车型销量


select a.年份,a.品牌,a.汽车类别,a.子车系,a.子车系编码,a.燃料类型,a.价格段,SUM(a.[销量_mix]) as [销量_]
from 

(
	select a.*,round(b.[销量]*a.[mix],0) as [销量_mix]

	from #mix a left join #车型销量 b  on  a.[年月]=b.[年月] and a.[子车系编码]=b.[子车系编码] and a.[品牌]=b.[品牌] and a.[汽车类别]=b.[汽车类别] and a.[燃料类型]=b.[燃料类型] and a.[子车系]=b.[子车系]

	--order by a.[年月],a.[子车系编码],a.品牌,a.汽车类别,a.子车系,a.燃料类型 asc

)a

group  by a.年份,a.品牌,a.汽车类别,a.子车系,a.子车系编码,a.燃料类型,a.价格段

order by   a.年份,a.品牌,a.汽车类别,a.子车系,a.子车系编码,a.燃料类型,a.价格段





--校验
--select [年份],[品牌],[汽车类别],[子车系],[子车系编码],[燃料类型],sum(cast([销量] as decimal(18,0))) as [销量]

--from [LandRoadsGZ].[dbo].[fact_JLL-车型上险数]

--where  [年月]>='2023-01' and [年月]<'2023-11' and [子车系编码] in ('J108215001')

--group  by [年份],[品牌],[汽车类别],[子车系],[子车系编码],[燃料类型]