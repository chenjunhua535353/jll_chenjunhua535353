/****** SSMS 的 SelectTopNRows 命令的脚本  ******/

select a.子车系编码,a.年月,a.型号编码,a.车型全称,b.[城市],b.[品牌],b.[子车系],round( b.销量*a.型号销量/a.sum销量,0) as 城市型号销量
FROM 
	(
		SELECT a.子车系编码,c.年月,c.型号编码,a.车型全称,c.销量 as 型号销量,
		sum(CONVERT(decimal,c.销量)) over(partition by a.子车系编码,c.年月) as sum销量
		,CONVERT(decimal,c.销量)/sum(CONVERT(decimal,c.销量)) over(partition by a.子车系编码,c.年月) mix

		FROM [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] a 
		left join  [LandRoadsGZ].[dbo].[mid_JLL型号上险数] c on a.车型编码=c.型号编码

		where  a.子车系编码 in('J018018049','J067088006','J018018020','J067088002')
		and c.年月 like '2023%' 
	)a
left join 
	(
		 SELECT b.[年份],b.[月份] ,b.[城市] ,b.[品牌],b.[子车系] ,b.[子车系编码],sum(CONVERT(decimal,b.[销量])) as [销量]

		 FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数] b

		 where   b.子车系编码 in('J018018049','J067088006','J018018020','J067088002')
		 and b.[年份]='2023'
		 group by b.[年份] ,b.[月份],b.[城市] ,b.[品牌],b.[子车系],b.[子车系编码]
	 )b 
	
on a.子车系编码=b.子车系编码  and a.年月=concat(b.年份,'-',b.[月份])

order  by a.年月,a.子车系编码,a.型号编码

