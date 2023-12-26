
------------------------------------------------------------------------月度

select a.[年月], a.[品牌],a.[汽车类别],a.[燃料类型],round(sum(a.[销量*mix]),-2) as 加权TP
from 

(
	select [车型编码],[年月], [品牌],[汽车类别],[燃料类型],[tp], [销量],

	--sum((CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )) over(partition by [年月],[品牌],[汽车类别],[燃料类型]) as 累计销量,

	(
		CONVERT(decimal,[tp])*
		(CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )/
		sum((CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )) over(partition by [年月],[品牌],[汽车类别],[燃料类型])
	) AS [销量*mix]

	from [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] 

	where [品牌] in ('特斯拉','比亚迪','深蓝','小鹏','丰田','本田','马自达','日产','蔚来','极氪','别克','AITO','理想','大众')

	and [燃料类型] in('纯电动','插电式混合动力','增程式电动')

	and [汽车类别] in('MPV','SUV','轿车')

	and trim([年月])>= '2019-01' and trim([年月]) < '2023-11'

)a

group by [年月], [品牌],[汽车类别],[燃料类型]
order  by  [年月], [品牌],[汽车类别],[燃料类型];



------------------------------------------------------------------------季度

select a.[季度], a.[品牌],a.[汽车类别],a.[燃料类型],round(sum(a.[销量*mix]),-2) as 加权TP
from 
(
	select [车型编码],
	(case when RIGHT(trim([年月]),2) in ('01','02','03') then CONCAT( LEFT(trim([年月]),4),'-01')
	when RIGHT(trim([年月]),2) in ('04','05','06') then CONCAT( LEFT(trim([年月]),4),'-02')
	when RIGHT(trim([年月]),2) in ('07','08','09') then CONCAT( LEFT(trim([年月]),4),'-03')
	when RIGHT(trim([年月]),2) in ('10','11','12') then CONCAT( LEFT(trim([年月]),4),'-04')
	END)AS [季度],

	[品牌],[汽车类别],[燃料类型],[tp], [销量],

	(
		CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )/
		sum((CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )) over(partition by left(trim([年月]),4),(cast(right(trim([年月]),2) as int)-1)/3,[品牌],[汽车类别],[燃料类型])
	) AS [销量*mix]

	from [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] 

	where [品牌] in ('特斯拉','比亚迪','深蓝','小鹏','丰田','本田','马自达','日产','蔚来','极氪','别克','AITO','理想','大众')

	and [燃料类型] in('纯电动','插电式混合动力','增程式电动')

	and [汽车类别] in('MPV','SUV','轿车')

	and trim([年月])>= '2019-01' and trim([年月]) < '2023-11'

)a
group by [季度], [品牌],[汽车类别],[燃料类型]
order  by  [季度], [品牌],[汽车类别],[燃料类型];



------------------------------------------------------------------------年度

select a.[年度], a.[品牌],a.[汽车类别],a.[燃料类型],round(sum(a.[销量*mix]),-2) as 加权TP
from 
(

		select [车型编码],LEFT(trim([年月]),4) AS [年度],
		[品牌],[汽车类别],[燃料类型],[tp], [销量],
		(
			CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )/
			sum((CASE WHEN CONVERT(decimal,[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,[销量]) END )) over(partition by left(trim([年月]),4),[品牌],[汽车类别],[燃料类型])
		) AS [销量*mix]

		from [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量] 

		where [品牌] in ('特斯拉','比亚迪','深蓝','小鹏','丰田','本田','马自达','日产','蔚来','极氪','别克','AITO','理想','大众')

		and [燃料类型] in('纯电动','插电式混合动力','增程式电动')

		and [汽车类别] in('MPV','SUV','轿车')

		and trim([年月])>= '2019-01' and trim([年月]) < '2023-11'

)a
group by [年度], [品牌],[汽车类别],[燃料类型]
order  by  [年度], [品牌],[汽车类别],[燃料类型];














