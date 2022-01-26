extends Node2D
#该频谱分析仪共有16个量化等级标准
const VU_COUNT = 16
#这个频率是？
const FREQ_MAX = 11050.0
#频谱分析仪 画布宽度默认400
const WIDTH = 400
#频谱分析仪 画布默认高度 100
const HEIGHT = 100
#最小分贝 默认60db
#此参数和频谱分析仪的画布动态绘制时，最低高度有关 最好不要动参数值
#60分贝的意义：40～60分贝：相当于普通室内谈话
const MIN_DB = 60
#AudioEffectInstance
var spectrum
#整个动态绘制和音频总线的频谱分析仪效果器有关，如果移除效果器，则无法进行动态绘制
#此原理可同样用于音乐播放器的示波器 个人感觉
func _draw():
	#warning-ignore:integer_division
	#每一个量化音量条对应的宽度 是固定值
	var w = WIDTH / VU_COUNT
	#print(w)
	var prev_hz = 0
	#循环17次range(1,17)
	for i in range(1, VU_COUNT+1):
		#频率hz 就是当前的循环次数*最大频率/量化等级标准(16)
		var hz = i * FREQ_MAX / VU_COUNT;
		#print(hz)
		#大小 振幅
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clamp((MIN_DB + linear2db(magnitude)) / MIN_DB, 0, 1)
		#高度=能量*画布高度(100)
		var height = energy * HEIGHT
		#重复绘制
		#为什么这里绘制一个矩形可以绘制出多个矩形效果
		#Rect2四个构造参数 即 Rect2(x: float, y: float, width: float, height: float)
		#通过x、y、宽度和高度构造一个Rect2。
		#每个音量条的宽度,
		draw_rect(Rect2(w * i, HEIGHT - height, w, height), Color.white)
		prev_hz = hz
		#print(prev_hz)
func _process(_delta):
	#这里调用重绘
	update()
	pass

func _ready():
	spectrum = AudioServer.get_bus_effect_instance(0,0)
	#print(spectrum)
