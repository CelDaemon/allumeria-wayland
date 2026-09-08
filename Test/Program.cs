using SoLoud;
using Steamworks;

var soloud = new Soloud();

SteamClient.Init(3516590, false);

// SteamInput.InputActionManifestFilePath = "/home/celdaemon/.local/share/Steam/steamapps/common/Allumeria/res/configs/input/game_actions_3516590.vdf";

var controllers = new Controller[16];
var currentCount = 0;

Thread.Sleep(1000); // Give steam input some time to get actions ready?

while (true) {
    SteamClient.RunCallbacks();
    SteamInput.RunFrame();
    var count = SteamInput.GetControllers(controllers);
    if (count != currentCount) {
        Console.WriteLine($"Controllers connected: {count}");
        currentCount = count;

        for (int i = 0; i < count; i++) {
            var controller = controllers[i];
            controller.ActionSet = "MenuControls";
        }
        // controllers[0].ShowBindingPanel();
    }
    for (int i = 0; i < count; i++) {
        var controller = controllers[i];
        var state = controller.GetAnalogState("Cursor");
        Console.WriteLine($"--- CONTROLLER {i + 1} ---");
        Console.WriteLine($"HND: {controller.Id}");
        Console.WriteLine($"TYP: {controller.InputType}");
        Console.WriteLine($"MOV: {state.X}, {state.Y}");
        Console.WriteLine($"AC: {state.Active}");
        Console.WriteLine($"MOD: {state.EMode}");
    }
    Thread.Sleep(16);
}
SteamClient.Shutdown();
