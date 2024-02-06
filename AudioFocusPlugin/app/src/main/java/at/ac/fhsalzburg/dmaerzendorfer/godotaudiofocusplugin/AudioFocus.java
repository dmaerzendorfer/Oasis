package at.ac.fhsalzburg.dmaerzendorfer.godotaudiofocusplugin;

import android.content.Context;
import android.media.AudioAttributes;
import android.media.AudioFocusRequest;
import android.media.AudioManager;
import android.os.Handler;
import android.util.ArraySet;
import android.util.Log;

import androidx.annotation.NonNull;

import org.godotengine.godot.Godot;
import org.godotengine.godot.plugin.GodotPlugin;
import org.godotengine.godot.plugin.SignalInfo;

import java.util.Arrays;
import java.util.List;
import java.util.Set;

public class AudioFocus extends GodotPlugin {

    private AudioManager audioManager;
    private AudioFocusRequest focusRequest;
    private Handler handler;
    private AudioManager.OnAudioFocusChangeListener afChangeListener;

    public AudioFocus(Godot godot) {
        super(godot);
        audioManager = (AudioManager) godot.getActivity().getSystemService(Context.AUDIO_SERVICE);

        AudioAttributes playbackAttributes = new AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_GAME)
                .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                .build();
        handler = new Handler();
        afChangeListener =
                new AudioManager.OnAudioFocusChangeListener() {
                    public void onAudioFocusChange(int focusChange) {
                        if (focusChange == AudioManager.AUDIOFOCUS_GAIN) {
                            emitSignal("AudioFocusGain");
                        } else if (focusChange == AudioManager.AUDIOFOCUS_LOSS_TRANSIENT) {
                            emitSignal("AudioFocusLossTransient");
                        } else if (focusChange == AudioManager.AUDIOFOCUS_LOSS) {
                            emitSignal("AudioFocusLoss");
                        } else{
                            Log.d("audioFocusPlugin","unhandled focusChange: "+focusChange);
                        }
                    }
                };
        focusRequest = new AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN)
                .setAudioAttributes(playbackAttributes)
                .setAcceptsDelayedFocusGain(true)
                .setOnAudioFocusChangeListener(afChangeListener, handler)
                .build();


    }

    @NonNull
    @Override
    public String getPluginName() {
        return "AudioFocusPlugin";
    }

    @NonNull
    @Override
    public Set<SignalInfo> getPluginSignals() {
        Set<SignalInfo> signals = new ArraySet<>();
        signals.add(new SignalInfo("AudioFocusGain"));
        signals.add(new SignalInfo("AudioFocusLossTransient"));
        signals.add(new SignalInfo("AudioFocusLoss"));
        return signals;
    }

    @NonNull
    @Override
    public List<String> getPluginMethods() {
        return Arrays.asList("requestAudioFocus","abandonAudioFocus");
    }

    public void requestAudioFocus(){
        int res = audioManager.requestAudioFocus(focusRequest);

    }
    public void abandonAudioFocus(){
        audioManager.abandonAudioFocusRequest(focusRequest);
    }
}
