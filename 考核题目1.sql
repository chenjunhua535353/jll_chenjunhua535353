
--drop table if exists #tp

--select a.���,a.[Ʒ��],a.�������,a.�ӳ�ϵ,a.�ӳ�ϵ����,a.ȼ������,round(sum([tp*mix]),-2) as ��Ȩtp 
--into #tp

--from 
--(
--	select  left(a.[����],4) as [���],c.[Ʒ��],c.[�������],c.[�ӳ�ϵ],c.[�ӳ�ϵ����],c.[ȼ������] ,	
--		(
--			CONVERT(decimal,a.[tp])*(CASE WHEN CONVERT(decimal,b.[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[����]) END )/
--			sum((CASE WHEN CONVERT(decimal,b.[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[����]) END )) over( partition by left(a.[����],4),c.[Ʒ��],c.�������,c.�ӳ�ϵ,c.�ӳ�ϵ����,c.ȼ������ )
--		) as [tp*mix]
--	from 
--		(
--		SELECT [����],[�ͺű���],round(avg(cast(nullif(tp,N'�޳�') as decimal(18,0))),-2) as tp
--		  FROM [LandRoadsGZ].[dbo].[fact_JLL-�ն˼۸�-�ֳ���]  
--		  where [����]>='2023-01' and [����]<'2023-11' and [����]='7'
--		  group by [����],[�ͺű���] 
--		)a

--	left join 
--		(
--		  SELECT [����],[�ͺű���],[����]
--		  FROM [LandRoadsGZ].[dbo].[mid_JLL�ͺ�������]  
--		  where  [����]>='2023-01' and [����]<'2023-11'
--		)b on a.[����]=b.[����] and a.[�ͺű���]=b.[�ͺű���]

--	left join [LandRoadsGZ].[dbo].[dim_SGM���ͱ����-ƥ��JLL] c on a.�ͺű��� =c.���ͱ��� 
--)a

-- group by a.���,a.[Ʒ��],a.�������,a.�ӳ�ϵ,a.�ӳ�ϵ����,a.ȼ������





-- select  *  from  #tp


--select a.���,a.[Ʒ��],a.�������,a.�ӳ�ϵ,a.�ӳ�ϵ����,a.ȼ������,a.[�۸��],sum([����]) as [����]

--from 
--(

--		select a.���,a.[Ʒ��],a.�������,a.�ӳ�ϵ,a.�ӳ�ϵ����,a.ȼ������,a.��Ȩtp,

--		(case when a.��Ȩtp <200000 then '20������'
--			when a.��Ȩtp >=200000 and a.��Ȩtp <210000 then '20-21��'
--			when a.��Ȩtp >=210000 and a.��Ȩtp <220000 then '21-22��'
--			when a.��Ȩtp >=220000 and a.��Ȩtp <230000 then '22-23��'
--			when a.��Ȩtp >=230000 and a.��Ȩtp <240000 then '23-24��'
--			when a.��Ȩtp >=240000 and a.��Ȩtp <250000 then '24-25��'
--			when a.��Ȩtp >=250000 and a.��Ȩtp <260000 then '25-26��'
--			when a.��Ȩtp >=260000 and a.��Ȩtp <260000 then '26-27��'
--			when a.��Ȩtp >=270000 and a.��Ȩtp <280000 then '27-28��'
--			when a.��Ȩtp >=280000 and a.��Ȩtp <290000 then '28-29��'
--			when a.��Ȩtp >=290000 and a.��Ȩtp <300000 then '29-30��'
--			else '30������' end ) as [�۸��],

--			b.����

--		FROM  #tp a

--		left join 
--			(
--					select ���,[Ʒ��],�������,�ӳ�ϵ,�ӳ�ϵ����,ȼ������,sum(cast([����] as decimal(18,0))) as [����]

--					from
--					[LandRoadsGZ].[dbo].[ods_JLL-�±�׼����������] where concat(���,'-',�·�)>'2023-01' and concat(���,'-',�·�)<'2023-11' 

--					group by  ���,[Ʒ��],�������,�ӳ�ϵ,�ӳ�ϵ����,ȼ������
--			)  b  

--			on a.���=b.��� and a.�ӳ�ϵ����=b.�ӳ�ϵ���� and a.[Ʒ��]=b.[Ʒ��] and a.�������=b.������� and a.ȼ������=b.ȼ������ and a.�ӳ�ϵ=b.�ӳ�ϵ

--) a

--group by a.���,a.[Ʒ��],a.�������,a.�ӳ�ϵ,a.�ӳ�ϵ����,a.ȼ������,a.[�۸��]




------------------------------------------------------------------------------------------------------------------------������Ŀ1

drop table if exists #mix

	select  a.�ͺű���,a.����,left(a.[����],4) as [���],c.[Ʒ��],c.[�������],c.[�ӳ�ϵ],c.[�ӳ�ϵ����],c.[ȼ������],a.tp,b.[����],
		(
			(CASE WHEN CONVERT(decimal,b.[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[����]) END )/
			sum((CASE WHEN CONVERT(decimal,b.[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,b.[����]) END )) over( partition by a.[����],c.[Ʒ��],c.�������,c.�ӳ�ϵ,c.�ӳ�ϵ����,c.ȼ������ )
		) as [mix],

		(case when a.tp <200000 then '20������'
				when a.tp >=300000 then '30������' 
				when ((a.tp-200000)/10000)>=FLOOR((a.tp-200000)/10000) and ((a.tp-200000)/10000)< ceiling((a.tp-200000)/10000)  
											then concat( cast( ceiling( (a.tp-200000)/10000)+20-1 as varchar(10)),'-',cast(ceiling((a.tp-200000)/10000)+20 as varchar(10)) ,'��')
		end)as [�۸��]

		--(case when a.tp <200000 then '20������'
		--	when a.tp >=200000 and a.tp <210000 then '20-21��'
		--	when a.tp >=210000 and a.tp <220000 then '21-22��'
		--	when a.tp >=220000 and a.tp <230000 then '22-23��'
		--	when a.tp >=230000 and a.tp <240000 then '23-24��'
		--	when a.tp >=240000 and a.tp <250000 then '24-25��'
		--	when a.tp >=250000 and a.tp <260000 then '25-26��'
		--	when a.tp >=260000 and a.tp <260000 then '26-27��'
		--	when a.tp >=270000 and a.tp <280000 then '27-28��'
		--	when a.tp >=280000 and a.tp <290000 then '28-29��'
		--	when a.tp >=290000 and a.tp <300000 then '29-30��'
		--	else '30������' end ) as [�۸��]

    into #mix
	from 
		(
		SELECT [����],[�ͺű���],round(avg(cast(nullif(tp,N'�޳�') as decimal(18,0))),-2) as tp
		  FROM [LandRoadsGZ].[dbo].[fact_JLL-�ն˼۸�-�ֳ���]  
		  where [����]>='2023-01' and [����]<'2023-11' and [����]='7'
		  group by [����],[�ͺű���] 
		)a

	left join 
		(
		  SELECT [����],[�ͺű���],[����]
		  FROM [LandRoadsGZ].[dbo].[mid_JLL�ͺ�������]  
		  where  [����]>='2023-01' and [����]<'2023-11'
		)b on a.[����]=b.[����] and a.[�ͺű���]=b.[�ͺű���]

	left join [LandRoadsGZ].[dbo].[dim_SGM���ͱ����-ƥ��JLL] c on a.�ͺű��� =c.���ͱ��� 

--select *  from #mix



drop table if exists #��������

select [����],[���],[Ʒ��],[�������],[�ӳ�ϵ],[�ӳ�ϵ����],[ȼ������],sum(cast([����] as decimal(18,0))) as [����]

into #��������

from [LandRoadsGZ].[dbo].[fact_JLL-����������]

where  [����]>='2023-01' and [����]<'2023-11'

group  by [����],[���],[Ʒ��],[�������],[�ӳ�ϵ],[�ӳ�ϵ����],[ȼ������]

--select *  from #��������


select a.���,a.Ʒ��,a.�������,a.�ӳ�ϵ,a.�ӳ�ϵ����,a.ȼ������,a.�۸��,SUM(a.[����_mix]) as [����_]
from 

(
	select a.*,round(b.[����]*a.[mix],0) as [����_mix]

	from #mix a left join #�������� b  on  a.[����]=b.[����] and a.[�ӳ�ϵ����]=b.[�ӳ�ϵ����] and a.[Ʒ��]=b.[Ʒ��] and a.[�������]=b.[�������] and a.[ȼ������]=b.[ȼ������] and a.[�ӳ�ϵ]=b.[�ӳ�ϵ]

	--order by a.[����],a.[�ӳ�ϵ����],a.Ʒ��,a.�������,a.�ӳ�ϵ,a.ȼ������ asc

)a

group  by a.���,a.Ʒ��,a.�������,a.�ӳ�ϵ,a.�ӳ�ϵ����,a.ȼ������,a.�۸��

order by   a.���,a.Ʒ��,a.�������,a.�ӳ�ϵ,a.�ӳ�ϵ����,a.ȼ������,a.�۸��





--У��
--select [���],[Ʒ��],[�������],[�ӳ�ϵ],[�ӳ�ϵ����],[ȼ������],sum(cast([����] as decimal(18,0))) as [����]

--from [LandRoadsGZ].[dbo].[fact_JLL-����������]

--where  [����]>='2023-01' and [����]<'2023-11' and [�ӳ�ϵ����] in ('J108215001')

--group  by [���],[Ʒ��],[�������],[�ӳ�ϵ],[�ӳ�ϵ����],[ȼ������]