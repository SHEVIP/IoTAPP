<<<<<<< HEAD
"# IoTAPP" 
=======
# IoT

## 页面组成

登录注册	auth

个人信息	info

工友圈	moment

总看板		board

工作台		work



## 项目结构

四象限分析法：是否具备UI属性、是否具备业务属性。

- 基础UI组件：为项目定制的Widget。
- 基础功能：网络调用、数据存储等。
- 业务UI：页面。
- 业务功能：业务逻辑。



```shell
lib
|--api					# 接口
|--model				# 业务对象
|--views				# 页面
|--util					# 基础功能
|--common				# 业务功能
|--components			# 组件
```

子目录以页面进行分组

```shell
conponents
|--board
|--info
|--work
```



## 命名规范

文件名蛇形命名法。

变量名小驼峰命名法。

类名大驼峰命名法。



页面类以Page结尾。

组件类，表明功能名称，且以组件类型结尾，如Box、Scroll、Table、Row等。



## 基础库

网络请求：dio库，代码位置utils/NetworkUtil.dart

数据存储：shared_preferences库，代码位置utils/PrefsUtil.dart



## UI逻辑

打开APP，进入登录界面。若检测到已登录，则进入首页。否则登录成功后跳转首页。



## 业务逻辑

### 注册

点击按钮	-> 	请求接口	->	保存用户名密码	->	跳转到登录

### 登录

点击按钮	->	请求接口	->	跳转首页

### 看板

**生产状态**

选择车间名称	->	请求接口screen/productionBoard	->	机器名称+百分比+设备状态

有哪些车间的接口



## 潜在隐患

TODO：dio请求失败的话，会怎么样？因为毕竟返回的是Response？
>>>>>>> e0d90227bc4a2db1aee4a722c014354800f606cb
