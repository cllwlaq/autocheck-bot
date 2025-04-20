#!/bin/bash 
# 文件名：bot.sh  
# 描述：自动化子域名收集与资产探测（每小时执行一次） 

# 配置参数 
TARGET_DOMAIN="example.com"        # 目标域名（必改） 
ARL_API_KEY=""  # ARL API密钥 ,这是灯塔里面的资产范围ID
SUBFINDER_OUTPUT="./subs.txt"      # SubFinder输出文件 
URLS_HISTORY="urls.txt"            # 历史记录文件

while true; do 
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 启动新一轮扫描..." 
    
    # Step 1: 执行SubFinder并检查结果 
    echo "正在运行SubFinder..." 
    if ! subfinder -d "$TARGET_DOMAIN" -o "$SUBFINDER_OUTPUT" -silent; then 
        echo "错误：SubFinder执行失败" 
        exit 1 
    fi 

    # 检查输出文件是否存在且非空 
    if [ ! -s "$SUBFINDER_OUTPUT" ]; then 
        echo "警告：未找到有效子域名，跳过后续步骤" 
        sleep 3600 
        continue 
    fi 

    # Step 2: 调用ARL API并处理结果 
    echo "从ARL获取资产..." 
    ARL_TEMP=$(mktemp)
    if ! python3 arlGetAassert.py -s "$ARL_API_KEY" > "$ARL_TEMP"; then 
        echo "错误：资产获取失败"
        rm -f "$ARL_TEMP"
        exit 1 
    fi 

    # 合并并去重结果
    COMBINED_TEMP=$(mktemp)
    cat "$SUBFINDER_OUTPUT" "$ARL_TEMP" | sort -u > "$COMBINED_TEMP"
    rm -f "$ARL_TEMP"

    # 判断执行模式
    if [ ! -f "$URLS_HISTORY" ]; then
        # 第一次执行模式
        echo "首次执行模式，生成初始记录文件..."
        mv "$COMBINED_TEMP" "$URLS_HISTORY"
        TIMESTAMP=$(date '+%y-%m-%d-%H:%M')
        cp "$URLS_HISTORY" "${TIMESTAMP}.txt"
        echo "首次扫描结果已保存至：${TIMESTAMP}.txt"
    else
        # 非首次执行模式
        echo "增量执行模式，检测新增资产..."
        NEW_TEMP=$(mktemp)
        cat "$COMBINED_TEMP" | anew "$URLS_HISTORY" > "$NEW_TEMP"
        rm -f "$COMBINED_TEMP"

        if [ -s "$NEW_TEMP" ]; then
            echo "发现新增资产数量：$(wc -l < "$NEW_TEMP")"
            cat "$NEW_TEMP" >> "$URLS_HISTORY"
            TIMESTAMP=$(date '+%y-%m-%d-%H:%M')
            mv "$NEW_TEMP" "${TIMESTAMP}.txt"
            echo "新增结果已保存至：${TIMESTAMP}.txt"
        else
            echo "未发现新增资产，跳过文件生成"
            rm -f "$NEW_TEMP"
        fi
    fi

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 本轮扫描完成，24小时后再次执行" 
    sleep 86400 
done;