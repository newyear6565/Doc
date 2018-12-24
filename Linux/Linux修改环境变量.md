ubuntu环境变量的三种设置方法

一：设置环境变量的三种方法

1.1 临时设置

export PATH=/home/yan/share/usr/local/arm/3.4.1/bin:$PATH

1.2 当前用户的全局设置

打开~/.bashrc，添加行：

export PATH=/home/yan/share/usr/local/arm/3.4.1/bin:$PATH

使生效：

source .bashrc

1.3 所有用户的全局设置

$ vim /etc/profile

在里面加入：

export PATH=/home/yan/share/usr/local/arm/3.4.1/bin:$PATH

使生效

source profile



二： 测试当前的环境变量

echo $PATH
或
env

用户登录后加载profile和bashrc的流程如下:

1. /etc/profile
    ->/etc/profile.d/*.sh

2. $HOME/.bash_profile
    ->$HOME/.bashrc
        ->/etc/bashrc

说明: 

bash首先执行/etc/profile脚本,/etc/profile脚本先依次执行/etc/profile.d/*.sh 
随后bash会执行用户主目录下的.bash_profile脚本,.bash_profile脚本会执行用户主目录下的.bashrc脚本, 
而.bashrc脚本会执行/etc/bashrc脚本。 
至此,所有的环境变量和初始化设定都已经加载完成. 
bash随后调用terminfo和inputrc，完成终端属性和键盘映射的设定.

其中PATH这个变量特殊说明一下:

如果是超级用户登录,在没有执行/etc/profile之前,PATH已经设定了下面的路径: 
/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
如果是普通用户,PATH在/etc/profile执行之前设定了以下的路径: 
/usr/local/bin:/bin:/usr/bin
这里要注意的是:在用户切换并加载变量,例如su -,这时，如果用户自己切换自己,比如root用户再用su - root切换的话,加载的PATH和上面的不一样. 
准确的说，是不总是一样.所以，在/etc/profile脚本中，做了如下的配置:

if [ `id -u` = 0 ]; then
pathmunge /sbin
pathmunge /usr/sbin
pathmunge /usr/local/sbin
fi

如果是超级用户登录,在/etc/profile.d/krb5.sh脚本中,在PATH变量搜索路径的最前面增加/usr/kerberos/sbin:/usr/kerberos/bin 
如果是普通用户登录,在/etc/profile.d/krb5.sh脚本中,在PATH变量搜索路径的最前面增加/usr/kerberos/bin

在/etc/profile脚本中,会在PATH变量的最后增加/usr/X11R6/bin目录 
在HOME/.bashprofile中,会在PATH变量的最后增加HOME/.bashprofile中,会在PATH变量的最后增加HOME/bin目录

以root用户为例,最终的PATH会是这样(没有其它自定义的基础上)

/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/X11R6/bin:/root/bin

以alice用户(普通用户)为例

/usr/kerberos/bin:/usr/bin:/bin:/usr/X11R6/bin:/home/alice/bin