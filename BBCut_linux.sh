#! /bin/sh

#使用方法
#./bilicut.sh bv号 开始时间 结束时间 输出文件名 分P选项（可选）
#例如：
#./bilicut.sh BV1uz4y1S7oG 00:00:20 00:00:30 悲惨世界0301 3
# 参数说明
# 1: bv号
# 2: 开始时间
# 3: 结束时间
# 4: 输出文件名
# 5：分P索引

#环境要求说明：
#此脚本使用BBDown下载工具，需要将脚本与BBDown执行文件放在同一目录下
#BBDown传送门：https://github.com/nilaoda/BBDown
#需要提前安装好FFmpeg环境，详见 https://blog.csdn.net/weixin_36155936/article/details/116988522
#仅音频选项  --audio-only


if [ ! -d "/root/download" ]; then
	mkdir /root/download
fi
if [ ! -d "/root/output" ]; then
	mkdir /root/output
fi

biliUrl="https://www.bilibili.com/video/"
downloadFlag=0

echo "正在下载..."
if [ $5 > 0 ] ; then
	path=/root/download/${1}/P${5}
	echo "分P选择：P${5}"
	#判断是否已经有缓存文件
	
	if [ ! -d "/root/download/${1}" ]; then
		mkdir /root/download/$1
	fi
	if [ ! -d "/root/download/${1}/P${5}" ]; then
		mkdir /root/download/$1/P$5
		results=`./BBDown ${biliUrl}${1} -p ${5} --work-dir /root/download/${1}/P${5} --audio-only`
		downloadFlag=1
	fi
else
	path=/root/download/${4}
	#echo "不存在分P选项"
	#判断是否已经有缓存文件
	if [ ! -d "/root/download/${1}" ]; then
		mkdir /root/download/$1
		results=`./BBDown ${1} --work-dir /root/download/${4} --audio-only`
		downloadFlag=1
	fi
fi
if [ $downloadFlag -eq 0 ] ; then
	echo "使用缓存文件"
else
	echo "下载完成"	
fi

files=$(ls $path)
echo "文件标题为 ${files}"
echo "切片时间区间 ${2} - ${3}"
echo "开始处理......"
ffmpeg -ss $2 -i "${path}/${files}" -c copy -t $3 "/root/output/${4}.mp4" -loglevel quiet
ffmpeg -i "/root/output/${4}.mp4" -vn -codec copy "/root/output/${4}".m4a -loglevel quiet
echo "处理完成 输出文件 /root/output/${4}.m4a"
