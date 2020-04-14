# BHP-Termux 教程

## 〇：前言

1. 感谢 [Lkeme](https://github.com/lkeme) 的 [BiliHelper-personal](https://github.com/lkeme/BiliHelper-personal)

   ![](https://i.loli.net/2019/07/13/5d2963e5cc1eb22973.png)

1. 文中所有蓝色文字均为超链接, 看到可以直接点击蓝色文字链接进入对应页面

1. **手机储存根目录** 在哪里?

   当你打开手机任意一个文件管理类软件显示的那个页面, 通常就是 **手机储存根目录**, 如下图所示:
   
   <img src="https://i.loli.net/2020/02/20/zMCfXBPKTeASpck.jpg" width="432"/>
   
   目录下通常有名为 `Android` 和 `data` 的文件夹, 如果你安装了 QQ 或者微信还会出现名为 `Tencent` 或 `tencent` 的文件夹, 那么这个就是 **手机储存根目录** 了

1. 如有需要请自备解压缩软件, 梯子

## 一：下载并安装 Termux

### 方法一: 使用 Google Play

1. 打开页面 [Termux](https://play.google.com/store/apps/details?id=com.termux) 跳转到 Google Play 下载并安装

### 方法二: 从 F-Droid 手动下载安装

1. 打开页面 [Termux](https://f-droid.org/packages/com.termux/)

   *注: 最新版本 0.94, 支持 Android 7.0 以上系统*

1. 在页面点击蓝色 **Download APK** 开始下载 Termux

1. 安装下载好的安装包

### 方法三: 从酷安手动下载安装

1. 打开页面 [Termux 高级终端](https://www.coolapk.com/apk/com.termux)

   *注: 最新版本 0.73, 支持 Android 5.0 以上系统*

1. 在页面点击绿色 **下载APK** 开始下载 Termux

1. 安装下载好的安装包

## 二：下载脚本

1. 打开页面 [BHP-Termux Releases](https://github.com/0x012FA733/BHP-Termux/releases)

1. 下载最新版本 Zip 压缩包

1. 打开压缩包, 复制文件夹内 `deploy.sh` 和 `start.sh` 到手机储存根目录

## 三：配置 Termux 并安装 BiliHelper

### 使用脚本配置 Termux 并安装 BiliHelper

1. 打开 Termux

   *注: 第一次打开 Termux 可能需要加载, 请等待加载完成*

1. 在 Termux 的终端输入

   ```
   termux-setup-storage
   ```

   在弹出的对话框给予 Termux 允许访问储存装置的权限

1. 在 Termux 的终端继续输入

   ```
   bash $HOME/storage/shared/deploy.sh -mpc
   ```

   或 (以下适用于国内)

   ```
   bash $HOME/storage/shared/deploy.sh -m t -p -c a
   ```

   *注:*

   *1. Termux 中长按屏幕可以复制 (Copy) 和粘贴 (Paste)*

   *2. 下载的文件默认文件名为 `deploy.sh`, 路径为手机储存根目录, 如果更改了路径或文件名请自己对应修改上面命令 (手机储存根目录: `$HOME/storage/shared/`)*

   *3. `deploy.sh` 详细参数*

      ```
      Usage:
        deploy.sh [-b] [-m <t|c|o>] [-p] [-c <a|g|o>] [-n]

      Options:
        -b  备份外部配置文件
        -m  切换 Termux 镜像地址
            可选参数: t: Tuna / 清华,
                     c: CloudFlare CDN
                     o: Official / 官方 (默认),
        -p  安装 / 更新先决程序 (首次运行必需)
        -c  安装 / 更新 Composer (首次运行必需)
            可选参数: a: aliyun / 阿里云,
                     g: Github / 本项目,
                     o: Official / 官方 (默认)
        -n  安装 BHP 时使用阿里云 Composer 镜像
      ```

1. 等待配置脚本运行完毕

## 四：配置 BiliHelper

### 编辑方法

使用任意文件管理工具, 以 **文本文件方式** 打开手机储存根目录下 `bhpConf/user.conf` 文件进行编辑

### 设置介绍

如需修改设置, 请直接修改各个设置等号后面部分即可

#### 账户设置

- `APP_USER` 账号(必需), 填入你的账号, 建议前后各加上一个双引号

- `APP_PASS` 密码(必需), 填入你的密码, 建议前后各加上一个双引号

   *注: 令牌部分自动生成, 请勿填写任何内容*

#### 其他设置

- 请参考 [BiliHelper-personal 配置文件详解](https://github.com/lkeme/BiliHelper-personal/wiki/%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6%E8%AF%A6%E8%A7%A3) 或 `user.conf` 内说明, 自行修改, 后果自负

## 五：启动 BiliHelper

### 使用脚本启动 BiliHelper

1. 打开 Termux

1. 在 Termux 的终端输入

   ```
   bash $HOME/storage/shared/start.sh
   ```

   *注:*

   *1. Termux 中长按屏幕可以复制 (Copy) 和粘贴 (Paste)*

   *2. 下载的文件默认文件名为 `start.sh`, 路径为手机储存根目录, 如果更改了路径或文件名请自己对应修改上面命令 (手机储存根目录: `$HOME/storage/shared/`)*

   *3. `start.sh` 详细参数*

      ```
      Usage:
        start.sh [-r]

      Options:
        -r  删除内部配置文件
      ```

1. 脚本运行启动 BiliHelper

   *注:*

   *1. 当任意配置文件不存在, 脚本将使用默认配置文件*

   *2. 使用默认配置文件, 请求输入用户名或密码时不支持符号 "\\" (反斜杠), 输入密码时你的密码不会显示在屏幕上*

## 六：常见问题

### **空白的账号和口令!** 或 **登录失败, 账号或者密码错误**

   -  使用外部配置文件启动

      请检查手机储存根目录下 `bhpConf/user.conf` 文件是否输入了正确的用户名和密码

   -  使用内部配置文件 / 默认配置启动

      在 Termux 中输入命令 `bash $HOME/storage/shared/start.sh -r` 清除内部配置文件, 重新输入正确的用户名和密码

### 更新 BiliHelper

   1. 在 Termux 中输入命令 `bash $HOME/storage/shared/deploy.sh` 或适用于国内的命令 `bash $HOME/storage/shared/deploy.sh -n` 运行, 即可自动更新到最新版本 BiliHelper

      *注: 添加选项 `-b` 可以自动备份配置文件, 其他请参考 三.3.3 (`deploy.sh` 详细参数)*

   1. 重新设置外部配置文件; 如配置文件无更新, 可以把备份配置文件 `user.conf.bak` (位于手机储存根目录下的 `bhpConf` 文件夹内) 重命名为 `user.conf`

   1. 继续在 Termux 中输入命令 `bash $HOME/storage/shared/start.sh` 运行, 即可启动 BiliHelper

### 其他问题

   - 参见 [BiliHelper-personal 常见问题](https://github.com/lkeme/BiliHelper-personal/wiki/%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98)