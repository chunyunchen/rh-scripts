import javax.sound.midi.*;
public class MiniMusicPlayer2 implements ControllerEventListener {
  public static void main (String [] args) {
     MiniMusicPlayer2 player = new MiniMusicPlayer2();
     player.go();
  }

  public void go() {
     try {
        Sequencer sequencer = MidiSystem.getSequencer();
        sequencer.open();
        Sequence seq = new Sequence(Sequence.PPQ, 4);
        Track track = seq.createTrack();

        int[] eventIWant = {127};
        sequencer.addControllerEventListener(this, eventIWant);

        for (int i = 5; i < 61; i++ ) {
           track.add(makeEvent(144,1,i,100,i));
           track.add(makeEvent(176,1,127,0,i));
           track.add(makeEvent(128,1,i,100,i+2));
        }   
        sequencer.setSequence(seq);
        sequencer.setTempoInBPM(220);
        sequencer.start();
     } catch (Exception ex) {
          ex.printStackTrace();
     }
  }

  public void controlChange(ShortMessage event) {
     System.out.println("la"); 
  }

  public static MidiEvent makeEvent(int comd, int chan, int one, int two, int tick) {
     MidiEvent event = null;
     try {
        ShortMessage msg = new ShortMessage();
        msg.setMessage(comd, chan, one, two);
        event = new MidiEvent(msg, tick);
     } catch ( Exception ex) { ex.printStackTrace(); }
     return event;   
  }
}
