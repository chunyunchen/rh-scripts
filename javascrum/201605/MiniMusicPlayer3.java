import javax.sound.midi.*;
import java.awt.*;
import javax.swing.*;
import java.io.*;

public class MiniMusicPlayer3 {
  private static JFrame f = new JFrame("My First Music Video");
  private static MyDrawPanel m1;
  
  public static void main (String [] args) {
     MiniMusicPlayer3 player = new MiniMusicPlayer3();
     player.go();
  }

  public void setUpGui() {
     m1 = new MyDrawPanel();
     f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
     f.setContentPane(m1);
     f.setBounds(30,30,300,300);
     f.setVisible(true);
  }

  public void go() {
     setUpGui();

     try {
        Sequencer sequencer = MidiSystem.getSequencer();
        sequencer.open();
        Sequence seq = new Sequence(Sequence.PPQ, 4);
        Track track = seq.createTrack();

        int[] eventIWant = {127};
        sequencer.addControllerEventListener(m1, eventIWant);

        for(int j = 0; j < 10; j++) {
        for (int i = 35; i < 120; i+=2 ) {
           track.add(makeEvent(144,1,i,100,i));
           track.add(makeEvent(176,1,127,0,i));
           track.add(makeEvent(128,1,i,100,i+2));
        }
           Thread.sleep(100);
        }   
        sequencer.setSequence(seq);
        sequencer.setTempoInBPM(220);
        sequencer.start();
     } catch (Exception ex) {
          ex.printStackTrace();
     }
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

  class MyDrawPanel extends JPanel implements ControllerEventListener {
     boolean msg = false;
     public void controlChange(ShortMessage event) {
        msg = true;
        repaint();
     }
     
     public void paintComponent(Graphics g) {
        if (msg) {
           Graphics2D g2 = (Graphics2D) g;
           int r = (int) (Math.random() * 250);
           int gr = (int) (Math.random() * 250);
           int b = (int) (Math.random() * 250);
           g.setColor(new Color(r, gr, b));
           int ht = (int) ((Math.random() * 120) + 10);
           int width = (int) ((Math.random() * 120) + 10);
           int x = (int) ((Math.random() * 40) + 10);
           int y = (int) ((Math.random() * 40) + 10);
           g.fillRect(x, y, ht, width);
           msg = false;
        }
     } 
  }
}
