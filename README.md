# CapsEz KeyMouse Tools 键盘和鼠标增强程序
Q群：785733384

;v190721 添加在tc里面中键点击打开目录
;v190904 更新暂停等热键，直接把AutoHotkey.exe改名为capsez.exe
;v190916 添加几种模式的开关，解决BUG10任务栏无法切换
;v190927 添加快捷键在TC中打开资源管理器中选中的文件，添加在tc中双击右键返回上一级。自动获取TC路径
;v191214 添加媒体播放相关快捷键和右键拖动窗口，解决一点小问题和小细节
;v200108 修复在资管或桌面没选文件的问题。再修复一些细节
;v200401 添加不同程序中对应不同的小菜单，增强对话框，tab组合键等

# caps：直接按CapsLock，等于esc {{{1

==================================================
# 按住capslk组合快捷键 {{{1
按住caps键再按其他按键，当然按住遥远的esc键也有一样的效果。
h,j,kl：上下左右
w,b：等于ctrl+左右
(可双击)u,i：等于End或Home，双击等于按住ctrl再end或Home
(可双击)n,m：等于PgDn或PgUp，双击等于按住ctrl再PgDn或PgUp，主要只是用于excel
g：等于ctrl+w
r：等于ctrl+r
o,p：等于ctrl+tab，ctrl+shift+tab
,. ：等于alt+tab
y：系统右键菜单
v：粘贴纯文本
enter：最大化
space：最小化

媒体相关快捷键，按住capslock再按：
backspace播放暂停，Pageup和pagedown上一首下一首，9和0也是上一首下一首，加减号＋-控制音量大小

pause：暂停热键，任务栏图标上分别是暂停热键、暂停脚本

ctrl+caps：恢复caps大写

==================================================
# `快捷键（就是tab上面，1左边的那个键） {{{1
基本等同于caps，但加上按住shift的效果，
就是按住caps的组合键算是移动，按住`的组合键算是选择。
h,j,kl：shift上下左右
w,b：等于ctrl+shift+左右
n,m：等于shift+PgDn或者PgUp
(可双击)u,i：等于End或Home，双击等于按住ctrl再end或Home
n,m：等于Shift+PgDn或PgUp

1，2，3 等于 Ctrl+X，C，V
4等于Del
当你按住 ` 不动进行选择的时候，接下来的操作，最舒服的位置就是1234


==================================================
# ;分号相关快捷键 {{{1
## 单右手 {{{2
h,j,kl：上下左右
n,m：PgDn或PgUp
space空格：等于del，实际使用中单手操作，当出现删除对话框后，由于空格也可以有回车确认的效果，所以会再按一下空格，

## 编辑相关 {{{2
c：单击等于ctrl+c复制，双击等于先ctrl+Home在ctrl+Shift+end之后再按ctrl+c
v：单击等于Ctrl+v粘贴，双击等于先ctrl+Home在ctrl+Shift+end之后再按ctrl+v
b：单击等于Ctrl+x剪切，双击等于先ctrl+Home在ctrl+Shift+end之后再按ctrl+x

z(可双击)：等于backspace，双击等于先shift+Home后再按Backspace
x(可双击)：等于del，双击等于先shift+End后再按Del
这5个按键，相对直接的del和back和ctrl+cxv这几个来说，更好按一点

## 输入相关 {{{2
d：等于先Home在Shift+end之后再按{Delete}，
a：等于先ctrl+Home在ctrl+Shift+end之后再按{Delete}

s: 搜索选中的文本（百度）
把a和d按键之间形成一点间隔，免得按错

g: 等于先ctrl+Home在ctrl+Shift+end之后再按ctrl+v再按回车，多用在搜索框中

u：等于先ctrl+t新建标签，然后再alt+d聚焦地址栏，再ctrl+v粘贴地址，再回车，可用于total commander和大多数浏览器

1：快速输入完整日期
2：快速输入简短日期
3：快速输入时间
 

## 启动切换程序相关 {{{2
最快的，因为手指都在键位上
；分号加caps，tab，qwert这7个键，
对应任务栏上1到7个固定的程序，等于发送Win+数字键，
分别对应Vim，totalcmd，qq，微信和，工作用的两个程序和cent浏览器，这样做到最快的切换速度



啰嗦一句
次一级，因为需要去找Win键，所以速度上没有上一种快
Win+数字固定在任务栏（123456789）和字母，例如Win+n启动Notepad2（ahk辅助的效果）


再次一级，用开始菜单，三键启动
开始菜单是XP，2003系统自带，在7以上系统中加装ClassicShell经典开始菜单软件（免费但需要安装）就可以使用
都是一个个的快捷方式，所以图标可以自由设定，好看不用记忆。
三键直达，Win->字母或数字->字母或数字，就是先按一下Win键，再按一个字母或者数字，再按一个字母或数字就能启动对应的快捷方式
。比如Win-> t -> e 启动下载工具，三键。
而其他类型的启动器，通常需要一个组合键，例如alt+space或者Win+\启动一个输入框，这就起码是第一下，然后输入最少一个字母或者
数字（通常不止一个字母），然后最后一个回车键下去才能启动程序。

快捷方式的作用，可以是启动一个程序，也可以打开目录，或者文档

# Alttab相关 {{{1
按住左键再滚轮，在AltaTab菜单中，可以点击右键或者按空格进行确认选择。
多用在把文件拖到别的程序中打开，或者类似于qq微信传文件。
也可以将浏览器中的图片直接拖到文件管理器中保存，也可以将文字拖到聊天窗口
在Alt+tab出来的程序切换窗口中，按住Alt不动，可以Tab向前（这是win的特性）也可以q向后（比win默认的alt+shift+tab好按一点）
，这是纯左手的，当然也可以hjkl来进行上下移动光标，
同理如果是按caps+，。出来的alttab窗口，也一样可以按住hjkl进行一样的切换


# Tab相关 {{{1
按住tab再按s w a d q f 
只基本操作上下左右翻页这几个，还可以扩展，主要用在左键右鼠的操作方式

按住tab再按12345
对应任务栏上固定的前5个程序快速切换


按住tab再按e，对应Enter回车
按r，对应Remove删除
按空格，对应Backspace，这个是total commander中鼠标操作最需要要的


==================================================
# 鼠标增强 {{{1
1、在任务栏上拨动鼠标滚轮，即可调整音量大小

2、（Win10中才开始自带的功能，Win8和7以下都需要）穿透滚动：拨动滚轮的时候，对鼠标光标下的窗体进行滚动，对不是当前窗口的程序，无需切换为当前窗口就能滚动。

3、按住Caps，拨动滚轮，即可对当前窗口调整透明度

4、左手按住capslock键，右手鼠标对当前（非最大化状态）程序中任意位置
按住左键不动，可拖动整个窗口
按住右键不动，可调整窗口大小
(几个按键配合更顺手)
按caps加鼠标中键，或者Win键加鼠标左键，来最大化窗口和恢复
按Win+A来切换窗口置顶，按Win+W来关闭程序

推荐用PopSel作为绿色便携启动器，所以Win+Z和win＋右键预留给PopSel（注释掉了，建议开启）

==================================================
# 其他程序中增强 {{{1
在主流浏览器中，F1新建标签，F2F3切换，F4关闭标签
;分号作为鼠标点击，因为Vimium等扩展没有点击的功能，所以用分号作为点击，常用来浏览图片（而在输入框中不影响正常输入分号）

Excel中
可以使用Ctrl+空格和Shift+空格来选整行和整列
ALT+C，复制单元格纯文本
ALT+G，定位
ALT+;，使用大一点的编辑框
F3进行筛选
alt+[和]，列宽和行高自行调整

==================================================
# 杂项增强 {{{1
## 类似于Listary中对于对话框的增强效果 {{{2
在打开、保存等对话框中，
按Alt+T，就将对话框中的目录切换到total commander中的当前目录，方便对话框进行选择。
按Alt+G，就将对话框中目录切换到total commander中，方便total commander目录进行进一步操作。

## 在资源管理器和桌面跳到totalcmd {{{2
在桌面和资源管理器中，按Alt+W，就跳到total commander中，如果是资源管理器就顺带关闭。

## 几种聊天工具的快捷键增强 {{{2
Tim，微信和TG中，可以Alt+1到0数字来选择聊天对象。alt+f在tc中打开接收文件的目录(需要自己设定一下目录位置)

Totalcmd中加几个快捷键
`符号，调出历史目录下拉菜单，可以用数字和字母按键进行选择，
批量重命名中按F1进行外部编辑
Ctrl+F2，把当前文件名加上剪贴板中文字。
Ctrl+Alt+F5,F6，把文件移动或者复制到对面面板中选中的目录，主要用在整理文件的时候，

双击鼠标右键，返回上一级目录
在资源管理器或者桌面中按Alt+W，将切换到或者打开tc，并选中对应文件。

total commander中可以增强的还有很多方式方法，所以在这个程序中不多放。

==================================================
# ：模式开关、重启 {{{1
ctrl+alt+win+r 重启脚本
常用，按键觉得有问题的时候就快捷键重启一下
Win10中ahk常卡键，Win7中好一点但也会有卡键的情况，所以现在设定为间隔15分钟自动重启脚本，这样没卡键的问题。

ctrl+alt+win+T或者pause : 停止热键（笔记本电脑上现在很多已经没pause键了）
在比如输入qq密码的时候，会因为qq的钩子问题，而导致密码输入错误
这时候需要临时屏蔽本程序，就按一下暂停键，等qq登录完成后再按一下恢复过来。

ctrl+alt+win+Z : 暂停脚本热键
图标变成红色的H，脚本暂停之后，快捷键仍然有用，
可以用鼠标来右键点击图标，出菜单选了后恢复；也可以直接ctrl+alt+win+R重启脚本
这个按键组合故意设计的不舒服的位置，因为正常用不到。


ctrl+alt+win+`花号 : tab相关组合键的开关
ctrl+alt+win+空格 : 空格相关组合键的开关

capslock + / 单键模式开关
效果等于不按住caps进行hjkl移动之类的。

==================================================
# 说明 {{{1
一直运行这个caps按键增强程序，然后结合我的total commander版本，
最最常用的动作就是最常用的total commander中的最精华的功能，快速搜索，
先正常打字母（不是汉字），然后用快速过滤出来想要的内容了，就可以在快速的结果上直接按caps+jk进行上下移动光标，
然后F3,4,5,6这些操作，如果不想要快速的结果，就左手小拇指直接按caps一下，发送了esc快捷键到total commander，按一下就先失去快速的输入框光标，
再按一下caps就是刷新了。而右手常用操作则有；来作为F4，另外还有，逗号作为取消选择，充分发挥双手的效率优势。

本程序中的杂项功能，其中
total commander中历史目录菜单功能来自array大侠
穿透滚动和拖动等功能来自老外


更多讨论可来QQ群 785733384

" 三个左大括号是vim的折叠标记，用Vim打开看起来效果更好
" vim: textwidth=120 wrap tabstop=4 shiftwidth=4
" vim: foldmethod=marker fdl=0
