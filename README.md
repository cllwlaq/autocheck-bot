# autocheck-bot
配合ARL灯塔以及subfinder自动化收集整理资产
编写了自动运行的脚本bot.sh、调用ARL接口的脚本arlGetAassert.py，实现subfinder和ARL联动，扩大资产范围，设置24小时运行一次，将subfinder和调用灯塔的资产合并后去重，第一次运行会生成urls.txt、subs.txt同时将urls.txt复制一份并以当前运行时间命令作为备份，后面的每一次运行如果有新的资产那么会将新的资产追加到urls.txt里面，同时单独将新增加的资产放到一个文件里面以运行结束时的时间命名。

执行bot.sh前，chmod +x bot.sh
arlGetAassert.py里面需要填入之前在config-docker.yaml里面配置的灯塔的认证key
![QQ_1745134394790](https://github.com/user-attachments/assets/033bd0b1-af40-4096-9c9e-aec138177867)
按照下面这个格式自己填就好了，不要太简单，不要填除了数字和字母以外的字符
API_KEY:"ff44256c-xxxx-xxxx-xxxx-xxxxxxxxxxx"
bot.sh里面的TARGET_DOMAIN填入目标域名
ARL_API_KEY填入灯塔里面的资产范围ID，没有就新建一个目标域名的，新建之前需要添加配置一个策略
![QQ_1745134481544](https://github.com/user-attachments/assets/07462be0-c0df-4086-a243-8a23fcf98592)
url路径https://IP:5003/api/asset_domain/ 里面的IP填入你的vps公网IP
![QQ_1745134512075](https://github.com/user-attachments/assets/49296a74-ae0c-4c10-b08a-b4cce7635e9a)
都填好以后，注意将arlGetAassert.py和bot.sh放到同一个目录
建议使用后台运行，运行命令：
nohup /bin/bash ./bot.sh > scan.log 2>&1 &
就是挂在后台运行，并将运行日志输出到scan.log里面
最后的目录结构以及效果
![QQ_1745134559827](https://github.com/user-attachments/assets/add16288-f4d4-442e-8cf1-2acbfb839d80)

![QQ_1745134605729](https://github.com/user-attachments/assets/f1cefdc4-d65c-4d3a-8d30-0ed9c83892cf)

具体详细的配置使用教程：

https://www.cnblogs.com/cll-wlaq/p/18836638
