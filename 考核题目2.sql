select a.[年月],a.[品牌],round(sum(a.[tp*mix]),-2) as [加权tp]
from
(
	select  c.[品牌] ,a.*,b.[销量],						
		(
			CONVERT(decimal,a.[tp])*(CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )/
			sum((CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )) over( partition by a.[年月],c.[品牌] )
		) as [tp*mix]
	from 
		(
		SELECT [年月],[型号编码],round(avg(cast(nullif(tp,N'无车') as decimal(18,0))),-2) as tp
		  FROM [LandRoadsGZ].[dbo].[fact_JLL-终端价格-分城市]  
		  where [年月]>='2022-01' and [周期]='7'
		  group by [年月],[型号编码] 
		)a

	left join 
		(
		  SELECT [年月],[型号编码],[销量]
		  FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数]  
		  where [年月]>='2022-01'
		)b on a.[年月]=b.[年月] and a.[型号编码]=b.[型号编码]

		left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] c on a.型号编码 =c.车型编码 

		where  c.[品牌] = '别克' and c.[子车系]  <>'别克GL8'
)a
		group by  a.[年月],a.[品牌]
		order by a.[年月] desc
		 


select a.[年月],a.[品牌],round(sum(a.[msrp*mix]),-2)as [加权msrp]
from
(
	select  c.[品牌] ,a.*,b.[销量],						
		(
			CONVERT(decimal,a.[msrp])*(CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )/
			sum((CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )) over( partition by a.[年月],c.[品牌] )
		) as [msrp*mix]
	from 
		(
		SELECT [年月],[型号编码],round(avg(cast([msrp] as decimal(18,0))),-2) as msrp
		  FROM [LandRoadsGZ].[dbo].[fact_JLL-终端价格-分城市]  
		  where [年月]>='2022-01' and [周期]='7'
		  group by [年月],[型号编码] 
		)a

	left join 
		(
		  SELECT [年月],[型号编码],[销量]
		  FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数]  
		  where [年月]>='2022-01'
		)b on a.[年月]=b.[年月] and a.[型号编码]=b.[型号编码]

		left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] c on a.型号编码 =c.车型编码 

		where  c.[品牌] = '别克' and c.[子车系]  <>'别克GL8'
)a
		group by  a.[年月],a.[品牌]
		order by a.[年月] desc





select a.[年月],a.[品牌],round(sum(a.[zk*mix]),-2)as [加权折扣]
from
(
	select  c.[品牌] ,a.*,b.[销量],						
		(
			CONVERT(decimal,a.[zk])*(CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )/
			sum((CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )) over( partition by a.[年月],c.[品牌] )
		) as [zk*mix]
	from 
		(
		SELECT [年月],[型号编码],round(avg(cast([msrp] as decimal(18,0))),-2)-round(avg(cast(nullif(tp,N'无车') as decimal(18,0))),-2) as zk
		  FROM [LandRoadsGZ].[dbo].[fact_JLL-终端价格-分城市]  
		  where [年月]>='2022-01' and [周期]='7'
		  group by [年月],[型号编码] 
		)a

	left join 
		(
		  SELECT [年月],[型号编码],[销量]
		  FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数]  
		  where [年月]>='2022-01'
		)b on a.[年月]=b.[年月] and a.[型号编码]=b.[型号编码]

		left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] c on a.型号编码 =c.车型编码 

		where  c.[品牌] = '别克' and c.[子车系]  <>'别克GL8'
)a
		group by  a.[年月],a.[品牌]
		order by a.[年月] desc