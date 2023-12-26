/****** SSMS 的 SelectTopNRows 命令的脚本  ******/


--------------------------------全市场

select round(sum(a.[tp*mix]),-2) as [2022年全年加权价格（TP）]
from
(
	select  c.[品牌系别] ,a.*,b.[销量],						
		(
			CONVERT(decimal,a.[tp])*(CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )/
			sum((CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )) over( partition by left(a.[年月],4))
		) as [tp*mix]
	from 
		(
		SELECT [年月],[型号编码],round(avg(cast(nullif(tp,N'无车') as decimal(18,0))),-2) as tp
		  FROM [LandRoadsGZ].[dbo].[fact_JLL-终端价格-分城市]  
		  where [年月]>='2022-01'and [年月]<'2023-01' and [周期]='7'
		  group by [年月],[型号编码] 
		)a

	left join 
		(
		  SELECT [年月],[型号编码],[销量]
		  FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数]  
		  where [年月]>='2022-01'and [年月]<'2023-01'
		)b on a.[年月]=b.[年月] and a.[型号编码]=b.[型号编码]

		left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] c on a.型号编码 =c.车型编码 
)a




select round(sum(a.[tp*mix]),-2) as [2023年1-11月全年加权价格（TP）]
from
(
	select  c.[品牌系别] ,a.*,b.[销量],						
		(
			CONVERT(decimal,a.[tp])*(CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )/
			sum((CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )) over( partition by left(a.[年月],4))
		) as [tp*mix]
	from 
		(
		SELECT [年月],[型号编码],round(avg(cast(nullif(tp,N'无车') as decimal(18,0))),-2) as tp
		  FROM [LandRoadsGZ].[dbo].[fact_JLL-终端价格-分城市]  
		  where [年月]>='2023-01'and [年月]<'2023-12' and [周期]='7'
		  group by [年月],[型号编码] 
		)a

	left join 
		(
		  SELECT [年月],[型号编码],[销量]
		  FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数]  
		  where [年月]>='2023-01'and [年月]<'2023-12'
		)b on a.[年月]=b.[年月] and a.[型号编码]=b.[型号编码]

		left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] c on a.型号编码 =c.车型编码 
	
)a




--------------------------------传统能源/新能源

select round(sum(a.[tp*mix]),-2) as [2022年全年加权价格（TP）]
from
(
	select  c.[品牌系别] ,a.*,b.[销量],						
		(
			CONVERT(decimal,a.[tp])*(CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )/
			sum((CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )) over( partition by left(a.[年月],4))
		) as [tp*mix]
	from 
		(
		SELECT [年月],[型号编码],round(avg(cast(nullif(tp,N'无车') as decimal(18,0))),-2) as tp
		  FROM [LandRoadsGZ].[dbo].[fact_JLL-终端价格-分城市]  
		  where [年月]>='2022-01'and [年月]<'2023-01' and [周期]='7'
		  group by [年月],[型号编码] 
		)a

	left join 
		(
		  SELECT [年月],[型号编码],[销量]
		  FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数]  
		  where [年月]>='2022-01'and [年月]<'2023-01'
		)b on a.[年月]=b.[年月] and a.[型号编码]=b.[型号编码]

		left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] c on a.型号编码 =c.车型编码 
		where c.[燃料类型] not in ('纯电动','插电式混合动力','增程式电动')
		--where c.[燃料类型] in ('纯电动','插电式混合动力','增程式电动')

)a




select round(sum(a.[tp*mix]),-2) as [2023年1-11月全年加权价格（TP）]
from
(
	select  c.[品牌系别] ,a.*,b.[销量],						
		(
			CONVERT(decimal,a.[tp])*(CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )/
			sum((CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )) over( partition by left(a.[年月],4))
		) as [tp*mix]
	from 
		(
		SELECT [年月],[型号编码],round(avg(cast(nullif(tp,N'无车') as decimal(18,0))),-2) as tp
		  FROM [LandRoadsGZ].[dbo].[fact_JLL-终端价格-分城市]  
		  where [年月]>='2023-01'and [年月]<'2023-12' and [周期]='7'
		  group by [年月],[型号编码] 
		)a

	left join 
		(
		  SELECT [年月],[型号编码],[销量]
		  FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数]  
		  where [年月]>='2023-01'and [年月]<'2023-12'
		)b on a.[年月]=b.[年月] and a.[型号编码]=b.[型号编码]

		left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] c on a.型号编码 =c.车型编码 

		where c.[燃料类型] not in ('纯电动','插电式混合动力','增程式电动')
		--where c.[燃料类型] in ('纯电动','插电式混合动力','增程式电动')
	
	--where b.销量 is not NULL
)a


--------------------------------自主/非自主
select round(sum(a.[tp*mix]),-2) as [2022年全年加权价格（TP）]
from
(
	select  c.[品牌系别] ,a.*,b.[销量],						
		(
			CONVERT(decimal,a.[tp])*(CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )/
			sum((CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )) over( partition by left(a.[年月],4))
		) as [tp*mix]
	from 
		(
		SELECT [年月],[型号编码],round(avg(cast(nullif(tp,N'无车') as decimal(18,0))),-2) as tp
		  FROM [LandRoadsGZ].[dbo].[fact_JLL-终端价格-分城市]  
		  where [年月]>='2022-01'and [年月]<'2023-01' and [周期]='7'
		  group by [年月],[型号编码] 
		)a

	left join 
		(
		  SELECT [年月],[型号编码],[销量]
		  FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数]  
		  where [年月]>='2022-01'and [年月]<'2023-01'
		)b on a.[年月]=b.[年月] and a.[型号编码]=b.[型号编码]

		left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] c on a.型号编码 =c.车型编码 

		where c.[品牌系别] = '自主'
		--where c.[品牌系别] <>'自主'

)a





select round(sum(a.[tp*mix]),-2) as [2023年1-11月全年加权价格（TP）]
from
(
	select  c.[品牌系别] ,a.*,b.[销量],						
		(
			CONVERT(decimal,a.[tp])*(CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )/
			sum((CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )) over( partition by left(a.[年月],4))
		) as [tp*mix]
	from 
		(
		SELECT [年月],[型号编码],round(avg(cast(nullif(tp,N'无车') as decimal(18,0))),-2) as tp
		  FROM [LandRoadsGZ].[dbo].[fact_JLL-终端价格-分城市]  
		  where [年月]>='2023-01'and [年月]<'2023-12' and [周期]='7'
		  group by [年月],[型号编码] 
		)a

	left join 
		(
		  SELECT [年月],[型号编码],[销量]
		  FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数]  
		  where [年月]>='2023-01'and [年月]<'2023-12'
		)b on a.[年月]=b.[年月] and a.[型号编码]=b.[型号编码]

		left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] c on a.型号编码 =c.车型编码 

		where c.[品牌系别] = '自主'

)a


--------------------------------'德系','日系','美系','韩系','欧系','法系'
select a.[品牌系别],round(sum(a.[tp*mix]),-2) as [2022年全年加权价格（TP）]
from
(
	select  c.[品牌系别] ,a.*,b.[销量],						
		(
			CONVERT(decimal,a.[tp])*(CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )/
			sum((CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )) over( partition by left(a.[年月],4),c.[品牌系别] )
		) as [tp*mix]
	from 
		(
		SELECT [年月],[型号编码],round(avg(cast(nullif(tp,N'无车') as decimal(18,0))),-2) as tp
		  FROM [LandRoadsGZ].[dbo].[fact_JLL-终端价格-分城市]  
		  where [年月]>='2022-01'and [年月]<'2023-01' and [周期]='7'
		  group by [年月],[型号编码] 
		)a

	left join 
		(
		  SELECT [年月],[型号编码],[销量]
		  FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数]  
		  where [年月]>='2022-01'and [年月]<'2023-01'
		)b on a.[年月]=b.[年月] and a.[型号编码]=b.[型号编码]

		left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] c on a.型号编码 =c.车型编码 

		where c.[品牌系别] in ('德系','日系','美系','韩系','欧系','法系')
	

	--where b.销量 is not NULL
)a

group by a.[品牌系别]



select a.[品牌系别],round(sum(a.[tp*mix]),-2) as [2023年1-11月全年加权价格（TP）]
from
(
	select  c.[品牌系别] ,a.*,b.[销量],						
		(
			CONVERT(decimal,a.[tp])*(CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )/
			sum((CASE WHEN CONVERT(decimal,b.[销量])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[销量]) END )) over( partition by left(a.[年月],4),c.[品牌系别] )
		) as [tp*mix]
	from 
		(
		SELECT [年月],[型号编码],round(avg(cast(nullif(tp,N'无车') as decimal(18,0))),-2) as tp
		  FROM [LandRoadsGZ].[dbo].[fact_JLL-终端价格-分城市]  
		  where [年月]>='2023-01'and [年月]<'2023-12' and [周期]='7'
		  group by [年月],[型号编码] 
		)a

	left join 
		(
		  SELECT [年月],[型号编码],[销量]
		  FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数]  
		  where [年月]>='2023-01'and [年月]<'2023-12'
		)b on a.[年月]=b.[年月] and a.[型号编码]=b.[型号编码]

		left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] c on a.型号编码 =c.车型编码 

		where c.[品牌系别] in ('德系','日系','美系','韩系','欧系','法系')
	
	
	--where b.销量 is not NULL
)a
group by a.[品牌系别]






--select  sum(tp)
--from 
--(
--		SELECT [月份],[车型编码],round(avg(cast(nullif(价格,N'无车') as decimal(18,0))),-2) as tp
--		  FROM [LandRoadsGZ].[dbo].[ods_SGM-传统汽车价格表]  
--		  where [月份]>='2023-01'and [月份]<'2023-12' and [周期]='7'
--		  group by [月份],[车型编码] 
--)a


--select *
--FROM  [LandRoadsGZ].[dbo].[fact_JLL_终端价格销量]
--where [年月]>='2023-01'and [年月]<'2023-12'
--and  [备注]='传统能源'



--		  SELECT sum([销量])
--		  FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数]  
--		  where [年月]>='2022-01'and [年月]<'2023-01'