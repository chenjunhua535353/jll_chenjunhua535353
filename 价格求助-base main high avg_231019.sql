






select aa.�ӳ�ϵ����,
min(aa.msrp)as Basemsrp,
sum((case when aa.px=1 then aa.msrp  else  0 end)) as mainmsrp,
max(aa.msrp)as highmsrp,
round(sum(aa.msrp*aa.�ͺ�����/aa.��������),-2) as Averagemsrp,
min(aa.tp)as Basetp,
sum((case when aa.px=1 then aa.tp  else  0 end)) as maintp,
max(aa.tp)as hightp,
round(sum(aa.tp*aa.�ͺ�����/aa.��������),-2) as Averagetp

from 

	(
	select a.�ӳ�ϵ����,a.�ͺű���,a.msrp,a.tp,a.�ͺ�����,a.��������,a.�ͺ�����/a.�������� as mix,

	row_number() over(partition by a.�ӳ�ϵ���� order by a.�ͺ�����/a.�������� desc ,a.msrp asc) as px

	from 

		(
		select c.�ӳ�ϵ����,a.*,

		(case when b.�ͺ�����  is null then 0.0000001 when b.�ͺ�����=0 then 0.0000001  else b.�ͺ����� end) as �ͺ�����,

		sum((case when b.�ͺ�����  is null then 0.0000001 when b.�ͺ�����=0 then 0.0000001  else b.�ͺ����� end)) over(partition by c.�ӳ�ϵ����) as ��������

		from 
			(
				select a.�ͺű���,
				round(avg(CONVERT(decimal,a.msrp))/100,0)*100 as msrp,

				round(avg(CONVERT(decimal,a.tp))/100,0)*100 as tp

				from [LandRoadsGZ].[dbo].[fact_JLL-�ն˼۸�-�ֳ���] a
				where ����='2023-10'and  a.tp <>'�޳�'
				group by a.�ͺű���
			)a

		left join 
			(
				select b.�ͺű���, CONVERT(decimal,b.����) as �ͺ�����
				from [LandRoadsGZ].[dbo].[mid_JLL�ͺ�������] b
				where ����='2023-10'
			)b on a.�ͺű���=b.�ͺű���

		left join  [LandRoadsGZ].[dbo].[dim_SGM���ͱ����-ƥ��JLL] c   on a.�ͺű���=c.���ͱ���

		)a

	--where a.�ӳ�ϵ���� in ('J025007036')

	)aa

group by   aa.�ӳ�ϵ����




