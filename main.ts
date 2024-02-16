export interface AudioDriverInstaller {
    installAudioDriver: () => boolean;
    checkAudioDriverInstalled: () => boolean;
    checkLegacyAudioDriverInstalled: () => boolean;
}
const AudioDriverInstaller: AudioDriverInstaller = require('bindings')('AudioDriverInstaller');

export default AudioDriverInstaller;