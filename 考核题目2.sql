select a.[����],a.[Ʒ��],round(sum(a.[tp*mix]),-2) as [��Ȩtp]
from
(
	select  c.[Ʒ��] ,a.*,b.[����],						
		(
			CONVERT(decimal,a.[tp])*(CASE WHEN CONVERT(decimal,b.[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[����]) END )/
			sum((CASE WHEN CONVERT(decimal,b.[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[����]) END )) over( partition by a.[����],c.[Ʒ��] )
		) as [tp*mix]
	from 
		(
		SELECT [����],[�ͺű���],round(avg(cast(nullif(tp,N'�޳�') as decimal(18,0))),-2) as tp
		  FROM [LandRoadsGZ].[dbo].[fact_JLL-�ն˼۸�-�ֳ���]  
		  where [����]>='2022-01' and [����]='7'
		  group by [����],[�ͺű���] 
		)a

	left join 
		(
		  SELECT [����],[�ͺű���],[����]
		  FROM [LandRoadsGZ].[dbo].[mid_JLL�ͺ�������]  
		  where [����]>='2022-01'
		)b on a.[����]=b.[����] and a.[�ͺű���]=b.[�ͺű���]

		left join [LandRoadsGZ].[dbo].[dim_SGM���ͱ����-ƥ��JLL] c on a.�ͺű��� =c.���ͱ��� 

		where  c.[Ʒ��] = '���' and c.[�ӳ�ϵ]  <>'���GL8'
)a
		group by  a.[����],a.[Ʒ��]
		order by a.[����] desc
		 


select a.[����],a.[Ʒ��],round(sum(a.[msrp*mix]),-2)as [��Ȩmsrp]
from
(
	select  c.[Ʒ��] ,a.*,b.[����],						
		(
			CONVERT(decimal,a.[msrp])*(CASE WHEN CONVERT(decimal,b.[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[����]) END )/
			sum((CASE WHEN CONVERT(decimal,b.[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[����]) END )) over( partition by a.[����],c.[Ʒ��] )
		) as [msrp*mix]
	from 
		(
		SELECT [����],[�ͺű���],round(avg(cast([msrp] as decimal(18,0))),-2) as msrp
		  FROM [LandRoadsGZ].[dbo].[fact_JLL-�ն˼۸�-�ֳ���]  
		  where [����]>='2022-01' and [����]='7'
		  group by [����],[�ͺű���] 
		)a

	left join 
		(
		  SELECT [����],[�ͺű���],[����]
		  FROM [LandRoadsGZ].[dbo].[mid_JLL�ͺ�������]  
		  where [����]>='2022-01'
		)b on a.[����]=b.[����] and a.[�ͺű���]=b.[�ͺű���]

		left join [LandRoadsGZ].[dbo].[dim_SGM���ͱ����-ƥ��JLL] c on a.�ͺű��� =c.���ͱ��� 

		where  c.[Ʒ��] = '���' and c.[�ӳ�ϵ]  <>'���GL8'
)a
		group by  a.[����],a.[Ʒ��]
		order by a.[����] desc





select a.[����],a.[Ʒ��],round(sum(a.[zk*mix]),-2)as [��Ȩ�ۿ�]
from
(
	select  c.[Ʒ��] ,a.*,b.[����],						
		(
			CONVERT(decimal,a.[zk])*(CASE WHEN CONVERT(decimal,b.[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[����]) END )/
			sum((CASE WHEN CONVERT(decimal,b.[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[����]) END )) over( partition by a.[����],c.[Ʒ��] )
		) as [zk*mix]
	from 
		(
		SELECT [����],[�ͺű���],round(avg(cast([msrp] as decimal(18,0))),-2)-round(avg(cast(nullif(tp,N'�޳�') as decimal(18,0))),-2) as zk
		  FROM [LandRoadsGZ].[dbo].[fact_JLL-�ն˼۸�-�ֳ���]  
		  where [����]>='2022-01' and [����]='7'
		  group by [����],[�ͺű���] 
		)a

	left join 
		(
		  SELECT [����],[�ͺű���],[����]
		  FROM [LandRoadsGZ].[dbo].[mid_JLL�ͺ�������]  
		  where [����]>='2022-01'
		)b on a.[����]=b.[����] and a.[�ͺű���]=b.[�ͺű���]

		left join [LandRoadsGZ].[dbo].[dim_SGM���ͱ����-ƥ��JLL] c on a.�ͺű��� =c.���ͱ��� 

		where  c.[Ʒ��] = '���' and c.[�ӳ�ϵ]  <>'���GL8'
)a
		group by  a.[����],a.[Ʒ��]
		order by a.[����] desc