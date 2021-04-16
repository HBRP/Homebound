/*

MIT License

Copyright (c) 2019 Emma Davenport

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

class AudioFile {

    constructor(soundfile, volume) {

        this.audio        = new Audio(soundfile);
        this.audio_name   = soundfile;
        this.audio.volume = volume;

    }

    PlayAudio() {

        this.StopAudio();
        this.audio.play();

    }

    StopAudio() {

        this.audio.pause();
        this.audio.currentTime = 0;

    }

    GetAudioName() {

        return this.audio_name;

    }

}

var AudioFiles = [];

function StartAudioFile(soundfile, volume) {

    var i;
    var found_audio_obj = false;
    for (i = 0; i < AudioFiles.length;i++) {
        if (AudioFiles[i].GetAudioName() == soundfile) {
            AudioFiles[i].PlayAudio()
            found_audio_obj = true;
            break;
        }
    }
    if (found_audio_obj == false) {

        AudioFiles.push(new AudioFile(soundfile, volume));
        AudioFiles[AudioFiles.length - 1].PlayAudio();

    }

}

function StopAudioFile(soundfile) {

    for (i = 0; i < AudioFiles.length;i++) {
        if (AudioFiles[i].audio_name == soundfile) {
            AudioFiles[i].StopAudio();
        }
    }

}

$(function() {
	window.addEventListener("message", function(event){
		if (event.data.audio.type == "play_sound") {
            StartAudioFile(event.data.audio.soundfile, event.data.audio.volume);
		} else if (event.data.audio.type == "stop_sound") {
            StopAudioFile(event.data.audio.soundfile);
        }
	});
});
