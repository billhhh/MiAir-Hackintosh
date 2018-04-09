# MiAir-Hackintosh

Hackintosh for now MiAir_i77500u

Thanks for the help of ourfor, his github address is
https://github.com/ourfor/Mibook-air

# Hackintosh Step


## 手动建立ESP

DG软件在这一步骤用有很大作用，因为mac需要200M的EFI才能抹盘
我的自带EFI+MSR只有100M+16M=116M，所以要手动建立

（1）进DG将原始EFI分区备份（右键复制到桌面），并制作镜像（右键保存到镜像）
（2）从C盘中压缩一个400M的盘
（3）进DG，将这个400M的空白盘新建一个EFI system partition的盘，从镜像中恢复
这里如果出现写磁盘错误，重启可解决（这里卡了挺久）

## 做启动U盘

（1）用TransMac做U盘，注：我用的10.13的系统
（2）复制已经做好的EFI到U盘的ESP分区，有两种方法。一种是直接用explorer++；另一种是参照这个视频：https://www.bilibili.com/video/av19235761，将U盘ESP删除，新建一个FAT32格式分区，再把EFI复制过来
因为我用的10.13的系统（http://pan.baidu.com/s/1kVwxCPL），就用的相对比较旧一点的efi文件，这个repo里面的EFI_小米笔记本Air-i7-7500U-10.13.zip
用太新的efi，无限重启，后来得知kext文件夹中coredisplay需要去掉就可以用了，这个就是导致无限重启的原因
特别注意，driver64UEFI文件夹中的EmuVariableUefi64，这个用于驱动独显，但是现在版本驱动不了用不到

## 安装

压缩C盘空间空出一个40G的盘
值得一提的是，有很多教程建议这个时候将这个空白盘抹成apple的
我也是参照这个视频https://www.bilibili.com/video/av19235761，新建盘但是不分配盘符和格式化，也是可以的

另外还有一个问题：win的盘，可以读但是不能写，这个可以修改，但是windows系统分区不能写
其他ntfs的分区可以，百度或者Google macOS原生读写ntfs，不建议安装ntfs读写软件，这样对Windows系统分区不好

efi好了以后，安装就问题不大了，注意不要登陆就好，后面三码合一
安装后，进win，将Clover文件夹复制到硬盘
bootice添加 /ESP/EFI/CLOVER/CLOVERX64.efi 启动项，并移动到第一个

## 完善

三码合一参考：https://www.bilibili.com/video/av20912880
另外直接装完以后可能唤醒有点问题，用10.13.3（https://pan.baidu.com/s/1bqmWMLp 密码: 7pu8），配合ourfor最新的efi（https://github.com/ourfor/Mibook-air/archive/5.0.zip）也可以解决


---------------------------20180408 更新---------------------

### 解决无限重启问题

用ourfor v5 20180406的也可以了，删除Kext文件夹里面的coredisplay就可以用了，这个是修复显卡的驱动，可能和这个版本不兼容吧


因为model太新，三码合一用不了，不过也无大碍
清理Kext缓存软件：Kext Utility.app

### 开HiDpi

参考教程：https://ourfor.top/2018/01/01/%E5%BC%80%E5%90%AFhidpi/
配置文件：DisplayVendorID-9e5.zip
同时需要配合 RDM：https://github.com/avibrazil/RDM

RDM系统启动方法是
For more practical results, add RDM.app to your Login Items in System Preferences ➡ Users & Groups ➡ Login Items. This way RDM will run automatically on startup.

我的机器高清模式下，1280*720不错

### 耳机声音小

声音-平衡-最左 或者最右

### clover默认启动Windows

clover configuration打开config.plist，参考如下链接自定义clover
http://ourfor.top/2018/01/13/%E4%B8%AA%E6%80%A7%E5%8C%96clover%E5%90%AF%E5%8A%A8%E9%A1%B9/

目前的问题主要是：
（1）蓝牙不能用
（2）合盖休眠黑屏，只能强制关机。所以用黑果目前只能关机，用HibernationFixup.kext没什么鸟用，http://www.heimac.net/index.php/archives/488/
（3）电量不抗用，应该是cpu变频没弄好
（4）WiFi不能用，我买了comfast网卡，但是只支持2.4G单频，应该买双频，推荐EDUP双频600M迷你无线网卡
360网卡GitHub有，但是很久没维护了：https://github.com/tonyxiahua/360WIFI-MAC
（5）貌似有了plist，亮度还是不保留，不过这个问题不大
（6）显示器接口数据还没弄，不要通过HDMI接显示器，系统会崩溃的，

# 参考

https://blog.csdn.net/Scythe666/article/details/79677730
http://www.miui.com/thread-7419826-1-1.html
http://www.miui.com/thread-7601066-1-1.html
http://www.miui.com/thread-7574042-1-1.html
http://www.miui.com/thread-11363672-1-1.html
https://www.bilibili.com/video/av20442523/?spm_id_from=333.338.recommend_report.2
https://www.bilibili.com/video/av19235761/?spm_id_from=333.338.recommend_report.3
