
------------------------------------------------------------------------�¶�

select a.[����], a.[Ʒ��],a.[�������],a.[ȼ������],round(sum(a.[����*mix]),-2) as ��ȨTP
from 

(
	select [���ͱ���],[����], [Ʒ��],[�������],[ȼ������],[tp], [����],

	--sum((CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )) over(partition by [����],[Ʒ��],[�������],[ȼ������]) as �ۼ�����,

	(
		CONVERT(decimal,[tp])*
		(CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )/
		sum((CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )) over(partition by [����],[Ʒ��],[�������],[ȼ������])
	) AS [����*mix]

	from [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] 

	where [Ʒ��] in ('��˹��','���ǵ�','����','С��','����','����','���Դ�','�ղ�','ε��','���','���','AITO','����','����')

	and [ȼ������] in('���綯','���ʽ��϶���','����ʽ�綯')

	and [�������] in('MPV','SUV','�γ�')

	and trim([����])>= '2019-01' and trim([����]) < '2023-11'

)a

group by [����], [Ʒ��],[�������],[ȼ������]
order  by  [����], [Ʒ��],[�������],[ȼ������];



------------------------------------------------------------------------����

select a.[����], a.[Ʒ��],a.[�������],a.[ȼ������],round(sum(a.[����*mix]),-2) as ��ȨTP
from 
(
	select [���ͱ���],
	(case when RIGHT(trim([����]),2) in ('01','02','03') then CONCAT( LEFT(trim([����]),4),'-01')
	when RIGHT(trim([����]),2) in ('04','05','06') then CONCAT( LEFT(trim([����]),4),'-02')
	when RIGHT(trim([����]),2) in ('07','08','09') then CONCAT( LEFT(trim([����]),4),'-03')
	when RIGHT(trim([����]),2) in ('10','11','12') then CONCAT( LEFT(trim([����]),4),'-04')
	END)AS [����],

	[Ʒ��],[�������],[ȼ������],[tp], [����],

	(
		CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )/
		sum((CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )) over(partition by left(trim([����]),4),(cast(right(trim([����]),2) as int)-1)/3,[Ʒ��],[�������],[ȼ������])
	) AS [����*mix]

	from [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] 

	where [Ʒ��] in ('��˹��','���ǵ�','����','С��','����','����','���Դ�','�ղ�','ε��','���','���','AITO','����','����')

	and [ȼ������] in('���綯','���ʽ��϶���','����ʽ�綯')

	and [�������] in('MPV','SUV','�γ�')

	and trim([����])>= '2019-01' and trim([����]) < '2023-11'

)a
group by [����], [Ʒ��],[�������],[ȼ������]
order  by  [����], [Ʒ��],[�������],[ȼ������];



------------------------------------------------------------------------���

select a.[���], a.[Ʒ��],a.[�������],a.[ȼ������],round(sum(a.[����*mix]),-2) as ��ȨTP
from 
(

		select [���ͱ���],LEFT(trim([����]),4) AS [���],
		[Ʒ��],[�������],[ȼ������],[tp], [����],
		(
			CONVERT(decimal,[tp])*(CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )/
			sum((CASE WHEN CONVERT(decimal,[����])=0 THEN 0.0000001 ELSE CONVERT(decimal,[����]) END )) over(partition by left(trim([����]),4),[Ʒ��],[�������],[ȼ������])
		) AS [����*mix]

		from [LandRoadsGZ].[dbo].[fact_JLL_�ն˼۸�����] 

		where [Ʒ��] in ('��˹��','���ǵ�','����','С��','����','����','���Դ�','�ղ�','ε��','���','���','AITO','����','����')

		and [ȼ������] in('���綯','���ʽ��϶���','����ʽ�綯')

		and [�������] in('MPV','SUV','�γ�')

		and trim([����])>= '2019-01' and trim([����]) < '2023-11'

)a
group by [���], [Ʒ��],[�������],[ȼ������]
order  by  [���], [Ʒ��],[�������],[ȼ������];














