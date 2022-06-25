package;

import haxe.ui.HaxeUIApp;

class SndWavRepacker {
	public static function main() {
		var app = new HaxeUIApp();
		app.ready(function() {
			app.addComponent(new MainView()); // .hide  When console mode

			app.start();
		});
	}
}
