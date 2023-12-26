--��Ŀ1���밴����������������͵���20-30��1��һ���εļ۸���������ݣ�ʱ�䷶Χ2023��1-10���ۼơ���Ҫ�����ֶΣ���excel���������


drop table if exists #�۸��

select left([����],4) as [���] ,[���ͱ���],[Ʒ��],[�������],[�ӳ�ϵ],[�ӳ�ϵ����],[ȼ������],[tp],[����],
(case when [tp]<200000 then '20������'
	when [tp]>=200000 and [tp]<210000 then '20-21��'
	when [tp]>=210000 and [tp]<220000 then '21-22��'
	when [tp]>=220000 and [tp]<230000 then '22-23��'
	when [tp]>=230000 and [tp]<240000 then '23-24��'
	when [tp]>=240000 and [tp]<250000 then '24-25��'
	when [tp]>=250000 and [tp]<260000 then '25-26��'
	when [tp]>=260000 and [tp]<260000 then '26-27��'
	when [tp]>=270000 and [tp]<280000 then '27-28��'
	when [tp]>=280000 and [tp]<290000 then '28-29��'
	when [tp]>=290000 and [tp]<300000 then '29-30��'
	else '30������' end ) as [�۸��]
	into #�۸��

FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����]

where [����]>='2023-01'and [����]<'2023-11'


select [���],[Ʒ��],[�������],[�ӳ�ϵ],[�ӳ�ϵ����],[ȼ������],[�۸��],sum(cast([����] as decimal(18,0))) as [����]  from #�۸��

where [�۸��] !='30������'and  [�۸��] !='20������'

group  by  [���],[Ʒ��],[�������],[�ӳ�ϵ],[�ӳ�ϵ����],[ȼ������],[�۸��]



--��Ŀ2���밴����������������͵���2022-2023����£����Ʒ�Ƶļ�ȨMSRP/TP/�ۿۣ�����Ҫ�޳����GL8������ͣ���Ҫ�����ֶΣ���excel���������

drop table if exists #mix

select [����],[���ͱ���],[Ʒ��],[tp],[����],[msrp],[msrp]-[tp] as [�ۿ�],

		(
			CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )/

			sum((CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )) over( partition by [����])

		) as [tp*mix],

		(
			CONVERT(decimal,[msrp])*(CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )/

			sum((CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )) over( partition by [����])

		) as [msrp*mix],

		(
			(CONVERT(decimal,[msrp])-CONVERT(decimal,[tp]))*(CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )/

			sum((CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )) over( partition by [����])

		) as [�ۿ�*mix]

		into #mix


FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����]

where [����]>='2022-01' and [Ʒ��] = '���' and [�ӳ�ϵ]  <>'���GL8'


select [����],[Ʒ��],round(sum([tp*mix]),-2) as ��ȨTP, round(sum([msrp*mix]),-2)  as ��Ȩmsrp,round(sum([�ۿ�*mix]),-2) as ��Ȩ�ۿ�

from  #mix

group  by [����],[Ʒ��]






--��Ŀ3���밴����������������͵��������г����ݵļ�Ȩ�۸���������ݣ���Ҫ�����ֶΣ���excel���������


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ȫ�г�

select a.�г�����,a.[2022��ȫ���Ȩ�۸�TP��],b.[2023��1-11��ȫ���Ȩ�۸�TP��],ABS(b.[2023��1-11��ȫ���Ȩ�۸�TP��]-a.[2022��ȫ���Ȩ�۸�TP��]) as [������������ֵ]

,round(a.[2022��1-12���ۼ�����],0) as [2022��1-12���ۼ�����],c.[2022��1-10���ۼ�����],d.[2023��1-10���ۼ�����],(d.[2023��1-10���ۼ�����]-c.[2022��1-10���ۼ�����]) as [2023��1-10������ͬ��]

from
	(
		select a.[�г�����],round(sum(a.[tp*mix]),-2) as [2022��ȫ���Ȩ�۸�TP��],sum(cast([����] as decimal(18,0))) as [2022��1-12���ۼ�����]
		from
			(
				select 'ȫ�г�'as [�г�����] , left([����],4) as '��',[���ͱ���],[tp],[����],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )/
							sum((CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )) over( partition by left([����],4))
						) as [tp*mix]
				FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2022-01' and [����]<'2023-01'
			)a
		group by a.[�г�����]

	) a
left join 
	(
		select a.[�г�����],round(sum(a.[tp*mix]),-2) as [2023��1-11��ȫ���Ȩ�۸�TP��]
		from
			(
				select 'ȫ�г�'as [�г�����] , left([����],4) as '��',[���ͱ���],[tp],[����],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )/
							sum((CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )) over( partition by left([����],4))
						) as [tp*mix]

				FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2023-01' and [����]<'2023-12'
			)a
		group by a.[�г�����]
	) b

on a.[�г�����]=b.[�г�����]
left join 
	(
		select  'ȫ�г�' as [�г�����],sum(cast([����] as decimal(18,0))) as [2022��1-10���ۼ�����] FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2022-01' and [����]<'2022-11'
	) c
on a.[�г�����]=c.[�г�����]
left join 
	(
		select  'ȫ�г�' as [�г�����],sum(cast([����] as decimal(18,0))) as [2023��1-10���ۼ�����] FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2023-01' and [����]<'2023-11'
	) d
	on a.[�г�����]=d.[�г�����]

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------��ͳ��Դ
union all

select a.�г�����,a.[2022��ȫ���Ȩ�۸�TP��],b.[2023��1-11��ȫ���Ȩ�۸�TP��],ABS(b.[2023��1-11��ȫ���Ȩ�۸�TP��]-a.[2022��ȫ���Ȩ�۸�TP��]) as [������������ֵ]

,round(a.[2022��1-12���ۼ�����],0) as [2022��1-12���ۼ�����],c.[2022��1-10���ۼ�����],d.[2023��1-10���ۼ�����],(d.[2023��1-10���ۼ�����]-c.[2022��1-10���ۼ�����]) as [2023��1-10������ͬ��]

from
	(
		select a.[�г�����],round(sum(a.[tp*mix]),-2) as [2022��ȫ���Ȩ�۸�TP��],sum(cast([����] as decimal(18,0))) as [2022��1-12���ۼ�����]
		from
			(

				select '��ͳ��Դ'as [�г�����] , left([����],4) as '��',[���ͱ���],[tp],[����],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )/
							sum((CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )) over( partition by left([����],4))
						) as [tp*mix]

				FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2022-01' and [����]<'2023-01' and  [ȼ������] not in ('���綯','���ʽ��϶���','����ʽ�綯')

			)a
		group by a.[�г�����]

	) a
left join 
	(
		select a.[�г�����],round(sum(a.[tp*mix]),-2) as [2023��1-11��ȫ���Ȩ�۸�TP��]
		from
			(
				select '��ͳ��Դ'as [�г�����] , left([����],4) as '��',[���ͱ���],[tp],[����],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )/
							sum((CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )) over( partition by left([����],4))
						) as [tp*mix]

				FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2023-01' and [����]<'2023-12'  and  [ȼ������] not in ('���綯','���ʽ��϶���','����ʽ�綯')
			)a
		group by a.[�г�����]
	) b

on a.[�г�����]=b.[�г�����]

left join 
	(
		select  '��ͳ��Դ' as [�г�����],sum(cast([����] as decimal(18,0))) as [2022��1-10���ۼ�����] FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2022-01' and [����]<'2022-11' and  [ȼ������] not in ('���綯','���ʽ��϶���','����ʽ�綯')
	) c
on a.[�г�����]=c.[�г�����]
left join 
	(
		select  '��ͳ��Դ' as [�г�����],sum(cast([����] as decimal(18,0))) as [2023��1-10���ۼ�����] FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2023-01' and [����]<'2023-11' and  [ȼ������] not in ('���綯','���ʽ��϶���','����ʽ�綯')
	) d
	on a.[�г�����]=d.[�г�����]
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------����Դ
union all

select a.�г�����,a.[2022��ȫ���Ȩ�۸�TP��],b.[2023��1-11��ȫ���Ȩ�۸�TP��],ABS(b.[2023��1-11��ȫ���Ȩ�۸�TP��]-a.[2022��ȫ���Ȩ�۸�TP��]) as [������������ֵ]

,round(a.[2022��1-12���ۼ�����],0) as [2022��1-12���ۼ�����],c.[2022��1-10���ۼ�����],d.[2023��1-10���ۼ�����],(d.[2023��1-10���ۼ�����]-c.[2022��1-10���ۼ�����]) as [2023��1-10������ͬ��]

from
	(
		select a.[�г�����],round(sum(a.[tp*mix]),-2) as [2022��ȫ���Ȩ�۸�TP��],sum(cast([����] as decimal(18,0))) as [2022��1-12���ۼ�����]
		from
			(
				select '����Դ'as [�г�����] , left([����],4) as '��',[���ͱ���],[tp],[����],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )/
							sum((CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )) over( partition by left([����],4))
						) as [tp*mix]
				FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2022-01' and [����]<'2023-01' and  [ȼ������] in ('���綯','���ʽ��϶���','����ʽ�綯')
			)a
		group by a.[�г�����]

	) a
left join 
	(
		select a.[�г�����],round(sum(a.[tp*mix]),-2) as [2023��1-11��ȫ���Ȩ�۸�TP��]
		from
			(
				select '����Դ'as [�г�����] , left([����],4) as '��',[���ͱ���],[tp],[����],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )/
							sum((CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )) over( partition by left([����],4))
						) as [tp*mix]

				FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2023-01' and [����]<'2023-12' and  [ȼ������] in ('���綯','���ʽ��϶���','����ʽ�綯')
			)a
		group by a.[�г�����]
	) b

on a.[�г�����]=b.[�г�����]

left join 
	(
		select  '����Դ' as [�г�����],sum(cast([����] as decimal(18,0))) as [2022��1-10���ۼ�����] FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2022-01' and [����]<'2022-11'and [ȼ������] in ('���綯','���ʽ��϶���','����ʽ�綯')
	) c
on a.[�г�����]=c.[�г�����]
left join 
	(
		select  '����Դ' as [�г�����],sum(cast([����] as decimal(18,0))) as [2023��1-10���ۼ�����] FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2023-01' and [����]<'2023-11'and [ȼ������] in ('���綯','���ʽ��϶���','����ʽ�綯')
	) d
	on a.[�г�����]=d.[�г�����]
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------����Ʒ��
union all

select a.�г�����,a.[2022��ȫ���Ȩ�۸�TP��],b.[2023��1-11��ȫ���Ȩ�۸�TP��],ABS(b.[2023��1-11��ȫ���Ȩ�۸�TP��]-a.[2022��ȫ���Ȩ�۸�TP��]) as [������������ֵ]

,round(a.[2022��1-12���ۼ�����],0) as [2022��1-12���ۼ�����],c.[2022��1-10���ۼ�����],d.[2023��1-10���ۼ�����],(d.[2023��1-10���ۼ�����]-c.[2022��1-10���ۼ�����]) as [2023��1-10������ͬ��]

from
	(
		select a.[�г�����],round(sum(a.[tp*mix]),-2) as [2022��ȫ���Ȩ�۸�TP��],sum(cast([����] as decimal(18,0))) as [2022��1-12���ۼ�����]
		from
			(
				select '����Ʒ��'as [�г�����] , left([����],4) as '��',[���ͱ���],[tp],[����],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )/
							sum((CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )) over( partition by left([����],4))
						) as [tp*mix]
				FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2022-01' and [����]<'2023-01' and  [Ʒ��ϵ��]='����'
			)a
		group by a.[�г�����]

	) a
left join 
	(
		select a.[�г�����],round(sum(a.[tp*mix]),-2) as [2023��1-11��ȫ���Ȩ�۸�TP��]
		from
			(
				select '����Ʒ��'as [�г�����] , left([����],4) as '��',[���ͱ���],[tp],[����],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )/
							sum((CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )) over( partition by left([����],4))
						) as [tp*mix]

				FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2023-01' and [����]<'2023-12'  and  [Ʒ��ϵ��]='����'
			)a
		group by a.[�г�����]
	) b

on a.[�г�����]=b.[�г�����]

left join 
	(
		select  '����Ʒ��' as [�г�����],sum(cast([����] as decimal(18,0))) as [2022��1-10���ۼ�����] FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2022-01' and [����]<'2022-11' and  [Ʒ��ϵ��]='����'
	) c
on a.[�г�����]=c.[�г�����]
left join 
	(
		select  '����Ʒ��' as [�г�����],sum(cast([����] as decimal(18,0))) as [2023��1-10���ۼ�����] FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2023-01' and [����]<'2023-11' and  [Ʒ��ϵ��]='����'
	) d
	on a.[�г�����]=d.[�г�����]
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------������Ʒ��
union all

select a.�г�����,a.[2022��ȫ���Ȩ�۸�TP��],b.[2023��1-11��ȫ���Ȩ�۸�TP��],ABS(b.[2023��1-11��ȫ���Ȩ�۸�TP��]-a.[2022��ȫ���Ȩ�۸�TP��]) as [������������ֵ]

,round(a.[2022��1-12���ۼ�����],0) as [2022��1-12���ۼ�����],c.[2022��1-10���ۼ�����],d.[2023��1-10���ۼ�����],(d.[2023��1-10���ۼ�����]-c.[2022��1-10���ۼ�����]) as [2023��1-10������ͬ��]

from
	(
		select a.[�г�����],round(sum(a.[tp*mix]),-2) as [2022��ȫ���Ȩ�۸�TP��],sum(cast([����] as decimal(18,0))) as [2022��1-12���ۼ�����]
		from
			(
				select '������Ʒ��'as [�г�����] , left([����],4) as '��',[���ͱ���],[tp],[����],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )/
							sum((CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )) over( partition by left([����],4))
						) as [tp*mix]
				FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2022-01' and [����]<'2023-01' and  [Ʒ��ϵ��]<>'����'
			)a
		group by a.[�г�����]

	) a
left join 
	(
		select a.[�г�����],round(sum(a.[tp*mix]),-2) as [2023��1-11��ȫ���Ȩ�۸�TP��]
		from
			(
				select '������Ʒ��'as [�г�����] , left([����],4) as '��',[���ͱ���],[tp],[����],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )/
							sum((CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )) over( partition by left([����],4))
						) as [tp*mix]

				FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2023-01' and [����]<'2023-12'  and  [Ʒ��ϵ��]<>'����'
			)a
		group by a.[�г�����]
	) b

on a.[�г�����]=b.[�г�����]

left join 
	(
		select  '������Ʒ��' as [�г�����],sum(cast([����] as decimal(18,0))) as [2022��1-10���ۼ�����] FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2022-01' and [����]<'2022-11' and  [Ʒ��ϵ��]<>'����'
	) c
on a.[�г�����]=c.[�г�����]
left join 
	(
		select  '������Ʒ��' as [�г�����],sum(cast([����] as decimal(18,0))) as [2023��1-10���ۼ�����] FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2023-01' and [����]<'2023-11' and  [Ʒ��ϵ��]<>'����'
	) d
	on a.[�г�����]=d.[�г�����]
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------��ϵ/��ϵ/��ϵ/��ϵ/ŷϵ/��ϵ

union all

select a.�г�����,a.[2022��ȫ���Ȩ�۸�TP��],b.[2023��1-11��ȫ���Ȩ�۸�TP��],ABS(b.[2023��1-11��ȫ���Ȩ�۸�TP��]-a.[2022��ȫ���Ȩ�۸�TP��]) as [������������ֵ]

,round(a.[2022��1-12���ۼ�����],0) as [2022��1-12���ۼ�����],c.[2022��1-10���ۼ�����],d.[2023��1-10���ۼ�����],(d.[2023��1-10���ۼ�����]-c.[2022��1-10���ۼ�����]) as [2023��1-10������ͬ��]

from
	(
		select a.[�г�����],round(sum(a.[tp*mix]),-2) as [2022��ȫ���Ȩ�۸�TP��],sum(cast([����] as decimal(18,0))) as [2022��1-12���ۼ�����]
		from
			(
				select [Ʒ��ϵ��] as [�г�����] , left([����],4) as '��',[���ͱ���],[tp],[����],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )/
							sum((CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )) over( partition by left([����],4),[Ʒ��ϵ��])
						) as [tp*mix]
				FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2022-01' and [����]<'2023-01' and  [Ʒ��ϵ��] in ('��ϵ','��ϵ','��ϵ','��ϵ','ŷϵ','��ϵ')
			)a
		group by a.[�г�����]

	) a
left join 
	(
		select a.[�г�����],round(sum(a.[tp*mix]),-2) as [2023��1-11��ȫ���Ȩ�۸�TP��]
		from
			(
				select [Ʒ��ϵ��] as [�г�����] , left([����],4) as '��',[���ͱ���],[tp],[����],
						(
							CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )/
							sum((CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )) over( partition by left([����],4),[Ʒ��ϵ��])
						) as [tp*mix]

				FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2023-01' and [����]<'2023-12'   and  [Ʒ��ϵ��] in ('��ϵ','��ϵ','��ϵ','��ϵ','ŷϵ','��ϵ')
			)a
		group by a.[�г�����]
	) b

on a.[�г�����]=b.[�г�����]

left join 
	(
		select  [Ʒ��ϵ��]  as [�г�����],sum(cast([����] as decimal(18,0))) as [2022��1-10���ۼ�����] FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2022-01' and [����]<'2022-11'  and  [Ʒ��ϵ��] in ('��ϵ','��ϵ','��ϵ','��ϵ','ŷϵ','��ϵ') group by [Ʒ��ϵ��]
	) c
on a.[�г�����]=c.[�г�����]
left join 
	(
		select  [Ʒ��ϵ��]  as [�г�����],sum(cast([����] as decimal(18,0))) as [2023��1-10���ۼ�����] FROM  [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] where [����]>='2023-01' and [����]<'2023-11'  and  [Ʒ��ϵ��] in ('��ϵ','��ϵ','��ϵ','��ϵ','ŷϵ','��ϵ') group by [Ʒ��ϵ��] 
	) d
	on a.[�г�����]=d.[�г�����]


