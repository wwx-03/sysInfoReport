: <<OVERVIEW
项目名称:系统健康检查报告

目标:生成服务器健康状态简报

监控指标:
	CPU/内存使用率(top / free)
	磁盘空间(df -h)
	当前登录用户(who)
	系统负载(uptime)

输出示例:

	==== System Health Report ====
	[Time]	2025-3-13 14:30:00
	[CPU]	15% used (15% user, 0% system)
	[RAM]	2.3G used / 3.8G total
	[DISK]	/:78% used (45G/58G)
	[Users]	3 active: root, bob, alice
	==============================

OVERVIEW

#!/bin/bash



echo "==== System Health Report ===="

time=$(date "+%Y-%m-%d %H:%M:%S")
printf "[Time]	$time\r\n"

cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

printf "[CPU]	%s%% used\r\n" "$cpu_usage"

#free -h | grep 内存 | awk '{print  }'

ram_usage=$(free -h | grep "内存" | awk '{print ($2 - $7) / $2}')
ram_used=$(free -h | grep "内存" | awk '{print $2 - $7}')
ram_total=$(free -h | grep "内存" | awk '{print $2}')

printf "[RAM]	%sG used / %sG\r\n" "$ram_used" "$ram_total"

disk_usage=$(df -h | grep "/dev/sda2" | awk '{print $5}')
disk_used=$(df -h | grep "/dev/sda2" | awk '{print $2 - $4}')
disk_total=$(df -h | grep "/dev/sda2" | awk '{print $2}')

printf "[DISK]	/:%s used (%sG/%s)\r\n" "$disk_usage" "$disk_used" "$disk_total"

user_members=$(who | wc -l)

printf "[Users]	%s active: " "$user_members"

index=1
i=1
while(( $i<=$user_members ))
do
	user_name=$(who | awk -v ind=$index '{print $ind}')
	printf "%s " "$user_name"
	index=`expr $index + 5`
	let "i ++"
done
printf "\r\n"
echo "=============================="



