# XMNAudio
一般音乐,音频 录音播放器,基于AVFoundation

### 注意

1. AMR编码解码 基于 libopencore
[bitcode编译方法](http://blog.csdn.net/chaoyuan899/article/details/51722496)

2. MP3编码 基于 lame类库
[bitcode版本编译](https://github.com/wuqiong/mp3lame-for-iOS)

3. libopencore 不支持bitcode 需要的话可以自行前往编译
4. 播放AMR文件时,需要指定AMR文件的fileTypeID方便使用AMR解码播放,否则可能无法播放
5. MP3,CAF采样率默认44100  可在开始录音前手动修改
6. AMR采样率必须为8000
7. 真机运行后显示image not match 的类库编译错误 解决方法如下
	* 删除XMNAudioExample 下的XMNAudio.framework类库
	* 重新编译下XMNAudio工程,生成真机的XMNAudio.framework类库
	* XMNAudioExample工程中重新添加下真机XMNAudio.framework类库,即可
	
	![示例图](http://7xlt1j.com1.z0.glb.clouddn.com/8607E7C1-5543-442B-B3C1-C39DD34EEB88.png)
### 使用方法


#### 1. 录音

	self.recorder = [[XMNAudioRecorder alloc] init];
	/** 设置不同的Encoder 可以录制不同文件 */
    [self.recorder setConvertType:XMNAudioEncoderTypeMP3];
	[self.recorder startRecording];

#### 2. 播放

##### 1.创建播放文件 实现XMNAudioFile协议,必须实现audioFileURL方法,如果播放AMR文件则必须同时实现fileTypeID方法

##### 2. 具体实例可以查看demo中XMNAudioPlayerController

	self.player = [[XMNAudioPlayer alloc] initWithAudioFile:self.songs[self.index]];
    [self.player play];
    
    
###TODO

1. 播放网络文件  -- done
2. 增加bitcode支持 -- done