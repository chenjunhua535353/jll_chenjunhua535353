--题目1：请按照以下条件，计算和导出20-30万，1万一个段的价格段销量数据；时间范围2023年1-10月累计。需要下列字段，以excel结果导出：


drop table if exists #价格段

select left([年月],4) as [年份] ,[车型编码],[品牌],[汽车类别],[子车系],[子车系编码],[燃料类型],[tp],[销量],
(case when [tp]<200000 then '20万以下'
	when [tp]>=200000 and [tp]<210000 then '20-21万'
	when [tp]>=210000 and [tp]<220000 then '21-22万'
	when [tp]>=220000 and [tp]<230000 then '22-23万'
	when [tp]>=230000 and [tp]<240000 then '23-24万'
	when [tp]>=240000 and [tp]<250000 then '24-25万'
	when [tp]>=250000 and [tp]<260000 then '25-26万'
	when [tp]>=260000 and [tp]<260000 then '26-27万'
	when [tp]>=270000 and [tp]<280000 then '27-28万'
	when [tp]>=280000 and [tp]<290000 then '28-29万'
	when [tp]>=290000 and [tp]<300000 then '29-30万'
	else '30万以上' end ) as [价格段]
	into #价格段

FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量]

where [年月]>='2023-01'and [年月]<'2023-11'


select [年份],[品牌],[汽车类别],[子车系],[子车系编码],[燃料类型],[价格段],sum(cast([销量] as decimal(18,0))) as [销量]  from #价格段

where [价格段] !='30万以上'and  [价格段] !='20万以下'

group  by  [年份],[品牌],[汽车类别],[子车系],[子车系编码],[燃料类型],[价格段]



--题目2：请按照以下条件，计算和导出2022-2023年分月，别克品牌的加权MSRP/TP/折扣，（需要剔除别克GL8这个车型）需要下列字段，以excel结果导出：

drop table if exists #mix

select [年月],[车型编码],[品牌],[tp],[销量],[msrp],[msrp]-[tp] as [折扣],

		(
			CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )/

			sum((CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )) over( partition by [年月])

		) as [tp*mix],

		(
			CONVERT(decimal,[msrp])*(CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )/

			sum((CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )) over( partition by [年月])

		) as [msrp*mix],

		(
			(CONVERT(decimal,[msrp])-CONVERT(decimal,[tp]))*(CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )/

			sum((CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )) over( partition by [年月])

		) as [折扣*mix]

		into #mix


FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量]

where [年月]>='2022-01' and [品牌] = '别克' and [子车系]  <>'别克GL8'


select [年月],[品牌],round(sum([tp*mix]),-2) as 加权TP, round(sum([msrp*mix]),-2)  as 加权msrp,round(sum([折扣*mix]),-2) as 加权折扣

from  #mix

group  by [年月],[品牌]






--题目3：请按照以下条件，计算和导出下列市场数据的加权价格和销量数据，需要下列字段，以excel结果导出：


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------全市场

select a.市场数据,a.[2022年全年加权价格（TP）],b.[2023年1-11月全年加权价格（TP）],ABS(b.[2023年1-11月全年加权价格（TP）]-a.[2022年全年加权价格（TP）]) as [均价增幅绝对值]

,round(a.[2022年1-12月累计销量],0) as [2022年1-12月累计销量],c.[2022年1-10月累计销量],d.[2023年1-10月累计销量],(d.[2023年1-10月累计销量]-c.[2022年1-10月累计销量]) as [2023年1-10月销量同比]

from
	(
		select a.[市场数据],round(sum(a.[tp*mix]),-2) as [2022年全年加权价格（TP）],sum(cast([销量] as decimal(18,0))) as [2022年1-12月累计销量]
		from
			(
				select '全市场'as [市场数据] , left([年月],4) as '年',[车型编码],[tp],[销量],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )/
							sum((CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )) over( partition by left([年月],4))
						) as [tp*mix]
				FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2022-01' and [年月]<'2023-01'
			)a
		group by a.[市场数据]

	) a
left join 
	(
		select a.[市场数据],round(sum(a.[tp*mix]),-2) as [2023年1-11月全年加权价格（TP）]
		from
			(
				select '全市场'as [市场数据] , left([年月],4) as '年',[车型编码],[tp],[销量],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )/
							sum((CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )) over( partition by left([年月],4))
						) as [tp*mix]

				FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2023-01' and [年月]<'2023-12'
			)a
		group by a.[市场数据]
	) b

on a.[市场数据]=b.[市场数据]
left join 
	(
		select  '全市场' as [市场数据],sum(cast([销量] as decimal(18,0))) as [2022年1-10月累计销量] FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2022-01' and [年月]<'2022-11'
	) c
on a.[市场数据]=c.[市场数据]
left join 
	(
		select  '全市场' as [市场数据],sum(cast([销量] as decimal(18,0))) as [2023年1-10月累计销量] FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2023-01' and [年月]<'2023-11'
	) d
	on a.[市场数据]=d.[市场数据]

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------传统能源
union all

select a.市场数据,a.[2022年全年加权价格（TP）],b.[2023年1-11月全年加权价格（TP）],ABS(b.[2023年1-11月全年加权价格（TP）]-a.[2022年全年加权价格（TP）]) as [均价增幅绝对值]

,round(a.[2022年1-12月累计销量],0) as [2022年1-12月累计销量],c.[2022年1-10月累计销量],d.[2023年1-10月累计销量],(d.[2023年1-10月累计销量]-c.[2022年1-10月累计销量]) as [2023年1-10月销量同比]

from
	(
		select a.[市场数据],round(sum(a.[tp*mix]),-2) as [2022年全年加权价格（TP）],sum(cast([销量] as decimal(18,0))) as [2022年1-12月累计销量]
		from
			(

				select '传统能源'as [市场数据] , left([年月],4) as '年',[车型编码],[tp],[销量],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )/
							sum((CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )) over( partition by left([年月],4))
						) as [tp*mix]

				FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2022-01' and [年月]<'2023-01' and  [燃料类型] not in ('纯电动','插电式混合动力','增程式电动')

			)a
		group by a.[市场数据]

	) a
left join 
	(
		select a.[市场数据],round(sum(a.[tp*mix]),-2) as [2023年1-11月全年加权价格（TP）]
		from
			(
				select '传统能源'as [市场数据] , left([年月],4) as '年',[车型编码],[tp],[销量],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )/
							sum((CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )) over( partition by left([年月],4))
						) as [tp*mix]

				FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2023-01' and [年月]<'2023-12'  and  [燃料类型] not in ('纯电动','插电式混合动力','增程式电动')
			)a
		group by a.[市场数据]
	) b

on a.[市场数据]=b.[市场数据]

left join 
	(
		select  '传统能源' as [市场数据],sum(cast([销量] as decimal(18,0))) as [2022年1-10月累计销量] FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2022-01' and [年月]<'2022-11' and  [燃料类型] not in ('纯电动','插电式混合动力','增程式电动')
	) c
on a.[市场数据]=c.[市场数据]
left join 
	(
		select  '传统能源' as [市场数据],sum(cast([销量] as decimal(18,0))) as [2023年1-10月累计销量] FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2023-01' and [年月]<'2023-11' and  [燃料类型] not in ('纯电动','插电式混合动力','增程式电动')
	) d
	on a.[市场数据]=d.[市场数据]
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------新能源
union all

select a.市场数据,a.[2022年全年加权价格（TP）],b.[2023年1-11月全年加权价格（TP）],ABS(b.[2023年1-11月全年加权价格（TP）]-a.[2022年全年加权价格（TP）]) as [均价增幅绝对值]

,round(a.[2022年1-12月累计销量],0) as [2022年1-12月累计销量],c.[2022年1-10月累计销量],d.[2023年1-10月累计销量],(d.[2023年1-10月累计销量]-c.[2022年1-10月累计销量]) as [2023年1-10月销量同比]

from
	(
		select a.[市场数据],round(sum(a.[tp*mix]),-2) as [2022年全年加权价格（TP）],sum(cast([销量] as decimal(18,0))) as [2022年1-12月累计销量]
		from
			(
				select '新能源'as [市场数据] , left([年月],4) as '年',[车型编码],[tp],[销量],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )/
							sum((CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )) over( partition by left([年月],4))
						) as [tp*mix]
				FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2022-01' and [年月]<'2023-01' and  [燃料类型] in ('纯电动','插电式混合动力','增程式电动')
			)a
		group by a.[市场数据]

	) a
left join 
	(
		select a.[市场数据],round(sum(a.[tp*mix]),-2) as [2023年1-11月全年加权价格（TP）]
		from
			(
				select '新能源'as [市场数据] , left([年月],4) as '年',[车型编码],[tp],[销量],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )/
							sum((CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )) over( partition by left([年月],4))
						) as [tp*mix]

				FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2023-01' and [年月]<'2023-12' and  [燃料类型] in ('纯电动','插电式混合动力','增程式电动')
			)a
		group by a.[市场数据]
	) b

on a.[市场数据]=b.[市场数据]

left join 
	(
		select  '新能源' as [市场数据],sum(cast([销量] as decimal(18,0))) as [2022年1-10月累计销量] FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2022-01' and [年月]<'2022-11'and [燃料类型] in ('纯电动','插电式混合动力','增程式电动')
	) c
on a.[市场数据]=c.[市场数据]
left join 
	(
		select  '新能源' as [市场数据],sum(cast([销量] as decimal(18,0))) as [2023年1-10月累计销量] FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2023-01' and [年月]<'2023-11'and [燃料类型] in ('纯电动','插电式混合动力','增程式电动')
	) d
	on a.[市场数据]=d.[市场数据]
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------自主品牌
union all

select a.市场数据,a.[2022年全年加权价格（TP）],b.[2023年1-11月全年加权价格（TP）],ABS(b.[2023年1-11月全年加权价格（TP）]-a.[2022年全年加权价格（TP）]) as [均价增幅绝对值]

,round(a.[2022年1-12月累计销量],0) as [2022年1-12月累计销量],c.[2022年1-10月累计销量],d.[2023年1-10月累计销量],(d.[2023年1-10月累计销量]-c.[2022年1-10月累计销量]) as [2023年1-10月销量同比]

from
	(
		select a.[市场数据],round(sum(a.[tp*mix]),-2) as [2022年全年加权价格（TP）],sum(cast([销量] as decimal(18,0))) as [2022年1-12月累计销量]
		from
			(
				select '自主品牌'as [市场数据] , left([年月],4) as '年',[车型编码],[tp],[销量],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )/
							sum((CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )) over( partition by left([年月],4))
						) as [tp*mix]
				FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2022-01' and [年月]<'2023-01' and  [品牌系别]='自主'
			)a
		group by a.[市场数据]

	) a
left join 
	(
		select a.[市场数据],round(sum(a.[tp*mix]),-2) as [2023年1-11月全年加权价格（TP）]
		from
			(
				select '自主品牌'as [市场数据] , left([年月],4) as '年',[车型编码],[tp],[销量],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )/
							sum((CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )) over( partition by left([年月],4))
						) as [tp*mix]

				FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2023-01' and [年月]<'2023-12'  and  [品牌系别]='自主'
			)a
		group by a.[市场数据]
	) b

on a.[市场数据]=b.[市场数据]

left join 
	(
		select  '自主品牌' as [市场数据],sum(cast([销量] as decimal(18,0))) as [2022年1-10月累计销量] FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2022-01' and [年月]<'2022-11' and  [品牌系别]='自主'
	) c
on a.[市场数据]=c.[市场数据]
left join 
	(
		select  '自主品牌' as [市场数据],sum(cast([销量] as decimal(18,0))) as [2023年1-10月累计销量] FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2023-01' and [年月]<'2023-11' and  [品牌系别]='自主'
	) d
	on a.[市场数据]=d.[市场数据]
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------非自主品牌
union all

select a.市场数据,a.[2022年全年加权价格（TP）],b.[2023年1-11月全年加权价格（TP）],ABS(b.[2023年1-11月全年加权价格（TP）]-a.[2022年全年加权价格（TP）]) as [均价增幅绝对值]

,round(a.[2022年1-12月累计销量],0) as [2022年1-12月累计销量],c.[2022年1-10月累计销量],d.[2023年1-10月累计销量],(d.[2023年1-10月累计销量]-c.[2022年1-10月累计销量]) as [2023年1-10月销量同比]

from
	(
		select a.[市场数据],round(sum(a.[tp*mix]),-2) as [2022年全年加权价格（TP）],sum(cast([销量] as decimal(18,0))) as [2022年1-12月累计销量]
		from
			(
				select '非自主品牌'as [市场数据] , left([年月],4) as '年',[车型编码],[tp],[销量],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )/
							sum((CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )) over( partition by left([年月],4))
						) as [tp*mix]
				FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2022-01' and [年月]<'2023-01' and  [品牌系别]<>'自主'
			)a
		group by a.[市场数据]

	) a
left join 
	(
		select a.[市场数据],round(sum(a.[tp*mix]),-2) as [2023年1-11月全年加权价格（TP）]
		from
			(
				select '非自主品牌'as [市场数据] , left([年月],4) as '年',[车型编码],[tp],[销量],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )/
							sum((CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )) over( partition by left([年月],4))
						) as [tp*mix]

				FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2023-01' and [年月]<'2023-12'  and  [品牌系别]<>'自主'
			)a
		group by a.[市场数据]
	) b

on a.[市场数据]=b.[市场数据]

left join 
	(
		select  '非自主品牌' as [市场数据],sum(cast([销量] as decimal(18,0))) as [2022年1-10月累计销量] FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2022-01' and [年月]<'2022-11' and  [品牌系别]<>'自主'
	) c
on a.[市场数据]=c.[市场数据]
left join 
	(
		select  '非自主品牌' as [市场数据],sum(cast([销量] as decimal(18,0))) as [2023年1-10月累计销量] FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2023-01' and [年月]<'2023-11' and  [品牌系别]<>'自主'
	) d
	on a.[市场数据]=d.[市场数据]
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------德系/日系/美系/韩系/欧系/法系

union all

select a.市场数据,a.[2022年全年加权价格（TP）],b.[2023年1-11月全年加权价格（TP）],ABS(b.[2023年1-11月全年加权价格（TP）]-a.[2022年全年加权价格（TP）]) as [均价增幅绝对值]

,round(a.[2022年1-12月累计销量],0) as [2022年1-12月累计销量],c.[2022年1-10月累计销量],d.[2023年1-10月累计销量],(d.[2023年1-10月累计销量]-c.[2022年1-10月累计销量]) as [2023年1-10月销量同比]

from
	(
		select a.[市场数据],round(sum(a.[tp*mix]),-2) as [2022年全年加权价格（TP）],sum(cast([销量] as decimal(18,0))) as [2022年1-12月累计销量]
		from
			(
				select [品牌系别] as [市场数据] , left([年月],4) as '年',[车型编码],[tp],[销量],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )/
							sum((CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )) over( partition by left([年月],4),[品牌系别])
						) as [tp*mix]
				FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2022-01' and [年月]<'2023-01' and  [品牌系别] in ('德系','日系','美系','韩系','欧系','法系')
			)a
		group by a.[市场数据]

	) a
left join 
	(
		select a.[市场数据],round(sum(a.[tp*mix]),-2) as [2023年1-11月全年加权价格（TP）]
		from
			(
				select [品牌系别] as [市场数据] , left([年月],4) as '年',[车型编码],[tp],[销量],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )/
							sum((CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )) over( partition by left([年月],4),[品牌系别])
						) as [tp*mix]

				FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2023-01' and [年月]<'2023-12'   and  [品牌系别] in ('德系','日系','美系','韩系','欧系','法系')
			)a
		group by a.[市场数据]
	) b

on a.[市场数据]=b.[市场数据]

left join 
	(
		select  [品牌系别]  as [市场数据],sum(cast([销量] as decimal(18,0))) as [2022年1-10月累计销量] FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2022-01' and [年月]<'2022-11'  and  [品牌系别] in ('德系','日系','美系','韩系','欧系','法系') group by [品牌系别]
	) c
on a.[市场数据]=c.[市场数据]
left join 
	(
		select  [品牌系别]  as [市场数据],sum(cast([销量] as decimal(18,0))) as [2023年1-10月累计销量] FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] where [年月]>='2023-01' and [年月]<'2023-11'  and  [品牌系别] in ('德系','日系','美系','韩系','欧系','法系') group by [品牌系别] 
	) d
	on a.[市场数据]=d.[市场数据]


