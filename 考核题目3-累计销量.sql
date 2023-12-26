

/****** SSMS 的 SelectTopNRows 命令的脚本  ******/


--------------全市场

SELECT 

sum(cast([销量] as decimal(18,0))) as   [2022年1-12月累计销量]

FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数]

where concat([年份],'-',[月份])>='2022-01'and concat([年份],'-',[月份])<'2023-01'



SELECT 

sum(cast([销量] as decimal(18,0))) as  [2022年1-10月累计销量]

FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数]

where concat([年份],'-',[月份])>='2022-01'and concat([年份],'-',[月份])<'2022-11'



SELECT 

sum(cast([销量] as decimal(18,0))) as  [2023年1-10月累计销量]

FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数]

where concat([年份],'-',[月份])>='2023-01'and concat([年份],'-',[月份])<'2023-11'




-------------传统能源



select  sum(cast([销量] as decimal(18,0))) as [2022年1-12月累计销量]
FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数]  
where  concat([年份],'-',[月份])>='2022-01'and concat([年份],'-',[月份])<'2023-01'
and [燃料类型] not in ('纯电动','插电式混合动力','增程式电动')

select  sum(cast([销量] as decimal(18,0))) as [2022年1-10月累计销量]
FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数]  
where  concat([年份],'-',[月份])>='2022-01'and concat([年份],'-',[月份])<'2022-11'
and [燃料类型] not in ('纯电动','插电式混合动力','增程式电动')

select  sum(cast([销量] as decimal(18,0))) as [2023年1-10月累计销量]
FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数]  
where  concat([年份],'-',[月份])>='2023-01'and concat([年份],'-',[月份])<'2023-11'
and [燃料类型] not in ('纯电动','插电式混合动力','增程式电动')




-------------新能源


select  sum(cast([销量] as decimal(18,0))) as [2022年1-12月累计销量]
FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数]  
where  concat([年份],'-',[月份])>='2022-01'and concat([年份],'-',[月份])<'2023-01'
and [燃料类型] in ('纯电动','插电式混合动力','增程式电动')

select  sum(cast([销量] as decimal(18,0))) as [2022年1-10月累计销量]
FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数]  
where  concat([年份],'-',[月份])>='2022-01'and concat([年份],'-',[月份])<'2022-11'
and [燃料类型] in ('纯电动','插电式混合动力','增程式电动')

select  sum(cast([销量] as decimal(18,0))) as [2023年1-10月累计销量]
FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数]  
where  concat([年份],'-',[月份])>='2023-01'and concat([年份],'-',[月份])<'2023-11'
and [燃料类型] in ('纯电动','插电式混合动力','增程式电动')



-------------自主品牌

select  sum(cast([销量] as decimal(18,0))) as [2022年1-12月累计销量]
FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数]  
where  concat([年份],'-',[月份])>='2022-01'and concat([年份],'-',[月份])<'2023-01'
and [品牌系别] in ('自主')

select  sum(cast([销量] as decimal(18,0))) as [2022年1-10月累计销量]
FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数]  
where  concat([年份],'-',[月份])>='2022-01'and concat([年份],'-',[月份])<'2022-11'
and [品牌系别] in ('自主')

select  sum(cast([销量] as decimal(18,0))) as [2023年1-10月累计销量]
FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数]  
where  concat([年份],'-',[月份])>='2023-01'and concat([年份],'-',[月份])<'2023-11'
and [品牌系别] in ('自主')



-------------非自主品牌
select  sum(cast([销量] as decimal(18,0))) as [2022年1-12月累计销量]
FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数]  
where  concat([年份],'-',[月份])>='2022-01'and concat([年份],'-',[月份])<'2023-01'
and [品牌系别] not in ('自主')

select  sum(cast([销量] as decimal(18,0))) as [2022年1-10月累计销量]
FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数]  
where  concat([年份],'-',[月份])>='2022-01'and concat([年份],'-',[月份])<'2022-11'
and [品牌系别] not in ('自主')

select  sum(cast([销量] as decimal(18,0))) as [2023年1-10月累计销量]
FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数]  
where  concat([年份],'-',[月份])>='2023-01'and concat([年份],'-',[月份])<'2023-11'
and [品牌系别] not in ('自主')


-------------'德系','日系','美系','韩系','欧系','法系'
select [品牌系别], sum(cast([销量] as decimal(18,0))) as [2022年1-12月累计销量]
FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数]  
where  concat([年份],'-',[月份])>='2022-01'and concat([年份],'-',[月份])<'2023-01'
and [品牌系别] in ('德系','日系','美系','韩系','欧系','法系')
group by [品牌系别]
select [品牌系别], sum(cast([销量] as decimal(18,0))) as [2022年1-10月累计销量]
FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数]  
where  concat([年份],'-',[月份])>='2022-01'and concat([年份],'-',[月份])<'2022-11'
and [品牌系别] in ('德系','日系','美系','韩系','欧系','法系')
group by [品牌系别]
select [品牌系别], sum(cast([销量] as decimal(18,0))) as [2023年1-10月累计销量]
FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数]  
where  concat([年份],'-',[月份])>='2023-01'and concat([年份],'-',[月份])<'2023-11'
and [品牌系别] in ('德系','日系','美系','韩系','欧系','法系')
group by [品牌系别]




select * 
FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数] 












SELECT sum(cast(a.[销量] as decimal(18,0))) as [2022年1-12月累计销量]

FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数] a 

left join (select  [燃料类型],子车系编码 from [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] b group by [燃料类型],子车系编码) b  on  a.子车系编码=b.子车系编码

where  concat([年份],'-',[月份])>='2023-01'and concat([年份],'-',[月份])<'2023-11' and  b.[燃料类型] not in ('纯电动','插电式混合动力','增程式电动')



SELECT 

sum(cast(a.[销量] as decimal(18,0))) as  [2022年1-10月累计销量]

FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数] a 

left join (select  [燃料类型],子车系编码 from [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] b group by [燃料类型],子车系编码) b  on  a.子车系编码=b.子车系编码

where  concat([年份],'-',[月份])>='2022-01'and concat([年份],'-',[月份])<'2022-11' and  b.[燃料类型] not in ('纯电动','插电式混合动力','增程式电动')



SELECT 

sum(cast(a.[销量] as decimal(18,0))) as  [2023年1-10月累计销量]

FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数] a 

left join (select  [燃料类型],子车系编码 from [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] b group by [燃料类型],子车系编码) b  on  a.子车系编码=b.子车系编码

where  concat([年份],'-',[月份])>='2023-01'and concat([年份],'-',[月份])<'2023-11' and  b.[燃料类型] not in ('纯电动','插电式混合动力','增程式电动')

-------------新能源


SELECT sum(cast(a.[销量] as decimal(18,0))) as [2022年1-12月累计销量]

FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数] a 

left join (select  [燃料类型],子车系编码 from [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] b group by [燃料类型],子车系编码) b  on  a.子车系编码=b.子车系编码

where  concat([年份],'-',[月份])>='2023-01'and concat([年份],'-',[月份])<'2023-11' and  b.[燃料类型]  in ('纯电动','插电式混合动力','增程式电动')



SELECT 

sum(cast(a.[销量] as decimal(18,0))) as  [2022年1-10月累计销量]

FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数] a 

left join (select  [燃料类型],子车系编码 from [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] b group by [燃料类型],子车系编码) b  on  a.子车系编码=b.子车系编码

where  concat([年份],'-',[月份])>='2022-01'and concat([年份],'-',[月份])<'2022-11' and  b.[燃料类型] in ('纯电动','插电式混合动力','增程式电动')



SELECT 

sum(cast(a.[销量] as decimal(18,0))) as  [2023年1-10月累计销量]

FROM [LandRoadsGZ].[dbo].[ods_JLL-新标准车型上险数] a 

left join (select  [燃料类型],子车系编码 from [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] b group by [燃料类型],子车系编码) b  on  a.子车系编码=b.子车系编码

where  concat([年份],'-',[月份])>='2023-01'and concat([年份],'-',[月份])<'2023-11' and  b.[燃料类型]  in ('纯电动','插电式混合动力','增程式电动')

-------------自主品牌


SELECT sum(cast(a.[销量] as decimal(18,0))) as [2022年1-12月累计销量]

FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数] a 

left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] b on a.型号编码 =b.车型编码 

where a.[年月]>='2022-01'and a.[年月]<'2023-01' and  [品牌系别]='自主'



SELECT 

sum(cast(a.[销量] as decimal(18,0))) as  [2022年1-10月累计销量]

FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数] a

left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] b on a.型号编码 =b.车型编码 

where a.[年月]>='2022-01'and a.[年月]<'2022-11' and  [品牌系别]='自主'



SELECT 

sum(cast(a.[销量] as decimal(18,0))) as  [2023年1-10月累计销量]

FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数] a 
left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] b on a.型号编码 =b.车型编码 

where a.[年月]>='2023-01'and a.[年月]<'2023-11' and  [品牌系别]='自主'




-------------非自主品牌

SELECT sum(cast(a.[销量] as decimal(18,0))) as [2022年1-12月累计销量]

FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数] a 

left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] b on a.型号编码 =b.车型编码 

where a.[年月]>='2022-01'and a.[年月]<'2023-01' and  [品牌系别]<>'自主'



SELECT 

sum(cast(a.[销量] as decimal(18,0))) as  [2022年1-10月累计销量]

FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数] a

left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] b on a.型号编码 =b.车型编码 

where a.[年月]>='2022-01'and a.[年月]<'2022-11' and  [品牌系别]<>'自主'



SELECT 

sum(cast(a.[销量] as decimal(18,0))) as  [2023年1-10月累计销量]

FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数] a 
left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] b on a.型号编码 =b.车型编码 

where a.[年月]>='2023-01'and a.[年月]<'2023-11' and  [品牌系别]<>'自主'


--------------德系/日系/美系/韩系/欧系/法系



SELECT  b.[品牌系别],sum(cast(a.[销量] as decimal(18,0))) as [2022年1-12月累计销量]

FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数] a 

left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] b on a.型号编码 =b.车型编码 

where a.[年月]>='2022-01'and a.[年月]<'2023-01' and  b.[品牌系别] in ('德系','日系','美系','韩系','欧系','法系')
group by b.[品牌系别]


SELECT 

b.[品牌系别],sum(cast(a.[销量] as decimal(18,0))) as  [2022年1-10月累计销量]

FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数] a

left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] b on a.型号编码 =b.车型编码 

where a.[年月]>='2022-01'and a.[年月]<'2022-11' and  b.[品牌系别] in ('德系','日系','美系','韩系','欧系','法系')
group by b.[品牌系别]


SELECT 

b.[品牌系别],sum(cast(a.[销量] as decimal(18,0))) as  [2023年1-10月累计销量]

FROM [LandRoadsGZ].[dbo].[mid_JLL型号上险数] a 
left join [LandRoadsGZ].[dbo].[dim_SGM车型编码表-匹配JLL] b on a.型号编码 =b.车型编码 

where a.[年月]>='2023-01'and a.[年月]<'2023-11' and  b.[品牌系别] in ('德系','日系','美系','韩系','欧系','法系')
group by b.[品牌系别]
		

