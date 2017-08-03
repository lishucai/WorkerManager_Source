/****** Object:  Table [dbo].[apparatus]    Script Date: 06/17/2017 09:16:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
if object_id(N'[apparatus]',N'U') is null  --判断表[apparatus]是否存在
CREATE TABLE [dbo].[apparatus](
	[no] [float] NULL,
	[jizhong] [nvarchar](255) NULL,
	[bianhao] [nvarchar](255) NULL,
	[bumeng] [nvarchar](255) NULL,
	[zherenren] [nvarchar](255) NULL,
	[caozuoren] [nvarchar](255) NULL,
	[zuoye] [nvarchar](255) NULL,
	[jianxiu] [nvarchar](255) NULL,
	[name] [nchar](10) NULL
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[persons]    Script Date: 06/17/2017 09:19:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
if object_id(N'[persons]',N'U') is null  --判断表[persons]是否存在
CREATE TABLE [dbo].[persons](
	[bianhao] [nvarchar](255) NULL,
	[name] [nvarchar](255) NULL,
	[danwei] [nvarchar](255) NULL,
	[bumen] [nvarchar](255) NULL,
	[zhiwei] [nvarchar](255) NULL,
	[lianxifangsi] [nvarchar](255) NULL,
	[shengfengzheng] [nvarchar](255) NULL,
	[jiguan] [nvarchar](255) NULL,
	[age] [nvarchar](255) NULL,
	[wenhua] [nvarchar](255) NULL,
	[jiaoyu] [nvarchar](255) NULL,
	[jineng] [nvarchar](255) NULL,
	[zhengshu] [nvarchar](255) NULL,
	[work] [nvarchar](255) NULL,
	[learn] [nvarchar](255) NULL,
	[task] [nvarchar](255) NULL,
	[worktime] [nvarchar](255) NULL,
	[solary] [nvarchar](255) NULL,
	[jiaodi] [nvarchar](255) NULL,
	[safe] [nvarchar](255) NULL,
	[photo] [varchar](50) NULL,
	[homeaddress] [nvarchar](500) NULL,
	[qslianxifanshi] [nvarchar](500) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[t_role]    Script Date: 06/17/2017 09:19:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
if object_id(N'[t_role]',N'U') is null  --判断表[t_role]是否存在
CREATE TABLE [dbo].[t_role](
	[role_id] [int] IDENTITY(1,1) NOT NULL,
	[role_name] [nvarchar](50) NOT NULL,
	[role_level] [int] NULL
) ON [PRIMARY]

GO


--判断约束是否存在
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_t_role_role_level]') AND parent_object_id = OBJECT_ID(N'[dbo].[t_role]'))
	ALTER TABLE [dbo].[t_role] ADD  CONSTRAINT [DF_t_role_role_level]  DEFAULT ((1)) FOR [role_level]
GO

/****** Object:  Table [dbo].[t_user]    Script Date: 06/17/2017 09:19:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
if object_id(N'[t_user]',N'U') is null  --判断表[t_user]是否存在
CREATE TABLE [dbo].[t_user](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[user_name] [nvarchar](50) NOT NULL,
	[login_name] [nvarchar](50) NOT NULL,
	[login_password] [nvarchar](50) NULL,
	[role_id] [int] NULL
) ON [PRIMARY]

GO


/****** Object:  Table [dbo].[t_group]    Script Date: 2017/6/17 15:34:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
if object_id(N't_group',N'U') is null
CREATE TABLE [dbo].[t_group](
	[group_id] [int] IDENTITY(1,1) NOT NULL,
	[group_name] [nvarchar](50) NULL,
	[group_desc] [nvarchar](100) NULL
) ON [PRIMARY]

GO




if object_id(N't_user_group',N'U') is null  --判断表t_user_group是否存在
	CREATE TABLE t_user_group(
		[id] [int] IDENTITY(1,1) NOT NULL,
		[user_id] [int] NULL,
		[group_id] [int] NULL
	) 
GO

if object_id(N'[t_user_role]',N'U') is null  
	CREATE TABLE [dbo].[t_user_role](
		[id] [int] IDENTITY(1,1) NOT NULL,
		[user_id] [int] NULL,
		[role_id] [int] NULL
	)
GO

if exists(select 1 from SYSCOLUMNS where id = object_id('t_user') and name = 'role_id')
	alter table t_user drop column role_id
go


if not exists(select 1 from SYSCOLUMNS where id = object_id('apparatus') and name = 'group_id')
	alter table apparatus add  group_id int null
go


if not exists(select 1 from SYSCOLUMNS where id = object_id('persons') and name = 'group_id')
	alter table persons add  group_id int null
go


if not exists(select 1 from SYSCOLUMNS where id = object_id('persons') and name = 'group_id')
	alter table persons add  group_id int null
go



ALTER TABLE apparatus ALTER COLUMN no nvarchar(100)
go

ALTER TABLE apparatus ALTER COLUMN bianhao int
go

if not exists(select 1 from SYSCOLUMNS where id = object_id('t_group') and name = 'parentId')
	alter table t_group add parentId int null
go

if not exists(select 1 from SYSCOLUMNS where id = object_id('t_group') and name = 'tree_id')
	alter table t_group add tree_id nvarchar(100) null
go


IF NOT EXISTS ( SELECT name FROM sysobjects WHERE id = ( SELECT syscolumns.cdefault FROM sysobjects 
    INNER JOIN syscolumns ON sysobjects.Id=syscolumns.Id 
    WHERE sysobjects.name=N't_group' AND syscolumns.name=N'parentId' ) 
)

	ALTER   TABLE   t_group  ADD   CONSTRAINT   DF_t_group_parentId   DEFAULT   0   FOR   parentId

go


alter table t_group alter column group_id int
go

alter table persons alter column bianhao nvarchar(50)
go

alter table persons alter column photo nvarchar(100)
go

if object_id(N't_models',N'U') is null
CREATE TABLE [dbo].t_models(
	[model_id] nvarchar(100)  NOT NULL,
	[model_name] [nvarchar](50) NULL,
	[model_desc] [nvarchar](100) NULL,
	urn nvarchar(100) null
) ON [PRIMARY]

GO

if not exists(select 1 from SYSCOLUMNS where id = object_id('t_models') and name = 'target_name')
	alter table t_models add  target_name nvarchar(100) null
go


alter table t_models alter column  urn nvarchar(1024) null