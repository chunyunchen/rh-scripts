import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class JFrameTestDrive {
   JFrame frame = null;
   JLabel label = null;

   public static void main(String [] args) {
       JFrameTestDrive gui = new JFrameTestDrive();
       gui.go();
   }

   public void go() {
      frame = new JFrame();
      JButton colorButton = new JButton("Change Circle");
      colorButton.addActionListener(new ColorListener());
      JButton labelButton = new JButton("Change Label");
      labelButton.addActionListener(new LabelListener());

      label = new JLabel("I'm a label");
      MyDrawPanel dp = new MyDrawPanel();
      
      frame.getContentPane().add(BorderLayout.SOUTH, colorButton);
      frame.getContentPane().add(BorderLayout.CENTER,dp);
      frame.getContentPane().add(BorderLayout.WEST, label);
      frame.getContentPane().add(BorderLayout.EAST, labelButton);
      frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
      frame.setSize(300,400);
      frame.setVisible(true);
   }

   class ColorListener implements ActionListener {
      public void actionPerformed(ActionEvent event) {
         frame.repaint();
      }
   }

   class LabelListener implements ActionListener {
      public void actionPerformed(ActionEvent event) {
         label.setText("Ouch");
      }
   }
}

class MyDrawPanel extends JPanel {
   public void paintComponent(Graphics g) {
      int red = (int) (Math.random() * 255);
      int green = (int) (Math.random() * 255);
      int blue = (int) (Math.random() * 255);
      Color cr = new Color(red, green, blue);
      g.setColor(cr);
      g.fillRect(100,100,100,100);
   }
}
