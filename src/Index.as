package 
{
	//--------------------------------------
	// IMPORTS
	//--------------------------------------
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.Loader;
	import flash.system.Security;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
	import flash.media.SoundMixer;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import com.includes.globalVars;
	
	/**
	 * ...
	 * @author Nilo
	 */
	
	public class Index extends MovieClip 
	{
		//--------------------------------------
		// VARIÁVEIS
		//--------------------------------------
		
		//
		public static var STAGE:Stage;
		
		
		// GlobalVars
		private var _globalVars = new globalVars();
		
		// CONTAINERS
		private var container:MovieClip;
		
		
		// MAIN
		private var mainUrl:URLRequest;
		private var mainLoader:Loader;
		private var assetsPath:String = "";
		private var mainPath:String;
		private var config:Object;
		private var main:Object;
		
		//OBJ
		private var _intro:Intro;
		private var _preloader:Preloader;
		
		public function Index():void 
		{
			STAGE = stage;
			// allow script access;
			Security.allowDomain( '*' );			// replace * with your domain;
			Security.allowInsecureDomain( '*' );	// replace * with your domain;
			
			// ASSETS
			assetsPath = root.loaderInfo.parameters.assetsPath;
			config= {
						suspendData: root.loaderInfo.parameters.suspendData,
						hay: root.loaderInfo.parameters.hay,
						cargo: root.loaderInfo.parameters.cargo,
						configPath: root.loaderInfo.parameters.configPath,
						intro: root.loaderInfo.parameters.intro
					}
			
			//_globalVars.debug(  root.loaderInfo.parameters.suspendData , "console.log" );
		
			
			mainPath = assetsPath + "main.swf";
			
			if( assetsPath == "" || assetsPath == null )
			{
				assetsPath = "";
				mainPath = _globalVars.get( "geral_mainPath" );
				config =  _globalVars.get( "config" );
			} 
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//--------------------------------------
		// INIT
		//--------------------------------------
		
		private function init(e:Event = null):void 
		{
			// Layout
			containerInit();
			
			//INTRO
			introInit();
		
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		
		
		//--------------------------------------
		// CONTAINER INIT
		//--------------------------------------
		
		private function containerInit()
		{
			// CONTAINER
			container = new MovieClip();
			addChildAt( container, 0 );
		}
		
		//--------------------------------------
		// INTRO
		//--------------------------------------
		
		private function introInit()
		{
			_intro = new Intro();
			container.addChild( _intro );
			_intro.sistema = false;
			_intro.addEventListener(Event.ENTER_FRAME, introFrame );
			
			_intro.x =150;
			_intro.y = 65;
			
			if ( config["intro"]  == 0 )
			{
				_intro["pularIntro"].visible = false;
			}
			else
			{
				_intro["pularIntro"].visible = true;
				_intro["pularIntro"].buttonMode = true;
				_intro["pularIntro"].mouseChildren = true;
				_intro["pularIntro"].addEventListener( MouseEvent.CLICK, callSistema );
				//MovieClip(_homeBTN)[ "homeBtn" ].addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 1000);
				//MovieClip(_homeBTN)[ "homeBtn" ].addEventListener(MouseEvent.MOUSE_OUT,  onOut, false, 1000);
			}
		}
		
		
		private function introFrame(e:Event)
		{
			if ( e.currentTarget.sistema )
			{
				_intro.removeEventListener(Event.ENTER_FRAME, introFrame );
				callSistema( null );
			}
		}
		
		private function callSistema(e:MouseEvent)
		{
			container.removeChild( _intro );
			SoundMixer.stopAll();
			
			_preloader = new Preloader();
			container.addChild( _preloader );
			_preloader.x = 254;
			_preloader.y = 206;
			
			//
			if (ExternalInterface.available) 
				ExternalInterface.call( "GravaIntro" );
			
			// Main Load
			mainLoad();
		}
		
		//--------------------------------------
		// MAIN LOAD
		//--------------------------------------
		
		private function mainLoad()
		{	
			mainUrl = new URLRequest( mainPath );
			mainLoader = new Loader();
			mainLoader.load( mainUrl );
			
			mainLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, mainProgress);
			mainLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, mainComplete);
		}
		
		private function mainProgress( e:ProgressEvent ):void
		{
			// Percent
			var percent = int( e.target.bytesLoaded / e.target.bytesTotal * 100 );
		}
		
		private function mainComplete( e:Event ):void
		{
			TweenMax.to(_preloader, 0.3 , { alpha:0, ease:Back.easeOut, delay: 8, onComplete:function() {
				container.removeChild( _preloader );
				
				// Add
				container.addChildAt( mainLoader, 0  );
				
				main = e.currentTarget.content;
				main.config( config, STAGE );
				
			}});
			
			// Remove Events
			mainLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, mainProgress);
			mainLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, mainComplete);
		}
	}	
}