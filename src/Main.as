package
{
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	import flash.text.TextField;
	
	[SWF(width = '500', height = '300', backgroundColor = "0xe1e1e1", frameRate = "60")]
	
	public class Main extends Sprite
	{
		
		private var output:TextField;
		
		public function Main()
		{
			// stage
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, stageResize);
			
			// output
			output = new TextField();
			output.wordWrap = output.border = output.background = true;  
			output.backgroundColor = 0xffffff;
			
			addChild(output);
			
			NativeApplication.nativeApplication.executeInBackground = true;
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
		
		}
		
		private function stageResize(e:Event):void
		{
			output.width = stage.stageWidth - 20;
			output.height = stage.stageHeight - 20;
			output.x = output.y = 10;
		}
		
		private function onInvoke(e:InvokeEvent):void
		{
			if (e.arguments.length > 0)
			{
				loadTps((e.arguments as Array)[0]);
			}
			else
			{
				output.appendText("\n--no arguments--");
				close();
			}
		}
		
		private var tps:XML;
		private var tpsFile:File;
		
		private function loadTps(path:String):void
		{
			output.appendText("\n" + path);
			
			tpsFile = new File();
			tpsFile = tpsFile.resolvePath(path);
			
			tpsFile.load();
			
			tpsFile.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				tps = XML(String(tpsFile.data));
				loadConfig();
			
			});
		
		}
		
		private var config:URLVariables;
		
		private function loadConfig():void
		{
			
			config = null;
			config = new URLVariables();
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				config.decode(String(loader.data));
				editTps();
			
			});
			
			loader.load(new URLRequest("config.txt"));
		
		}
		
		private function editTps():void
		{
			
			output.appendText("\neditTps... ");
			
			var temp:int = 0;
			for each (var x:XML in tps..filename)
			{
				if (String(x.text()).search(".png") != -1 || String(x.text()).search(".xml") != -1)
				{
					var i:int = 0;
					for each (var s:String in String(x.text()).toLowerCase().split("/"))
					{
						if (s.search("praia") != -1)
						{
							var a:Array = String(x.text()).split("/");
							x.setChildren(config["PRAIA_PATH"].split("/").concat(a.slice((i + 1), a.length)).join("/"));
						}
						i++;
					}
				}
				
			}
			
			output.appendText("\ntps: " + tps);
			
			var file:FileStream = new FileStream();
			file.open(tpsFile, FileMode.WRITE);
			file.writeUTFBytes("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" + tps.toString());
			file.close();
			
			launchTexturePacker();
		
		}
		
		private function launchTexturePacker():void
		{
			
			output.appendText("\nlaunchTexturePacker... " + Capabilities.os);
			
			var pathEV:String = config["TEXTUREPACKER_PATH"];
			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			var fileEV:File = new File();
			fileEV = fileEV.resolvePath(config["STARTER_PATH"]);
			
			//nativeProcessStartupInfo.arguments = Vector.<String>(['/c', 'start', config["TEXTUREPACKER_PATH"], tpsFile.nativePath]);
			nativeProcessStartupInfo.arguments = new <String>[];  
			if (Capabilities.os.toLocaleLowerCase().search("windows") != -1)
			{
				nativeProcessStartupInfo.arguments.push('/c', 'start');   
			}
			else 
			{
				nativeProcessStartupInfo.arguments.push('-a');
			}
			
			nativeProcessStartupInfo.arguments.push(config["TEXTUREPACKER_PATH"], tpsFile.nativePath); 			
			
			
			
			nativeProcessStartupInfo.executable = fileEV;
			
			if (NativeProcess.isSupported)
			{
				var process:NativeProcess = new NativeProcess();
				process.start(nativeProcessStartupInfo);
			}
			
			close();
		
		}
		
		private function close():void
		{
			NativeApplication.nativeApplication.exit();
		}
	
	}

}