export interface AudioDriverInstaller {
    installAudioDriver: () => boolean;
    checkAudioDriverInstalled: () => boolean;
}
const AudioDriverInstaller: AudioDriverInstaller = require('bindings')('AudioDriverInstaller');

export default AudioDriverInstaller;