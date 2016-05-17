import java.io.*;
import java.util.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class QuizCardPlayer{
   private JTextArea display;
   //private JTextArea answer;
   private ArrayList<QuizCard> cardList;
   private QuizCard currentCard;
   private int currentCardIndex;
   private JFrame frame;
   private JButton nextButton;
   private boolean isShowAnswer;
 
   public static void main(String [] args) {
      QuizCardPlayer player = new QuizCardPlayer();
      player.go();
   }

   public void go() {
      frame = new JFrame("Quiz Card Player");
      JPanel mainPanel = new JPanel();
      Font bigFont = new Font("sanserif", Font.BOLD, 24);

      display = new JTextArea(10,20);
      display.setLineWrap(true);
      display.setEditable(false);
      display.setFont(bigFont);
      JScrollPane qScroller = new JScrollPane(display);
      qScroller.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
      qScroller.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);

    //  answer = new JTextArea(10,20);
     // answer.setLineWrap(true);
      //answer.setEditable(false);
      //answer.setFont(bigFont);
      //JScrollPane aScroller = new JScrollPane(answer);
      //aScroller.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
      //aScroller.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);

      JButton nextButton = new JButton("Show Question");
   
      mainPanel.add(qScroller);
    //  mainPanel.add(aScroller);
      mainPanel.add(nextButton);
      nextButton.addActionListener(new NextCardListener());

      JMenuBar menuBar = new JMenuBar();
      JMenu fileMenu = new JMenu("File");
      JMenuItem loadMenuItem = new JMenuItem("Load card set");
      loadMenuItem.addActionListener(new OpenMenuListener());
     
      fileMenu.add(loadMenuItem);
      menuBar.add(fileMenu);

      frame.setJMenuBar(menuBar);
      frame.getContentPane().add(BorderLayout.CENTER, mainPanel);
      frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
      frame.setSize(550, 600);
      frame.setVisible(true);
   }

   public class NextCardListener implements ActionListener {
      public void actionPerformed (ActionEvent ev) {
         if (isShowAnswer) {
            display.setText(currentCard.getAnswer());
            nextButton.setText("Next Card");
            isShowAnswer = false;
         } else {
            if (currentCardIndex < cardList.size()) {
               showNextCard();
            } else {
               display.setText("That was the last card");
               nextButton.setEnabled(false);
            }
         }
      }
   }

   public class OpenMenuListener implements ActionListener {
      public void actionPerformed (ActionEvent ev) {
         JFileChooser fileSave = new JFileChooser();
         fileSave.showOpenDialog(frame);
         loadFile(fileSave.getSelectedFile());
      }
   }

   public void loadFile(File file) {
         cardList = new ArrayList<QuizCard>();
         try {
            BufferedReader reader = new BufferedReader(new FileReader(file));
            String line = null;
            while ((line = reader.readLine()) != null ) {
                makeCard(line);
            }
            reader.close();
         } catch ( IOException ex) {
            System.out.println("couldn't read the cardlist file");
            ex.printStackTrace();
         }
   }

   public void makeCard(String lineToParse) {
      String[] result = lineToParse.split("/");
      QuizCard card = new QuizCard(result[0], result[1]);
      cardList.add(card);
      System.out.println("made a card");
   }

   public void showNextCard() {
      currentCard = cardList.get(currentCardIndex);
      currentCardIndex++;
      display.setText(currentCard.getQuestion());
      nextButton.setText("Show Answer");
   }
}

