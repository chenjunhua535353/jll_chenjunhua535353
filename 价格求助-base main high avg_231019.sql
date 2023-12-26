






select aa.子车系编码,
min(aa.msrp)as Basemsrp,
sum((case when aa.px=1 then aa.msrp  else  0 end)) as mainmsrp,
max(aa.msrp)as highmsrp,
round(sum(aa.msrp*aa.型号销量/aa.车型销量),-2) as Averagemsrp,
min(aa.tp)as Basetp,
sum((case when aa.px=1 then aa.tp  else  0 end)) as maintp,
max(aa.tp)as hightp,
round(sum(aa.tp*aa.型号销量/aa.车型销量),-2) as Averagetp

from 

	(
	select a.子车系编码,a.型号编码,a.msrp,a.tp,a.型号销量,a.车型销量,a.型号销量/a.车型销量 as mix,

	row_number() over(partition by a.子车系编码 order by a.型号销量/a.车型销量 desc ,a.msrp asc) as px

	from 

		(
		select c.子车系编码,a.*,

		(case when b.型号销量  is null then 0.0000001 when b.型号销量=0 then 0.0000001  else b.型号销量 end) as 型号销量,

		sum((case when b.型号销量  is null then 0.0000001 when b.型号销量=0 then 0.0000001  else b.型号销量 end)) over(partition by c.子车系编码) as 车型销量

		from 
			(
				select a.型号编码,
				round(avg(CONVERT(decimal,a.msrp))/100,0)*100 as msrp,

				round(avg(CONVERT(decimal,a.tp))/100,0)*100 as tp

				from [LandRoadsGZ].[dbo].[fact_JLL-终端价格-分城市] a
				where 年月='2023-10'and  a.tp <>'无车'
				group by a.型号编码
			)a

		left join 
			(
				select b.型号编码, CONVERT(decimal,b.销量) as 型号销量
				from [LandRoadsGZ].[dbo].[mid_JLL型号上险数] b
				where 年月='2023-10'
			)b on a.型号编码=b.型号编码

		left join  [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] c   on a.型号编码=c.车型编码

		)a

	--where a.子车系编码 in ('J025007036')

	)aa

group by   aa.子车系编码




