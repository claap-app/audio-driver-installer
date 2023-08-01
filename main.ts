export interface AudioDriverInstaller {
    installAudioDriver: () => boolean;
    checkAudioDriverInstallation: () => boolean;
}
const AudioDriverInstaller: AudioDriverInstaller = require('bindings')('AudioDriverInstaller');

export default AudioDriverInstaller;