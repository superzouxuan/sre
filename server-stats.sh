#!/bin/bash

# server-stats.sh
# 一个简单的服务器性能监控脚本

echo "========================="
echo "服务器性能概览 - $(date)"
echo "========================="

# CPU 总使用率
echo ""
echo "[CPU 使用率]"
cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%","",v); print v }')
cpu_usage=$(echo "scale=2; 100 - $cpu_idle" | bc)
echo "CPU 总使用率: ${cpu_usage}%"

# 内存总使用情况
echo ""
echo "[内存使用情况]"
free -m | awk 'NR==2{
    total=$2;
    used=$3;
    free=$4;
    used_percent = (used/total)*100;
    printf("总内存: %d MB\n已用: %d MB\n可用: %d MB\n使用率: %.2f%%\n", total, used, free, used_percent);
}'

# 磁盘总使用情况
echo ""
echo "[磁盘使用情况]"
df -h --total | grep 'total' | awk '{print "总空间: "$2"\n已用: "$3"\n可用: "$4"\n使用率: "$5}'

# CPU 使用率排名前5的进程（完整命令行 + 可执行文件名）
echo ""
echo "[CPU 使用率排名前5的进程]"
ps -eo pid,ppid,%cpu,comm,args --sort=-%cpu | head -n 6

# 内存使用率排名前5的进程（完整命令行 + 可执行文件名）
echo ""
echo "[内存使用率排名前5的进程]"
ps -eo pid,ppid,%mem,comm,args --sort=-%mem | head -n 6

echo ""
echo "========================="
echo "数据采集完成 ✅"
echo "========================="
